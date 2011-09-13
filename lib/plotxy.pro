;- Plot the parm1 thru parm6 vs.time

pro plotxy,tag_value1,tag_label_x,x_label,$
           tag_value2,tag_label_y,y_label
;time,parm1,parm2, $
          ;titles,ytitles;,title_flt,date_str

num = n_elements(tag_value1)
print,'n_elements(tag_value1):', num

;get_tic_labels,time(0),time(num-1l), $
 ;              num_tics,tic_values,tic_names

;xt1 = tic_values(0)
;xt2 = tic_values(num_tics)

if num lt 2000 then begin
  num1 = num     ;changed 01/11/2001
  print,'num,num1: ',num,num1
  indp = lindgen(num1) * 1l ;changed 01/11/2001
endif else begin
  if num gt 10000l then num1 = num / 10l else num1 = num       ;subsample to reduce ps file size
;;
  indp = lindgen(num1) * 10l
endelse

sw = 0
while sw ne 4 do begin

 !p.multi = [0,1,1]

  plot,tag_value1(indp),tag_value2(indp), $
       charsize = 1.2, $
       /ynozero, $
       ;xtitle = x_label, $
       ;ytitle = y_label, $
       xtitle = tag_label_x, $
       ytitle = tag_label_y, $
       background = 255,psym=6,symsize=1.0, $
       color = 0


 ;laser_wid,sw
 ;select_output,sw
 laser_wid_select,sw

 !p.multi = 0

endwhile

end
