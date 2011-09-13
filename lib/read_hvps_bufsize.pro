;-
;- read_hvps_bufsize.pro
;
;- created 7/10/00 - Donna
;-
;- Read the HVPS directory to get the tags' offset
;-
pro read_hvps_bufsize,fn_hvps,buff_size

tag_time_offset=0
tag_img_offset=0
tag_tas_offset=0
tag_elapsTime_offset=0
tag_shdOr_offset=0

; read the first buffer to get the offsets
openr,unit,fn_hvps,/get_lun
status = fstat(unit)

temp_dir = intarr(8)
  readu,unit,temp_dir
print,'temp_dir: ',temp_dir
;check how many lines in the directory
num_lines_dir = fix(temp_dir(1)/16.)
print,'num_lines_dir: ',num_lines_dir
tag_time_offset = temp_dir(1)
print,'tag_time_offset: ',tag_time_offset

for i=1,num_lines_dir-1 do begin
  readu,unit,temp_dir
  if temp_dir(0) eq 6000 then tag_img_offset = temp_dir(1)
  print,'temp_dir: ',temp_dir
  if temp_dir(0) eq 6001 then tag_tas_offset = temp_dir(1)
  if temp_dir(0) eq 6002 then tag_elapsTime_offset = temp_dir(1)
  if temp_dir(0) eq 6003 then tag_shdOr_offset = temp_dir(1)
  if temp_dir(0) eq 999 then buff_size = temp_dir(1)
endfor
print,'tag_img_offset,tag_tas_offset,tag_elapsTime_offset,tag_shdOr_offset,buff_size:',tag_img_offset,tag_tas_offset,tag_elapsTime_offset,tag_shdOr_offset,buff_size
close,unit
free_lun,unit

end



