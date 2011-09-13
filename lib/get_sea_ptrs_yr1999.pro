
;- get_sea_ptrs2.pro

function get_sea_ptrs_yr1999, flt_num_str, fn_src,tag_sel,num,SUMM=summ,DIR_PATH=dir_path,FN_DIR=fn_dir

;- Extract the directory info from an SEA raw file and save it to a file (.dir). If it already
;- exists then read the info from the .dir file (much faster). Return the time in hrs and hms and
;- the buffer pointers for the specified tag number (tag_sel) in a structure (time_struct).

;- Inputs
;-  fn_src - File name of the SEA raw data.
;-  tag_sel - The selected tag number.
;-  num>0 Return zero-filled array of size num if no occurrences of tag_sel are found
;-        Return array of appropriate size if occurrences are found
;-  num=0 Stop if no occurrences of tag_sel found
;-  summ = If set, display a summary of the directory structure.
;-  dir_path = If set, directory path to use for saving .dir file. Otherwise, save in same
;-             directory as fn_src

;- Outputs
;-  time_struct - An structure of arrays for the following:
;-   time_hrs - The time in hrs for every buffer.
;-   time_hms - The time in hh:mm:ss for every buffer.
;-   buf_ptrs - A file pointer to every buffer for the selected tag number

;- Used for dimensioning a set of arrays of unknown size - the maximum number of tags ever
;- expected in a raw SEA file
max_dir_entries = 500000l

;- Contruct the .dir file name. Directory info will be saved here the 1st time through.
if keyword_set(DIR_PATH) then begin
    fn_dir = dir_path + '.dir'
    fn_txt = dir_path + '.txt'
    fn_err = dir_path + '.err'
endif else begin
    len = strlen(fn_src)
    fn_dir = strmid(fn_src,0,len-3) + 'dir'
    fn_txt = strmid(fn_src,0,len-3) + 'txt'
    fn_err = strmid(fn_src,0,len-3) + 'err'
endelse

if keyword_set(FN_DIR) then begin
    fn_txt = strmid(fn_dir,0,len-3) + 'txt'
    fn_err = strmid(fn_dir,0,len-3) + 'err'
endif
;stop
print,'fn_dir: ',fn_dir
;p = strmid(fn_dir,27,3)
;fltno = float(p)

fltno = float(flt_num_str)

;stop
;- Check if the .dir file exists. If it does, read the desired data from there. If not, extract
;- it from the SEA raw file (fn_src) and create the .dir file. The following are stored in the
;- .dir file for every tag:
;-   tag - tag number
;-   buff_num - buffer number (a sequence number) for this tag
;-   tag_ptrs - the file pointer for this tag
;-   freq - the sample rate (number of samples for each buffer)
;-   totbytes - total number of bytes that the data for this tag occupies
;-   offset - the pointer offset from the beginning of the buffer to the values for this tag
;-   time_hrs - time in hrs for this tag
;-   time_hms - time in hms for each tag

openr,unit,fn_dir,/get_lun,error = err
;stop
if err eq 0 then begin
    data2 = lonarr(2)
    readu,unit,data2
    num_tags = data2(0)
    num_buffers = data2(1)
    print,'1) num_tags,num_buffers: ',num_tags,num_buffers

    tag         = intarr(num_tags)
    buff_num = intarr(num_tags)
    tag_ptrs = lonarr(num_tags)
    freq     = intarr(num_tags)
    totbytes = intarr(num_tags)
    offset   = intarr(num_tags)
    time_hrs = fltarr(num_tags)
    time_hms = dblarr(num_tags)

    readu,unit,tag
    readu,unit,buff_num
    readu,unit,tag_ptrs
    readu,unit,freq
    readu,unit,totbytes
    readu,unit,time_hrs
    readu,unit,time_hms
stop
    free_lun,unit

if fltno eq 751.0 then begin
  print,'Initial First time point     : ',time_hrs(0), time_hms(0)
  print,'Initial Last time point      : ',time_hrs(num_tags-1), time_hms(num_tags-1)

new_time_sec = dblarr(1)

  ; num_tags = number of points we have
  ; go through each data point and add the 107 seconds
  for i=0l, num_tags-1l do begin
       hr = fix(time_hrs(i))
       minute_to_seconds = (time_hrs(i)-hr)*60.0*60.0
       new_time_sec = hr*3600.0 + minute_to_seconds + 107 ; add the time difference
       time_hrs(i) = new_time_sec/3600.0

       new_hr = fix(time_hrs(i))
       new_minutes = (time_hrs(i)-new_hr)*60.0
       temp_new_minutes = fix(new_minutes)
       time_hms(i) = fix(time_hrs(i))*10000.0 + $                 ; hrs
                     fix(new_minutes)*100.0 + $                      ; minutes
                     (new_minutes - temp_new_minutes)*60.0        ;seconds
;stop
  endfor

  print,'modified First time point     : ',time_hrs(0), time_hms(0)
  print,'modified Last time point      : ',time_hrs(num_tags-1), time_hms(num_tags-1)
endif

endif else begin
;stop
    ;- The .dir file did not exist. Get the directory info from the SEA raw file
    ans = dialog_message('Could not find: ' + fn_dir + '  Creating ...',/information)

    data = intarr(8)     ;Each directory entry is 8 ints (16 bytes)
    date_time = intarr(9)  ;The date and time for each buffer is stored in 9 ints (18 bytes)
    print,'2) num_tags,num_buffers: '

    openr,unit,fn_src,/get_lun

    status = fstat(unit)
    print,'fn_src     : ',fn_src
    print,'status.size: ',status.size
;stop
    ptr = 0l

    i = 0l     ;buffer counter
    j = 0l     ;tag counter

    tag         = intarr(max_dir_entries)
    buff_num = intarr(max_dir_entries)
    tag_ptrs = lonarr(max_dir_entries)
    freq     = intarr(max_dir_entries)
    totbytes = intarr(max_dir_entries)
    time_hrs = fltarr(max_dir_entries)
    time_hms = dblarr(max_dir_entries)
    offset   = intarr(max_dir_entries)

    ;- Read buffers until the ptr exceeds the size of the file
    while ptr lt status.size-16 do begin

       ;- A way to monitor the progress of reading the directories (~ 1 min)
       if i mod 1000 eq 0 then $
         if i eq 0 then begin
          base = widget_base(/column,/base_align_right,title='Reading Sea Directories ...', $
              xoffset = 200,yoffset = 200)
          field1  = cw_field(base,title='Number read: ',value='0',/string)
          widget_control,base,/realize
         endif else widget_control,field1,set_value=strtrim(i,2)

       num_dir_entries = 0
       tag_num = 0

       point_lun,unit,ptr

       ;- Ptr should be at the beginning of a directory. Read until tag 999 is encountered
       s1 = j
       while tag_num ne 999 do begin
         buff_num(j) = i
         readu,unit,data
         tag_num     = data(0)
         tag(j)      = data(0)
         offset(j)   = data(1)
         freq(j)     = data(3)
         totbytes(j) = data(2)
         tag_ptrs(j) = ptr + long(offset(j))
         ;print,'tag_num,offset(j): ',tag_num,offset(j)
         if tag_num eq 999 then ptr = ptr + long(offset(j))
         j = j + 1l

       endwhile
       s2 = j - 1l

       ;- First values after the directory are 9 ints of date and time
       readu,unit,date_time
       fltdate = float(date_time(0)) * 10000. + $
                  float(date_time(1)) *   100. + $
                 float(date_time(2))

       time_hrs(s1:s2) = float(double(date_time(3)) + $
                          double(date_time(4)) / 60. + $
                          double(date_time(5)) / 3600. + $
                          double(date_time(6)) / 360000.)

       ;- If the hrs is less than 6 then must be after midnight (for T28 anyway).
       ;- Convert to 24 plus hrs (i.e., 25,26,27,... hrs).
       tem = date_time(3)
       if tem lt 6 then tem = tem + 24

       time_hms(s1:s2) = double(tem) * 10000. + $
                          double(date_time(4)) * 100. + $
                          double(date_time(5)) + $
                          double(date_time(6)) / 100.

       i = i + 1l
;stop
    endwhile   ;Done reading the raw file and extracting directory info

    widget_control,base,/destroy

    ;wdelete, wnum

    close,/all

    ;- Resize all the arrays to the number of tags found in the file
    num_buffers = i
    num_tags = j

    tag         = tag(0:num_tags-1)
    offset   = offset(0:num_tags-1)
    freq     = freq(0:num_tags-1)
    tag_ptrs = tag_ptrs(0:num_tags-1)
    totbytes = totbytes(0:num_tags-1)
    buff_num = buff_num(0:num_tags-1)
    time_hms = time_hms(0:num_tags-1)
    time_hrs = time_hrs(0:num_tags-1)

if fltno eq 751.0 then begin
  print,'Initial First time point     : ',time_hrs(0), time_hms(0)
  print,'Initial Last time point      : ',time_hrs(num_tags-1), time_hms(num_tags-1)

  new_time_sec = dblarr(1)

  ; num_tags = number of points we have
  ; go through each data point and add the 107 seconds
  for i=0l, num_tags-1l do begin
       hr = fix(time_hrs(i))
       minute_to_seconds = (time_hrs(i)-hr)*60.0*60.0
       new_time_sec = hr*3600.0 + minute_to_seconds + 107 ; add the time difference
       time_hrs(i) = new_time_sec/3600.0

       new_minutes = (time_hrs(i)-hr)*60.0
       temp_new_minutes = fix(new_minutes)
       time_hms(i) = fix(time_hrs(i))*10000.0 + $                 ; hrs
                     fix(new_minutes)*100.0 + $                      ; minutes
                     (new_minutes - temp_new_minutes)*60.0        ;seconds
;stop
  endfor

  print,'modified First time point     : ',time_hrs(0), time_hms(0)
  print,'modified Last time point      : ',time_hrs(num_tags-1), time_hms(num_tags-1)
endif
;stop
    ;- If time is less than 6 hrs then must be after midnight. Convert to 24 plus hrs.
    ind = where(time_hrs lt 6.,cnt)
    if cnt ne 0 then time_hrs(ind) = time_hrs(ind) + 24.

    ;- Create the .dir file
    openw,unit,fn_dir,/get_lun
    writeu,unit,num_tags,num_buffers
    writeu,unit,tag
    writeu,unit,buff_num
    writeu,unit,tag_ptrs
    writeu,unit,freq
    writeu,unit,totbytes
    writeu,unit,time_hrs
    writeu,unit,time_hms

    free_lun,unit
;stop
endelse     ;End of creating the .dir file

;- Display a directory summary if the summ is set
if keyword_set(SUMM) then begin

    ;print,'num_buffers,num_tags: ',num_buffers,num_tags
    ;print,'min/max tag: ',min(tag),max(tag)

    ;- Assume that there are the same number of each slow data tag. 1-100 would take too much
    ;- space. Maybe a check is needed here to make sure that is true.
    for i=1,1 do begin
       ind_slow = where(tag eq i,cnt_slow)
    endfor

    ;- 2DC Records
    ind_2dc = where(tag eq 300,cnt_300)
    ind_2dc = where(tag eq 301,cnt_301)
    ind_2dc = where(tag eq 302,cnt_302)
    ind_2dc = where(tag eq 303,cnt_303)
    ind_2dc = where(tag eq 304,cnt_304)
    ;print,'min/max times   : ',min(times(ind)),max(times(ind))
    ;print,'min/max offset  : ',min(offset(ind)),max(offset(ind))
    ;print,'min/max freq    : ',min(freq(ind)),max(freq(ind))
    ;print,'min/max totbytes: ',min(totbytes(ind)),max(totbytes(ind))

    ;- Hail Records
    ind_hail = where(tag eq 320,cnt_hail)
    ;print,'  min/max totbytes: ',min(totbytes(ind)),max(totbytes(ind))

    ;- HVPS Records
    ind_6000 = where(tag eq 6000,cnt_6000)
    ind_hvps = where(tag eq 6001,cnt_6001)
    ind_hvps = where(tag eq 6002,cnt_6002)
    ind_hvps = where(tag eq 6003,cnt_6003)
    ind_hvps = where(tag eq 6004,cnt_6004)
    ;print,'min/max times   : ',min(time_hms(ind_hvps)),max(time_hms(ind_hvps))
    ;print,'min/max tag_ptrs: ',tag_ptrs(ind_hvps(0)),tag_ptrs(ind_hvps(1))
    ;print,'min/max offset  : ',min(offset(ind_hvps)),max(offset(ind_hvps))
    ;print,'min/max hun     : ',min(hun(ind_hvps)),max(hun(ind_hvps))

    ;- Txt Records
    ind = where(tag eq -5 or tag eq -6,cnt_txt)

    ;- Print text records to a file
    if cnt_txt ne 0 then begin

       openw,unit_txt,fn_txt,/get_lun
       openr,unit_src,fn_src,/get_lun
       for i=0,cnt_txt-1 do begin
         point_lun,unit_src,tag_ptrs(ind(i))
         txt = bytarr(totbytes(ind(i)))
         str = ''
         readu,unit_src,txt
         for j=0,totbytes(ind(i))-1 do str = str + string(txt(j))
         printf,unit_txt,str
       endfor
       free_lun,unit_txt
       free_lun,unit_src
    endif

    ;- Err Records
    ind = where(tag eq -3,cnt_err)

    ;- Print err records to a file if there are any
    if cnt_err ne 0 then begin

       openw,unit_err,fn_err,/get_lun
       openr,unit_src,fn_src,/get_lun
       for i=0,cnt_err-1 do begin
         point_lun,unit_src,tag_ptrs(ind(i))
         txt = bytarr(totbytes(ind(i)))
         str = ''
         readu,unit_src,txt
         for j=0,totbytes(ind(i))-1 do str = str + string(txt(j))
         printf,unit_err,str
       endfor
       free_lun,unit_err
       free_lun,unit_src
    endif

    ;- Display directory summary in a widget - changed 8/31/2001
    base = widget_base(/column,/base_align_right,title='Summary of Sea Records')
    field1  = cw_field(base,title='Slow Data Records : ',value='0',/string)
    ;field2  = cw_field(base,title='2DC Records (300): ',value='0',/string)
    field3  = cw_field(base,title='2DC Records: ',value='0',/string)
    ;field4  = cw_field(base,title='2DC Records (302): ',value='0',/string)
    ;field5  = cw_field(base,title='2DC Records (303): ',value='0',/string)
    ;field6  = cw_field(base,title='2DC Records (304): ',value='0',/string)
    field7  = cw_field(base,title='Hail Records: ',value='0',/string)
    ;field8  = cw_field(base,title='HVPS Records (6000): ',value='0',/string)
    field9  = cw_field(base,title='HVPS Records: ',value='0',/string)
    ;field10 = cw_field(base,title='HVPS Records (6002): ',value='0',/string)
    ;field11 = cw_field(base,title='HVPS Records (6003): ',value='0',/string)
    ;field12 = cw_field(base,title='HVPS Records (6004): ',value='0',/string)
    field13 = cw_field(base,title='Text Records: ',value='0',/string)
    field14 = cw_field(base,title='Error Records: ',value='0',/string)

    widget_control,base,/realize
    widget_control,field1,set_value=strtrim(cnt_slow,2)
    ;widget_control,field2,set_value=strtrim(cnt_300,2)
    widget_control,field3,set_value=strtrim(cnt_301,2)
    ;widget_control,field4,set_value=strtrim(cnt_302,2)
    ;widget_control,field5,set_value=strtrim(cnt_303,2)
    ;widget_control,field6,set_value=strtrim(cnt_304,2)
    widget_control,field7,set_value=strtrim(cnt_hail,2)
    ;widget_control,field8,set_value=strtrim(cnt_6000,2)
    widget_control,field9,set_value=strtrim(cnt_6001,2)
    ;widget_control,field10,set_value=strtrim(cnt_6002,2)
    ;widget_control,field11,set_value=strtrim(cnt_6003,2)
    ;widget_control,field12,set_value=strtrim(cnt_6004,2)
    widget_control,field13,set_value=strtrim(cnt_txt,2)
    widget_control,field14,set_value=strtrim(cnt_err,2)

    ans1 = menu_wid(['Close Summary Window?','yes','no'])
    if ans1 eq 0 then begin
       widget_control,base,/destroy
    endif

    ;- Plot the occurrences of buffer times for each of 4 different data types (i.e.,slow,2dc,hail,hvps)
    ans = menu_wid(['Plot Buffer Times?','Yes','No'])
    if ans eq 0 then begin
       window,xs=500,ys=400,4,title='Buffer Times'
       device,decompose=0
       ;stop
       get_tic_labels2,time_hrs(ind_slow(0)),time_hrs(ind_slow(cnt_slow-1l)), $
                        num_tics,tic_values,tic_names
       xt1 = tic_values(0)
       xt2 = tic_values(num_tics)
       yval = fltarr(cnt_slow)
       yval(*) = 1.
       ;stop
       plot,time_hrs(ind_slow),yval, $
          background = 255, $
          psym = 7, $
             symsize = 0.2, $
          color = 0, $
          xtitle = 'Buffer Time (hhmmss)', $
          ytitle = 'Key', $
          title = fn_src, $
          charsize = 1.2, $
          xrange = [xt1,xt2], $
          xticks = num_tics, $
          xtickname = tic_names, $
          xtickv = tic_values, $
          xminor = 4, $
          yrange = [0,5]
       xyouts,time_hrs(ind_slow(0)),1.1,'Slow',charsize=0.9,color = 0

       if cnt_300 ne 0 then begin
         yval = fltarr(cnt_300)
         yval(*) = 2.
         oplot,time_hrs(ind_2dc),yval, $
             psym = 7, $
             symsize = 0.2, $
             color = 0
         xyouts,time_hrs(ind_2dc(0)),2.1,'2DC',charsize=0.9,color = 0
       endif

       if cnt_hail ne 0 then begin
         yval = fltarr(cnt_hail)
         yval(*) = 3.
         oplot,time_hrs(ind_hail),yval, $
             psym = 7, $
             symsize = 0.2, $
             color = 0
         xyouts,time_hrs(ind_hail(0)),3.1,'Hail',charsize=0.9,color = 0
       endif

       if cnt_6000 ne 0 then begin
         yval = fltarr(cnt_6000)
         yval(*) = 4.
         oplot,time_hrs(ind_6000),yval, $
             psym = 7, $
             symsize = 0.2, $
             color = 0
         xyouts,time_hrs(ind_6000(0)),4.1,'HVPS',charsize=0.9,color = 0
       endif

       ans = menu_wid(['Select:','Continue ...'])
       wdelete,4
    endif
endif     ;End of summary

;- Extract return quantities (time_struct)
ind = where(tag eq tag_sel,cnt)

if cnt ne 0 then begin
    time_struct = {time_hrs:fltarr(cnt), $
                   time_hms:dblarr(cnt), $
                   buf_ptrs:lonarr(cnt) }
    time_struct.buf_ptrs(*) = tag_ptrs(ind)
    ;stop
    time_struct.time_hrs(*) = time_hrs(ind)
    time_struct.time_hms(*) = time_hms(ind)
endif else begin          ;if no occurrences of the selected tag are found
    if num eq 0 then begin     ;if num=0 then stop (a critical tag number, e.g., image buffers)
       print,'No occurrences of ',tag_sel,' found'
       ;stop
    endif else begin      ;if num>0 then return a zero-filled array structure (a noncritical
                    ;tag number, e.g., elapsed time)
       time_struct = {time_hrs:fltarr(num), $
                       time_hms:dblarr(num), $
                       buf_ptrs:lonarr(num) }
    endelse
endelse

;- Free memory (maybe doesn't help?)
tag      = 0
offset   = 0
freq     = 0
tag_ptrs = 0
totbytes = 0
buff_num = 0
time_hms = 0
time_hrs = 0

return, time_struct

end
