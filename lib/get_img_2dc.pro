
;- get_img_2dc.pro

pro get_img_2dc,data_2dc,num_disp_buffs,pan_x,pan_y,init_time, $
                img_buff,num_particles,particle_area,time_between_particles, $
                start_particle,end_particle	;,particle_bottom,particle_top

;fn = 'c:\sea\raw\f748_2dc.raw'

img = bytarr(1024,32)

;- Convert data_2dc to an image
mask = '00000001'Xl
for i=0,31 do img(*,i) = (ishft(data_2dc,-i) and mask) * 255
;stop
;- Get the indices (column numbers) for the zero slices (start of a particle),
;- the indices for the blank slices (all ones - marks the end of a particle or
;- anamolously fills in front of and behind the particle image), and
;- the indices where there is image data (something other than ones or zeroes)
ind_zero = where(data_2dc eq 0,cnt_zero)

ind_ones = where((data_2dc and 'FFFFFFFF'X) eq 'FFFFFFFF'X,cnt_ones)

ind_img = where((data_2dc and 'FFFFFFFF'X) ne 'FFFFFFFF'X and data_2dc ne 0,cnt_img)

start_particle = intarr(1000)
end_particle   = intarr(1000)
particle_area  = intarr(1000)
time_between_particles = fltarr(1000)

num_particles = 0

;- Search through the start particle indices (zeroes) and find the beginning and ending indices of each particle image
for j=0,cnt_zero-2 do begin
	if (ind_zero(j+1) - ind_zero(j)) gt 1 and $					;don't include adjacent slices of zeroes
      	ind_zero(j) gt end_particle(num_particles-1>0) and $		;avoid multiple zeroes in large particle images
      	max(ind_ones) gt ind_zero(j+1) then begin					;guard against an image that continues into the next buffer
      		start_particle(num_particles) = ind_zero(j) + 1
   			ind_1st_ones = where(ind_ones gt ind_zero(j),cnt_1st_ones)	;look for the 1st ones slice after a zero slice
   			end_particle(num_particles) = ind_ones(ind_1st_ones(0))
   			time_between_particles(num_particles) = float(data_2dc(ind_zero(j) - 1)) * 0.00005

;- if there's some zero slices in front of or behind the particle image, adjust the end_particle marker to the end
;- of the image
   			if cnt_img ne 0 then begin
    			ind_last_img = where(ind_img lt (ind_zero(j+1)-1) and $		;make sure the last image slice occurs before the zero slice
                         			ind_img gt end_particle(num_particles),cnt_last_img)	;and after the current end marker
    			if cnt_last_img ne 0 then end_particle(num_particles) = ind_img(ind_last_img(cnt_last_img-1))
   			endif
   			num_particles = num_particles + 1
	endif
endfor

print,'num_particles: ',num_particles
;stop
;- Adjust arrays for oversizing
start_particle = start_particle(0:num_particles-1)
end_particle   = end_particle(0:num_particles-1)
particle_size  = end_particle - start_particle

;- Get rid of the particles with all blank slices (the end slice immediately follows the start slice)
ind = where(particle_size gt 1,num_particles)
;print,'num_particles 2: ',cnt
if num_particles ne 0 then begin
	start_particle = start_particle(ind)
	end_particle = end_particle(ind)

	img_buff = img
  	;if cnt_zero ne 0 then img1(ind_zero,*) = 1
  	;if cnt_ones ne 0 then img1(ind_ones,*) = 1

;- Colorize the accepted particle images for display
  	for j=0,num_particles-1 do begin
  		area = 0
   		for m=start_particle(j),end_particle(j) do begin
    		tem = img_buff(m,*)
    		ind_tem = where(tem eq 0,cnt_tem)
    		area = area + fix(cnt_tem)
    		;print,'cnt_tem: ',cnt_tem
    		if cnt_tem ne 0 then tem(ind_tem) = 1
    		img_buff(m,*) = tem(*)
   		endfor
   		particle_area(j) = area
  	endfor

start_particle = start_particle(0:num_particles-1)
end_particle   = end_particle(0:num_particles-1)
particle_area  = particle_area(0:num_particles-1)
time_between_particles = time_between_particles(0:num_particles-1)

endif

;- Colorize the start and end slices, and data slices
;for j=0,num_particles-1 do begin
	;img1(start_particle(j),*) = 2
  	;img1(end_particle(j),*) = 1
;endfor
;if cnt_img ne 0 then img1(ind_img,0:2) = 3

;;start_particle = start_particle(0:num_particles-1)
;;end_particle   = end_particle(0:num_particles-1)
;;particle_area  = particle_area(0:num_particles-1)
;;time_between_particles = time_between_particles(0:num_particles-1)
;stop
;print,'time_between_particles in get_img_2dc: ',time_between_particles
;print,'time_between_particles in get_img_2dc (s): ',(total(time_between_particles))
end
