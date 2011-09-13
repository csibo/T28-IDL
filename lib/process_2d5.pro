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

;- process_2d5.pro

;- Main routine for calling display_buffers and find_part.
;- Display_buffers displays 1,2,or 3 columns of image buffers for selected buffer numbers.
;- Find_part calculates buffer and particle quantities for selected buffers and saves them
;- to .buf and .par files, respectively. It also creates a log file documenting anomalous
;- buffers, and a file that contains the indices for all occluded pixels (.ind).

pro process_2d5

print,''
print,'In the PROCESS_2D5 program!'
print,''

device,decomposed=0

@buff_struct

files = { fn_src : '', $
          fn_buf : '', $
          fn_par : '', $
          fn_ind : '', $
          fn_chg : '', $
          fn_log : '', $
          fn_slw : '', $
          fn_dir : '' }


files1995 = { fn_hvps : '', $   ; specifically designed for the 1995, 1998, 1999, 2001, 2002, 2003 data
         fn_rnd : '', $
          fn_buf : '', $
          fn_par : '', $
          fn_ind : '', $
          fn_chg : '', $
          fn_slw : '', $
          fn_log : '', $
          fn_dir : '' }

device,retain=2

;- Flights in which 2D data is available
probe = menu_wid_new([ 'Select Probe:' , '2DC Probe'     , $
                           'HVPS Probe'  , $
                           'HAIL Probe'])
probe = probe + 1


;=====================================================
; FOR 2DC PROBE
;=====================================================
if probe eq 1 then begin
  ; select year for the data
  yr = intarr(1)
  yrnos = ['Year 1995 (VORTEX Project)', $
        'Year 1998 (CHILL) Project',$
        'Year 1999 (Turbulence Project)', $
         'Year 2000 (STEPS Project)', $
         'Year 2001 (Rapid City)', $
         'Year 2002 (Rapid City and Colorado)', $
         'Year 2003 (Rapid City-Norman)', $
         'Year 2004 (Rapid City)', $
         'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
  if yr_ind eq 0 then yr_number = 1995
  if yr_ind eq 1 then yr_number = 1998
  if yr_ind eq 2 then yr_number = 1999
  if yr_ind eq 3 then yr_number = 2000
  if yr_ind eq 4 then yr_number = 2001
  if yr_ind eq 5 then yr_number = 2002
  if yr_ind eq 6 then yr_number = 2003
  if yr_ind eq 7 then yr_number = 2004
  print,'yr_ind = ',yr

   ; get the constants for 2DC probe
    specs = get_specs_2dc(probe-1)
    year = yr_number

   ; select the flight number, set titl to a string for the
   ; flight name, initialize the file names structure (files) and
   ; the b_info_arr structure array
   case yr_ind of
   ; - Year 1995 (VORTEX Project)
   0: begin
   	 select_flight_2dc, yr, flt_num, titl, year,fltno
     title = '2DC'
     flt_num_str = ''
     flt_num_str = strtrim(string(flt_num),2)
     init_sea,flt_num_str,specs,files,b_info_arr,buf_ptrs,year,fltno

      end

   ; - Year 1998 (CHILL) Project
   1: begin
     select_flight_2dc, yr, flt_num, titl, year,fltno
     title = '2DC'
     flt_num_str = ''
     flt_num_str = strtrim(string(flt_num),2)
     init_sea,flt_num_str,specs,files,b_info_arr,buf_ptrs,year,fltno

      end

   ; - Year 1999 (Turbulence Project)
   2: begin
       yr_number = 1999
       mes = 'Statistics not available for the 2DC instrument during 1999 field project!!'
       result = dialog_message(mes, /Information)
       print,result

      end

   ; - Year 2000 (STEPS Project)
   3: begin
     select_flight_2dc, yr, flt_num, titl, year,fltno
     title = '2DC'
     flt_num_str = ''
     flt_num_str = strtrim(string(flt_num),2)
     init_sea,flt_num_str,specs,files,b_info_arr,buf_ptrs,year,fltno

      end

   ; - Year 2001 (Rapid City)
   4: begin
     select_flight_2dc, yr, flt_num, titl, year,fltno
     title = '2DC'
     flt_num_str = ''
     flt_num_str = strtrim(string(flt_num),2)
     init_sea,flt_num_str,specs,files,b_info_arr,buf_ptrs,year,fltno

      end

   ; - Year 2002 (Rapid City + Greeley, CO)
   5: begin
     select_flight_2dc, yr, flt_num, titl, year,fltno
     title = '2DC'
     flt_num_str = ''
     flt_num_str = strtrim(string(flt_num),2)
     init_sea,flt_num_str,specs,files,b_info_arr,buf_ptrs,year,fltno

      end

   ; - Year 2003 (Norman, OK + Greeley, CO)
   6: begin
     select_flight_2dc, yr, flt_num, titl, year,fltno
     title = '2DC'
     flt_num_str = ''
     flt_num_str = strtrim(string(flt_num),2)
     init_sea,flt_num_str,specs,files,b_info_arr,buf_ptrs,year,fltno

      end

   ; - Year 2004 (Rapid City)
   7: begin
     select_flight_2dc, yr, flt_num, titl, year,fltno
     title = '2DC'
     flt_num_str = ''
     flt_num_str = strtrim(string(flt_num),2)
     init_sea,flt_num_str,specs,files,b_info_arr,buf_ptrs,year,fltno

      end

endcase

endif ; end if loop for 2DC probe

;=====================================================
; FOR HVPS PROBE
;=====================================================
 if probe eq 2 then begin
  ; select year for the data

  yr = intarr(1)
  yrnos = ['Year 1995 (VORTEX Project)', $
           'Year 1998 (CHILL) Project',$
           'Year 1999 (Turbulence Project)', $
           'Year 2000 (STEPS Project)', $
           'Year 2001 (Rapid City)', $
           'Year 2002 (Rapid City and Colorado)', $
           'Year 2003 (Rapid City-Norman)', $
           'Year 2004 (Rapid City)', $
           'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
   if yr_ind eq 0 then yr_number = 1995
   if yr_ind eq 1 then yr_number = 1998
   if yr_ind eq 2 then yr_number = 1999
   if yr_ind eq 3 then yr_number = 2000
   if yr_ind eq 4 then yr_number = 2001
   if yr_ind eq 5 then yr_number = 2002
   if yr_ind eq 6 then yr_number = 2003
   if yr_ind eq 7 then yr_number = 2004

  ; get the constants for HVPS probe
    specs = get_specs_HVPS(probe-1)
    year = yr_number
;stop
   ; select the flight number, set titl to a string for the
   ; flight name, initialize the file names structure (files) and
   ; the b_info_arr structure array
   case yr_ind of
   ; - Year 1995 (VORTEX Project)
   0: begin
   	  select_flight_hvps1, yr, fn_hvps, flt_num, title, year
   	  buf_size = 2048
      skip_bytes = bytarr(12)
      skip_bytes2 = bytarr(1)
      init_1995,flt_num,specs,files1995,b_info_arr,buf_ptrs,year
      title = 'HVPS'
      yr_number = 1995

      end

   ; - Year 1998 (CHILL) Project
   1: begin
      select_flight_hvps1, yr, fn_hvps, flt_num, title, year
      title = 'HVPS'
      fltno = fix(flt_num)
      init_sea,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 1998

      end

   ; - Year 1999 (Turbulence Project)
   2: begin
      mes = 'Statistics not available for the 2DC instrument during 1999 field project!!'
      result = dialog_message(mes, /Information)
      print,result
      yr_number = 1999

      end

   ; - Year 2000 (STEPS Project)
   3: begin
      select_flight_hvps1, yr, fn_hvps, flt_num, title, year
      title = 'HVPS'
      fltno = fix(flt_num)
      init_sea,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 2000

      end

   ; - Year 2001 (Rapid City)
   4: begin
     select_flight_hvps1, yr, fn_hvps, flt_num, title, year
     title = 'HVPS'
     fltno = fix(flt_num)
     init_sea,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
     yr_number = 2001

      end

   ; - Year 2002 (Rapid City + Greeley, CO)
   5: begin
      select_flight_hvps1, yr, fn_hvps, flt_num, title, year
      title = 'HVPS'
      fltno = fix(flt_num)
      init_sea,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 2002

      end

   ; - Year 2003 (Norman, OK + Greeley, CO)
   6: begin
      select_flight_hvps1, yr, fn_hvps, flt_num, title, year
      title = 'HVPS'

      fltno = fix(flt_num)
      init_sea,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 2003

      end

   ; - Year 2004 (Rapid City)
   7: begin
      select_flight_hvps1, yr, fn_hvps, flt_num, title, year
      title = 'HVPS'
      fltno = fix(flt_num)
      init_sea,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 2004

      end

 endcase

endif ; end if loop for HVPS probe


;=====================================================
; FOR HAIL PROBE
;=====================================================
if probe eq 3 then begin
  ; select year for the data
  yr = intarr(1)
  yrnos = ['Year 1995 (VORTEX Project)', $
           'Year 1998 (CHILL) Project',$
           'Year 1999 (Turbulence Project)', $
           'Year 2000 (STEPS Project)', $
           'Year 2001 (Rapid City)', $
           'Year 2002 (Rapid City and Colorado)', $
           'Year 2003 (Rapid City-Norman)', $
           'Year 2004 (Rapid)', $
           'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind

   if yr_ind eq 0 then yr_number = 1995
   if yr_ind eq 1 then yr_number = 1998
   if yr_ind eq 2 then yr_number = 1999
   if yr_ind eq 3 then yr_number = 2000
   if yr_ind eq 4 then yr_number = 2001
   if yr_ind eq 5 then yr_number = 2002
   if yr_ind eq 6 then yr_number = 2003
   if yr_ind eq 7 then yr_number = 2004

  ; get the constants for HAIL probe
    specs = get_specs_hail(probe-1)
    year = yr_number

   ; select the flight number, set titl to a string for the
   ; flight name, initialize the file names structure (files) and
   ; the b_info_arr structure array
   case yr_ind of
   ; - Year 1995 (VORTEX Project)
   0: begin
   	  select_flight_hail1, yr, fn_hail, flt_num, title, year
      init_seaN,flt_num,specs,files1995,b_info_arr,buf_ptrs,year
      title = 'hail'
      yr_number = 1995

      end

   ; - Year 1998 (CHILL) Project
   1: begin
      select_flight_hail1, yr, fn_hail, flt_num, title, year
      fltno = fix(flt_num)
      init_seaN,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 1998

      end

   ; - Year 1999 (Turbulence Project)
   2: begin
      mes = 'Statistics is not available for the Hail instrument during 1999 field project!'
      result = dialog_message(mes, /Information)
      print,result
      ;select_flight_hail1, yr, fn_hail, flt_num, title, year
      ;init_seaN_yr1999,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      ;yr_number = 1999

      end

   ; - Year 2000 (STEPS Project)
   3: begin
      select_flight_hail1, yr, fn_hail, flt_num, title, year
      fltno = fix(flt_num)
      init_seaN,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 2000

      end

   ; - Year 2001 (Rapid City)
   4: begin
     select_flight_hail1, yr, fn_hail, flt_num, title, year
     fltno = fix(flt_num)
     init_seaN,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
     yr_number = 2001

      end

   ; - Year 2002 (Rapid City + Greeley, CO)
   5: begin
      select_flight_hail1, yr, fn_hail, flt_num, title, year
      fltno = fix(flt_num)
      init_seaN,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 2002

      end

   ; - Year 2003 (Norman, OK + Greeley, CO)
   6: begin
      select_flight_hail1, yr, fn_hail, flt_num, title, year
      fltno = fix(flt_num)
      init_seaN,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 2003

      end

   ; - Year 2004 (Rapid City)
   7: begin
      select_flight_hail1, yr, fn_hail, flt_num, title, year
      fltno = fix(flt_num)
      init_seaN,flt_num,specs,files,b_info_arr,buf_ptrs,year,fltno
      yr_number = 2004

      end

 endcase

endif ; end if loop for HAIL probe



num_buffers = n_elements(b_info_arr)       ;The number of buffers for the selected probe type and flight
print,'num_buffers: ',num_buffers
print,'start time : ',b_info_arr(0).time_hms
print,'end time   : ',b_info_arr(num_buffers-1).time_hms
print,'Probe chosen is: ',title
print,''
;stop
;- Select the start and end buff times for display or processing
se = time_wid_mainNew(b_info_arr(*).time_hms)

start_buffer = se(0)
end_buffer   = se(1)
skip         = se(2)

if end_buffer ge (num_buffers-1) then end_buffer = num_buffers - 2

print,'start_buffer: ',start_buffer
print,'end_buffer  : ',end_buffer
print,'skip        : ',skip


;stop
ptype = menu_wid_new(['Select Processing:','Display Buffers','Find Blobs'])

systime_start = systime(0)
;stop

case ptype of

    0: begin
       ;if specs.probe_type eq 6 then begin
       if yr_ind eq 0 then begin
          display_buffers1995,files1995,specs,b_info_arr,start_buffer,end_buffer,skip,buf_ptrs
       endif else begin
           ;display_buffers2,files,specs,b_info_arr,start_buffer,end_buffer,skip,buf_ptrs,title,yr_number
          display_buffers4,files,specs,b_info_arr,start_buffer,end_buffer,$
                     skip,buf_ptrs,title,yr_number, probe, yr_ind
       endelse

       end

    1: begin
       ;if specs.probe_type eq 6 then begin
       if yr_ind eq 0 then begin
             find_part1995,files1995,specs,b_info_arr,start_buffer,end_buffer,buf_ptrs
       endif else begin
            ;find_part,files,specs,b_info_arr,start_buffer,end_buffer,buf_ptrs
            find_part1,files,specs,b_info_arr,start_buffer,end_buffer,buf_ptrs
       endelse

        end

    ;2: disp_buffs,files,specs,b_info_arr,buf_ptrs

endcase

print,'Start: ',systime_start
print,'End  : ',systime(0)

mes = 'The Raw Data Processing Is Done Now! Please continue with STEP 2 of Statistics option.'
result = dialog_message(mes, /Information)
print,result

WDELETE,1

end


