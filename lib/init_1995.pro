; Copyright © 2001, IAS, SD School of Mines and Technology.
; This software is provided as is without any warranty whatsoever.
; It may be freely used, copied or distributed, for non-commercial
; purposes. This copyright notice must be kept with any copy of this
; software.  If this software shall be used commercially or sold
; as part of a larger package, please contact the copyright holder
; to arrange payment. Bugs and comments should be directed to
; t28user@typhoon.ias.sdsmt.edu with subject "t28display IDL routine".
;
;------------------------------------------------------------------------------------------

;- init_1995.pro
;
;- Modified init_sea.pro program to be able to work with the 1995 HVPS data
;
;- LAST MODIFIED: January, 2002
;----------------------------------------------------------------------------

pro init_1995,flt_num_str,specs, $
             files1995,b_info_arr,buf_ptrs,year

;- This routine performs 3 tasks:
;-	1. Construct the filenames in the structure files
;-	2. Fill some of the elements of the structure array, b_info_arr
;-	3. Get the pointers to the image buffers (buf_ptrs)

;- Input
;-	flt_num_str - The flight number in a string.
;-	specs - A structure of constants for a specific probe (from get_specs).

;- Output
;-	files - A structure of filenames needed for this processing
;-		fn_src - The raw SEA file (from the T28) (input file)
;-		fn_buf - The file to which b_info_arr (buffer quantities) are written (output file)
;-		fn_ind - The file to which the indices of the decoded image buffer are written (output file).
;-		fn_par - The file to which p_info_arr (particle quantities) is written (output file).
;-		fn_chg - The file to which the charge data is written (if there is any) (output file).
;-		fn_log - The file to which processing anamolies are written (output file).
;-		fn_slw - The file to which some slow data quantities are written (output file).
;-	b_info_arr - A structure array of buffer quantities (one array element for each buffer).
;-               Only the following quantities for each structure element are filled here:
;-		time_hrs - Time of buffer in hours.
;-		time_hms - Time of buffer in hh:mm:ss.
;-		img_ptr - A file pointer to the image buffer.
;-		mult_fac - The multiply factor for the buffer.
;-		div_fac - The divide factor for the buffer.
;-		elapsed_time - The elapsed time for the buffer (if available).
;-		calc_tas_buff - The calculated TAS corresponding to the buffer (from slow data).
;-		rose_buff - The rosemount temperature for the buffer (from slow data).
;-		press1_buff - Static pressure 1 for the buffer (from slow data).
;-		fssp_lw_buff - FSSP LW for the buffer (from slow data).
;-		time_rnd - The actual slow data buffer time from which the above were derived in hms.
;-	buf_ptrs - The pointers to every image buffer (duplicate of b_info_arr.img_ptr).

@buff_struct

files1995 = { fn_hvps : '', $   ; specifically designed for the 1995 data
		  fn_rnd : '', $
          fn_buf : '', $
          fn_par : '', $
          fn_ind : '', $
          fn_chg : '', $
          fn_slw : '', $
          fn_log : '', $
          fn_dir : '' }

;- Construct the file name for the raw hvps data
;stop
files1995.fn_hvps = specs.data_path + year + path_sep()+'f' + flt_num_str + path_sep()+'hvps_' + flt_num_str + '.dat'

;- Check if fn_hvps already exists. If it does not, print message and stop.
openr,unit,files1995.fn_hvps,/get_lun,error = err
if err ne 0 then begin
	ans = dialog_message(files1995.fn_hvps + ' does not exist - please check data_path in get_specs.pro')
	stop
endif
free_lun,unit

;- Construct the file name for the reduced data
;stop
files1995.fn_rnd = specs.data_path + year + path_sep()+'f' + flt_num_str + path_sep()+'flt' + flt_num_str + '.rnd'

;- Check if fn_rnd already exists. If it does not, print message and stop.
openr,unit,files1995.fn_rnd,/get_lun,error = err
if err ne 0 then begin
	ans = dialog_message(files1995.fn_rnd + ' does not exist - please check data_path in get_specs.pro')
	stop
endif
free_lun,unit

;- Construct the file name for the buffer data
buf_path = specs.buf_path + year + path_sep()+'' + flt_num_str   + path_sep()+'f' + flt_num_str ;+ specs.probe_name
;stop
files1995.fn_buf = buf_path  + specs.probe_name + '.buf'

;- Check if fn_buf already exists. If it does, ask if it is OK to overwrite or ask for another file name
ans = dialog_message('Will you be running find_part for ' + specs.probe_name + '?',/question)
if ans eq 'Yes' then begin
	openr,unit,files1995.fn_buf,/get_lun,error = err
	if err eq 0 then begin
		ans = menu_wid(['"' + files1995.fn_buf + '" Exists:','OK (Overwrite)','Select New File Name'])
		if ans eq 1 then begin
			files1995.fn_buf = input_wid(initial_value = files1995.fn_buf,input_title = 'Enter New Filename')
			len = strlen(files1995.fn_buf)
			buf_path = strmid(files1995.fn_buf,0,len-4)
		endif
		free_lun,unit
	endif
endif

;- Construct the file names for the other output files
print,'buf_path: ',buf_path
files1995.fn_par = buf_path + specs.probe_name + '.par'
print,'files1995.fn_par: ',files1995.fn_par
files1995.fn_ind = buf_path + specs.probe_name + '.ind'
files1995.fn_log = buf_path + specs.probe_name + '.log'
files1995.fn_slw = buf_path + specs.probe_name + '.slw'
files1995.fn_chg = buf_path + specs.probe_name + '.chg'
files1995.fn_dir = buf_path + '.dir'
;stop
;- Fill the time and image pointer elements in the b_info_arr array structure.
;- Set the image pointers to a separate array (buf_ptrs)
time_struct = get_1995_ptrs(files1995.fn_hvps,files1995.fn_rnd,specs.img_sea_tag,1,/summ,fn_dir = files1995.fn_dir)
num_buffers = n_elements(time_struct.time_hrs)

print,'num_buffers = ',num_buffers
;stop
b_info_arr = replicate(b_info,num_buffers)
b_info_arr(*).time_hrs = time_struct.time_hrs(*)
b_info_arr(*).time_hms = float(time_struct.time_hms(*))
b_info_arr(*).img_ptr  = float(time_struct.buf_ptrs(*))
buf_ptrs = time_struct.buf_ptrs(*)
time_struct = 0
;stop
;- Get the pointers to the multiply/divide factors and the elapsed times.
;tem_struct = get_1995_ptrs2(files1995.fn_rnd,specs.mdf_sea_tag,num_buffers,fn_dir=files1995.fn_dir)
;mdf_ptrs = tem_struct.buf_ptrs
;tem_struct = get_1995_ptrs2(files1995.fn_rnd,specs.et_sea_tag,num_buffers,fn_dir=files1995.fn_dir)
;et_ptrs = tem_struct.buf_ptrs

;- Fill the multiply and divide factors, and the elapsed time in the b_info_arr array structure.
;tas_factors = get_tas_factors(files1995.fn_src,mdf_ptrs)
;b_info_arr(*).mult_fac = tas_factors.multiply_factor(*)
;b_info_arr(*).div_fac  = tas_factors.divide_factor(*)
;tas_factors = 0

b_info_arr(*).mult_fac = 10		;these values do not exist in the orriginal
b_info_arr(*).div_fac  = 10		;raw file.  The values were given in order to follow the
								;structure of the T28DISPLAY program (valid for the 2000 STEPS data)

;elapsed_time = get_elapsed(files1995.fn_src,et_ptrs)
;b_info_arr(*).elapsed_time = elapsed_time(*) * specs.elapsed_factor
;elapsed_time = 0
b_info_arr(*).elapsed_time = 0.1 ;these values do not exist in the orriginal


;- Get the slow data from the raw file and fill the appropriate elements in the b_info_arr array
;- structure. Check if the data has already been extracted and saved to a separate file. If so, read
;- the data from there (much faster).
print,'Extracting Slow (reduced) Data ...'
;openr,unit,files1995.fn_rnd,/get_lun,error = err
;stop
read_rnd1995, files1995.fn_rnd, num_tags,tags,tag_ind, data, num1, hrs, hms, err

if err eq 0 then begin  ; the reduced data file exists

	raw_struct = { calc_tas :fltarr(num_buffers), $
                   rose     :fltarr(num_buffers), $
                   press1   :fltarr(num_buffers), $
                   fssp_lw  :fltarr(num_buffers), $
                   time_raw :fltarr(num_buffers), $
                   fssp_cnts:fltarr(num_buffers) }
	;readu,unit,raw_struct
	;free_lun,unit

   ; include the corresponding slow data for each HVPS time buffer

for b = 0, num_buffers -1 do begin
	tag1 = 211 ; calc_tas
	;find the calc_tas closest value to the HVPS buffer time
	ind_tag1 = where(abs(hms-b_info_arr(b).time_hms) le 1.0,n)
	;print,'number of values found = ', n
	tag1n = where(tags eq tag1,t)  ; tag1n = 98
	;print,'number of tags matching calc_tas = ',t
	;stop
	raw_struct.calc_tas(b) = data(tag1n+1,ind_tag1(0))  ; just take the first
	;stop													;closest value
	tag2 = 106 ;rose
	tag2n = where(tags eq tag2,t)
	;print,'number of tags matching rose = ',t
	raw_struct.rose(b) = data(tag2n+1,ind_tag1(0))
;;;;stop
	tag3 = 103 ;press1
	tag3n = where(tags eq tag3,t)
	;print,'number of tags matching press1 = ',t
	ind_tag3 = where(tags eq tag3,cnt3)
	raw_struct.press1(b) = data(tag3n+1,ind_tag1(0))
	;stop
	tag4 = 144 ;fssp_lw
	tag4n = where(tags eq tag4,t)
	;print,'number of tags matching fssp_lw = ',t
	ind_tag4 = where(tags eq tag4,cnt4)
	raw_struct.fssp_lw(b) = data(tag4n+1,ind_tag1(0))
	;stop
	 ;time raw
	raw_struct.time_raw(b) = hrs(ind_tag1(0))    ;data(0,*)
	;stop

	tag5 = 141 ;fssp_cnts
	tag5n = where(tags eq tag5,t)
	;print,'number of tags matching fssp_cnts = ',t
	ind_tag5 = where(tags eq tag5,cnt5)
	raw_struct.fssp_cnts(b) = data(tag5n+1,ind_tag1(0))
	;stop
endfor

;stop
endif else begin
	;raw_struct = get_tas_raw(files1995.fn_src,b_info_arr(*).time_hrs,fndir=files1995.fn_dir)
	;openw,unit,files1995.fn_slw,/get_lun
	;writeu,unit,raw_struct
	;free_lun,unit

	print,'The reduced data file for the 1995 data cannot be found!'

endelse

b_info_arr(*).calc_tas_buff = raw_struct.calc_tas(*)
b_info_arr(*).rose_buff     = raw_struct.rose(*)
b_info_arr(*).press1_buff   = raw_struct.press1(*)
b_info_arr(*).fssp_lw_buff  = raw_struct.fssp_lw(*)
b_info_arr(*).time_rnd      = raw_struct.time_raw(*)
raw_struct = 0

;- In case a comparison with extracted raw data is needed
;fn_reduced = data_path + 'Rnd\flt' + flt_num_str(flt_num) + '.rnd'
;rnd_struct = get_tas_rnd(fn_reduced,b_info_arr(*).time_hrs)

;- Plot the b_info_arr quantities filled above. Check if they seem reasonable.
window,xs=300,ys=600,/free,title='Plot of Extracted Data - ' + specs.probe_name
win_num = !d.window

sw = 0
while sw ne 4 do begin

	!p.multi = [0,1,6]

	plot,b_info_arr(*).mult_fac, $
		background = 255, $
		color = 0, $
		title = 'Muliply Factor', $
		charsize = 1.5, $
		/ynozero
    xyouts,b_info_arr(0).mult_fac, 10.4,$
           'Not available for the 1995 HVPS data.', charsize = 0.9, $
           color=0

	plot,b_info_arr(*).div_fac, $
		background = 255, $
		color = 0, $
		title = 'Divide Factor', $
		charsize = 1.5, $
		/ynozero
	xyouts,b_info_arr(0).div_fac, 10.4,$
           'Not available for the 1995 HVPS data.', charsize = 0.9, $
           color=0

	plot,b_info_arr(*).elapsed_time, $
		background = 255, $
		color = 0, $
		charsize = 1.5, $
		title = 'Elapsed Time', $
		ytitle = 'Seconds'
	xyouts,b_info_arr(0).elapsed_time, 0.04,$
           'Not available for the 1995 HVPS data.', charsize = 0.9, $
           color=0

	plot,b_info_arr(*).calc_tas_buff, $
		background = 255, $
		color = 0, $
		title = 'Calculated TAS', $
		charsize = 1.5, $
		/ynozero, $
		ytitle = 'm/s'

	plot,(b_info_arr(*).mult_fac * specs.clock_factor * specs.x_resolution * 1.e-6) / b_info_arr(*).div_fac, $
		background = 255, $
		color = 0, $
		title = 'TAS Clock', $
		charsize = 1.5, $
		/ynozero, $
		ytitle = 'm/s'
	xyouts,(b_info_arr(0).mult_fac * specs.clock_factor * specs.x_resolution * 1.e-6), 10.4,$
           'Not available for the 1995 HVPS data.', charsize = 0.9, $
           color=0

	plot,b_info_arr(*).fssp_lw_buff, $
		background = 255, $
		color = 0, $
		title = 'FSSP LW', $
		charsize = 1.5, $
		yrange=[-0.5,10.], $
		ytitle = 'g/m!E3!N'

	;plot,((b_info_arr(*).time_rnd) - hms2hrs2(b_info_arr(*).time_hms)), $ ;* 3600., $
	;	background = 255, $
	;	color = 0, $
	;	title = 'Difference - Slow and Buffer Times', $
	;	ytitle = 'Seconds', $
	;	charsize = 1.5, $
	;	/ynozero

	!p.multi = 0

	laser_wid,sw

endwhile

wdelete,win_num

end
