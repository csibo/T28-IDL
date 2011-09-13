;- read_buf.pro
;- Read .buf file

function read_buf,fn_buf

@buff_struct

openr,unit_buf,fn_buf,/get_lun

status = fstat(unit_buf)
print,'status: ',status
num_buffs = status.size / (num_buf_tags * 4.)
print,'num_buffs: ',num_buffs

b_info_arr = replicate(b_info,num_buffs)
readu,unit_buf,b_info_arr
free_lun,unit_buf

return,b_info_arr

end

