; select_flight_hail1.pro
;
; Routine written to be called when user selects the flight to view.
; It will save the needed information into the lib/flightselected.txt
;
; Written by Dr. Donna Kliche
; Last modified: September 16, 2008
;
;---------------------------------------------------------------------

pro select_flight_hail1, yr, fn_hail, flt_num, titl, year

dir1 = ''
dir2 = ''

   data_file=FILE_WHICH('t28data.txt')
   openr, 1,data_file
   readf,1,dir1
   close,1

   idl_file=FILE_WHICH('t28idl.txt')
   openr, 1,idl_file
   readf,1,dir2
   close,1

;---------------------------------------------------------
; Flights valid for yr 1995!
;---------------------------------------------------------
if (yr eq 0) then begin

   year = 'yr1995'

  ; select a flight number
  fltnos = ['Flight 665 (06/12/1995)',$
  			'Flight 666 (06/17/1995)',$
           	'Flight 667 (06/20/1995)',$
           	'Flight 668 (06/22/1995)',$
           	'Flight 670 (06/27/1995)',$
           	'Flight 671 (06/28/1995)']

  fltn     = ['665' , '666' , '667' , '668' , '670' , '671']

  fltno_ncar = ['0', '1', '2', '3', '4', '5']
  flt_date   = ['0612', '0617', '0620', '0622', '0627', '0628']

  flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])
  flt_num = fltn(flt_ind)
  fltno = fix(flt_num)
  titl = 'Flight ' + fltn(flt_ind)
  title_flt = 'flt ' + fltn(flt_ind)
   fn_hvps = dir1 + year +path_sep()+'f' + fltn(flt_ind) + path_sep()+'f' + $
                        fltn(flt_ind)+'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_out = dir2 + 'output'+path_sep()+'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'

   fn_reduce = dir1 + year +path_sep()+'f'+fltn(flt_ind)+path_sep()+'flt'+fltn(flt_ind)+'.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+'_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_hail = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+'hail.raw'
   print,'fn_hail: ',fn_hail

   fn_fssp = dir1 + 'yr1995'+path_sep()+'tables'+path_sep()+'fssp.chn'
   print,'fssp_chn: ',fn_fssp

   fn_posttel = dir1 + 'yr1995'+path_sep()+'tables'+path_sep()+'posttel.tag'
   print,'fn_posttel: ',fn_posttel

   fn_raw = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+'.raw'
   print,'fn_raw: ',fn_raw

   fn_src = dir1 + year + path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+ '.src'
   print,'fn_src: ',fn_src

endif

;---------------------------------------------------------
; Flights valid for yr 1998!
;---------------------------------------------------------
if (yr eq 1) then begin

   year = 'yr1998'

  ; select a flight number
  fltnos = ['Flight 711 (06/11/1998)',$
  			'Flight 712 (06/12/1998)',$
           	'Flight 713 (06/12/1998)',$
           	'Flight 714 (06/17/1998)',$
           	'Flight 716 (06/21/1998)',$
           	'Flight 717 (06/22/1998)']

  fltn     = ['711' , '712' , '713' , '714' , '716' , '717']

  fltno_ncar = ['0', '1', '2', '3', '4', '5']
  flt_date   = ['0611', '0612', '0612', '0617', '0621', '0622']

  flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])
  flt_num = fltn(flt_ind)
  fltno = fix(flt_num)

  titl = 'Flight ' + fltn(flt_ind)
  title_flt = 'flt ' + fltn(flt_ind)
  fn_hvps = dir1 + year +path_sep()+'f' + fltn(flt_ind) + path_sep()+'f' + $
                        fltn(flt_ind)+'hvps.raw'
  print,'fn_hvps: ',fn_hvps

  fn_out = dir2 + 'output'+path_sep()+'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'

  fn_reduce = dir1 + year +path_sep()+'f'+fltn(flt_ind)+path_sep()+'flt'+fltn(flt_ind)+'.rnd'
  print,'fn_reduced: ',fn_reduce

  fn_2dc = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+'_2dc.raw'
  print,'fn_2dc: ',fn_2dc

  fn_hail = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+'hail.raw'
  print,'fn_hail: ',fn_hail

  if flt_ind ge 4 then begin
     fn_fssp = dir1 + 'yr1998'+path_sep()+'tables'+path_sep()+'fssp2.chn'
     print,'fssp_chn: ',fn_fssp
  endif else begin
     fn_fssp = dir1 + 'yr1998'+path_sep()+'tables'+path_sep()+'fssp1.chn'
     print,'fssp_chn: ',fn_fssp
  endelse

  fn_raw = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+'.raw'
  print,'fn_raw: ',fn_raw

  fn_posttel = dir1 + 'yr1998'+path_sep()+'tables'+path_sep()+'posttel.tag'
  print,'fn_posttel: ',fn_posttel

  fn_src = dir1 + year + path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+ '.src'
  print,'fn_src: ',fn_src

endif

;---------------------------------------------------------
; Flights valid for yr 1999!
;---------------------------------------------------------
if yr eq 2 then begin

       mes = 'The hail instrument was not used during the Turbulence Project (1999)!'
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

   fltnos = ['STEPS - Flight 747 (05/25/2000 - Charge Recorded)',$
             'STEPS - Flight 748 (05/26/2000 - Charge Recorded)',$
             'STEPS - Flight 750 (05/31/2000 - Charge Recorded)',$
             'STEPS - Flight 751 (06/03/2000 - Charge Recorded)',$
             'STEPS - Flight 752 (06/06/2000 - Charge Recorded)',$
             'STEPS - Flight 753 (06/09/2000 - Charge Recorded)',$
             'STEPS - Flight 754 (06/11/2000 - Charge Recorded)',$
             'STEPS - Flight 755 (06/12/2000 - Charge Recorded)',$
             'STEPS - Flight 756 (06/19/2000 - Charge Recorded)',$
             'STEPS - Flight 757 (06/22/2000 - Charge Recorded)',$
             'STEPS - Flight 758 (06/23/2000 - Charge Recorded)',$
             'STEPS - Flight 759 (06/24/2000 - Charge Recorded)',$
             'STEPS - Flight 761 (06/29/2000 - Charge Recorded)']

    fltn     = ['747','748','750','751','752',$
                '753','754','755','756', $
                '757','758','759','761']
    fltno_ncar = ['0','1','2','3','4','5','6','7',$
                  '8','9','10','11','12','13']
    flt_date   = ['0525','0526','0531','0603',$
                  '0606','0609','0611','0612','0619',$
                  '0622','0623','0624','0629']

   flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])

   flt_num = fltn(flt_ind)
   fltno = fix(flt_num)
   titl = 'Flight ' + fltn(flt_ind)
   title_flt = 'flt ' + fltn(flt_ind)
   fn_hvps = dir1 + year +path_sep()+'f' + fltn(flt_ind) + path_sep()+'f' + $
                        fltn(flt_ind)+'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_out = dir2 + 'output'+path_sep()+'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'

   fn_reduce = dir1 + year +path_sep()+'f'+fltn(flt_ind)+path_sep()+'flt'+fltn(flt_ind)+'.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+'_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_hail = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+'hail.raw'
   print,'fn_hail: ',fn_hail

   fn_fssp = dir1 + 'yr2000'+path_sep()+'tables'+path_sep()+'fssp.chn'
   print,'fssp_chn: ',fn_fssp

   fn_posttel = dir1 + 'yr2000'+path_sep()+'tables'+path_sep()+'posttel.tag'
   print,'fn_posttel: ',fn_posttel

   fn_raw = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+'.raw'
   print,'fn_raw: ',fn_raw

   fn_src = dir1 + year + path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+ '.src'
   print,'fn_src: ',fn_src

endif


;---------------------------------------------------------
; Flights valid for yr 2001!
;---------------------------------------------------------
if (yr eq 4) then begin

  year = 'yr2001'
  ; select a flight number

   fltnos = ['Flight 766 (06/22/2001) - Rapid City - Charge Recorded',$
             'Flight 767 (07/06/2001) - Rapid City - Charge Recorded',$
             'Flight 768 (05/31/2001) - To Forth Collins - Charge Recorded',$
             'Flight 769 (07/10/2001) - From Forth Collins - Charge Recorded',$
             'Flight 770 (07/20/2001) - Rapid City - Charge Recorded',$
             'Flight 771 (08/08/2001) - Rapid City - NO Charge' ,$
             'Flight 772 (08/14/2001) - Rapid City - NO Charge',$
             'Flight 773 (09/19/2001) - Rapid City - NO Charge',$
             'Flight 774 (10/04/2001) - Rapid City - NO Charge']

    fltn     = ['766','767','768','769','770',$
                '771','772','773','774']

    fltno_ncar = ['0','1','2','3','4','5','6','7',$
                  '8']
    flt_date   = ['0622','0706','0531','0710',$
                  '0720','0808','0814','0919','1004']

   flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])

   flt_num = fltn(flt_ind)
   fltno = fix(flt_num)
   titl = 'Flight ' + fltn(flt_ind)
   title_flt = 'flt ' + fltn(flt_ind)
   fn_hvps = dir1 + year +path_sep()+'f' + fltn(flt_ind) + path_sep()+'f' + $
                        fltn(flt_ind)+'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_out = dir2 + 'output'+path_sep()+'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'

   fn_reduce = dir1 + year+ path_sep()+'f'+fltn(flt_ind)+path_sep()+'flt'+fltn(flt_ind)+'.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+$
                        '_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_fssp = dir1 + 'yr2001'+path_sep()+'tables'+path_sep()+'fssp.chn'
   print,'fssp_chn: ',fn_fssp

   fn_posttel = dir1 + 'yr2001'+path_sep()+'tables'+path_sep()+'posttel.tag'
   print,'fn_posttel: ',fn_posttel

   fn_hail = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+$
                        'hail.raw'
   print,'fn_hail: ',fn_hail

   fn_raw = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+$
                        '.raw'
   print,'fn_raw: ',fn_raw

   fn_src = dir1 + year + path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+ '.src'


endif


;---------------------------------------------------------
; Flights valid for yr 2002!
;---------------------------------------------------------
if (yr eq 5) then begin

year = 'yr2002'
  ; select a flight number

   fltnos = ['Flight 775 (04/19/2002) - Rapid City - NO Charge',$
             'Flight 776 (05/03/2002) - Rapid City - NO Charge',$
             'Flight 777 (05/23/2002) - Rapid City - NO Charge',$
             'Flight 778 (06/03/2002) - To Greeley, CO - NO Charge',$
             'Flight 779 (06/05/2002) - Greeley - Test Flight - NO Charge',$
             'Flight 780 (06/09/2002) - Greeley - Test Flight - NO Charge',$
             'Flight 781 (06/11/2002) - Greeley - NO Charge',$
             'Flight 782 (06/12/2002) - Greeley - NO Charge',$
             'Flight 785 (06/15/2002) - Greeley - NO Charge']


    fltn     = ['775','776','777','778','779',$
                '780','781','782','785']

    fltno_ncar = ['0','1','2','3','4','5','6','7',$
                  '8']
    flt_date   = ['0419','0503','0523','0603',$
                  '0605','0609','0611','0612','0615']

   flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])

   flt_num = fltn(flt_ind)
   fltno = fix(flt_num)
   titl = 'Flight ' + fltn(flt_ind)
   title_flt = 'flt ' + fltn(flt_ind)
   fn_hvps = dir1 + year +path_sep()+'f' + fltn(flt_ind) + path_sep()+'f' + $
                        fltn(flt_ind)+'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_out = dir2 + 'output'+path_sep()+'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'

   fn_reduce = dir1 + year +path_sep()+'f'+fltn(flt_ind)+path_sep()+'flt'+fltn(flt_ind)+'.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+$
                        '_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_hail = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+$
                        'hail.raw'
   print,'fn_hail: ',fn_hail

   if flt_ind ge 4 then begin
     fn_fssp = dir1 + 'yr2002'+path_sep()+'tables'+path_sep()+'fssp2.chn'
     print,'fssp_chn: ',fn_fssp
   endif else begin
     fn_fssp = dir1 + 'yr2002'+path_sep()+'tables'+path_sep()+'fssp1.chn'
     print,'fssp_chn: ',fn_fssp
   endelse

   fn_raw = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+$
                        '.raw'
   print,'fn_raw: ',fn_raw

   if flt_ind ge 7 then begin
     fn_posttel = dir1 + 'yr2002'+path_sep()+'tables'+path_sep()+'posttel2.tag'
     print,'fn_posttel: ',fn_posttel
   endif else begin
     fn_posttel = dir1 + 'yr2002'+path_sep()+'tables'+path_sep()+'posttel1.tag'
     print,'fn_posttel: ',fn_posttel
   endelse

   fn_src = dir1 + year + path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+ '.src'

endif

;---------------------------------------------------------
; Flights valid for yr 2003!
;---------------------------------------------------------
if (yr eq 6) then begin

  year = 'yr2003'
  ; select a flight number

   fltnos = ['Flight 790 (02/20/2003) - Rapid City - NO Charge',$
             'Flight 791 (02/27/2003) - Rapid City - NO Charge',$
             'Flight 792 (05/07/2003) - Rapid City - NO Charge',$
             'Flight 793 (05/08/2003) - Rapid City - NO Charge',$
             'Flight 797 (05/15/2003) - Norman - Test Flight -NO Charge',$
             'Flight 798 (05/16/2003) - Norman - NO Charge',$
             'Flight 800 (05/19/2003) - Norman - NO Charge',$
             'Flight 801 (05/22/2003) - Norman - NO Charge',$
             'Flight 802 (05/23/2003) - Norman - NO Charge',$
             'Flight 803 (06/01/2003) - Norman - NO Charge',$
             'Flight 804 (06/02/2003) - Norman - NO Charge',$
             'Flight 805 (06/04/2003) - Norman - NO Charge',$
             'Flight 807 (06/10/2003) - Norman - NO Charge',$
             'Flight 810 (07/09/2003) - Rapid City - NO Charge',$
             'Flight 811 (07/13/2003) - Rapid City - NO Charge', $
             'Flight 812 (07/21/2003) - Rapid City to Greeley',$
             'Flight 813 (07/23/2003) - Greeley - NO Charge',$
             'Flight 814 (07/25/2003) - Greeley - NO Charge',$
             'Flight 815 (07/26/2003) - Greeley - NO Charge',$
             'Flight 816 (07/27/2003) - Greeley - NO Charge',$
             'Flight 817 (07/28/2003) - Greeley - NO Charge',$
             'Flight 819 (07/29/2003) - Greeley - NO Charge',$
             'Flight 820 (07/30/2003) - Greeley - NO Charge']


    fltn     = ['790','791','792','793','797',$
                '798','800','801','802','803',$
                '804','805','807','810','811',$
                '812','813','814','815','816',$
                '817','819','820']

    fltno_ncar = ['0','1','2','3','4','5','6','7',$
                  '8','9','10','11','12','13','14',$
                  '15','16','17','18','19','20','21',$
                  '22']

    flt_date   = ['0220','0227','0507','0508',$
                  '0515','0516','0519','0522',$
                  '0523','0601','0602','0604',$
                  '0610','0709','0713','0721',$
                  '0723','0725','0726','0727',$
                  '0728','0729','0730']

   flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])

   flt_num = fltn(flt_ind)
   fltno = fix(flt_num)
   titl = 'Flight ' + fltn(flt_ind)
   title_flt = 'flt ' + fltn(flt_ind)
   fn_hvps = dir1 + year +path_sep()+'f' + fltn(flt_ind) + path_sep()+'f' + $
                        fltn(flt_ind)+'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_out = dir2 + 'output'+path_sep()+'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'

   fn_reduce = dir1 + year +path_sep()+'f'+fltn(flt_ind)+path_sep()+'flt'+fltn(flt_ind)+'.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+$
                        '_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_hail = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'f'+ fltn(flt_ind)+$
                        'hail.raw'
   print,'fn_hail: ',fn_hail

   ;if flt_ind ge 4 then begin
   if flt_ind ge 13 then begin
     fn_fssp = dir1 + 'yr2003'+path_sep()+'tables'+path_sep()+'fssp2.chn'
     print,'fssp_chn: ',fn_fssp
   endif else begin
     fn_fssp = dir1 + 'yr2003'+path_sep()+'tables'+path_sep()+'fssp1.chn'
     print,'fssp_chn: ',fn_fssp
   endelse

   fn_raw = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+$
                        '.raw'
   print,'fn_raw: ',fn_raw

   if flt_ind ge 7 then begin
     fn_posttel = dir1 + 'yr2003'+path_sep()+'tables'+path_sep()+'posttel2.tag'
     print,'fn_posttel: ',fn_posttel
   endif else begin
     fn_posttel = dir1 + 'yr2003'+path_sep()+'tables'+path_sep()+'posttel1.tag'
     print,'fn_posttel: ',fn_posttel
   endelse
   fn_src = dir1 + year + path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+ '.src'


endif

;---------------------------------------------------------
; Flights valid for yr 2004!
;---------------------------------------------------------
if (yr eq 7) then begin

year = 'yr2004'
  ; select a flight number

   fltnos = ['Flight 827 (01/23/2004) - Rapid City - NO Charge'];,$

   fltn     = ['827']

   fltno_ncar = ['0']

   flt_date   = ['0123']

   flt_ind = menu_wid_wide(['Select Flight Number:',fltnos])

   flt_num = fltn(flt_ind)
   fltno = fix(flt_num)
   titl = 'Flight ' + fltn(flt_ind)
   title_flt = 'flt ' + fltn(flt_ind)
   fn_hvps = dir1 + year + path_sep()+'f' + fltn(flt_ind) + path_sep()+'f' + fltn(flt_ind)+'hvps.raw'
   print,'fn_hvps: ',fn_hvps

   fn_out = dir2 + 'output'+path_sep()+'f' +  fltn(flt_ind) + '_' $
                        + flt_date(flt_ind) + '00.dat'

   fn_reduce = dir1 + year +path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+fltn(flt_ind)+'.rnd'
   print,'fn_reduced: ',fn_reduce

   fn_2dc = dir1 + year +path_sep()+'f' + fltn(flt_ind)+ path_sep()+'f'+ fltn(flt_ind)+'_2dc.raw'
   print,'fn_2dc: ',fn_2dc

   fn_hail = dir1 + year +path_sep()+'f' + fltn(flt_ind)+ path_sep()+'f'+ fltn(flt_ind)+'hail.raw'
   print,'fn_hail: ',fn_hail

   ;if flt_ind ge 4 then begin
   if flt_ind ge 13 then begin
     fn_fssp = dir1 + 'yr2004'+path_sep()+'tables'+path_sep()+'fssp2.chn'
     print,'fssp_chn: ',fn_fssp
   endif else begin
     fn_fssp = dir1 + 'yr2004'+path_sep()+'tables'+path_sep()+'fssp1.chn'
     print,'fssp_chn: ',fn_fssp
   endelse

   fn_raw = dir1 + year +path_sep()+'f' + fltn(flt_ind)+ path_sep()+'flt'+ fltn(flt_ind)+'.raw'
   print,'fn_raw: ',fn_raw

   if flt_ind ge 7 then begin
     fn_posttel = dir1 + 'yr2004'+path_sep()+'tables'+path_sep()+'posttel2.tag'
     print,'fn_posttel: ',fn_posttel
   endif else begin
     fn_posttel = dir1 + 'yr2004'+path_sep()+'tables'+path_sep()+'posttel1.tag'
     print,'fn_posttel: ',fn_posttel
   endelse
   fn_src = dir1 + year + path_sep()+'f' + fltn(flt_ind) +path_sep()+'flt'+ fltn(flt_ind)+ '.src'


endif

if (yr gt 0) and (yr lt 8) then begin

   ; save selected flight files in a temporary file
   fn = dir2 + 'lib'+path_sep()+'flightselected.txt'
   openw, 2, fn
   printf,2,fn_out
   printf,2,title_flt
   printf,2,fltno
   if (yr ge 3) then begin
   printf,2,fn_hvps
   endif
   printf,2,fn_reduce
   printf,2,fn_2dc
   printf,2,fn_fssp
   printf,2,fn_posttel
   printf,2,year
   printf,2,fn_hail
   printf,2,fn_raw
   printf,2,fn_src
   close,2

endif
;---------------------------------------------------------
; NO Valid Flights Selected!
;---------------------------------------------------------
if yr eq 8 then begin

       mes = 'No year was selected! Bye now!'
       result = dialog_message(mes, /Information)
       print,result

endif




end

