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
;  Donna included the option to plot one tag against the other,
;  not just tag against the time.
;------------------------------------------------

pro PlotReducedOnly_new2

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
fn_hvps = ''
fn_reduced =''
fn_hail=''
fn_2dc = ''
fssp_chn = ''
fn_posttel = ''
year = ''
fn_raw=''


openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
readf,1,fn_out
readf,1,title_flt
readf,1,fltno
close,1

if ((fltno ge 725) AND (fltno lt 738)) then begin
 openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
 readf,1,fn_out
 readf,1,title_flt
 readf,1,fltno
 readf,1,fn_reduced
 readf,1,fn_2dc
 readf,1,fssp_chn
 readf,1,fn_posttel
 readf,1,year
 close,1
endif

;if ((fltno gt 737) OR (fltno lt 725)) then begin
if (fltno gt 737) then begin
 openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
 readf,1,fn_out
 readf,1,title_flt
 readf,1,fltno
 readf,1,fn_hvps
 readf,1,fn_reduced
 readf,1,fn_2dc
 readf,1,fssp_chn
 readf,1,fn_posttel
 readf,1,year
 close,1
endif

if ((fltno ge 654) AND (fltno le 665)) then begin	;flights for Yr 1995
  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
  readf,1,fn_out
  readf,1,title_flt
  readf,1,fltno
  readf,1,fn_reduced
  readf,1,fssp_chn
  readf,1,fn_posttel
  readf,1,year
  close,1
endif

if ((fltno ge 666) AND (fltno le 670)) then begin	;flights for Yr 1995

  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
  readf,1,fn_out
  readf,1,title_flt
  readf,1,fltno
  readf,1,fn_hvps
  readf,1,fn_reduced
  readf,1,fssp_chn
  readf,1,fn_posttel
  readf,1,year
  close,1
endif

if (fltno eq 671) then begin	;flight for Yr 1995
  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
  readf,1,fn_out
  readf,1,title_flt
  readf,1,fltno
  readf,1,fn_reduced
  readf,1,fssp_chn
  readf,1,fn_posttel
  readf,1,year
  close,1
endif

if (fltno eq 717) then begin	;flight for Yr 1998
  openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
  readf,1,fn_out
  print,fn_out
  readf,1,title_flt
  print,title_flt
  readf,1,fltno
  print,fltno
  readf,1,fn_hvps
  print,fn_hvps
  readf,1,fn_reduced
  print,fn_reduced
  readf,1,fn_2dc
  print,fn_2dc
  readf,1,fssp_chn
  print,fssp_chn
  readf,1,fn_posttel
  print,fn_posttel
  readf,1,year
  print,year
  readf,1,fn_hail
  print,fn_hail
  readf,1,fn_raw
  print,fn_raw
  close,1
endif

fltnos = fltno
;stop

title_flt = 'flt ' + string(fltno)
print,'fn_reduced: ',fn_reduced

print,'fn_posttel: ',fn_posttel

 if fltnos ge 782 then begin
       fn_titles = dir1 + year +path_sep()+'tables'+path_sep()+'tag_names2.txt'
       fn_units = dir1 + year + path_sep()+'tables'+path_sep()+'tag_units2.txt'
 endif else begin
       fn_titles = dir1 +year + path_sep()+'tables'+path_sep()+'tag_names1.txt'
       fn_units = dir1 + year + path_sep()+'tables'+path_sep()+'tag_units1.txt'
 endelse

if ((fltno ge 654) AND (fltno le 671)) then begin 	;flights for Yr 1995
;- Read the reduced data file to get time,lat,lon,and calc_tas
 read_rnd1995,fn_reduced,num_tags,tags,tag_ind,data,num,hrs,hms,err
 print,'num: ',num
 times_red = long(hms)
 times_red = strtrim(string(times_red),2)
 ;stop
 ;- transform to decimal time
 time_red=hrs(*)
 ;stop
 ;select time interval to process
 hours_str=strtrim(strmid(times_red,0,2),2)
 minutes_str=strtrim(strmid(times_red,2,2),2)
 seconds_str=strtrim(strmid(times_red,4,2),2)
 ;stop
endif else begin
 ;- Read the reduced data file to get time,lat,lon,and calc_tas
 read_rnd,fn_reduced,num_tags,tags,tag_ind,data,num,fltno
 print,'num: ',num
 times_red = long(reform(data(0,*)))

 times_red = strtrim(string(times_red),2)
 ;stop
 ;- transform to decimal time
 hms2hrs,times_red,time_red

 ;select time interval to process
 hours_str=strtrim(strmid(times_red,0,2),2)
 minutes_str=strtrim(strmid(times_red,2,2),2)
 seconds_str=strtrim(strmid(times_red,4,2),2)
endelse

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

;- Get data for tags
read_posttel,tag_post,tag_labels,fn_posttel

;- Initialize the structures for reduced data and metadata (tag numbers, labels, format, min/max)
num_pts = num_records
num=num_records

; modified init_tagst to include the differences
;init_tagsT2,num_pts,hdata,metadata,num_tags_rnd
;stop
if ((fltnos ge 711) AND (fltnos lt 718)) then begin
  init_tagsT2_yr1998, num_pts, hdata_1998, metadata,num_tags_rnd,list_var
  data = data(*,start_buff:end_buff)
  data_into_hdata_1998, start_buff, end_buff, data, hdata_1998,hours_str, minutes_str, seconds_str, list_var
endif
;stop

if ((fltnos ge 725) AND (fltnos lt 738)) then begin
  init_tagsT2_yr1999, num_pts, hdata_1999, metadata,num_tags_rnd, list_var
  data = data(*,start_buff:end_buff)
endif
;stop

if ((fltnos ge 738) AND (fltnos lt 775)) then begin
  init_tagsT2,num_pts,hdata,metadata,num_tags_rnd
  data = data(*,start_buff:end_buff)
endif

if ((fltnos ge 775) and (fltnos lt 782)) then begin
  init_tagsT3,num_pts,hdata,metadata,num_tags_rnd
  data = data(*,start_buff:end_buff)
endif

if (fltnos ge 782) then begin
  init_tagsT4,num_pts,hdata,metadata,num_tags_rnd
  data = data(*,start_buff:end_buff)
endif

if ((fltnos ge 654) AND (fltnos le 671)) then begin
  init_tags_yr1995,num_pts,hdata_1995,metadata,num_tags_rnd,list_var
  data = data(*,start_buff:end_buff)
  data_into_hdata_1995,start_buff,end_buff, data, hdata_1995,hours_str, minutes_str, seconds_str, list_var, size_dn_hirate, fltno

  ;stop
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
  ;stop
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
        ;for Dyn_press1 - Dyn_press2
       if (selected_tag(0) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(0) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(0) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(0) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(0) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(0) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(0) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(0) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value = tag_value_a - tag_value_b
       endif

      if (fltno ne 717) then begin
	   if ((fltnos ge 654) AND (fltnos le 671)) then begin
	     get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(0), tag_ind, tag_title, tag_unit, tag_value, tag_label, tag_unt
       endif else begin   ;(selected_tag(0) lt 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(0),tag_value,selected_tag_lab
       endelse
      endif

	   if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(0), tag_ind, tag_title, tag_unit, tag_value, tag_label, tag_unt
	    
       endif
      tag_value1 = tag_value
      tag_label1=strarr(1)
      y_label1=strarr(1)
      tag_label1(0)= tag_title(tag_ind(0)+3)
      y_label1(0) = tag_unit(tag_ind(0) + 3)
      ;stop
       plot1R,time_red, $
         tag_value1, $
           tag_label1, $
           y_label1
         ;['C'];;;,title_flt,date_str
       end

    1: begin         ; 2 graphs per page

       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(0) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(0) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(0) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(0) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(0) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(0) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(0) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(0) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif


       ;SElect Tag #2
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(1) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(1) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(1) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(1) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(1) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(1) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(1) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(1) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

      print,'selected_tag(0)=',selected_tag(0)
      if (fltno ne 717) then begin
      if (selected_tag(0) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(0), tag_ind(0), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value1 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(0) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(0),tag_value,selected_tag_lab
           tag_value1 = tag_value
         endelse
      endif
      endif

	   if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(0), tag_ind(0), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
	     tag_value1=tag_value
       endif
;       if (selected_tag(0) lt 900) then begin
;        get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(0),tag_value,selected_tag_lab
;      tag_value1 = tag_value
;      endif
      tag_label2=strarr(2)
      y_label2 = strarr(2)
      tag_label2(0)= tag_title(tag_ind(0)+3)
      y_label2(0) = tag_unit(tag_ind(0) + 3)

;       if (selected_tag(1) lt 900) then begin
;       get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(1),tag_value,selected_tag_lab
;      tag_value2 = tag_value
;      endif
;stop
      print,'selected_tag(1)=',selected_tag(1)
      if (fltno ne 717) then begin
      if (selected_tag(1) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(1), tag_ind(1), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value2 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(0) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(1),tag_value,selected_tag_lab
           tag_value2 = tag_value
         endelse
      endif
      endif

       if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(1), tag_ind(1), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
	     tag_value2=tag_value
       endif

      tag_label2(1)= tag_title(tag_ind(1)+3)
      y_label2(1) = tag_unit(tag_ind(1) + 3)

       plot2R,time_red, $
         tag_value1,$
         tag_value2,$
           tag_label2, $
           y_label2

       end

    2: begin      ; 4 graphs per page

       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(0) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(0) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(0) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(0) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(0) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(0) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(0) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(0) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;SElect Tag #2
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(1) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(1) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(1) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(1) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(1) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(1) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(1) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(1) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;Select Tag #3
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(2) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(2) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(2) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(2) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(2) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(2) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(2) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(2) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;SElect Tag #4
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(3) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(3) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(3) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(3) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(3) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(3) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(3) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(3) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

      print,'selected_tag(0)=',selected_tag(0)

    if (fltno ne 717) then begin
      if (selected_tag(0) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(0), tag_ind(0), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value1 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(0) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(0),tag_value,selected_tag_lab
           tag_value1 = tag_value
         endelse
      endif
    endif

   	   if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(0), tag_ind(0), tag_title, tag_unit, tag_value, tag_label, tag_unt

	     tag_value1=tag_value
	     stop
       endif

      tag_label4=strarr(4)
      y_label4 = strarr(4)
      tag_label4(0)= tag_title(tag_ind(0)+3)
      y_label4(0) = tag_unit(tag_ind(0) + 3)

;       if (selected_tag(0) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(0),tag_value,selected_tag_lab
;      tag_value1 = tag_value
;      endif
;
;      tag_label(0)= tag_title(tag_ind(0)+3)
;      y_label(0) = tag_unit(tag_ind(0) + 3)

    if (fltno ne 717) then begin
      print,'selected_tag(1)=',selected_tag(1)
      if (selected_tag(1) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(1), tag_ind(1), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value2 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(1) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(1),tag_value,selected_tag_lab
           tag_value2 = tag_value
         endelse
      endif
    endif

       if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(1), tag_ind(1), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     tag_value2=tag_value
	     stop
       endif
      tag_label4(1)= tag_title(tag_ind(1)+3)
      y_label4(1) = tag_unit(tag_ind(1) + 3)


;       if (selected_tag(1) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(1),tag_value,selected_tag_lab
;      tag_value2 = tag_value
;      endif
;
;      tag_label(1)= tag_title(tag_ind(1)+3)
;      y_label(1) = tag_unit(tag_ind(1) + 3)
;
;       if (selected_tag(2) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(2),tag_value,selected_tag_lab
;      tag_value3 = tag_value
;      endif
;
;      tag_label(2)= tag_title(tag_ind(2)+3)
;      y_label(2) = tag_unit(tag_ind(2) + 3)

    if (fltno ne 717) then begin
      print,'selected_tag(2)=',selected_tag(2)
      if (selected_tag(2) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(2), tag_ind(2), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value3 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(1) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(2),tag_value,selected_tag_lab
           tag_value3 = tag_value
         endelse
      endif
     endif

       if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(2), tag_ind(2), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
	     tag_value3=tag_value
       endif

      tag_label4(2)= tag_title(tag_ind(2)+3)
      y_label4(2) = tag_unit(tag_ind(2) + 3)


;       if (selected_tag(3) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(3),tag_value,selected_tag_lab
;      tag_value4 = tag_value
;      endif
;
;      tag_label(3)= tag_title(tag_ind(3)+3)
;      y_label(3) = tag_unit(tag_ind(3) + 3)

      print,'selected_tag(3)=',selected_tag(3)
     if (fltno ne 717) then begin
      if (selected_tag(3) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(3), tag_ind(3), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value4 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(1) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(3),tag_value,selected_tag_lab
           tag_value4 = tag_value
         endelse
      endif
     endif

       if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(3), tag_ind(3), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
	     tag_value4=tag_value
       endif

      tag_label4(3)= tag_title(tag_ind(3)+3)
      y_label4(3) = tag_unit(tag_ind(3) + 3)


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

       ;Select Tag #1
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(0) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(0) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(0) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(0) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(0) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(0) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(0) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(0) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value1 = tag_value_a - tag_value_b
       endif

       ;SElect Tag #2
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(1) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(1) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(1) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(1) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(1) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(1) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(1) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(1) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value2 = tag_value_a - tag_value_b
       endif

       ;Select Tag #3
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(2) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(2) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(2) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(2) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(2) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(2) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(2) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(2) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value3 = tag_value_a - tag_value_b
       endif

       ;SElect Tag #4
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(3) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(3) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(3) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(3) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value4= tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(3) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(3) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(3) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(3) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value4 = tag_value_a - tag_value_b
       endif

       ;Select Tag #5
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(4) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value5 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(4) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value5 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(4) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value5 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(4) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value5 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(4) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value5 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(4) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value5 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(4) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value5 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(4) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value5 = tag_value_a - tag_value_b
       endif

       ;SElect Tag #6
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(5) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value6 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(5) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value6 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(5) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value6 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(5) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value6 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(5) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value6 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(5) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value6 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(5) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value6 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(5) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value6 = tag_value_a - tag_value_b
       endif

       ;Select Tag #7
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(6) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value7 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(6) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value7 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(6) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value7 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(6) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value7 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(6) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value7 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(6) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value7 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(6) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value7 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(6) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value7 = tag_value_a - tag_value_b
       endif

       ;SElect Tag #8
       ;for Dyn_press1 - Dyn_press2
       if (selected_tag(7) eq 900) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,101,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,102,tag_value_b,selected_tag_lab
           tag_value8 = tag_value_a - tag_value_b
       endif

       ;for Stat_press1 - Stat_press2
       if (selected_tag(7) eq 901) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,103,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,104,tag_value_b,selected_tag_lab
           tag_value8 = tag_value_a - tag_value_b
       endif

       ;for Rose - RFT
       if (selected_tag(7) eq 902) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,106,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,107,tag_value_b,selected_tag_lab
           tag_value8 = tag_value_a - tag_value_b
       endif

       ;for Heading - GPS_Grd_trk_angle
       if (selected_tag(7) eq 903) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,193,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,175,tag_value_b,selected_tag_lab
           tag_value8 = tag_value_a - tag_value_b
       endif

       ;for AccelZ - Accel
       if (selected_tag(7) eq 904) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,292,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,109,tag_value_b,selected_tag_lab
           tag_value8 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - Calc_TAS
       if (selected_tag(7) eq 905) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,211,tag_value_b,selected_tag_lab
           tag_value8 = tag_value_a - tag_value_b
       endif

       ;for NCAR_TAS - GPS_Grd_Spd
       if (selected_tag(7) eq 906) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,118,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,174,tag_value_b,selected_tag_lab
           tag_value8 = tag_value_a - tag_value_b
       endif

       ;for GPS_Alt - Press_Elev
       if (selected_tag(7) eq 907) then begin
         get_tag3,tags,data,num,tag_post,tag_labels,178,tag_value_a,selected_tag_lab
           get_tag3,tags,data,num,tag_post,tag_labels,205,tag_value_b,selected_tag_lab
           tag_value8 = tag_value_a - tag_value_b
       endif

;       if (selected_tag(0) lt 900) then begin
;       get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(0),tag_value,selected_tag_lab
;      tag_value1 = tag_value
;      endif
;
;      tag_label(0)= tag_title(tag_ind(0)+3)
;      y_label(0) = tag_unit(tag_ind(0) + 3)
      tag_label8=strarr(8)
      y_label8 = strarr(8)

      print,'selected_tag(0)=',selected_tag(0)
     if (fltno ne 717) then begin
      if (selected_tag(0) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(0), tag_ind(0), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value1 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(0) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(0),tag_value,selected_tag_lab
           tag_value1 = tag_value
         endelse
      endif
     endif

       if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(0), tag_ind(0), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
	     tag_value1=tag_value
       endif
      tag_label8(0)= tag_title(tag_ind(0)+3)
      y_label8(0) = tag_unit(tag_ind(0) + 3)



;       if (selected_tag(1) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(1),tag_value,selected_tag_lab
;      tag_value2 = tag_value
;      endif
;
;      tag_label(1)= tag_title(tag_ind(1)+3)
;      y_label(1) = tag_unit(tag_ind(1) + 3)

      print,'selected_tag(1)=',selected_tag(1)

     if (fltno ne 717) then begin
      if (selected_tag(1) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(1), tag_ind(1), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value2 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(1) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(1),tag_value,selected_tag_lab
           tag_value2 = tag_value
         endelse
      endif
     endif

       if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(1), tag_ind(1), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
	     tag_value2=tag_value
       endif

      tag_label8(1)= tag_title(tag_ind(1)+3)
      y_label8(1) = tag_unit(tag_ind(1) + 3)


;       if (selected_tag(2) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(2),tag_value,selected_tag_lab
;      tag_value3 = tag_value
;      endif
;
;      tag_label(2)= tag_title(tag_ind(2)+3)
;      y_label(2) = tag_unit(tag_ind(2) + 3)

      print,'selected_tag(2)=',selected_tag(2)

    if (fltno ne 717) then begin
      if (selected_tag(2) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(2), tag_ind(2), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value3 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(2) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(2),tag_value,selected_tag_lab
           tag_value3 = tag_value
         endelse
      endif
     endif

      if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(2), tag_ind(2), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
         tag_value3=tag_value
       endif
      tag_label8(2)= tag_title(tag_ind(2)+3)
      y_label8(2) = tag_unit(tag_ind(2) + 3)

;       if (selected_tag(3) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(3),tag_value,selected_tag_lab
;      tag_value4 = tag_value
;      endif
;
;      tag_label(3)= tag_title(tag_ind(3)+3)
;      y_label(3) = tag_unit(tag_ind(3) + 3)

      print,'selected_tag(3)=',selected_tag(3)

    if (fltno ne 717) then begin
      if (selected_tag(3) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(3), tag_ind(3), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value4 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(3) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(3),tag_value,selected_tag_lab
           tag_value4 = tag_value
         endelse
      endif
    endif

   	   if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(3), tag_ind(3), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
       tag_value4=tag_value
       endif
      tag_label8(3)= tag_title(tag_ind(3)+3)
      y_label8(3) = tag_unit(tag_ind(3) + 3)

;       if (selected_tag(4) lt 900) then begin
;       get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(4),tag_value,selected_tag_lab
;      tag_value5 = tag_value
;      endif
;
;      tag_label(4)= tag_title(tag_ind(4)+3)
;      y_label(4) = tag_unit(tag_ind(4) + 3)

      print,'selected_tag(4)=',selected_tag(4)

    if ( fltno ne 717) then begin
      if (selected_tag(4) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(4), tag_ind(4), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value5 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(4) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(4),tag_value,selected_tag_lab
           tag_value5 = tag_value
         endelse
      endif
    endif

       if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(4), tag_ind(4), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
       tag_value5=tag_value
       endif
      tag_label8(4)= tag_title(tag_ind(4)+3)
      y_label8(4) = tag_unit(tag_ind(4) + 3)


;       if (selected_tag(5) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(5),tag_value,selected_tag_lab
;      tag_value6 = tag_value
;      endif
;
;      tag_label(5)= tag_title(tag_ind(5)+3)
;      y_label(5) = tag_unit(tag_ind(5) + 3)

      print,'selected_tag(5)=',selected_tag(5)

    if (fltno ne 717) then begin
      if (selected_tag(5) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(5), tag_ind(5), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value6 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(5) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(5),tag_value,selected_tag_lab
           tag_value6 = tag_value
         endelse
      endif
     endif

     if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(5), tag_ind(5), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
     tag_value6=tag_value
       endif
      tag_label8(5)= tag_title(tag_ind(5)+3)
      y_label8(5) = tag_unit(tag_ind(5) + 3)

;       if (selected_tag(6) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(6),tag_value,selected_tag_lab
;      tag_value7 = tag_value
;      endif
;
;      tag_label(6)= tag_title(tag_ind(6)+3)
;      y_label(6) = tag_unit(tag_ind(6) + 3)

      print,'selected_tag(6)=',selected_tag(6)

    if (fltno ne 717) then begin
      if (selected_tag(6) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(6), tag_ind(6), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value7 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(6) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(6),tag_value,selected_tag_lab
           tag_value7 = tag_value
         endelse
      endif

    endif

       if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(6), tag_ind(6), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
       tag_value7=tag_value
       endif

      tag_label8(6)= tag_title(tag_ind(6)+3)
      y_label8(6) = tag_unit(tag_ind(6) + 3)

;       if (selected_tag(7) lt 900) then begin
;      get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(7),tag_value,selected_tag_lab
;      tag_value8 = tag_value
;      endif
;
;      tag_label(7)= tag_title(tag_ind(7)+3)
;      y_label(7) = tag_unit(tag_ind(7) + 3)

      print,'selected_tag(7)=',selected_tag(7)

    if (fltno ne 717) then begin
      if (selected_tag(7) lt 900) then begin
        if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tag(7), tag_ind(7), tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value8 = tag_value
	       ;stop
         endif else begin   ;(selected_tag(7) lt 900) then begin
           get_tag3,tags,data,num,tag_post,tag_labels,selected_tag(7),tag_value,selected_tag_lab
           tag_value8 = tag_value
         endelse
      endif
     endif

    if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tag(7), tag_ind(7), tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
       tag_value8=tag_value
       endif

      tag_label8(7)= tag_title(tag_ind(7)+3)
      y_label8(7) = tag_unit(tag_ind(7) + 3)

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

    if (fltno ne 717) then begin
      if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tagx, tag_ind_x, tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value1 = tag_value
	       ;stop
      endif else begin   ;(selected_tag(7) lt 900) then begin
           get_tag3new,tags,data,num,tag_post,tag_labels,selected_tagx,tag_value,selected_tag_lab
           tag_value1 = tag_value
      endelse

    endif

       if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tagx, tag_ind_x, tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
	     tag_value1=tag_value
       endif
;one graph per page
;select features for tag1 -> X-Axis
;;get_tag3new,tags,data,num,tag_post,tag_labels,selected_tagx,tag_value,selected_tag_lab
;get_tag3,data,num,tag_post,tag_labels,selected_tagx,tag_value,selected_tag_lab
;;tag_value1=tag_value
tag_label_x=tag_title(tag_ind_x+3)
x_label=tag_unit(tag_ind_x+3)


    if (fltno ne 717) then begin
      if ((fltnos ge 654) AND (fltnos le 671)) then begin
	       get_tag3_1995, tag_nums, hdata_1995, num, selected_tagy, tag_ind_y, tag_title, tag_unit, tag_value, tag_label, tag_unt
	       tag_value2 = tag_value
	       ;stop
      endif else begin   ;(selected_tag(7) lt 900) then begin
           get_tag3new,tags,data,num,tag_post,tag_labels,selected_tagy,tag_value,selected_tag_lab
           tag_value2 = tag_value
      endelse

    endif

      if (fltnos eq 717) then begin
	     get_tag3_1998, tag_nums, hdata_1998, num, selected_tagy, tag_ind_y, tag_title, tag_unit, tag_value, tag_label, tag_unt
	     stop
	     tag_value2=tag_value
       endif
;select features for tag2 -> Y-Axis
;;get_tag3new,tags,data,num,tag_post,tag_labels,selected_tagy,tag_value,selected_tag_lab
;get_tag3,data,num,tag_post,tag_labels,selected_tagy,tag_value,selected_tag_lab
;;tag_value2=tag_value
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
