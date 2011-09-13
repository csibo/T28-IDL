
;- get_img_hvps_nc.pro
;- Decode a set of HVPSC buffers to an image
;- The buffers were recorded in the no-charge SEA mode
;- Valid for flights during August, 2001
;
;- Last modified: July 29, 2003
;	Donna modified this program to be able to do the display of particle
;   concentration for the HVPS display.
;	This works for the Greeley, CO, flights! (did not test for other
;	flights yet).
;----------------------------------------------------------------------

pro get_img_hvps_nc,data,num_disp_buffs,np,nl,init_time, $
                    img,time_img,num_particles,buffer_num,time_between_particles, $ ;;;,particle_area,time_between_particles, $
                    particle_start,particle_end,particle_bottom,particle_top,particle_time

np         = 1000               ;most buffer images are less than 1000 pixels;
nl         = 256                ;number of elements in the HVPS sensor array
                                ;some of the top and bottom elements are masked out
num_slices = 2048               ;number of 2 byte slices in an HVPS image buffer
period     = 6.                 ;period of a slice in um (if clock frequency is 166kHz)
                                ;true for T28 CO 98 data but maybe not for other data
                                ;generally the clock speed should vary with TAS to
                                ;give a horizontal resolution of 400 um
                                ;period if used to calculate the time of a slice
;period = 0.0004 / tas          ;if clock speed is variable
period     = 4.D                ;In the HVPS-C the slices are based on a 4 usec clock

;stop

;max_num_particles = 1000
;max_num_particles = 100*num_disp_buffs
max_num_particles = 1000
max_num_particles = max_num_particles * num_disp_buffs
tot_num_slices = num_slices * num_disp_buffs
print,'tot_num_slices = ',tot_num_slices


tot_np = np * num_disp_buffs

; Initialize
num_particles 	= 0
time_between_particles = fltarr(max_num_particles)
;time_between_particles(*) = 0
;inter_part_cycles_next = 0
;particle_start  = 0
;particle_end    = 0
;particle_bottom = 0
;particle_top    = 0
;particle_area 	= 0
;particle_time   = 0
particle_start  = intarr(max_num_particles)
particle_end    = intarr(max_num_particles)
particle_bottom = intarr(max_num_particles)
particle_top    = intarr(max_num_particles)
particle_area 	= intarr(max_num_particles)
particle_time   = intarr(max_num_particles)
particle_start(*)  = 0
particle_end(*)    = 0
particle_bottom(*) = 0
particle_top(*)    = 0
particle_area(*) 	= 0
particle_time(*)   = 0
;particle_start(*) = 20000

;-
img = intarr(tot_np,nl)
img(*,*) = -1
;img(*,*) = 255   ; 9/12/2002

particle_time(0) = init_time


ix = 0l     ; 1st column number in decoded image ( a little padding)
i = 0

print,'size data: ',size(data)
;stop
while i lt (tot_num_slices ) do begin

	;print,'i: ',i

	if(data(i) eq 'CAAA'X) then begin
		print,'Mask: ',i
		i = i + 1024		;save some time skipping through mask buffer
	endif


	iy = 0
;	particle_area = 0l
	num_cycles = 0.
    overflow = 0
	sw = 0
	while ((sw eq 0) and (i lt tot_num_slices)) do begin   ; while have particle

      if(data(i) eq 'CAAA'X) then begin
      print,'Mask: ',i
       i=i+1024                   ; skip the mask
      endif

	  if((data(i) and '8000'X) eq 0) then begin  ;not a timing word

	     if((data(i) and '4000'X) gt 0) then begin ; an image word
	     ;stop
	     ;print,'i = ', i
				bit2 = 'S'		; bit set
				ix = ix + 1l
				iy = 0l
				num_cycles = num_cycles + 1.
		 endif else bit2 = 'C'  ; bit clear
		 num_clear = data(i) and '007F'X
		 num_occluded = ishft(data(i),-7) and '007F'X
		 if bit2 eq 'S' and num_clear eq 0 and num_occluded eq 0 then num_clear = 128

         particle_area(num_particles) = particle_area(num_particles) + num_occluded
		 iy = iy + num_clear + num_occluded
		 ;particle_area(num_particles) = particle_area(num_particles) + num_occluded
		 if (iy ge 15 and iy le 240 and ix lt tot_np and num_occluded ne 0) then begin
			;;img(ix,iy-num_occluded+1:iy) = 1
			img(ix,iy-num_occluded+1:iy) = num_particles	;jul 29, 2003
			;particle_area = particle_area + num_occluded
		 endif
		 ;num_particles = num_particles + 1

	  endif else begin
	    sw = 1
	    word_type = 'T'    ; timing word
		if i lt (tot_num_slices-1) then begin
		   inter_part_cycles_next = float(long(data(i)) and '3FFF'X) * 2.^14 + $
		   					   float(long(data(i+1)) and '3FFF'X)

		   inter_part_cycles_next = inter_part_cycles_next + num_cycles
		endif

		if ((data(i) and '4000'X) gt 0) then begin
		   overflow = 1
		   print,'Overflow detected at buffer, frame: ',buffer_num
		endif
		;num_particles = num_particles + 1
		i = i+ 1
;print,'i = ', i
	 endelse

		i = i + 1

       ;;; if((data(i) and 'FFFF'X) eq 'CAAA'X) then sw = 0;;;sw = 1
       ;look for begining of new particle - July 29, 2003
        if((data(i) and 'FFFF'X) eq '407F'X) then sw = 0

   endwhile         ; end of a particle
      ;print,'num_particles = ',num_particles
      ;stop

      particle_end(num_particles) = ix
     if particle_end(num_particles) lt particle_start(num_particles) then $
           particle_end(num_particles) = particle_end(num_particles) > particle_start(num_particles)

      if (inter_part_cycles_next gt 0) then begin
	  time_between_particles(num_particles) = double(inter_part_cycles_next) * period * 1.e-6		;seconds
	  endif else begin
	  ;;;num_particles = 1
	  time_between_particles(num_particles) = 0.		;seconds
	  endelse
	  ix = ix + 1

      s1 = particle_start(num_particles)
      s2 = particle_end(num_particles)
      particle_time(num_particles) = total(time_between_particles(0:num_particles))/3600.

	  ;try to make sure the particle pixels are positive numbers,
	  ;while the rest of the values are negative -Jul 29, 2003
	  ;stop
	  min_values = min(img)
	  max_values = max(img)
	  ;print,'min_values = ',min_values
	  ;print,'max_values = ',max_values

	if (min_values ne max_values) then begin
	  pos_values = where(img gt min_values, cnt_pos)
	  img(pos_values) = abs(img(pos_values))
	  ;stop
 	endif

      ;sum each row of the array, 1 - is for rows, 2 - is for columns
      tem = total(img(0>s1<(tot_np-1):s1>s2<(tot_np-1),*),1)
      ind = where(tem gt 0, cnt)

      if cnt ne 0 then begin
         particle_bottom(num_particles) = ind(0)
         particle_top(num_particles) = ind(cnt-1)
      endif else begin
         particle_bottom(num_particles) = 0
         particle_top(num_particles) = 0
      endelse
;stop
num_particles = num_particles + 1

endwhile			;i < 2047, end of buffer

print,'This buffer had #particles = ',num_particles
;stop

if num_particles eq 0 then begin
   num_particles = 1
   img(10,128) = 1
   ;Feb 21, 2003
   print,'num_particles = 0 ...'
endif

;particle_area(*) = 0

end
