; Copyright © 2001, IAS, SD School of Mines and Technology.
; This software is provided as is without any warranty whatsoever.
; It may be freely used, copied or distributed, for non-commercial
; purposes. This copyright notice must be kept with any copy of this
; software.  If this software shall be used commercially or sold
; as part of a larger package, please contact the copyright holder
; to arrange payment. Bugs and comments should be directed to
; t28user@typhoon.ias.sdsmt.edu with subject "t28display IDL routine".
;
; LAST MODIFIED (DVK):  Jan, 2002, to include a scroll bar
;-----------------------------------------------------------------------

;- menu_wid.pro

function menu_wid, desc, GROUP = basea

if keyword_set(GROUP) then base = widget_base(group_leader = basea, /modal) $
                      else base = widget_base()

num = n_elements(desc)

bgroup = cw_bgroup(base, desc(1:num-1),label_top = desc(0),/column,/scroll,$
		  xsize = 100, x_scroll_size = 100, ysize = 100,$
                  y_scroll_size = 100)

widget_control, /realize, base, tlb_set_xoffset = 200, tlb_set_yoffset = 150

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
