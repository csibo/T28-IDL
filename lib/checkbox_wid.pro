
;- checkbox_wid.pro

function checkbox_wid, desc, GROUP = basea

if keyword_set(GROUP) then base = widget_base(group_leader = basea, /modal, /column) $
                      else base = widget_base(/column)

num = n_elements(desc)
check_ind = intarr(num-1)

bgroup1 = cw_bgroup(base, desc(1:num-1),label_top = desc(0), /nonexclusive, column = 5)

bgroup3 = cw_bgroup(base, 'OK', /column, /frame)

widget_control, /realize, base, tlb_set_xoffset = 100, tlb_set_yoffset = 200

;basea = widget_base(group_leader = base_leader, /modal, /column)
;values1 = [ 'Yes' , 'No' ]
;bgroup1 = cw_bgroup(basea,values1,label_top = 'Color?', /column, /frame, /exclusive, set_value = color_sw)
;values2 = [ 'Landscape' , 'Portrait - 1/2' , 'Portrait - 2/3' , 'Portrait - Full' ]
;bgroup2 = cw_bgroup(basea, values2, label_top = 'Orientation?', /column, /frame, /exclusive,set_value = height_sw)
;field1  = cw_field(basea, value = psfile, title = 'Postscript filename?', /column)
;widget_control, basea, /realize, tlb_set_xoffset = 300, tlb_set_yoffset = 300

;ev = widget_event(base)
sw = 1
;while ev.id ne bgroup3 do begin
while sw ne 0 do begin
 ev = widget_event(base)
 if ev.id eq bgroup1 then begin
  print,ev,ev.value
  check_ind(ev.value) = 1
 endif
 if ev.id eq bgroup3 then sw = 0
 ;if ev.id eq bgroup2 then height_sw = ev.value
endwhile
;widget_control, field1, get_value = psfile
;psfile = psfile_dir + psfile(0)
;widget_control, /destroy, basea

;sw = 1
;while sw ne 0 do begin

;ev = widget_event(base)

;print,'ev.value: ',ev.value
;print,'ev: ',ev
;sw = ev.value
;endwhile

print,'check_ind: '
print,check_ind

widget_control, /destroy, base
;widget_control, /destroy, ev.top

;return, ev.value
return, check_ind

end
