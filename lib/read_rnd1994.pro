; Copyright © 2001, IAS, SD School of Mines and Technology.
; This software is provided as is without any warranty whatsoever.
; It may be freely used, copied or distributed, for non-commercial
; purposes. This copyright notice must be kept with any copy of this
; software.  If this software shall be used commercially or sold
; as part of a larger package, please contact the copyright holder
; to arrange payment. Bugs and comments should be directed to
; t28user@typhoon.ias.sdsmt.edu with subject "t28display IDL routine".
;
;------------------------------------------------------------------------------------------

;-
;- read_rnd1994.pro
;-
;- Modified program read_rnd.pro to accomodate for the 1994 HVPS data
;- LAST MODIFIED: Jan, 2002
;----------------------------------------------------------------------

pro read_rnd1994,fn,num_tags,tags,tag_ind,data,num, hrs, hms, err

;-
;- Open rnd file
;-

;stop
openr,unit_rnd,fn,/get_lun, error = err
;stop
;-
;- Get size of file
;-
status = fstat(unit_rnd)
file_size = long(status.size / 4l)

print,'file_size: ',file_size

;-
;- Read the number of tags for each time point
;-
rec_size = long(1)
readu,unit_rnd,rec_size
;byteorder,rec_size,/lswap
print,'rec_size: ',rec_size
num_tags = long(rec_size - 1l)
print,'num_tags: ',num_tags

;-
;- Compute number of time points
;-
num = file_size / rec_size - 1l
print,'num: ',num

;-
;- Read the tags
;-
tags = lonarr(num_tags)
readu,unit_rnd,tags
;byteorder,tags,/lswap
;print,'tag numbers:'
;print,tags

;-
;- Read the data
;-
data = fltarr(rec_size,num)
hrs = fltarr(num)
hms = fltarr(num)
readu,unit_rnd,data
;byteorder,data,/lswap
data = float(data)

data(0,0:num-1) = data(0,0:num-1) + 60000.0
hms(*) = data(0,0:num-1)

for s = 0, num-1 do begin
   time_str = long(data(0,s))
   time_str = strtrim(string(time_str),2)
  ; stop
   len = strlen(time_str)
   if len eq 6 then begin
     hrs(s) = float(strmid(time_str, 0,2)) + float(strmid(time_str,2,2))/60. + $
   			  float(strmid(time_str,4,2)) / 3600.
   endif else begin
     hrs(s) = float(strmid(time_str,0,1)) + float(strmid(time_str,1,2))/60. + $
              float(strmid(time_str,3,2)) / 3600.
   endelse
endfor


free_lun,unit_rnd

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

;-
;- First and last time points
;-
print,'First time point     : ',data(0,0)
print,'Last time point      : ',data(0,num-1)
print,'Difference           : ',(time2 - time1) * 3600.
print,'Number of time points: ',num

;-
;- Get tag indices
;-
;tag_ind = intarr(500)
tag_ind = intarr(700)  ; 6/22/00
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

