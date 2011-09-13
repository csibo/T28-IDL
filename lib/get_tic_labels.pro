;-
;- get_tic_labels.pro
;-
;- Only works for time in decimal hours
;-
pro get_tic_labels,start_time,end_time, $
                   num_tics,tic_values,tic_names

tic_int = 0.01666667
;print,'tic_int: ',tic_int

fi = 2.0
sw = 1
while sw eq 1 do begin

tem = start_time / tic_int
tem = fix(tem)
xt1 = float(tem) * tic_int
;print,'xt1: ',xt1

if end_time lt start_time then end_time = end_time + 24.
tem1 = end_time / tic_int + 1.000
;print,'tem1: ',tem1
tem2 = fix(tem1)
;print,'tem2: ',tem2
xt2 = float(tem2) * tic_int
;print,'xt2: ',xt2

num_tics = fix((xt2 - xt1) / tic_int + 0.1)

tic_values = fltarr(num_tics+1)
tic_names  = strarr(num_tics+1)
for m=0,num_tics do tic_values(m) = xt1 + float(m) * tic_int

;print,'num_tics: ',num_tics
;print,'tic_values: ',tic_values

if num_tics le 9 then sw = 2 else tic_int = tic_int * fi
fi = fi + 1.

endwhile

tic_values_tem = tic_values
ind = where(tic_values ge 24.,cnt)
if cnt ne 0 then tic_values_tem(ind) = tic_values(ind) - 24. ;6/19/00

hrs2hms_mili,tic_values_tem,tic_names
;print,'tic_names: ',tic_names

end

