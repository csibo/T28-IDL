;***********************************************************************
;
;- get622_img_cp_mult.pro
;- Decode a set of HVPSC buffers to an image w or w/o charge plotted
; for flight 757 skip_bytes should be 62 because we added
; the elapsed time (2 words = unsigned long int), and
; the elapsed shadow or (1 word = unsigned int)
; directory before                      = 86 bytes
; directory entrance for elapsed time   = 16 bytes
; elapsed time                          =  4 bytes
; directory entrance for elapsed shadow = 16 bytes
; elapsed shadow or                     =  2 bytes
; =================================================
; total                                 = 124 bytes = 62 words
;-
;- Last update: 06/23/2000
;- 1/30/2001
;- Fix the particle images, which appeared squized on the horizontal dimension,
;  due to hvps clocking missunderstanding during STEPS (summer 2001)
;***********************************************************************

pro get622_img_cp_mult,data,num_disp_buffs,np,nl,init_time,charge_sw, $
                    img,time_img,num_particles,particle_area,charge_plates,time_between_particles, $
                    particle_start,particle_end,particle_bottom,particle_top,particle_time

np         = 1000               ;most buffer images are less than 1000 pixels;

nl         = 256                ;number of elements in the HVPS sensor array
                                ;some of the top and bottom elements are masked out
; try expanding the particle in the x direction 1/31/2001
num_slices = 2048               ;number of 2 byte slices in an HVPS image buffer

;period     = 6.                 ;period of a slice in um (if clock frequency is 166kHz)
                                ;true for T28 CO 98 data but maybe not for other data
                                ;generally the clock speed should vary with TAS to
                                ;give a horizontal resolution of 400 um
                                ;period if used to calculate the time of a slice
;period = 0.0004 / tas          ;if clock speed is variable
period     = 4.D                ;In the HVPS-C the slices are based on a 4 usec clock

max_num_particles = num_disp_buffs * 100
max_num_particles = 1000
;max_num_particles = 100  ; changed on 7/11/00
tot_num_slices = num_slices * num_disp_buffs
;tot_num_slices = 2100

tot_np = np * num_disp_buffs

num_particles 	= 0

time_between_particles = fltarr(max_num_particles)
particle_start  = intarr(max_num_particles)
particle_end    = intarr(max_num_particles)
particle_bottom = intarr(max_num_particles)
particle_top    = intarr(max_num_particles)
particle_area 	= intarr(max_num_particles)
particle_time   = fltarr(max_num_particles)
charge_plates	= fltarr(1000,8,6)

particle_start(*) = 20000

signs = [ 1 , 3 , 4 , 6 ]		; for displaying the charge, so that the sign on the data
								; is the same on all plates (is a way of flipping the sign)
pairs_upper = [ 7 , 6 , 5 , 4 ]
pairs_lower = [ 0 , 1 , 2 , 3 ]

;-
img = intarr(tot_np,nl)
img(*,*) = -1
time_img = fltarr(tot_np,nl)		;necessary anymore?

particle_time(0) = init_time

ix = 0l

i = 0

print,'size data: ',size(data)

while i le (tot_num_slices - 1) do begin

	; print,'i: ',i
    ; buffer_no = i/4182
    ; print,'Buffer number = ',buffer_no

;check if the buffer is a masking buffer, containing information about masking
	if(data(i) eq 'CAAA'X) then begin   ; information about masking
		print,'Mask: ',i
		i = i + 1024		;save some time skipping through mask buffer
	endif


	if data(i) eq '3FF0'X and data(i+1) eq '3FF1'X then begin   ; '3FF1' = begining of particle
																; '3FF0' = end of particle
		;print,format = '(2Z8)',i,data(i),data(i+1)

		; ishft function performs the bit shift operation on bytes
		; perform 8 bit shift to the left, to get inter_part_cycles
		inter_part_cycles = ishft(long(data(i+2)),16) or long(data(i+3))
		;;;print,'inter_part_cycles: ',inter_part_cycles

		for l=0,5 do charge_plates(num_particles,*,l) = data(i+4+l*8:i+4+(l+1)*8-1)

		iy = 0
		num_cycles = 0

		i = i + 52

		sw = 0

;create the arrays to hold the images of the particles

		while sw eq 0 and i lt (tot_num_slices-1) do begin
		;while sw eq 0 do begin
			if((data(i) and '4000'X) gt 0) then begin
				bit2 = 'S'
				ix = ix + 1l
				; try to expand the x direction of the particle
				;ix = 2*ix not good
				iy = 0
				num_cycles = num_cycles + 1.
			endif else bit2 = 'C'
			num_clear = data(i) and '7F'X
			plus = data(i) and '80'X
			; right shift 7 bits
			num_occluded = ishft(data(i),-7) and '7F'X
			if bit2 eq 'S' and num_clear eq 0 then num_clear = 128

			particle_area(num_particles) = particle_area(num_particles) + num_occluded
			iy = iy + num_clear + num_occluded

			;based on mask information
			;modify this through checking the mask and counting exactly the number of zeroes
			;at the begining and end of mask, and replace 15 AND 240!
			if (iy gt 15 and iy lt 240 and ix lt tot_np and num_occluded ne 0) then begin
				img(ix,iy-num_occluded+1:iy) = num_particles

			endif

			i = i + 1

			if (data(i) and 'FFFF'X) eq '3FF0'X and (data(i+1) and 'FFFF'X) eq '3FF1'X then sw = 1

			if((data(i) and 'FFFF'X) eq 'CAAA'X) then sw = 1

		endwhile				;end of a particle

		;maxy = max(abs(charge))
;print,'period for particles: ',period
		time_between_particles(num_particles) = double(inter_part_cycles) * period * 1.e-6		;seconds
        print,'time_between_particles(num_particles): ',time_between_particles(num_particles)
;;;stop
		;particle_end(num_particles) = ix		;valid before
		particle_end(num_particles) = ix + 1  ; added 2/1/2001

		;if particle_end(num_particles) lt particle_start(num_particles) then $
			;particle_end(num_particles) = particle_start(num_particles)
		particle_end(num_particles) = particle_end(num_particles) > particle_start(num_particles)

		num_particles = num_particles + 1
		if charge_sw eq 1 then particle_start(num_particles) = ix + 15 else particle_start(num_particles) = ix
		s1 = particle_start(num_particles-1)
		s2 = particle_end(num_particles-1)
		;time_between_particles(num_particles-1) = time_between_particles(num_particles-1) + ((s2-s1) * period * 1.e-6)
		particle_time(num_particles-1) = total(time_between_particles(0:num_particles-1)) / 3600. + init_time	;hours

   ;;;     print,'particle_start(num_particles-1): ',s1
   ;;;	   print,'particle_end(num_particles-1): ',s2
   ;;;     print,'particle_time(num_particles-1): ',particle_time(num_particles-1)


		;print,'s1,s2: ',s1,s2
		tem = total(img(0>s1<(tot_np-1):s1>s2<(tot_np-1),*),1)

		ind = where(tem gt 0,cnt)
		if cnt ne 0 then begin
			particle_bottom(num_particles-1) = ind(0)
			particle_top(num_particles-1) = ind(cnt-1)
		endif else begin
			particle_bottom(num_particles-1) = 0
			particle_top(num_particles-1) = 0
		endelse

;stop

;- Plot charge plate data
		if charge_sw eq 1 then begin

		if ix lt (tot_np-20) then begin			;don't try plotting past end of image array
		img(ix+1,*) = 0

		;- For plotting the max of the upper and lower plates separately
		;maxu = -1000
		;maxl = -1000
		;for ic=0,3 do begin
			;if max(abs(charge_plates(num_particles-1,ic,*))) gt maxl then begin
				;ind_low = ic
				;maxl = max(abs(charge_plates(num_particles-1,ic,*)))
			;endif
			;if max(abs(charge_plates(num_particles-1,7-ic,*))) gt maxu then begin
				;ind_up = 7-ic
				;maxu = max(abs(charge_plates(num_particles-1,7-ic,*)))
			;endif
		;endfor

		;- Plotting the max of all the plates and using the corresponding upper/lower plate
		maxul = -1000
		for ic=0,7 do begin
			if max(abs(charge_plates(num_particles-1,ic,*))) gt maxul then begin
				ind_uplow = ic
				maxul = max(abs(charge_plates(num_particles-1,ic,*)))
			endif
		endfor
		ind_tem = where(pairs_upper eq ind_uplow,cnt_tem)
		if cnt_tem ne 0 then begin
			ind_up  = pairs_upper(ind_tem)
			ind_low = pairs_lower(ind_tem)
		endif else begin
			ind_tem = where(pairs_lower eq ind_uplow,cnt_tem)
			ind_up  = pairs_upper(ind_tem)
			ind_low = pairs_lower(ind_tem)
		endelse
		;-------

		charge_upper = charge_plates(num_particles-1,ind_up,*)
		charge_lower = charge_plates(num_particles-1,ind_low,*)

;;for mm = 0, 5 do begin
;;   print,'charge_upper, charge_lower: ',charge_upper(mm),charge_lower(mm)
;;   ;print,'charge_lower: ',charge_lower(mm)
;;endfor
;;print,''

;for mm = 0, 5 do begin
;   ;print,'charge_upper: ',charge_upper(mm)
;   print,'charge_lower: ',charge_lower(mm)
;endfor

		ind_tem = where(signs eq ind_up,cnt_tem)
		if cnt_tem ne 0 then charge_upper = -charge_upper
		ind_tem = where(signs eq ind_low,cnt_tem)
		if cnt_tem ne 0 then charge_lower = -charge_lower

		for ic=0,5 do begin
			yyl = (charge_upper(ic) + 4000) * 128 / 8000
			yyu = 255 - (charge_lower(ic) + 4000) * 128 / 8000
			yyl = 1>yyl<128
			yyu = 128>yyu<254
			;print,'yyl,yyu: ',yyl,yyu
			img(ix+2+ic*2:ix+2+ic*2+1,yyl-1:yyl+1) = 0		;ix+2+ic  for single width
			img(ix+2+ic*2:ix+2+ic*2+1,yyu-1:yyu+1) = 0
		endfor
		img(ix+14,*) = 0				;8 for single width
		img(ix+2:ix+13,64) = 0			;7 for single width
		img(ix+2:ix+13,192) = 0
		ix = ix + 15					;9 for single width
		endif
		endif		;end plotting charge plate data

	endif else i = i + 1		;if not a end/start slice then increment slice counter

endwhile			;i < 2047, end of buffer

if num_particles eq 0 then num_particles = 1
;stop
;particle_start  = particle_start(0:num_particles-1)
;particle_end    = particle_end(0:num_particles-1)
;particle_bottom = particle_bottom(0:num_particles-1)
;particle_top    = particle_top(0:num_particles-1)
;particle_area   = particle_area(0:num_particles-1)
;particle_time   = particle_time(0:num_particles-1)
;charge_plates   = charge_plates(0:num_particles-1,*,*)
;time_between_particles = time_between_particles(0:num_particles-1)

end
