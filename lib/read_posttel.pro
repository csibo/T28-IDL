;-
;- read_posttel.pro
;-
pro read_posttel,tag_post,tag_labels,fn

;;;fn = 'c:\t28\t28display2.0\lib\posttel2.tag'

openr,unit,fn,/get_lun

data = intarr(3)
str = ' '
tag_post   = intarr(200)
tag_labels = strarr(200)

readf,unit,str
;;print,str
;stop
i = 0
while not eof(unit) do begin
 readf,unit,data,str
 tag_post(i)   = data(0)
 tag_labels(i) = str
; if i eq 119 then stop
 ;stop
 i = i + 1
 ;;print,i
endwhile
num_all_tags = i

end

