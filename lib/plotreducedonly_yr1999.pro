 ;- PlotReducedOnly_new.pro
;
;- This Program replaces the display of the
;- reduced data as presented in the hvpswidnew.pro.
;- It displays all the plots for the reduced
;- data, with the option to choose the time
;- interval needed.
;
;- Author: Donna
;- Last modified: Jan 14, 2001
;- Last modified: May 20, 2003
; Last modified: March 19, 2008
;  Donna included the option to plot one tag against the other,
;  not just tag against the time.
;------------------------------------------------

pro PlotReducedOnly_yr1999

device, decomposed = 0

tvlct,255,0,0,1

dir1 = ''
data_file=FILE_WHICH('t28data.txt')
openr, 1,data_file
readf,1,dir1
close,1

dir2 = ''
idl_file=FILE_WHICH('t28idl.txt')
openr, 1,idl_file
readf,1,dir2
close,1

fn_out = ''
title_flt = ''
fltno = intarr(1)
fltnos = 0
fn_reduced =''
fn_2dc = ''
fssp_chn = ''
fn_posttel = ''
year = ''
fn_hail = ''
fn_raw = ''


 openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
 readf,1,fn_out
 readf,1,title_flt
 readf,1,fltno
 readf,1,fn_reduced
 readf,1,fn_2dc
 readf,1,fssp_chn
 readf,1,fn_posttel
 readf,1,year
 readf,1,fn_hail
 readf,1,fn_raw
 close,1


fltnos = fltno

title_flt = 'flt ' + string(fltno)
print,'fn_reduced: ',fn_reduced

print,'fn_posttel: ',fn_posttel

fn_titles = dir1 +year + path_sep()+'tables'+path_sep()+'tag_names1.txt'
fn_units = dir1 + year + path_sep()+'tables'+path_sep()+'tag_units1.txt'

;stop
;- Read the reduced data file to get time,lat,lon,and calc_tas
read_rnd1999,fn_reduced,num_tags,tags,tag_ind,data,num,fltno
print,'num: ',num
;stop
;data_all includes all channel counts for fssp, 2dc, etc; for display of slow data, consider
;only the data in the tag_names1.txt
;stop
;data1 = fltarr(100,num)
;data1(0:24,*) = data_all(0:24,*)	; tags 101-140
;data1(25:37,*) = data_all(39:51,*) ; tags 190-150
;data1(38:99,*) = data_all(66:123,*)
;
;stop
times_red = long(reform(data(0,*)))
;times_red = times_red    ;+ 60000l
times_red = strtrim(string(times_red),2)
;stop
;- transform to decimal time
hms2hrs,times_red,time_red
;stop
;select time interval to process
hours_str=strtrim(strmid(times_red,0,2),2)
minutes_str=strtrim(strmid(times_red,2,2),2)
seconds_str=strtrim(strmid(times_red,4,2),2)
;stop
ind = where(strlen(hours_str) eq 1,cnt)
if cnt ne 0 then hours_str(ind) = '0' + hours_str(ind)
ind = where(strlen(minutes_str) eq 1,cnt)
if cnt ne 0 then minutes_str(ind) = '0' + minutes_str(ind)
ind = where(strlen(seconds_str) eq 1,cnt)
if cnt ne 0 then seconds_str(ind) = '0' + seconds_str(ind)
b_times = hours_str + minutes_str + seconds_str
;stop
se_buffs = time_wid_main2(b_times)
;stop
start_buff = se_buffs(0) - 1
end_buff   = se_buffs(1) - 1
print,'start_buff: ',start_buff
print,'end_buff  : ',end_buff
;stop
num_records = end_buff - start_buff + 1
hours   = hours_str(start_buff:end_buff)
minutes = minutes_str(start_buff:end_buff)
seconds = seconds_str(start_buff:end_buff)
;data = data(*,start_buff:end_buff)
time_red = time_red(start_buff:end_buff)
;data_byte = data_byte(*,start_buff:end_buff)
;stop
;- Get data for tags
read_posttel,tag_post,tag_labels,fn_posttel

;- Initialize the structures for reduced data and metadata (tag numbers, labels, format, min/max)
num_pts = num_records
num=num_records

; modified init_tagst to include the differences
;init_tagsT2,num_pts,hdata,metadata,num_tags_rnd
if ((fltnos ge 725) AND (fltnos lt 738)) then begin
  init_tagsT2_yr1999, num_pts, hdata_1999, metadata,num_tags_rnd, list_var
  data = data(*,start_buff:end_buff)
  data_into_hdata_1999, start_buff, end_buff, data, hdata_1999,hours_str, minutes_str, seconds_str, list_var
endif

print,'the number of tags is: ',num_tags_rnd
;stop
;init_tags,num_pts,hdata,metadata,num_tags_rnd
tag_nums = metadata.tag_num
plabels = metadata.plabel
;stop
plabels = strtrim(tag_nums) + '-' + plabels

;-Read the titles and units for each tag
read_titles_units,fn_titles,fn_units,tag_title,tag_unit
;stop

;Give the user the option to plot tag vs. time, or
;tag vs. another tag.
type_graph = intarr(1)
type_graph = 0 ; initialize
while type_graph ne 2 do begin
  type_graph = menu_wid_new(['Type of Graph?','Tag Value vs. Time', $
                   'Tag1 Value vs. Tag2 Value', 'Quit'])


if type_graph eq 0 then begin

;- Go into a while loop to ask number for graphs
;- Ask how many plots on the page
n_graphs = intarr(1)
n_graphs = 0   ;initialize
while n_graphs ne 4 do begin
n_graphs = menu_wid_new(['Number of graphs per page?','1-GRAPH/PAGE', $
                 '2-GRAPHS/PAGE','4-GRAPHS/PAGE','8-GRAPHS/PAGE','Quit'])
;graphs = ['Number of graphs per page?','1-GRAPH/PAGE', $
;      '2-GRAPHS/PAGE','4-GRAPHS/PAGE','8-GRAPHS/PAGE']
;graph_index = menu_wid('Select The Number of Graphs Per Page:',graphs)
;stop

;tag_label = strarr(8)
;y_label = strarr(8)
;print,'The number of graphs per page = ',n_graphs

window,xs=700,ys=700,1
;;window,xs=537,ys=646,1  ; to mach Mo's plots in matlab


if n_graphs eq 0 then begin
  JUMP1G:

  selected_tag_inds = checkbox_wid(['PLEASE SELECT 1 TAG: ',plabels(3:num_tags_rnd-1)])
  tag_ind = where(selected_tag_inds eq 1,num_selected)
  t1=size(tag_ind)

  if t1(1) eq 1 then begin
   selected_tag = tag_nums(tag_ind+3)
  endif else begin
    mes = 'You did not select ONE tag.  Please try again!'
    result = dialog_message(mes, /Error)
    print,result
    GOTO,JUMP1G
  endelse
  ;stop
endif

if n_graphs eq 1 then begin
  JUMP2G:

  selected_tag_inds = checkbox_wid(['PLEASE SELECT 2 TAGS: ',plabels(3:num_tags_rnd-1)])
  tag_ind = where(selected_tag_inds eq 1,num_selected)
  t2=size(tag_ind)
  print,'size(tag_ind)=',t2(1)
  ;stop
  if t2(1) eq 2 then begin
    selected_tag = tag_nums(tag_ind+3)
  endif else begin
    mes = 'You did not select TWO tags.  Please try again!'
    result = dialog_message(mes, /Error)
    print,result
    GOTO,JUMP2G
  endelse
  ;selected_tag = tag_nums(tag_ind+3)
endif

if n_graphs eq 2 then begin
  JUMP4G:

  selected_tag_inds = checkbox_wid(['PLEASE SELECT 4 TAGS: ',plabels(3:num_tags_rnd-1)])
  tag_ind = where(selected_tag_inds eq 1,num_selected)
  t4=size(tag_ind)
  print,'size(tag_ind)=',t4(1)
  if t4(1) eq 4 then begin
  selected_tag = tag_nums(tag_ind+3)
  endif else begin
    mes = 'You did not select FOUR tags.  Please try again!'
    result = dialog_message(mes, /Error)
    print,result
    GOTO,JUMP4G
  endelse
endif

if n_graphs eq 3 then begin
  JUMP8G:
  selected_tag_inds = checkbox_wid(['PLEASE SELECT 8 TAGS: ',plabels(3:num_tags_rnd-1)])
  tag_ind = where(selected_tag_inds eq 1,num_selected)
  t8=size(tag_ind)
  print,'size(tag_ind)=',t8(1)
  if t8(1) eq 8 then begin
  selected_tag = tag_nums(tag_ind+3)
  endif else begin
    mes = 'You did not select EIGHT tags.  Please try again!'
    result = dialog_message(mes, /Error)
    print,result
    GOTO,JUMP8G
  endelse
endif
;stop
case n_graphs of

    0: begin      ; one graph per page

       if (selected_tag(0) lt 900) then begin
       get_tag3_1999, tag_nums, hdata_1999, num, selected_tag(0), tag_ind, tag_title, tag_unit, tag_value, tag_label, tag_unt
       ;get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(0),tag_value,selected_tag_lab
       tag_value1 = tag_value
       endif

      tag_label1=strarr(1)
      y_label1=strarr(1)
      tag_label1(0)= tag_title(tag_ind(0)+3)	; for yr 1999
      y_label1(0) = tag_unit(tag_ind(0) + 3) ; for yr 1999

       plot1R,time_red, $
         tag_value1,$
           tag_label1, $
           y_label1
         ;['C'];;;,title_flt,date_str
       end

    1: begin         ; 2 graphs per page


       if (selected_tag(0) lt 900) then begin
        get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(0), tag_ind(0), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value1 = tag_value
      endif

      tag_label2=strarr(2)
      y_label2 = strarr(2)
      tag_label2(0)= tag_title(tag_ind(0)+3)	;yr 1999
      y_label2(0) = tag_unit(tag_ind(0) + 3)	;yr 1999

       if (selected_tag(1) lt 900) then begin
       get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(1), tag_ind(1), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value2 = tag_value
      endif

      tag_label2(1)= tag_title(tag_ind(1)+3)	;yr 1999
      y_label2(1) = tag_unit(tag_ind(1) + 3)	;yr 1999

       plot2R,time_red, $
         tag_value1,$
         tag_value2,$
           tag_label2, $
           y_label2

       end

    2: begin      ; 4 graphs per page


       if (selected_tag(0) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(0), tag_ind(0), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value1 = tag_value
      endif

      tag_label4=strarr(4)
      y_label4 = strarr(4)
      tag_label4(0)= tag_title(tag_ind(0)+3)	;yr 1999
      y_label4(0) = tag_unit(tag_ind(0) + 3)	;yr 1999

       if (selected_tag(1) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(1), tag_ind(1), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value2 = tag_value
      endif

      tag_label4(1)= tag_title(tag_ind(1)+3)	;yr 1999
      y_label4(1) = tag_unit(tag_ind(1) + 3)	;yr 1999

       if (selected_tag(2) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(2), tag_ind(2), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value3 = tag_value
      endif

      tag_label4(2)= tag_title(tag_ind(2)+3)	;yr 1999
      y_label4(2) = tag_unit(tag_ind(2) + 3)	;yr 1999

       if (selected_tag(3) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(3), tag_ind(3), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value4 = tag_value
      endif

      tag_label4(3)= tag_title(tag_ind(3)+3)	;yr 1999
      y_label4(3) = tag_unit(tag_ind(3) + 3)	;yr 1999

       ;;;plot4R,time_red, $
       plot4Rnew,time_red, $
         tag_value1,$
         tag_value2,$
         tag_value3,$
         tag_value4,$
           tag_label4, $
         y_label4


       end

    3: begin      ; 8 graphs per page


       if (selected_tag(0) lt 900) then begin
       get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(0), tag_ind(0), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value1 = tag_value
      endif

      tag_label8=strarr(8)
      y_label8 = strarr(8)
      tag_label8(0)= tag_title(tag_ind(0)+3)	;yr 1999
      y_label8(0) = tag_unit(tag_ind(0) +3)	;yr 1999

       if (selected_tag(1) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(1), tag_ind(1), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value2 = tag_value
      endif

      tag_label8(1)= tag_title(tag_ind(1)+3)	;yr 1999
      y_label8(1) = tag_unit(tag_ind(1) +3)	;yr 1999

       if (selected_tag(2) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(2), tag_ind(2), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value3 = tag_value
      endif

      tag_label8(2)= tag_title(tag_ind(2)+3)	;yr 1999
      y_label8(2) = tag_unit(tag_ind(2) +3)	;yr 1999

       if (selected_tag(3) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(3), tag_ind(3), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value4 = tag_value
      endif

      tag_label8(3)= tag_title(tag_ind(3)+3)	;yr 1999
      y_label8(3) = tag_unit(tag_ind(3) +3)	;yr 1999

       if (selected_tag(4) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(4), tag_ind(4), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value5 = tag_value
      endif

      tag_label8(4)= tag_title(tag_ind(4)+3)	;yr 1999
      y_label8(4) = tag_unit(tag_ind(4) +3)	;yr 1999

       if (selected_tag(5) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(5), tag_ind(5), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value6 = tag_value
      endif

      tag_label8(5)= tag_title(tag_ind(5)+3)	;yr 1999
      y_label8(5) = tag_unit(tag_ind(5) +3)	;yr 1999

       if (selected_tag(6) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(6), tag_ind(6), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value7 = tag_value
      endif

      tag_label8(6)= tag_title(tag_ind(6)+3)	;yr 1999
      y_label8(6) = tag_unit(tag_ind(6) +3)	;yr 1999
;stop
       if (selected_tag(7) lt 900) then begin
      get_tag3_1999,tag_nums, hdata_1999, num, selected_tag(7), tag_ind(7), tag_title, tag_unit, tag_value, tag_label, tag_unt
      tag_value8 = tag_value
      endif

      tag_label8(7)= tag_title(tag_ind(7)+3)	;yr 1999
      y_label8(7) = tag_unit(tag_ind(7) +3)	;yr 1999
;stop
       plot8R,time_red, $
         tag_value1,$
         tag_value2,$
         tag_value3,$
         tag_value4,$
         tag_value5,$
         tag_value6,$
         tag_value7,$
         tag_value8,$
           tag_label8, $
         y_label8
       end
    4: begin   ;done creating graphs
       GOTO, JUMP1
       end
endcase

endwhile ;end while for n_graphs ne 4

endif ;end for type_graph eq 0

if (type_graph eq 1) then begin
   ;this is where we include the option to plot one tag
   ;against another tag

   ;select tag for X-Axis
   JUMP1X:
   ;message,'Select Tag for X-AXIS !'
   select_xtag = checkbox_wid(['Select Tag for X-AXIS:',plabels(3:num_tags_rnd-1)])
   tag_ind_x = where(select_xtag eq 1,num_selected)

   tx = size(tag_ind_x)
   ;stop
   if tx(1) eq 1 then begin
      selected_tagx = tag_nums(tag_ind_x+3)
      ;stop
   endif else begin
      mes = 'You did not select ONE tag for X-Axis.  Please try again!'
      result = dialog_message(mes,/Error)
      print,result
      GOTO,JUMP1X
   endelse

   ;select tag for Y-Axis
   JUMP1Y:
   ;message,'Select Tag for Y-AXIS !'
   select_ytag = checkbox_wid(['Select Tag for Y-AXIS:',plabels(3:num_tags_rnd-1)])
   tag_ind_y = where(select_ytag eq 1,num_selected)

   ty = size(tag_ind_y)
   ;stop
   if ty(1) eq 1 then begin
      selected_tagy = tag_nums(tag_ind_y+3)
      ;stop
   endif else begin
      mes = 'You did not select ONE tag for Y-Axis.  Please try again!'
      result = dialog_message(mes,/Error)
      print,result
      GOTO,JUMP1Y
   endelse

;one graph per page
;select features for tag1 -> X-Axis
;;get_tag3new,tags,data,num,tag_post,tag_labels,selected_tagx,tag_value,selected_tag_lab
get_tag3_1999, tag_nums, hdata_1999, num, selected_tagx, tag_ind_x, tag_title, tag_unit, tag_value, tag_label, tag_unt

;get_tag3,data,num,tag_post,tag_labels,selected_tagx,tag_value,selected_tag_lab
tag_value1=tag_value
tag_label_x=tag_title(tag_ind_x+3)
x_label=tag_unit(tag_ind_x+3)

;select features for tag2 -> Y-Axis
;;get_tag3new,tags,data,num,tag_post,tag_labels,selected_tagy,tag_value,selected_tag_lab
get_tag3_1999, tag_nums, hdata_1999, num, selected_tagy, tag_ind_y, tag_title, tag_unit, tag_value, tag_label, tag_unt

;get_tag3,data,num,tag_post,tag_labels,selected_tagy,tag_value,selected_tag_lab
tag_value2=tag_value
tag_label_y=tag_title(tag_ind_y+3)
y_label=tag_unit(tag_ind_y+3)
;stop
;call the plotting routine
plotxy,tag_value1,tag_label_x,x_label,$
       tag_value2,tag_label_y,y_label

endif ;for if type_graph eq 1


if type_graph eq 2 then begin
  GOTO, JUMP1
endif


endwhile ;for the type_graph



state = {SELECTED_TAG_INDS:selected_tag_inds, $
         TAGS:tags, $
         DATA:data, $
         NUM:num, $
         TAG_POST:tag_post, $
         TAG_LABELS:tag_labels, $
         TAG_NUMS:tag_nums, $
         TIME_RED:time_red }

;;widget_control,base,set_uvalue=state

;;xmanager,'PlotReducedOnly',base

JUMP1:
mes = 'Displaying Sesion is Over Now!'
result = dialog_message(mes, /Information)
print,result
WDELETE,1

end
