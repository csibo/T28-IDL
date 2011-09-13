
;- hrs2hms2.pro

;- Convert time in hrs to a hr/mn/sc string

function hrs2hms2,time

num = n_elements(time)
time_str = strarr(num)

for i=0l,num-1l do begin

	tem_hr = fix(time(i))
	tem_hr_str = strtrim(string(tem_hr),2)
	if strlen(tem_hr_str) eq 1 then tem_hr_str = '0' + tem_hr_str

	tem_min = fix((time(i) - float(tem_hr)) * 60.)
	tem_min_str = strtrim(string(tem_min),2)

	tem_sec = fix((time(i) - float(tem_hr) - float(tem_min) / 60.) * 3600. + 0.5)
	tem_sec_str = strtrim(string(tem_sec),2)
	if tem_sec_str eq '0' then tem_sec_str = '00'
	if tem_sec_str eq '60' then begin
 		tem_min_str = strtrim(string(tem_min+1),2)
 		tem_sec_str = '00'
	endif

 	if strlen(tem_min_str) eq 1 then tem_min_str = '0' + tem_min_str
 	if strlen(tem_sec_str) eq 1 then tem_sec_str = '0' + tem_sec_str
	;time_str(i) = tem_hr_str + ':' + tem_min_str + ':' + tem_sec_str
 	time_str(i) = tem_hr_str + tem_min_str + tem_sec_str
endfor

return, time_str

end

