;-
;- reduced_wid.pro
;-
pro reduced_wid_event,ev

;common hbt,hvps_buffer_time

widget_control,ev.top,get_uvalue=state

widget_control,ev.id,get_uvalue=uval

print,'ev: ',ev
print,'uval: ',uval

case uval of

 'DONE'   :begin
           widget_control,ev.top,/destroy
           return
           end

 'LIST'   :begin
           selected_tag = state.tag_nums(ev.index + 3)
           print,'selected tag: ',selected_tag
           end

 else:

endcase

;-
;- Get the buffer and blob strip images
;-
widget_control,/hourglass

;;get_tag,state.tags,state.data,state.num,state.tag_post,state.tag_labels,selected_tag,tag_value,selected_tag_lab
get_tag3,state.tags,state.data,state.num,state.tag_post,state.tag_labels,selected_tag,tag_value,selected_tag_lab

;checking data
print,'selected tag: ',selected_tag
;print,'tag_value: ',tag_value
print,'min,max for tag_value: ',min(tag_value),max(tag_value)
;stop

wset,state.index1

;select a time interval	01/11/2001
print,'min(state.time_red),max(state.time_red):',min(state.time_red),max(state.time_red)

;- Get hms strings for the time sequence x axis
get_tic_labels,min(state.time_red),max(state.time_red), $
               num_tics,tic_values,tic_names
xt1 = tic_values(0)
xt2 = tic_values(num_tics)

ytitle = ''
plot,state.time_red,tag_value, $
     xtitle = 'Time (hhmmss)', $
     ytitle = selected_tag_lab, $
     background = 255, $
     color = 0, $
     xrange = [xt1,xt2], $
     xticks = num_tics, $
     xtickname = tic_names, $
     xtickv = tic_values, $
     xminor = 4
widget_control,state.slider_id,get_value = buffer_num
hvps_buffer_time = state.time(buffer_num)
plots,[hvps_buffer_time,hvps_buffer_time],[!y.crange(0),!y.crange(1)], $
      color = 1
      linestyle = 2


end

;---------- ---------- ----------
pro reduced_wid,base1,tags,data,num,tag_post,tag_labels,time_red,slider_id,time

;common hbt,hvps_buffer_time

tvlct,255,0,0,1

; find the flight number
dir2 = ''
idl_file=FILE_WHICH('t28idl.txt')
openr, 1,idl_file
readf,1,dir2
close,1

fn_out = ''
title_flt = ''
fltnos = ''
fn_hvps = ''
fn_reduced =''
fn_2dc = ''
fssp_chn = ''
fn_posttel = ''

openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
readf,1,fn_out
readf,1,title_flt
readf,1,fltnos
readf,1,fn_hvps
readf,1,fn_reduced
readf,1,fn_2dc
readf,1,fssp_chn
readf,1,fn_posttel
close,1
fltno = intarr(1)
fltno = fltnos


;- Initialize the structures for reduced data and metadata (tag numbers, labels, format, min/max)
num_pts = 2

;;;init_tags,num_pts,hdata,metadata,num_tags_rnd
if fltno ge 782 then begin
 init_tagst4,num_pts,hdata,metadata,num_tags_rnd
endif

if (fltno ge 775) AND (fltno lt 782) then begin
 init_tagst3,num_pts,hdata,metadata,num_tags_rnd
endif

if fltno lt 775 then begin
 init_tagst2,num_pts,hdata,metadata,num_tags_rnd
endif

tag_nums = metadata.tag_num
plabels = metadata.plabel

plabels = strtrim(tag_nums) + '-' + plabels
base1 = widget_base(/column)
base2 = widget_base(/column,group_leader=base1)
base3 = widget_base(/column,group_leader=base2)
base    = widget_base(/column, group_leader=base3)

button2 = widget_button(base, value='Done', uvalue='DONE')

selected_tag_ind = widget_list(base, value = plabels(3:num_tags_rnd-1), uvalue = 'LIST', ysize = 10, xsize = 10)

;draw1   = widget_draw(base, xsize=500, ysize=200, /frame)
draw1   = widget_draw(base, /scroll, x_scroll_size=700, xsize=700, $
          uvalue='IMG', /button_events, y_scroll_size=500, ysize=500, retain=2)

widget_control,base,/realize

widget_control,draw1,get_value=index1

;wset,index1

;plot,charge_data(0,*), $
     ;background = 255, $
     ;color = 0



state = {INDEX1:index1, $
         TAGS:tags, $
         DATA:data, $
         NUM:num, $
         TAG_POST:tag_post, $
         TAG_LABELS:tag_labels, $
         TAG_NUMS:tag_nums, $
         SELECTED_TAG_IND:selected_tag_ind, $
         TIME_RED:time_red, $
         ;BUFFER_TIME:buffer_time, $
         SLIDER_ID:slider_id, $
         TIME:time }

widget_control,base,set_uvalue=state

xmanager,'reduced_wid',base

end

