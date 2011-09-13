
;- init_sea.pro

pro init_sea,flt_num_str,specs, $
             files,b_info_arr,buf_ptrs,year,fltno

;- This routine performs 3 tasks:
;-  1. Construct the filenames in the structure files
;-  2. Fill some of the elements of the structure array, b_info_arr
;-  3. Get the pointers to the image buffers (buf_ptrs)

;- Input
;-  flt_num_str - The flight number in a string.
;-  specs - A structure of constants for a specific probe (from get_specs).

;- Output
;-  files - A structure of filenames needed for this processing
;-   fn_src - The raw SEA file (from the T28) (input file)
;-   fn_buf - The file to which b_info_arr (buffer quantities) are written (output file)
;-   fn_ind - The file to which the indices of the decoded image buffer are written (output file).
;-   fn_par - The file to which p_info_arr (particle quantities) is written (output file).
;-   fn_chg - The file to which the charge data is written (if there is any) (output file).
;-   fn_log - The file to which processing anamolies are written (output file).
;-   fn_slw - The file to which some slow data quantities are written (output file).
;-  b_info_arr - A structure array of buffer quantities (one array element for each buffer).
;-               Only the following quantities for each structure element are filled here:
;-   time_hrs - Time of buffer in hours.
;-   time_hms - Time of buffer in hh:mm:ss.
;-   img_ptr - A file pointer to the image buffer.
;-   mult_fac - The multiply factor for the buffer.
;-   div_fac - The divide factor for the buffer.
;-   elapsed_time - The elapsed time for the buffer (if available).
;-   calc_tas_buff - The calculated TAS corresponding to the buffer (from slow data).
;-   rose_buff - The rosemount temperature for the buffer (from slow data).
;-   press1_buff - Static pressure 1 for the buffer (from slow data).
;-   fssp_lw_buff - FSSP LW for the buffer (from slow data).
;-   time_rnd - The actual slow data buffer time from which the above were derived in hms.
;-  buf_ptrs - The pointers to every image buffer (duplicate of b_info_arr.img_ptr).

@buff_struct

files = { fn_src : '', $
          fn_buf : '', $
          fn_par : '', $
          fn_ind : '', $
          fn_chg : '', $
          fn_log : '', $
          fn_slw : '', $
          fn_dir : '' }

;- Construct the file name for the raw data
;stop
files.fn_src = specs.data_path + year + path_sep()+'f' + flt_num_str + path_sep()+'flt' + flt_num_str + '.src'
;stop
;- Check if fn_src already exists. If it does not, print message and stop.
openr,unit,files.fn_src,/get_lun,error = err
if err ne 0 then begin
    ans = dialog_message(files.fn_src + ' does not exist - please check data_path in get_specs.pro')
    ;stop
endif
free_lun,unit
;stop
;- Construct the file name for the buffer data
buf_path = specs.buf_path + year + path_sep() + flt_num_str   + path_sep()+'f' + flt_num_str ;+ specs.probe_name
;stop
files.fn_buf = buf_path  + specs.probe_name + '.buf'

;- Check if fn_buf already exists. If it does, ask if it is OK to overwrite or ask for another file name
ans = dialog_message('Will you be running find_part for ' + specs.probe_name + '?',/question)
if ans eq 'Yes' then begin
    openr,unit,files.fn_buf,/get_lun,error = err
    ;stop
    if err eq 0 then begin

       ans = menu_wid(['"' + files.fn_buf + '" Exists:','OK (Overwrite)','Select New File Name'])

       if ans eq 1 then begin
         files.fn_buf = input_wid(initial_value = files.fn_buf,input_title = 'Enter New Filename')
         len = strlen(files.fn_buf)
         buf_path = strmid(files.fn_buf,0,len-4)
         index_fn = 1
       endif

       if ans eq 0 then begin
        index_fn = 0
        ;stop
       endif
       ;stop
       free_lun,unit
    endif
endif

;;- Construct the file names for the other output files
if (index_fn eq 1) then begin
        print,'buf_path: ',buf_path
        files.fn_par = buf_path + '.par'
        print,files.fn_par
        files.fn_ind = buf_path + '.ind'
        files.fn_log = buf_path + '.log'
        files.fn_slw = buf_path + '.slw'
        files.fn_chg = buf_path + '.chg'
        files.fn_dir = buf_path + '.dir'

 endif

if (index_fn eq 0) then begin
        print,'buf_path: ',buf_path
        files.fn_par = buf_path + specs.probe_name + '.par'
        print,files.fn_par
        files.fn_ind = buf_path + specs.probe_name + '.ind'
        files.fn_log = buf_path + specs.probe_name + '.log'
        files.fn_slw = buf_path + specs.probe_name + '.slw'
        files.fn_chg = buf_path + specs.probe_name + '.chg'
        files.fn_dir = buf_path + '.dir'
 endif

;- Fill the time and image pointer elements in the b_info_arr array structure.
;- Set the image pointers to a separate array (buf_ptrs)
time_struct = get_sea_ptrs2(files.fn_src,specs.img_sea_tag,1,/summ,fn_dir = files.fn_dir)
num_buffers = n_elements(time_struct.time_hrs)
print,'num_buffers = ',num_buffers
b_info_arr = replicate(b_info,num_buffers)
;stop
;correct the time for the f751 when the computer was slow 1min 47sec
if (fltno eq 751) then begin

    for i=0, num_buffers-1 do begin
       b_info_arr(*).time_hrs = time_struct.time_hrs(*)
       b_info_arr(*).time_hms = float(time_struct.time_hms(*))

       hr = fix(b_info_arr(i).time_hrs)
       minute_to_seconds = (b_info_arr(i).time_hrs-hr)*60.0*60.0
       new_time_sec = hr*3600.0 + minute_to_seconds + 107 ; add the time difference
       b_info_arr(i).time_hrs = new_time_sec/3600.0

       new_hr =  fix(b_info_arr(i).time_hrs)
       new_minutes = (b_info_arr(i).time_hrs-new_hr)*60.0
       temp_new_minutes = fix(new_minutes)
       b_info_arr(i).time_hms = fix(b_info_arr(i).time_hrs)*10000.0 + $      ; hrs
                              fix(new_minutes)*100.0 + $                   ; minutes
                           (new_minutes - temp_new_minutes)*60.0        ;seconds
     endfor

    print,'modified First time point     : ',b_info_arr(0).time_hrs, b_info_arr(0).time_hms
    print,'modified Last time point      : ',b_info_arr(num_buffers-1).time_hrs, b_info_arr(num_buffers-1).time_hrs


endif else begin

  b_info_arr(*).time_hrs = time_struct.time_hrs(*)
  b_info_arr(*).time_hms = float(time_struct.time_hms(*))

endelse
;b_info_arr(*).time_hrs = time_struct.time_hrs(*)
;b_info_arr(*).time_hms = float(time_struct.time_hms(*))
b_info_arr(*).img_ptr  = float(time_struct.buf_ptrs(*))
buf_ptrs = time_struct.buf_ptrs(*)
time_struct = 0

;- Get the pointers to the multiply/divide factors and the elapsed times.
tem_struct = get_sea_ptrs2(files.fn_src,specs.mdf_sea_tag,num_buffers,fn_dir=files.fn_dir)
mdf_ptrs = tem_struct.buf_ptrs
tem_struct = get_sea_ptrs2(files.fn_src,specs.et_sea_tag,num_buffers,fn_dir=files.fn_dir)
et_ptrs = tem_struct.buf_ptrs

;- Fill the multiply and divide factors, and the elapsed time in the b_info_arr array structure.
tas_factors = get_tas_factors(files.fn_src,mdf_ptrs)
b_info_arr(*).mult_fac = tas_factors.multiply_factor(*)
b_info_arr(*).div_fac  = tas_factors.divide_factor(*)
tas_factors = 0

elapsed_time = get_elapsed(files.fn_src,et_ptrs)
b_info_arr(*).elapsed_time = elapsed_time(*) * specs.elapsed_factor
elapsed_time = 0

;- Get the slow data from the raw file and fill the appropriate elements in the b_info_arr array
;- structure. Check if the data has already been extracted and saved to a separate file. If so, read
;- the data from there (much faster).
print,'Extracting Slow Data ...'
openr,unit,files.fn_slw,/get_lun,error = err
if err eq 0 then begin
    raw_struct = { calc_tas :fltarr(num_buffers), $
                   rose     :fltarr(num_buffers), $
                   press1   :fltarr(num_buffers), $
                   fssp_lw  :fltarr(num_buffers), $
                   time_raw :fltarr(num_buffers), $
                   fssp_cnts:fltarr(num_buffers) }
    readu,unit,raw_struct
    free_lun,unit
endif else begin
    raw_struct = get_tas_raw(files.fn_src,b_info_arr(*).time_hrs,fn_dir=files.fn_dir)
    openw,unit,files.fn_slw,/get_lun
    writeu,unit,raw_struct
    free_lun,unit
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

    !p.multi = [0,1,7]

    plot,b_info_arr(*).mult_fac, $
       background = 255, $
       color = 0, $
       title = 'Muliply Factor', $
       charsize = 1.5, $
       /ynozero

    plot,b_info_arr(*).div_fac, $
       background = 255, $
       color = 0, $
       title = 'Divide Factor', $
       charsize = 1.5, $
       /ynozero

    plot,b_info_arr(*).elapsed_time, $
       background = 255, $
       color = 0, $
       charsize = 1.5, $
       title = 'Elapsed Time', $
       ytitle = 'Seconds'

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

    plot,b_info_arr(*).fssp_lw_buff, $
       background = 255, $
       color = 0, $
       title = 'FSSP LW', $
       charsize = 1.5, $
       yrange=[-.5,3.], $
       ytitle = 'g/m!E3!N'

    plot,(hms2hrs2(b_info_arr(*).time_rnd) - hms2hrs2(b_info_arr(*).time_hms)) * 3600., $
       background = 255, $
       color = 0, $
       title = 'Difference - Slow and Buffer Times', $
       ytitle = 'Seconds', $
       charsize = 1.5, $
       /ynozero

    !p.multi = 0

    laser_wid,sw

endwhile

wdelete,win_num

end
