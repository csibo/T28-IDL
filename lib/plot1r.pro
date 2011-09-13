;- Plot the parm1 thru parm6 vs.time

pro plot1R,time,parm1, $
          titles,ytitles
;,title_flt,date_str

num = n_elements(time)
;print,'n_elements(time):', num
print,'n_elements(time):', num
print,'param1(0:10): ',parm1(0:10)
print,'time(0:10): ',time(0:10)

get_tic_labels,time(0),time(num-1l), $
               num_tics,tic_values,tic_names

xt1 = tic_values(0)
xt2 = tic_values(num_tics)
display_time1 = xt2-xt1
hr_display_time = fix(xt2-xt1)
min_display_time = (display_time1 - hr_display_time)*60.0
display_time = hr_display_time*3600.0 + min_display_time*60.0
zero_line = findgen(display_time)
temp_time = findgen(display_time)
zero_line(*) = 0

;stop
;;if num gt 10000l then num1 = num / 10l else num1 = num       ;subsample to reduce ps file size
;if num gt 10000l then num1 = num  else num1 = num
;;print,'num,num1: ',num,num1
;;indp = lindgen(num1) * 10l
;indp = lindgen(num1)
;if num lt 2000 then begin
  num1 = num     ;changed 01/11/2001
  ;print,'num,num1: ',num,num1
  indp = lindgen(num1) * 1l ;changed 01/11/2001
;endif else begin
 ; if num gt 10000l then num1 = num / 10l else num1 = num     ;subsample to reduce ps file size
;  indp = lindgen(num1) * 10l
;endelse

;print,'indp: ',indp
;print,'time: ', time

ind = where(time lt 6.0,cnt)
;print,'count of values less than 6.0: ',cnt
;stop
if cnt ne 0 then time(ind) = time(ind) + 24.
;print,'time: ', time

sw = 0
while sw ne 4 do begin

 !p.multi = [0,1,1]
; for i=1,4 do begin
;  case i of
;   1:parm = parm1
   ;2:parm = parm2
   ;3:parm = parm3
   ;4:parm = parm4
;  endcase

parm =parm1
  plot,time(indp),parm(indp), $
       charsize = 1.2, $
       xrange = [xt1,xt2], $
       xticks = num_tics, $
       xtickname = tic_names, $
       xtickv = tic_values, $
       xminor = 4, $
       /ynozero, $
       ;ytitle = ytitles(i-1), $
       ytitle = ytitles(0), $
       xtitle = 'Time (hhmmss)', $
       ;title = titles(i-1), $
       title = titles(0), $
       background = 255, $
       color = 0
;zero line plot
oplot, temp_time, zero_line, color=0
;stop
;print,'xt1, xt2:',xt1,xt2
;print,'time(indp):', time(indp)
;print,'parm(indp):', parm(indp)
  ;- Title on top plot
 ;;; if i eq 1 then xyouts,!x.crange(0),!y.crange(1) + 0.05 * (!y.crange(1) - !y.crange(0)), $
  ;;;                      title_flt + ' ' + date_str,charsize = 0.7

; endfor

 laser_wid_select,sw

 !p.multi = 0

endwhile

end
