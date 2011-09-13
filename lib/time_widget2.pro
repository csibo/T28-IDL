;-
;- time_widget2.pro
;-
pro time_widget2_event,ev

common start_end,start_buff,end_buff

widget_control,ev.top,get_uvalue=state
start_buff = state.start_buff
end_buff   = state.end_buff

widget_control,ev.id,get_uvalue=uval

;print,'ev: ',ev

case uval of
 'DONE'   : begin
            widget_control,ev.top,/destroy
            return
            end
 'SLIDER1': begin
            start_buff = ev.value
            if start_buff gt end_buff then start_buff = end_buff

;            str = 'Start Time: ' + string(format = '(f8.4)',state.b_times(start_buff-1)) + $
;                  ' (' + string(format = '(i5)',start_buff) + ')   ' + $
;                  'End Time: ' + string(format = '(f8.4)',state.b_times(end_buff-1)) + $
;                  ' (' + string(format = '(i5)',end_buff) + ')'

            str = 'Start Time: ' + state.b_times(start_buff-1) + $
                  ' (' + string(format = '(i5)',start_buff) + ')   ' + $
                  'End Time: ' + state.b_times(end_buff-1) + $
                  ' (' + string(format = '(i5)',end_buff) + ')'

            widget_control,state.text1,set_value=str
            widget_control,state.slider2,set_slider_min=start_buff
            end
 'SLIDER2': begin
            end_buff = ev.value
            if end_buff lt start_buff then end_buff = start_buff

;            str = 'Start Time: ' + string(format = '(f8.4)',state.b_times(start_buff-1)) + $
;                  ' (' + string(format = '(i5)',start_buff) + ')   ' + $
;                  'End Time: ' + string(format = '(f8.4)',state.b_times(end_buff-1)) + $
;                  ' (' + string(format = '(i5)',end_buff) + ')'

            str = 'Start Time: ' + state.b_times(start_buff-1) + $
                  ' (' + string(format = '(i5)',start_buff) + ')   ' + $
                  'End Time: ' + state.b_times(end_buff-1) + $
                  ' (' + string(format = '(i5)',end_buff) + ')'

            widget_control,state.text1,set_value=str
            widget_control,state.slider1,set_slider_max=end_buff
            end

endcase

state.start_buff = start_buff
state.end_buff   = end_buff
widget_control,ev.top,set_uvalue=state

end

pro time_widget2,b_times

common start_end,start_buff,end_buff

num_buffers = n_elements(b_times)

start_buff = 1
end_buff   = num_buffers

base1 = widget_base()
;base2 = widget_base(/column,group_leader=base1,/modal)
;base3 = widget_base(/column,group_leader=base2)
;base10 = widget_base(/column,group_leader=base9)
;base11 = widget_base(/column,group_leader=base10)
;base12 = widget_base(/column,group_leader=base11)
;base13 = widget_base(/column,group_leader=base12)
base    = widget_base(/column,group_leader=base1,/modal)


slider1 = widget_slider(base,uvalue='SLIDER1',/drag,$
          minimum=1,maximum=num_buffers,title='Start Buff',/frame,scr_xsize = 1000)
slider2 = widget_slider(base,uvalue='SLIDER2',/drag,$
          minimum=1,maximum=num_buffers,title='End Buff',/frame,scr_xsize = 1000)

text1   = widget_text(base,xsize=30,/frame)

button  = widget_button(base,value='Done',uvalue='DONE')

widget_control,base,/realize

state = {START_BUFF:start_buff,END_BUFF:end_buff, $
         SLIDER1:slider1,SLIDER2:slider2, $
         TEXT1:text1, $
         B_TIMES:b_times}
widget_control,base,set_uvalue=state

;str = 'Start Time: ' + string(format = '(f8.4)',state.b_times(start_buff-1)) + $
;      ' (' + string(format = '(i5)',start_buff) + ')   ' + $
;      'End Time: ' + string(format = '(f8.4)',state.b_times(end_buff-1)) + $
;      ' (' + string(format = '(i5)',end_buff) + ')'

str = 'Start Time: ' + state.b_times(start_buff-1) + $
      ' (' + string(format = '(i5)',start_buff) + ')   ' + $
      'End Time: ' + state.b_times(end_buff-1) + $
      ' (' + string(format = '(i5)',end_buff) + ')'

widget_control,state.text1,set_value=str

widget_control,state.slider1,set_value=start_buff
widget_control,state.slider2,set_value=end_buff

xmanager,'time_widget2',base

end

