
;- disp_hail.pro

;- Main routine for calling display_buffers and find_part.
;- Display_buffers displays 1,2,or 3 columns of image buffers for
;  selected buffer numbers.
;- Find_part calculates buffer and particle quantities for selected
;  buffers and saves them to .buf and .par files, respectively.
;- It also creates a log file documenting anomalous buffers, and a file
;- that contains the indices for all occluded pixels (.ind).

pro disp_hail

device,decomposed=0,retain = 2

@buff_struct

files = { fn_src : '', $
          fn_buf : '', $
          fn_par : '', $
          fn_ind : '', $
          fn_chg : '', $
          fn_log : '', $
          fn_slw : '', $
          fn_dir : '' }

device,retain=2

probe_type = 4
probe_type = probe_type + 1

;- Get the constants for a specific probe type
specs = get_specs(probe_type-1)

           ;select_flight_1, ind_selected
           ;select_flight_slow_1, ind_selected
		 select_flight_hail, ind_selected

           ;read the needed fn from flightselected.txt
         if ind_selected lt 6 then begin
           dir2 = ''
           data_file = FILE_WHICH('t28idl.txt')
           openr, 1, data_file
           readf,1,dir2
           close,1

           fn_out = ''
           title_flt = ''
           fltno = intarr(1)
           fltnos = ''
           fn_hvps=''
           fn_reduced =''
           fn_2dc = ''
           fssp_chn = ''
           fn_posttel = ''
           year = ''
           fn_hail = ''
           fn_raw = ''

           openr,1,dir2+'lib' + path_sep() + 'flightselected.txt'
           readf,1,fn_out
           readf,1,title_flt
           readf,1,fltnos
           close,1

	if ((fltnos ge 725) AND (fltnos lt 738)) then begin
	   openr,1,dir2+'lib' + path_sep() + 'flightselected.txt'
           readf,1,fn_out
           readf,1,title_flt
           readf,1,fltnos
           readf,1,fn_reduced
           readf,1,fn_2dc
           readf,1,fssp_chn
           readf,1,fn_posttel
           readf,1,year
           readf,1,fn_hail
           readf,1,fn_raw
           close,1

	endif else begin

	   openr,1,dir2+'lib' + path_sep() + 'flightselected.txt'
           readf,1,fn_out
           readf,1,title_flt
           readf,1,fltnos
           readf,1,fn_hvps
           readf,1,fn_reduced
           readf,1,fn_2dc
           readf,1,fssp_chn
           readf,1,fn_posttel
           readf,1,year
           readf,1,fn_hail
           readf,1,fn_raw
           close,1

		endelse

           fltno = fltnos

           titl =title_flt

           init_sean,fltno,specs,files,b_info_arr,buf_ptrs,year,fltnos
;stop
num_buffers = n_elements(b_info_arr)       ;The number of buffers for the selected probe type and flight
print,'num_buffers: ',num_buffers
start_time = b_info_arr(0).time_hms
print,'start time : ',b_info_arr(0).time_hms
end_time = b_info_arr(num_buffers-1).time_hms
print,'end time   : ',b_info_arr(num_buffers-1).time_hms
print,''

;- Select the start and end buff times for display or processing
se = time_wid_mainnew(b_info_arr(*).time_hms)

start_buffer = se(0)
end_buffer   = se(1)
skip         = se(2)


if end_buffer ge (num_buffers-1) then end_buffer = num_buffers - 2

print,'start_buffer: ',start_buffer
print,'end_buffer  : ',end_buffer
print,'skip        : ',skip


;stop
ptype = menu_wid_new(['Processing:','Display HAIL Buffers', 'Write Hail-Count Output File'])

systime_start = systime(0)

base=widget_base(/column)
ev=widget_event(base)
widget_control,base,set_uvalue=state2dc

case ptype of

    0: display_buffers2,files,specs,b_info_arr,start_buffer,end_buffer,skip,buf_ptrs,titl

    1: towrite_hail_file, 0, start_time, end_time, num_buffers, start_buffer, end_buffer, b_info_arr,ev

endcase

print,'Start: ',systime_start
print,'End  : ',systime(0)

mes = 'The Raw Data Processing Is Done Now!'
result = dialog_message(mes, /Information)
print,result

WDELETE,1

endif

end
