;-
;- read_rnd.pro
;-
pro read_rnd,fn,num_tags,tags,tag_ind,data,num,fltno

;-
;- Open rnd file
;-
openr,unit,fn,/get_lun

;-
;- Get size of file
;-
status = fstat(unit)
file_size = long(status.size / 4l)
print,'file_size: ',file_size

;-
;- Read the number of tags for each time point
;-
rec_size = long(1)
;stop
;rec_size = lonarr(1)
readu,unit,rec_size
;stop
;byteorder,rec_size,/lswap
print,'rec_size: ',rec_size
num_tags = long(rec_size - 1l)
print,'num_tags: ',num_tags
;stop
;-
;- Compute number of time points
;-
num = file_size / rec_size - 1l
print,'num: ',num

;-
;- Read the tags
;-
tags = lonarr(num_tags)
readu,unit,tags
;byteorder,tags,/lswap
t=where(tags eq 171,cnt)
;stop
print,'tag numbers:'
print,tags

;-
;- Read the data
;-
data = fltarr(rec_size,num)
readu,unit,data
;byteorder,data,/lswap
data = float(data)

free_lun,unit

;Flt751 has a delay of 107 seconds (the computer was slow)
if fltno eq 751 then begin
  print,'Initial First time point     : ',data(0,0)
  print,'Initial Last time point      : ',data(0,num-1)
  print,'data(0,0:8) = ',data(0,0:8)
  ; num = number of points we have
  ; go through each data point and add the 107 seconds
  for i=0, num-1 do begin
       hr = fix(data(0,i)/10000.0)
       minute = fix((data(0,i)-hr*10000.0)/100.0)
       second = fix(data(0,i)-hr*10000.0 - minute*100.0)
       ;time in seconds
       time_sec = hr*3600.0 + minute*60.0 + second*1.0
       ; add the 107 seconds to the time
       new_time_sec = time_sec + 107.0
       hrs = new_time_sec/3600.0
       new_hr = fix(new_time_sec/3600.0)
       mins = (hrs - new_hr*1.0)*60.0
       new_minute = fix(mins)
       secs = round((mins-new_minute*1.0)*60.0)
       new_time = new_hr*10000.0 + new_minute*100.0 + secs*1.0
       data(0,i) = new_time
  endfor

  print,'modified First time point     : ',data(0,0)
  print,'modified Last time point      : ',data(0,num-1)
  print,'data(0,0:8) = ',data(0,0:8)
  ;-
;- Convert 1st and last time points to decimal hrs
;-
  time1_str = long(data(0,0))
  time2_str = long(data(0,num-1))
  time1_str = strtrim(string(time1_str),2)
  time2_str = strtrim(string(time2_str),2)

  print,'time1_str: ',time1_str
  print,'time2_str: ',time2_str
  len1 = strlen(time1_str)
  len2 = strlen(time2_str)
  print,'len1: ',len1
  print,'len2: ',len2

  if len1 eq 6 then begin
    time1 = float(strmid(time1_str,0,2)) + float(strmid(time1_str,2,2)) / 60. + float(strmid(time1_str,4,2)) / 3600.
  endif else begin
    time1 = float(strmid(time1_str,0,1)) + float(strmid(time1_str,1,2)) / 60. + float(strmid(time1_str,3,2)) / 3600.
  endelse

  if len2 eq 6 then begin
    time2 = float(strmid(time2_str,0,2)) + float(strmid(time2_str,2,2)) / 60. + float(strmid(time2_str,4,2)) / 3600.
  endif else begin
    time2 = float(strmid(time2_str,0,1)) + float(strmid(time2_str,1,2)) / 60. + float(strmid(time2_str,3,2)) / 3600.
  endelse
;  stop
endif else begin

;-
;- Convert 1st and last time points to decimal hrs
;-
  time1_str = long(data(0,0))
  time2_str = long(data(0,num-1))
  time1_str = strtrim(string(time1_str),2)
  time2_str = strtrim(string(time2_str),2)

  print,'time1_str: ',time1_str
  print,'time2_str: ',time2_str
  len1 = strlen(time1_str)
  len2 = strlen(time2_str)
  print,'len1: ',len1
  print,'len2: ',len2

  if len1 eq 6 then begin
    time1 = float(strmid(time1_str,0,2)) + float(strmid(time1_str,2,2)) / 60. + float(strmid(time1_str,4,2)) / 3600.
  endif else begin
    time1 = float(strmid(time1_str,0,1)) + float(strmid(time1_str,1,2)) / 60. + float(strmid(time1_str,3,2)) / 3600.
  endelse

  if len2 eq 6 then begin
    time2 = float(strmid(time2_str,0,2)) + float(strmid(time2_str,2,2)) / 60. + float(strmid(time2_str,4,2)) / 3600.
  endif else begin
    time2 = float(strmid(time2_str,0,1)) + float(strmid(time2_str,1,2)) / 60. + float(strmid(time2_str,3,2)) / 3600.
  endelse
;stop
;-
;- First and last time points
;-
print,'First time point     : ',data(0,0)
print,'Last time point      : ',data(0,num-1)
print,'Difference           : ',(time2 - time1) * 3600.
print,'Number of time points: ',num
;stop
endelse
;-
;- Get tag indices
;-
;tag_ind = intarr(500)
;tag_ind = intarr(700)  ; 6/22/00
tag_ind = intarr(950)  ; 7/09/02
tag_ind(*) = -1
for i=0,num_tags-1 do begin
 tem = tags(i)
 ;print,'tem for tag_ind is: ', tem   ; 6/22/00
 tag_ind(tem) = i
endfor

;for i=0,399 do begin
; print,i,tag_ind(i)
;endfor

end

