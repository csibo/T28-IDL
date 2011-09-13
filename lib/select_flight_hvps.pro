; select_flight_hvps.pro
;
; Routine written to be called when user selects the flight to view.
; It will save the needed information into the lib/flightselected.txt
;
; Written by Donna Kliche
; Last modified: June 24, 2002
; Last modified: February 21, 2008
;	- Donna added flights for 1999 Turbulence Project
;
;---------------------------------------------------------------------

pro select_flight_hvps, yr

; select year for the data
yr = -1
while (yr eq -1) do begin
   yr = intarr(1)
   yrnos = ['Year 1995 - VORTEX', $
        'Year 1998 - TINT',$
        'Year 1999 - TCAD', $
         'Year 2000 - STEPS', $
         'Year 2002 - CHILL-TEX', $
         'Year 2003 - JPOLE/TELEX and CHILL-TEX' ,$
         'Return']

   yr_ind = menu_wid_wide(['Select Year:',yrnos])
   yr = yr_ind

   print,'yr_ind = ',yr

   dir1 = ''
   dir2 = ''

   data_file = FILE_WHICH('t28data.txt')
   openr, 1, data_file
   readf,1,dir1
   close,1

   idl_file = FILE_WHICH('t28idl.txt')
   openr, 1, idl_file
   readf,1,dir2
   close,1

;---------------------------------------------------------
; Flights valid for yr 1995!
;---------------------------------------------------------
if (yr eq 0) then begin

; show message
mesFor1995 = 'To display and analyse the 1995 VORTEX HVPS data, please choose the Statistics option from the main Menu!'
           result1995 = dialog_message(mesFor1995,/Information)

return

endif

;---------------------------------------------------------
; Flights valid for yr 1998!
;---------------------------------------------------------
if (yr eq 1) then begin

year = 'yr1998'
  ; select a flight number

   fltnos = ['Flight 717 - 06/22/1998 (No charge)', $
             'Return']

    fltn     = ['717']

    fltno_ncar = ['0']
    flt_date   = ['0622']

   flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])

;print,'flt_ind = ', flt_ind

if flt_ind ne 1 then begin
   fn_out = dir2 + 'output' + path_sep() + 'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'
   title_flt = 'flt ' + fltn(flt_ind)

   fltno = fltn(flt_ind)

   full_dir = dir1 + year + path_sep() + 'f' + fltn(flt_ind) + path_sep()
   tables_dir = dir1 + year + path_sep() + 'tables' + path_sep()

   fn_hvps = full_dir + 'f' + fltn(flt_ind) + 'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_reduce = full_dir + 'flt' + fltn(flt_ind) + '.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = full_dir + 'f' + fltn(flt_ind) + '_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_hail = full_dir + 'f' + fltn(flt_ind) + 'hail.raw'
   print,'fn_hail: ',fn_hail

   fn_fssp = tables_dir + 'fssp1.chn'
   print,'fssp_chn: ',fn_fssp

   fn_raw = full_dir + 'flt' + fltn(flt_ind) + '.raw'
   print,'fn_raw: ',fn_raw

   fn_posttel = tables_dir + 'posttel.tag'
   print,'fn_posttel: ',fn_posttel

endif else begin
   yr = -1
endelse
endif

;---------------------------------------------------------
; Flights valid for yr 1999!
;---------------------------------------------------------
if yr eq 2 then begin

       mes = 'The HVPS instrument was not used during the TCAD Project!'
       result = dialog_message(mes, /Information)
       print,result
return
endif

;---------------------------------------------------------
; Flights valid for yr 2000!
;---------------------------------------------------------
if (yr eq 3) then begin

  ; select a flight number
year = 'yr2000'

   fltnos = ['Flight 747 - 05/25/2000 (Charge recorded)',$
             'Flight 748 - 05/26/2000 (Charge recorded)',$
             'Flight 750 - 06/01/2000 (Charge recorded)',$
             'Flight 751 - 06/03/2000 (Charge recorded)',$
             'Flight 752 - 06/06/2000 (Charge recorded)',$
             'Flight 753 - 06/09/2000 (Charge recorded)',$
             'Flight 754 - 06/11/2000 (Charge recorded)',$
             'Flight 755 - 06/12/2000 (Charge recorded)',$
             'Flight 756 - 06/20/2000 (Charge recorded)',$
             'Flight 757 - 06/22/2000 (Charge recorded)',$
             'Flight 758 - 06/23/2000 (Charge recorded)',$
             'Flight 759 - 06/25/2000 (Charge recorded)',$
             'Flight 761 - 06/29/2000 (Charge recorded)',$
             'Return']

    fltn     = ['747','748','750','751','752',$
                '753','754','755','756', $
                '757','758','759','761']
    fltno_ncar = ['0','1','2','3','4','5','6','7',$
                  '8','9','10','11','12','13']
    flt_date   = ['0525','0526','0601','0603',$
                  '0606','0609','0611','0612','0620',$
                  '0622','0623','0625','0629']

   flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])

if flt_ind ne 13 then begin
   fn_out = dir2 + 'output' + path_sep() + 'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'
   title_flt = 'flt ' + fltn(flt_ind)

   fltno = fltn(flt_ind)

   full_dir = dir1 + year + path_sep() + 'f' + fltn(flt_ind) + path_sep()
   tables_dir = dir1 + year + path_sep() + 'tables' + path_sep()

   fn_hvps = full_dir + 'f' + fltn(flt_ind) + 'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_reduce = full_dir + 'flt' + fltn(flt_ind) + '.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = full_dir + 'f' + fltn(flt_ind) + '_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_hail = full_dir + 'f' + fltn(flt_ind) + 'hail.raw'
   print,'fn_hail: ',fn_hail

   fn_raw = full_dir + 'flt' + fltn(flt_ind) + '.raw'
   print,'fn_raw: ',fn_raw

   fn_fssp = tables_dir + 'fssp.chn'
   print,'fssp_chn: ',fn_fssp

   fn_posttel = tables_dir + 'posttel.tag'
   print,'fn_posttel: ',fn_posttel

endif else begin
   yr = -1
endelse
endif

;---------------------------------------------------------
; Flights valid for yr 2002!
;---------------------------------------------------------
if (yr eq 4) then begin

year = 'yr2002'
  ; select a flight number

   fltnos = ['Flight 781 - 06/11/2002) - Greeley - NO Charge',$
             'Flight 782 - 06/12/2002) - Greeley - NO Charge',$
             'Flight 785 - 06/16/2002) - Greeley - NO Charge',$
             'Return']

    fltn     = ['781','782','785']

    fltno_ncar = ['6','7','8']
    flt_date   = ['0611','0612','0616']

   flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])

;print,'flt_ind = ', flt_ind

if flt_ind ne 3 then begin
   fn_out = dir2 + 'output' + path_sep() + 'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'
   title_flt = 'flt ' + fltn(flt_ind)

   fltno = fltn(flt_ind)

   full_dir = dir1 + year + path_sep() + 'f' + fltn(flt_ind) + path_sep()
   tables_dir = dir1 + year + path_sep() + 'tables' + path_sep()

   fn_hvps = full_dir + 'f' + fltn(flt_ind) + 'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_reduce = full_dir + 'flt' + fltn(flt_ind) + '.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = full_dir + 'f' + fltn(flt_ind) + '_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_hail = full_dir + 'f' + fltn(flt_ind) + 'hail.raw'
   print,'fn_hail: ',fn_hail

   fn_fssp = tables_dir + 'fssp2.chn'
   print,'fssp_chn: ',fn_fssp

   fn_raw = full_dir + 'flt' + fltn(flt_ind) + '.raw'
   print,'fn_raw: ',fn_raw

   if flt_ind ge 1 then begin
     fn_posttel = tables_dir + 'posttel2.tag'
     print,'fn_posttel: ',fn_posttel
   endif else begin
     fn_posttel = tables_dir + 'posttel1.tag'
     print,'fn_posttel: ',fn_posttel
   endelse

endif else begin
   yr = -1
endelse
endif

;---------------------------------------------------------
; Flights valid for yr 2003!
;---------------------------------------------------------
if (yr eq 5) then begin

year = 'yr2003'
  ; select a flight number

   fltnos = ['Flight 798 - 05/16/2003 - JPOLE/TELEX (No charge)',$
             'Flight 800 - 05/19/2003 - JPOLE/TELEX (No charge)',$
             'Flight 802 - 05/23/2003 - JPOLE/TELEX (No charge)',$
             'Flight 803 - 06/01/2003 - JPOLE/TELEX (No charge)',$
             'Flight 805 - 06/04/2003 - JPOLE/TELEX (No charge)',$
             'Flight 807 - 06/10/2003 - JPOLE/TELEX (No charge)',$
             'Flight 813 - 07/23/2003 - CHILL-TEX (No charge)',$
             'Flight 814 - 07/25/2003 - CHILL-TEX (No charge)',$
             'Flight 815 - 07/26/2003 - CHILL-TEX (No charge)',$
             'Flight 816 - 07/27/2003 - CHILL-TEX (No charge)',$
             'Flight 817 - 07/28/2003 - CHILL-TEX (No charge)',$
             'Flight 819 - 07/29/2003 - CHILL-TEX (No charge)',$
             'Flight 820 - 07/30/2003 - CHILL-TEX (No charge)',$
             'Return']


    fltn     = ['798','800','802','803','805','807',$
                '813','814','815','816',$
                '817','819','820']

    fltno_ncar = ['5','6','8','9','11','12',$
                  '16','17','18','19','20','21',$
                  '22']

    flt_date   = ['0516','0519','0523','0601','0604',$
                  '0610','0723','0725','0726','0727',$
                  '0728','0729','0730']

   flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])

;print,'flt_ind = ', flt_ind

if flt_ind ne 13 then begin
   fn_out = dir2 + 'output' + path_sep() + 'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'
   title_flt = 'flt ' + fltn(flt_ind)

   fltno = fltn(flt_ind)

   full_dir = dir1 + year + path_sep() + 'f' + fltn(flt_ind) + path_sep()
   tables_dir = dir1 + year + path_sep() + 'tables' + path_sep()

   fn_hvps = full_dir + 'f' + fltn(flt_ind) + 'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_reduce = full_dir + 'flt' + fltn(flt_ind) + '.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = full_dir + 'f' + fltn(flt_ind) + '_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_hail = full_dir + 'f' + fltn(flt_ind) + 'hail.raw'
   print,'fn_hail: ',fn_hail

   if flt_ind ge 6 then begin
     fn_fssp = tables_dir + 'fssp2.chn'
     print,'fssp_chn: ',fn_fssp
   endif else begin
     fn_fssp = tables_dir + 'fssp1.chn'
     print,'fssp_chn: ',fn_fssp
   endelse

   fn_raw = full_dir + 'flt' + fltn(flt_ind) + '.raw'
   print,'fn_raw: ',fn_raw

   if flt_ind ge 2 then begin
     fn_posttel = tables_dir + 'posttel2.tag'
     print,'fn_posttel: ',fn_posttel
   endif else begin
     fn_posttel = tables_dir + 'posttel1.tag'
     print,'fn_posttel: ',fn_posttel
   endelse

endif else begin
   yr = -1
endelse
endif

endwhile

;---------------------------------------------------------
; Exit the program
;---------------------------------------------------------

if (yr ne 6) then begin
   ; save selected flight files in a temporary file
   fn = dir2 + 'lib' + path_sep() + 'flightselected.txt'
   openw, 2, fn
   printf,2,fn_out
   printf,2,title_flt
   printf,2,fltno
   if (yr ne 2) then begin
      printf, 2, fn_hvps
   endif
   printf,2,fn_reduce
   printf,2,fn_2dc
   printf,2,fn_fssp
   printf,2,fn_posttel
   printf,2,year
   printf,2,fn_hail
   printf,2,fn_raw
   close,2
endif

;if yr eq 6 then begin

;       mes = 'No year was selected! Bye now!'
;       result = dialog_message(mes, /Information)
;       print,result

;endif

end
