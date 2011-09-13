
;- menu_wid_new.pro
;==================================

function menu_wid_new, desc, GROUP = basea

if keyword_set(GROUP) then base = widget_base(group_leader = basea, /modal) $
                      else base = widget_base()

num = n_elements(desc)

if num le 10 then bgroup = cw_bgroup(base, desc(1:num-1),label_top = desc(0),/column) else $
				  bgroup = cw_bgroup(base, desc(1:num-1),label_top = desc(0),/column,y_scroll_size = 300,/scroll)

widget_control, /realize, base, tlb_set_xoffset = 300, tlb_set_yoffset = 300

;sw = 1
;while sw ne 0 do begin

ev = widget_event(base)

;print,'ev.value: ',ev.value
;print,'ev: ',ev
;sw = ev.value
;endwhile



widget_control, /destroy, base
;widget_control, /destroy, ev.top

return, ev.value

end
