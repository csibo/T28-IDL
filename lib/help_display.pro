
;-
;- T28Display.pro
;-
pro help_display_event,ev

widget_control,ev.top,get_uvalue=test
;print,'test: ',test

widget_control,ev.id,get_uvalue=uval
;print

case uval of
 'DONE' : widget_control,ev.top,/destroy

 'SELE' : begin

          case ev.value of

		   'HDHVPS' :begin
		   			 widget_control,ev.top
		   			 ;SPAWN,"c:\Program Files\Netscape\Communicator\Program\netscape.exe c:\t28\t28display\help-web\hvps_display.html", /NOSHELL, /NOWAIT
                     SPAWN,"c:\Program Files\Internet Explorer\iexplore.exe c:\t28\t28display3.0\help-web\hvps_display.html", /NOSHELL, /NOWAIT
                     end

           'HDSLOW' :begin
                    widget_control,ev.top
                    ;SPAWN,"c:\Program Files\Netscape\Communicator\Program\netscape.exe c:\t28\t28display\help-web\slow_display.html", /NOSHELL, /NOWAIT
					SPAWN,"c:\Program Files\Internet Explorer\iexplore.exe c:\t28\t28display3.0\help-web\slow_display.html", /NOSHELL, /NOWAIT
                   end

           'HD2DC' :begin
           			widget_control,ev.top
                    ;SPAWN,"c:\Program Files\Netscape\Communicator\Program\netscape.exe c:\t28\t28display\help-web\2dc_display.html", /NOSHELL, /NOWAIT
                    SPAWN, "c:\Program Files\Internet Explorer\iexplore.exe c:\t28\t28display3.0\help-web\2dc_display.html", /NOSHELL, /NOWAIT
                   end

           'HDHAIL':begin
                   widget_control,ev.top
                   ;SPAWN,"c:\Program Files\Netscape\Communicator\Program\netscape.exe c:\t28\t28display\help-web\hail_display.html", /NOSHELL, /NOWAIT
				   SPAWN,"c:\Program Files\Internet Explorer\iexplore.exe c:\t28\t28display3.0\help-web\hail_display.html", /NOSHELL, /NOWAIT
                   end

           'HSTAT':begin
                    widget_control,ev.top
                    ;SPAWN,"c:\Program Files\Netscape\Communicator\Program\netscape.exe c:\t28\t28display\help-web\statistics_display.html", /NOSHELL, /NOWAIT
					SPAWN,"c:\Program Files\Internet Explorer\iexplore.exe c:\t28\t28display3.0\help-web\statistics_display.html", /NOSHELL, /NOWAIT
                   end

          endcase
          end
endcase

end

;---------- ---------- ----------
pro help_display

;,fn_hvps,fn_2dc, fn_reduce,$
                 ;    fn_fssp, fn_posttel, fn_out, title_flt, fltno
;@myfile

device,decomposed=0


b_values = [ 'Display HVPS - HELP' , 'Display Slow Data - HELP' , 'Display 2DC - HELP' , 'Display Hail - HELP', 'Statistics - HELP']
bu_values = [ 'HDHVPS' , 'HDSLOW', 'HD2DC', 'HDHAIL', 'HSTAT']

loadct,0
tvlct,255,0,0,1
tvlct,0,255,0,2
tvlct,0,0,255,3
tvlct,255,0,255,4

base    = widget_base(/column)
lab1    = widget_label(base,/frame,value='HELP FOR The T28 Data Analysis')
bgroup1 = cw_bgroup(base,b_values,button_uvalue=bu_values,/column,/frame,label_top='Select:',uvalue='SELE')
button3 = widget_button(base,value='Quit',uvalue='DONE')

;print,'lab1: ',lab1
;print,'button3: ',button3

state = {var1:lab1,var2:bgroup1,var3:button3}

widget_control,base,set_uvalue=state

widget_control,base,/realize

xmanager,'help_display',base

end

