;
;- get_img_only2.pro
;- Decode a set of HVPSC buffers to an image w/o charge plotted
;
;- Written: 10/17/2002
;- Author: Donna Kliche
;- Last modified: 10/17/2002
;----------------------------------------------------------------

pro get_img_only2,bufm,num_disp_buffs,pan_x,pan_y,start_buffer_num,time,charge_sw, $
                    img,time_img,num_particles,particle_area,charge_plates,time_between_particles, $
                    particle_start,particle_end,particle_bottom,particle_top,particle_time,$
                    total_buffer_size,skip_bytes,buf_size


;call get image routines as if we want to display with charge:
charge_sw = 1 ;temporarily

;print,'total_buffer_size: ',total_buffer_size
buf_num = start_buffer_num

charge_sw = 1
;calculations for particle_top,particle_bottom mainly (histogram display)
if total_buffer_size eq 4220 then begin
 get622_img_cp_mult,bufm,num_disp_buffs,pan_x,pan_y,time(buf_num),$
       charge_sw,img,time_img,num_particles,particle_area,$
       charge_plates,time_between_particles, particle_start,$
       particle_end,particle_bottom,particle_top,particle_time
endif

charge_sw=1
;calculations for particle_top,particle_bottom mainly (histogram display)
if total_buffer_size eq 4182 then begin
no_charge_recorded = 0
 get_img_cp_mult,bufm,num_disp_buffs,pan_x,pan_y,time(buf_num),$
       charge_sw, img,time_img,num_particles,particle_area,$
       charge_plates,time_between_particles, particle_start,$
       particle_end,particle_bottom,particle_top,particle_time,no_charge_recorded
endif

charge_sw = 0
i=0
new_img = intarr(1000,256)
buf = intarr(buf_size)
kb=0
;just the buffers to be displayed
bufm_modif = bufm(0:num_disp_buffs*2048 - 1)

;for loop to build the final image with several buffers
for buf_num = start_buffer_num,(start_buffer_num + num_disp_buffs)-1 do begin
  ;take one buffer at a time
  buf(*) = bufm_modif(kb*2048:(kb+1)*2048 - 1)

  if total_buffer_size eq 4220 then begin
    get_img_only,buf,1,pan_x,pan_y,time(buf_num),charge_sw, img
  endif

  if total_buffer_size eq 4182 then begin
    get_img_only,buf,1,pan_x,pan_y,time(buf_num),charge_sw, img
  endif

  new_img(i:i+170,*) = img(0:170,*)

  i = i+170
  kb=kb+1

endfor

img(*) = new_img(*)

end
