
;- input_wid.pro

;- An editable widget for text input

function input_wid,INITIAL_VALUE = initial_value,INPUT_TITLE = input_title

if not keyword_set(INITIAL_VALUE) then initial_value = ''
if not keyword_set(INPUT_TITLE) then input_title = 'Enter Input'
len = strlen(initial_value)
base = widget_base(xoffset=200,yoffset=200)
field = cw_field(base, title=input_title, value=initial_value, /string, /return_events, /column, xsize = len)
widget_control,base,/realize
ev = widget_event(base)
widget_control, field, get_value=str
widget_control, /destroy, base
print,'str: ',str

return, str

end