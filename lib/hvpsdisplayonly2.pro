;------------------------------------------------------
;-
;- HvpsDisplayOnly.pro
;
;- Date: 06/08/2000
;- Purpose: To display only the HVPS images using the
;- file f*hvps.raw
;
;------------------------------------------------------
pro HvpsDisplayOnly2_event,ev

common yr_ind, ind_selected

widget_control,ev.top,get_uvalue=test
print,'test: ',test

widget_control,ev.id,get_uvalue=uval
print


case uval of
 'DONE' : widget_control,ev.top,/destroy
 'SELE' : begin

          case ev.value of

           'DISP1' :begin
           			widget_control,ev.top ;, /destroy
                    result = menu_wid_wide(['Select Type of Display:','Particles and Charges', 'Particles only'])
					case result of
					  0: disp622_buffst23    ;disp622_buffst22

                      1: disp_buffs_hvps_only

                    endcase

                   end

		   'DISP2' :begin
		   			widget_control,ev.top ;, /destroy
		   			;stop
		   			if ind_selected eq 1 then begin
		   			;stop
		   			  disp_buffs_hvps_nc1998
		   			endif else disp_buffs_hvps_nc
		   			print,'ind_selected = ',ind_selected
		   			end

          endcase
          end
endcase

end

;---------- ---------- ----------
pro HvpsDisplayOnly2,ind_selected

device,decomposed=0
;stop
b_values = ['Display HVPS Only (Charge Recorded - Yr 2000)','Display HVPS Only (NO Charge Recorded - Yrs 1998 - 2003)' ]
bu_values = [ 'DISP1','DISP2' ]

;;;select_flight

loadct,0
tvlct,255,0,0,1
tvlct,0,255,0,2
tvlct,0,0,255,3
tvlct,255,0,255,4

base    = widget_base(/column)
lab1    = widget_label(base,/frame,value='HVPS Quick Display')
bgroup1 = cw_bgroup(base,b_values,button_uvalue=bu_values,/column,/frame,label_top='Select:',uvalue='SELE')
button3 = widget_button(base,value='Quit',uvalue='DONE')

print,'lab1: ',lab1
print,'button3: ',button3
;state.ind_selected = ind_selected

state = {var1:lab1,$
         var2:bgroup1,$
         var3:button3}


widget_control,base,set_uvalue=state

widget_control,base,/realize


xmanager,'HvpsDisplayOnly2',base

end

