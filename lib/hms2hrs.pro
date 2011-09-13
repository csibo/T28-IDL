;-
;- hms2hrs.pro
;-
pro hms2hrs,hms,hrs

;print,'Calling IDLLib routine ...'

num_times = n_elements(hms)

hrs = fltarr(num_times)

for i=0,num_times-1 do begin
 len1 = strlen(hms(i))
 if len1 ge 6 or len1 le 7 then begin
  hrs(i) = float(strmid(hms(i),0,2)) + float(strmid(hms(i),2,2)) / 60. + float(strmid(hms(i),4,2)) / 3600.
 endif else begin
  hrs(i) = float(strmid(hms(i),0,1)) + float(strmid(hms(i),1,2)) / 60. + float(strmid(hms(i),3,2)) / 3600.
 endelse
endfor

end


