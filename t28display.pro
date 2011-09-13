; Copyright � 2001, IAS, SD School of Mines and Technology.
; This software is provided as is without any warranty whatsoever.
; It may be freely used, copied or distributed, for non-commercial
; purposes. This copyright notice must be kept with any copy of this
; software.  If this software shall be used commercially or lder
; to arrange payment. Bugs and comments should be directed to
; t28user@typhoon.ias.sdsmt.edu with subject "t28display IDL routine".
;
;------------------------------------------------------------------------------------------

;-
;- T28Display.pro
;-
pro t28display_event,ev

widget_control,ev.top,get_uvalue=test

widget_control,ev.id,get_uvalue=uval
common yr_ind, ind_selected
case uval of
 'DONE' : widget_control,ev.top,/destroy

 'SELE' : begin

          case ev.value of

       'DHVPS' :begin
                    select_flight_hvps, ind_selected
                   widget_control,ev.top ;, /destroy
                 if (ind_selected ne 6) then begin
                    ;;;disp622_buffst2new
                    if ind_selected ne 2 then begin
                     if ind_selected gt 0 and ind_selected le 7 then begin
                      hvpsdisplayonly2,ind_selected
                     endif
                    endif
                  endif

                    end

           'DSLOW' :begin
                    select_flight_slow, ind_selected
                    widget_control,ev.top
                    if ind_selected ge 0 and ind_selected le 7 then begin
                    ;plotreducedonly
                    ;plotreducedonly_new
                    ;read the needed fn from flightselected.txt
                    dir2 = ''
                    idl_file = FILE_WHICH('t28idl.txt')
                    openr, 1,idl_file
                    readf,1,dir2
                    close,1
                    fn_out = ''
                    title_flt = ''
                    fltno = 0
                    fltnos = 0
                    fn_hvps = ''
                    fn_reduced =''
                    fn_2dc = ''
                    fssp_chn = ''
                    fn_posttel = ''

                  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
                  readf,1,fn_out
                  readf,1,title_flt
                  readf,1,fltno
                  close,1

                  fltnos=fix(fltno)

		  if ((fltnos ge 725) AND (fltnos lt 738)) then begin
		   openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
                   readf,1,fn_out
                   readf,1,title_flt
                   readf,1,fltno
                   readf,1,fn_reduced
                   readf,1,fn_2dc
                   readf,1,fssp_chn
                   readf,1,fn_posttel
                   close,1
	           print,'Flight selected: ',fltno

		   plotreducedonly_yr1999
		 endif

		  if ((fltnos ge 738) OR (fltnos lt 725)) then begin
                    plotreducedonly_new2	; valid for 1995 and 2000 +
                  endif


		endif
                end

           'D2DC' :begin
              ;- Get 2DC data
                   ;select_flight_1, ind_selected
                   select_flight_2dc,ind_selected
                if ind_selected gt 0 and ind_selected le 7 then begin

                  ;read the needed fn from flightselected.txt
                  dir2 = ''
                  idl_file=FILE_WHICH('t28idl.txt')
                  openr, 1,idl_file
                  readf,1,dir2
                  close,1

                  fn_out = ''
                  title_flt = ''
                  fltno = 0
                  fltnos = 0
                  fn_hvps = ''
                  fn_reduced =''
                  fn_2dc = ''
                  fssp_chn = ''
                  fn_posttel = ''

                  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
                  readf,1,fn_out
                  readf,1,title_flt
                  readf,1,fltno
                  close,1

		fltnos=fix(fltno)
        ;if fltnos eq 733 then GOTO, F2
		if (fltnos gt 738) then begin
				  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
                  readf,1,fn_out
                  readf,1,title_flt
                  readf,1,fltno
                  readf,1,fn_hvps
                  close,1
			print,'Flight selected: ',fltno

       		read_hvps_bufsize,fn_hvps,total_buffer_size
;stop
      		if total_buffer_size eq 4220 then begin
        		disp622_2dctnew
       		endif

       		if total_buffer_size eq 4182 then begin
        		disp_2dctnew
       		endif
		endif

		if ((fltnos ge 725) AND (fltnos lt 733)) then begin
				  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
                  readf,1,fn_out
                  readf,1,title_flt
                  readf,1,fltno
                  readf,1,fn_reduced
                  readf,1,fn_2dc
                  readf,1,fssp_chn
                  readf,1,fn_posttel
                  close,1
			print,'Flight selected: ',fltno
			;disp_2dctnew
			disp_2dct1,fn_2dc, fn_reduced, fssp_chn, fn_posttel, fltno
		 endif

		if ((fltnos ge 733) AND (fltnos lt 738)) then begin
				  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
                  readf,1,fn_out
                  readf,1,title_flt
                  readf,1,fltno
                  readf,1,fn_reduced
                  readf,1,fn_2dc
                  readf,1,fssp_chn
                  readf,1,fn_posttel
                  close,1
			print,'Flight selected: ',fltno
			;disp_2dctnew
			disp_2dct2,fn_2dc, fn_reduced, fssp_chn, fn_posttel, fltno
		 endif

			if (fltnos lt 725) then begin
				  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
                  readf,1,fn_out
                  readf,1,title_flt
                  readf,1,fltno
                  readf,1,fn_reduced
                  readf,1,fn_2dc
                  readf,1,fssp_chn
                  readf,1,fn_posttel
                  close,1
				print,'Flight selected: ',fltno
				if (fltno eq 717) then begin
				mes = 'Flight 717 does not have 2DC data!'
       			result = dialog_message(mes, /Information)
       			print,result
				GOTO,F2
				endif
				;disp_2dctnew
				disp_2dct1,fn_2dc, fn_reduced, fssp_chn, fn_posttel, fltno
		 	endif

        	endif
			F2:

                end

           'DHAIL':begin
            	   disp_hail
                   end

           'STAT':begin
                    widget_control,ev.top
                    ;MaskSearchNew
                    disp_stat
                   end

          'Help': begin
          widget_control,ev.top
          help_display
          end
          endcase
          end
endcase

end

;---------- ---------- ----------
pro t28display

print,'In the T28DISPLAY program!'

;,fn_hvps,fn_2dc, fn_reduce,$
                 ;    fn_fssp, fn_posttel, fn_out, title_flt, fltno
;@myfile

device,decomposed=0


b_values = [ 'Display HVPS' , 'Display Slow Data' , 'Display 2DC' , 'Display Hail', 'Statistics','HELP Menu' ]
bu_values = [ 'DHVPS' , 'DSLOW', 'D2DC', 'DHAIL', 'STAT','Help' ]

loadct,0
tvlct,255,0,0,1
tvlct,0,255,0,2
tvlct,0,0,255,3
tvlct,255,0,255,4

base    = widget_base(/column)
lab1    = widget_label(base,/frame,value='T28 Data Analysis')
bgroup1 = cw_bgroup(base,b_values,button_uvalue=bu_values,/column,/frame,label_top='Select:',uvalue='SELE')
button3 = widget_button(base,value='Quit',uvalue='DONE')

;print,'lab1: ',lab1
;print,'button3: ',button3

state = {var1:lab1,var2:bgroup1,var3:button3}

widget_control,base,set_uvalue=state

widget_control,base,/realize

xmanager,'t28display',base

end

