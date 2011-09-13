;-
;- read_titles_units.pro
;-
pro read_titles_units,fn_titles,fn_units,tag_title,tag_unit

;- Open file of Tags with corresponding names

print,'fname=',fn_titles
openr,unit,fn_titles,/get_lun

data = intarr(1)
str = ' '
tag_id   = intarr(200)
tag_title = strarr(200)

readf,unit,str
print,str
readf,unit,str
print,str
;stop
i = 0
while not eof(unit) do begin
 readf,unit,data,str
 tag_id(i)   = data(0)
 tag_title(i) = str
 ;print,'i,tag,tag_title:',i,data,tag_title(i)
 i = i + 1
 ;stop
endwhile
num_all_tags = i

;tag_title = tag_title(0:num_all_tags-1)

;- Open file of Tags with corresponding units
openr,unit,fn_units,/get_lun

data = intarr(1)
str = ' '
tag_id   = intarr(200)
tag_unit = strarr(200)

readf,unit,str
print,str
readf,unit,str
print,str

i = 0
while not eof(unit) do begin
 readf,unit,data,str
 tag_id(i)   = data(0)
 tag_unit(i) = str
 i = i + 1
; stop
endwhile

end

