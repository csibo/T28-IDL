;
;- display_buffers2.pro
;
; Last modified: March 5, 2003
;  To include the entire number of particles in the displayed HVPS
;  buffer.
;
;--------------------------------------------------------------------------

pro display_buffers2,files,specs,b_info_arr,start_buffer,end_buffer,skip,buf_ptrs,title,yr_number

@part_struct

;laserx     = 19. ;24.	;width of printer output in cm
;max_lasery = 24. ;17.	;height of printer output in cm
laserx     = 24.		;width of printer output in cm
max_lasery = 17.		;height of printer output in cm
scalex     = 1.0		;subsample factor for width of image buffer
scaley     = 1.0
;fac        = 600		;width of output window displaying array of image buffers
fac = 1000
charge_sw  = 0

if specs.probe_type eq 1 then begin
	buf1 = ulonarr(specs.buf_size)
	buf2 = ulonarr(specs.buf_size)
endif else begin
	buf1 = uintarr(specs.buf_size)
	buf2 = uintarr(specs.buf_size)
endelse

device,retain=2

openr,unit,files.fn_src,/get_lun
openw,unit_log,'tem.dat',/get_lun	;not used here - a dummy file for get_img to write

;- Select number of columns of image buffers in array
npan_x = menu_wid_new(['Number of columns?','1','2','3','4'])
npan_x = npan_x + 1

;- Compute factors needed to construct array of image buffers
pan_x_sc  = fix(float(specs.pan_x) * scalex)     ;width of the image buffer after scaling
pan_y_sc  = fix(float(specs.pan_y) * scaley)     ;height of the image buffer after scaling
num_x     = npan_x * pan_x_sc                    ;width of the output array of image buffers
num_y_max = float(num_x) * max_lasery / laserx   ;maximum height of output array of image buffers using 24 cm
npan_y    = fix(num_y_max / float(pan_y_sc))     ;the number of image buffers to be displayed in vertical
num_y     = npan_y * pan_y_sc                    ;height of output array of image buffer based on npan_y
lasery    = laserx * float(num_y) / float(num_x) ;height of output array in cm
num_pan   = npan_x * npan_y                      ;total number of image buffers displayed in array

;- Compute factors needed to display array of image buffers on screen
subsam    = float(num_x) / fac                   ;subsample factor needed to fit the output array within fac pixels
pan_sub_x = fix(float(pan_x_sc) / float(subsam)) ;width of each image buffer after subsampling
pan_sub_y = fix(float(pan_y_sc) / float(subsam)) ;height of each image buffer after subsampling
sub_x     = npan_x * pan_sub_x                   ;width of array of image bufers after subsampling
sub_y     = npan_y * pan_sub_y                   ;height of array of image bufers after subsampling

print,'num_x    : ',num_x
print,'num_y    : ',num_y
print,'subsam   : ',subsam
print,'pan_sub_x: ',pan_sub_x
print,'pan_sub_y: ',pan_sub_y
print,'sub_x    : ',sub_x
print,'sub_y    : ',sub_y

;- Needed to get black images on white background for the screen
white = bytarr(sub_x,sub_y)
white(*,*) = 255
loadct,0

window,xs=sub_x,ys=sub_y,1

num_buffs2get = (end_buffer - start_buffer) / skip + 1
num_pages = num_buffs2get / num_pan
if num_buffs2get mod num_pan ne 0 then num_pages = num_pages + 1

print,'num_pages: ',num_pages

eb_tem = start_buffer - skip

for kk=0,num_pages-1 do begin
	sb_tem = eb_tem + skip
	eb_tem = sb_tem + (num_pan - 1) * skip
 	;sb_tem = start_buffer + 1 + kk * num_pan - 1
 	;eb_tem = start_buffer + 1 + (kk + 1) * num_pan - 2
 	if eb_tem gt (end_buffer - 1) then eb_tem = end_buffer - 1

 	print,'sb_tem,eb_tem: ',sb_tem,eb_tem

 	wset,1
 	tv,white

	;- Image containing array of image buffers at full scale (for printing)
 	img_all = bytarr(num_x,num_y)
 	img_all(*,*) = 255
	;img_sub_all = bytarr(sub_x,sub_y)
	img = intarr(specs.pan_x,specs.pan_y)
	blob_simg = intarr(specs.nps,specs.nl)

 	for k=sb_tem,eb_tem,skip do begin

		buffer_num = k
		buffer_num_str = strtrim(fix(buffer_num),2)

		point_lun,unit,buf_ptrs(k)
  		readu,unit,buf1

		point_lun,unit,buf_ptrs(k+1)
  		readu,unit,buf2
  		;stop

		period = float(b_info_arr(k).div_fac) / (float(b_info_arr(k).mult_fac) * specs.clock_factor)
		print,'period: ',period

		case specs.probe_type of

			1: begin
		   		buf = [buf1(512:1023),buf2(0:511)]
		   		blob_img = get_img_2dc2(buf,b_info_arr(k).time_hrs,period,k,specs,p_info_arr)
		   		img(*,*) = 0
           		end

			2: begin
		   		buf = [buf1,buf2]
		   		blob_img = get_img_cp2(buf,b_info_arr(k).time_hrs,charge_sw,specs,k,unit_log, $
		                          		p_info_arr,charge_plates)
           		end

			3: begin
		   		buf = [buf1,buf2]
		   		buf = swap_endian(buf)
		   		blob_img = get_img_nd2(buf,b_info_arr(k).time_hrs,specs,period,k,unit_log,p_info_arr)
		   		end

			4: begin
		   		buf = [buf1,buf2]
		   		blob_img = get_img_h98(buf,b_info_arr(k).time_hrs,specs,period,k,unit_log,p_info_arr)
           		end

			5: begin
		   		buf = [buf1,buf2]
;		   		print,'buf1:',buf1
;		   		print,'buf2:',buf2
		   		blob_img = get_img_hail(buf,b_info_arr(k).time_hrs,specs,p_info_arr)
		   		period = 0.000004D
           		end

			;7: begin
		   	;	buf = [buf1(512:1023),buf2(0:511)]
		   	;	blob_img = get_img_2dc2(buf,b_info_arr(k).time_hrs,period,k,specs,p_info_arr)
		   	;	img(*,*) = 0
           	;	end
;
;			8: begin
;		   		buf = [buf1,buf2]
;		   		blob_img = get_img_cp2(buf,b_info_arr(k).time_hrs,charge_sw,specs,k,unit_log, $
;		                          		p_info_arr,charge_plates)
 ;          		end
  ;
;			9: begin
;		   		buf = [buf1(512:1023),buf2(0:511)]
;		   		blob_img = get_img_2dc2(buf,b_info_arr(k).time_hrs,period,k,specs,p_info_arr)
;		   		img(*,*) = 0
;           		end
;
;			10: begin
;		   		buf = [buf1,buf2]
;		   		blob_img = get_img_cp2(buf,b_info_arr(k).time_hrs,charge_sw,specs,k,unit_log, $
;		                          		p_info_arr,charge_plates)
;           		end

		endcase

		dim = size(blob_img)
    	xsize = dim(1)
    	ysize = dim(2)

print,'xsize=',xsize
print,'ysize=',ysize

		;- Scale the image in the horizontal to obtain a 1:1 aspect ratio (exc 2DC)

;***************************************************************
;changed on March 4, 2003
;***************************************************************
		if specs.xscale gt 1. then begin
			;xscale = period * b_info_arr(k).calc_tas_buff / (specs.y_resolution * 1.e-6)
			;xscale = 2.0  ;valid for all years except 2000

			if yr_number eq 2000 then xscale=4.0  ;valid for 2000 only
			if yr_number ne 2000 then xscale=2.0  ;valid for all years except 2000

			xsize = xsize * (xscale > 1.)
			print,'xscale,xsize,b_info_arr(k).calc_tas_buff: ',xscale,xsize,b_info_arr(k).calc_tas_buff
			blob_simg(0:xsize-1,*) = congrid(blob_img,xsize,ysize)

		endif else begin

			blob_simg(0:xsize-1,*) = blob_img(*,*)
		endelse
		blob_img = 0

		if specs.probe_type eq 1 then $
			img(*,2:33) = blob_simg(*,*) else $

			;img = blob_simg(0:specs.pan_x-1,*) ; original
			;-----------------------------------------------------------
			; this modification from the original was done to be able to
			; incorporate all the particles from the buffer with the
			; corresponding correction in the x direction
			;-----------------------------------------------------------
			img = blob_simg(30:30+specs.pan_x-1,*)

		ind1 = where(img eq 0,cnt)
		ind2 = where(img gt 0 or img le -2,cnt)
		img(ind1) = 255
		img(ind2) = 0

		;- Compute TAC
		inter_time_tem = p_info_arr(*).inter_part_time2
		seq_num_tem = p_info_arr(*).seq_num
		ind = where(seq_num_tem eq 1,cnt)
		if cnt ne 0 then tac = total(inter_time_tem(ind)) else tac = 0.

		;- Duration of buffer
		if k lt end_buffer then dur_tem = double(b_info_arr(k+1).time_hrs) - double(b_info_arr(k).time_hrs) else $
		                    	dur_tem = double(b_info_arr(k).time_hrs) - double(b_info_arr(k-1).time_hrs)
		dur_tem = dur_tem * 3600.

		b_info_arr(k).num_frames = float(max(p_info_arr(*).frame_num-1))
		b_info_arr(k).num_blobs  = float(n_elements(p_info_arr))		;# of 2d blobs (particles) in HVPS image

  		;img_sc = congrid(img,specs.pan_x,pan_y_sc)		;correction for TAS distortion
  		;img_sc = img

		;- Put a black border around the image buffer
  		img(0:1,*)     = 0
  		img(specs.pan_x-2:specs.pan_x-1,*) = 0
  		img(*,0:1)     = 0
  		img(*,pan_y_sc-2:pan_y_sc-1) = 0
  		print,'specs.pan_x=',specs.pan_x
  		print,'specs.pan_y=',specs.pan_y

		;- Stuff the image buffer into the array of image buffers
  		m1 = fix(((k - sb_tem) / skip) / npan_y)
  		m2 = fix(((k - sb_tem) / skip) mod npan_y)

  		x1 = m1 * specs.pan_x
  		x2 = (m1 + 1) * specs.pan_x - 1
  		y2 = num_y - (m2 * pan_y_sc) - 1
  		y1 = num_y - ((m2 + 1) * pan_y_sc - 1) - 1

  		img_all(x1:x2,y1:y2) = img(*,*)

		;- Subsample the image for display on the screen
  		img_sub = congrid(img,pan_sub_x,pan_sub_y)

		;- Put a border around each image buffer to be displayed on the screen
  		img_sub(0:1,*)     = 0
  		img_sub(pan_sub_x-2:pan_sub_x-1,*) = 0
  		img_sub(*,0:1)     = 0
  		img_sub(*,pan_sub_y-2:pan_sub_y-1) = 0

 		x1 = m1 * pan_sub_x                    ;x location for the image buffer on the screen
  		y1 = sub_y - ((m2 + 1) * pan_sub_y)    ;y location for the image buffer on the screen
  		x2 = x1 + pan_sub_x - 1
  		y2 = y1 + pan_sub_y - 1

		;img_sub_all(x1:x2,y1:y2) = img_sub(*,*)

  		wset,1
  		tv,img_sub,x1,y1

  		x1 = m1 * pan_sub_x + 5                ;x location for the time annotation in the image buffer
  		y1 = sub_y - (m2 * pan_sub_y + 10)     ;y location for the time annotation in the image buffer

  		time_str = buffer_num_str + '  ' + string(format='(f9.2)',b_info_arr(k).time_hms) ;+ $
  			;;;	'  TAC:' + string(format = '(f6.3)',tac) + $
  			;;;	'  Dur:' + string(format = '(f6.3)',dur_tem) + $
  			;;;	'  NB: ' + strtrim(fix(b_info_arr(k).num_blobs),2) + $
  			;;;	'  NF: ' + strtrim(fix(b_info_arr(k).num_frames),2)
             ;'  Tot:'  + strtrim(tot_buf_time,2) + $
             ;'  Wait:' + strtrim(wait_time,2) + $
             ;'  Img:'  + strtrim(tot_image_time,2) + $
             ;'  Img+Chg:'  + strtrim(tot_charge_time+tot_image_time,2) + $
             ;'  MF:'   + string(format = '(f5.1)',multiply_factor) + $
             ;'  DF:'   + string(format = '(f5.1)',divide_factor) + $
             ;'  FQ:'   + strtrim(multiply_factor * 50. / divide_factor,2) + ' KHz' + $
             ;'  NO:'   + strtrim(fix(num_overflows),2) + $
             ;'  Min:'  + strtrim((tot_counts1),2) + $
             ;'  Max:'  + strtrim((tot_counts2),2) + $
             ;'  NP:'   + strtrim(fix(num_particles),2) + $
             ;'  Mean:' + strtrim(mean_time_between,2)
             ;'  C3:'   + strtrim((tot_counts3),2)
 	 	xyouts,x1,y1,time_str,/device,charsize = 0.5,color=0  ;original
 	 	;xyouts,x1,y1,time_str,/device,charsize = 0.7,color=0

 	endfor

	;- Print to laser printer
 	laser_out = menu_wid_new(['Printer output?','Yes','No'])
 	laser_out = laser_out + 1
 	if laser_out eq 1 then begin

 		sw = 0
 		while sw ne 4 do begin

 			tv,congrid(img_all,fix(float(num_x)/2.),fix(float(num_y)/2.))
 			;tv,img_sub_all

 			;- Time annotate each image buffer
 			for k=sb_tem,eb_tem,skip do begin
   				buffer_num = k
   				buffer_num_str = strtrim(fix(buffer_num),2)
   				m1 = fix(((k - sb_tem) / skip) / npan_y)
   				m2 = fix(((k - sb_tem) / skip) mod npan_y)
   				x1 = fix((float(m1) * float(specs.pan_x) + 5.) * laserx * 1000. / float(num_x))
   				y1 = fix((float(num_y) - (float(m2) * float(pan_y_sc))) * lasery * 1000. / float(num_y))
   				y1 = y1 - 150
   				time_str = buffer_num_str + '  ' + strtrim(b_info_arr(k).time_hms,2)
   				;xyouts,x1,y1,time_str,/device,charsize = 0.5,color = 0
   				xyouts,x1,y1,time_str,/device,charsize = 0.7,color = 0
 			endfor
;titl = '2DC buffer display'
;titl = 'HVPS buffer display'
titl = title + ' buffer display'
 			;xyouts,0,lasery * 1000. + 30.,titl,charsize = 0.5,color = 0,/device     ;Title annotation at the top
;;;xyouts,0,lasery * 1000. + 100.,titl,charsize = 0.8,color = 0,/device     ;Title annotation at the top
;xyouts,0,lasery * 1000. + 50.,titl,charsize = 0.8,color = 0,/device
 			;laser_hvps,sw
 			;laser_widNew,sw
 			laser_wid_select,sw

 		endwhile

 	endif

endfor



free_lun,unit
free_lun,unit_log

end


