
;-
;- T28Display.pro
;-
pro disp_stat_event,ev

widget_control,ev.top,get_uvalue=test
;print,'test: ',test

widget_control,ev.id,get_uvalue=uval
;print

case uval of
 'DONE' : widget_control,ev.top,/destroy
 'SELE' : begin

          case ev.value of

		   'P2D3' :begin
		   			widget_control,ev.top,/destroy
                    ;process_2d3
                    ;process_2d4
                    process_2d5
                   end

           'XPOSE' :begin
           			widget_control,ev.top,/destroy
                    ;xpose_par
                    xpose_par4
                   end

           'IMGSRT' :begin
           			widget_control,ev.top,/destroy
           			print,'Start program img_sort2!'
           			;img_sort2
           			img_sort4
                    end

           'PLOTARC':begin
           			widget_control,ev.top,/destroy
           			print,'Start program plot_arc2!'
                    ;plot_arc2
                    plot_arc4
                    end

          endcase
          end
endcase

end

;---------- ---------- ----------
pro disp_stat

print,'In the DISP_STAT program!'

device,decomposed=0

b_values = [ 'I - Process Raw Data File' , 'II - Particle Preprocessing' , 'III - Extracting Particle Images' , 'IV - Plotting Statistical Data' ]
bu_values = [ 'P2D3' , 'XPOSE','IMGSRT','PLOTARC' ]

loadct,0
tvlct,255,0,0,1
tvlct,0,255,0,2
tvlct,0,0,255,3
tvlct,255,0,255,4

base5   = widget_base()
base    = widget_base(/column,/frame,group_leader=base5)
lab1    = widget_label(base,/frame,value='T28 Data Analysis')
bgroup1 = cw_bgroup(base,b_values,button_uvalue=bu_values,/column,/frame,label_top='Select:',uvalue='SELE',/return_name)

button3 = widget_button(base,value='Quit',uvalue='DONE')

print,'lab1: ',lab1
print,'button3: ',button3

state = {var1:lab1,var2:bgroup1,var3:button3}


widget_control,base,set_uvalue=state

widget_control,base,/realize

xmanager,'disp_stat',base

end

