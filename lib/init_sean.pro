
;- init_seaN.pro
;- used for disp_hail.pro only

pro init_seaN,flt_num_str,specs,files,b_info_arr,buf_ptrs,year,fltno
             ;files,b_info_arr,buf_ptrs,year

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

if (strmid(year,2) eq 1999) then begin
 @buff_struct_yr1999
endif else begin
 @buff_struct
endelse

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
files.fn_src = specs.data_path + year + path_sep() + 'f' + flt_num_str + path_sep() + $
   'flt' + flt_num_str + '.src'

print,'files.fn_src = ',files.fn_src

;stop
;- Check if fn_src already exists. If it does not, print message and stop.
openr,unit,files.fn_src,/get_lun,/swap_if_big_endian,error = err
if err ne 0 then begin
    ans = dialog_message(files.fn_src + ' does not exist - please check data_path in get_specs.pro')
    
endif
free_lun,unit

;- Construct the file name for the buffer data
buf_path = specs.buf_path + year + path_sep() + flt_num_str + path_sep() + 'f' + flt_num_str ;+ specs.probe_name
files.fn_buf = buf_path + specs.probe_name + '.buf'
;stop

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

;- Construct the file names for the other output files
print,'buf_path: ',buf_path
files.fn_par = buf_path + '.par'
;print,'files.fn_par: ',files.fn_par
files.fn_ind = buf_path + '.ind'
files.fn_log = buf_path + '.log'
files.fn_slw = buf_path + '.slw'
files.fn_chg = buf_path + '.chg'
files.fn_dir = buf_path + '.dir'
;files.fn_par = buf_path + specs.probe_name + '.par'
;;print,'files.fn_par: ',files.fn_par
;files.fn_ind = buf_path + specs.probe_name + '.ind'
;files.fn_log = buf_path + specs.probe_name + '.log'
;files.fn_slw = buf_path + specs.probe_name + '.slw'
;files.fn_chg = buf_path + specs.probe_name + '.chg'
;files.fn_dir = buf_path + '.dir'
;stop

;- Fill the time and image pointer elements in the b_info_arr array structure.
;- Set the image pointers to a separate array (buf_ptrs)
if ((flt_num_str ge '725') AND (flt_num_str le '737')) then begin
time_struct = get_sea_ptrs_yr1999(flt_num_str,files.fn_src,specs.img_sea_tag,1,/summ,fn_dir = files.fn_dir)
num_buffers = n_elements(time_struct.time_hrs)
b_info_arr = replicate(b_info,num_buffers)
endif else begin
time_struct = get_sea_ptrs2(files.fn_src,specs.img_sea_tag,1,/summ,fn_dir = files.fn_dir)
num_buffers = n_elements(time_struct.time_hrs)
b_info_arr = replicate(b_info,num_buffers)
endelse


;correct the time for the f751 when the computer was slow 1min 47sec
if (fltno eq 751) then begin

    for i=0l, num_buffers-1l do begin
       b_info_arr(*).time_hrs = time_struct.time_hrs(*)
       b_info_arr(*).time_hms = float(time_struct.time_hms(*))

       hr = fix(b_info_arr(i).time_hrs)
       minute_to_seconds = (b_info_arr(i).time_hrs-hr)*60.0*60.0
       new_time_sec = hr*3600.0 + minute_to_seconds + 107 ; add the time difference
       b_info_arr(i).time_hrs = new_time_sec/3600.0

       new_hr =  fix(b_info_arr(i).time_hrs)
       new_minutes = (b_info_arr(i).time_hrs-new_hr)*60.0
       temp_new_minutes = fix(new_minutes)
       b_info_arr(i).time_hms = fix(b_info_arr(i).time_hrs)*10000.0 + $                 ; hrs
                     fix(new_minutes)*100.0 + $                   ; minutes
                     (new_minutes - temp_new_minutes)*60.0        ;seconds
     endfor

    print,'modified First time point     : ',fix(b_info_arr(0).time_hrs), fix(b_info_arr(i).time_hms)
    print,'modified Last time point      : ',fix(b_info_arr(num_buffers-1).time_hrs), fix(b_info_arr(num_buffers-1).time_hrs)

endif else begin

b_info_arr(*).time_hrs = time_struct.time_hrs(*)
b_info_arr(*).time_hms = float(time_struct.time_hms(*))

endelse

b_info_arr(*).img_ptr  = float(time_struct.buf_ptrs(*))
buf_ptrs = time_struct.buf_ptrs(*)
time_struct = 0

;- Get the pointers to the multiply/divide factors and the elapsed times.
tem_struct = get_sea_ptrs2(files.fn_src,specs.mdf_sea_tag,num_buffers,fn_dir=files.fn_dir)
mdf_ptrs = tem_struct.buf_ptrs
tem_struct = get_sea_ptrs2(files.fn_src,specs.et_sea_tag,num_buffers,fn_dir=files.fn_dir)
et_ptrs = tem_struct.buf_ptrs


end