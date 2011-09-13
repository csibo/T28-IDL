;-
;- hrs2hms_mili.pro
;-
;- Convert time in hrs to a hr/mn/sc string
;-
pro hrs2hms_mili,time,time_str

num = n_elements(time)
time_str = strarr(num)
for i=0l,num-1l do begin
 tem_hr = time(i)
 tem_hr_str = strtrim(string(fix(tem_hr)),2)
 tem_min = (time(i) - fix(tem_hr)) * 60.
 tem_min_str = strtrim(string(fix(tem_min)),2)
 tem_sec = (tem_min-fix(tem_min))* 60.
; tem_sec = ((time(i) - float(tem_hr) - float(tem_min) / 60.) * 3600.)
 tem_sec_str = strtrim(string(fix(tem_sec)),2)
 ;stop
; tem_mil = fix((time(i) - float(tem_hr) - float(tem_min) / 60. - float(tem_sec) / 3600.) * 1000. * 3600.)
; tem_mil_str = strtrim(string(tem_mil),2)
tem_mil=fix((tem_sec-fix(tem_sec))*1000)
tem_mil_str = strtrim(string(tem_mil),2)

if tem_sec_str eq '0' then tem_sec_str = '00'
 if tem_sec_str eq '60' then begin
  tem_sec_str = '00'
  tem_min = tem_min + 1
  tem_min_str = strtrim(string(tem_min),2)
  if tem_min_str eq '60' then begin
   tem_min_str = '00'
   tem_hr = tem_hr + 1
   tem_hr_str = strtrim(string(tem_hr),2)
   if tem_hr_str eq '24' then begin
    tem_hr = 1
    tem_hr_str = '01'
   endif
  endif
 endif
 if strlen(tem_hr_str) eq 1 then tem_hr_str = '0' + tem_hr_str
 if strlen(tem_min_str) eq 1 then tem_min_str = '0' + tem_min_str
 if strlen(tem_sec_str) eq 1 then tem_sec_str = '0' + tem_sec_str
 if strlen(tem_mil_str) eq 1 then tem_mil_str = '00' + tem_mil_str
 if strlen(tem_mil_str) eq 2 then tem_mil_str = '0' + tem_mil_str
; time_str(i) = tem_hr_str + ':' + tem_min_str + ':' + tem_sec_str
 time_str(i) = tem_hr_str + tem_min_str + tem_sec_str + '.' + tem_mil_str
endfor
;stop
end

