;-
;- read_hail_chn.pro
;
;- This routine will read the hail.chn file which is located
; under c:\t28\data\yr___\tables\
;
; Created: 10/24/2002
;
; Last update: 10/24/2002
;------------------------------------------------------

pro read_hail_chn,fn,vol,bin_width,bins,bine

;- Filename for HVPS data
dir2 = ''
idl_file=FILE_WHICH('t28idl.txt')
openr, 1,idl_file
readf,1,dir2
close,1

dir1 = ''
data_file=FILE_WHICH('t28data.txt')
openr, 1,data_file
readf,1,dir1
close,1

fn_out = ''
title_flt = ''
fltno = intarr(1)
fn_hvps = ''
fn_reduced =''
fn_2dc = ''
fssp_chn = ''

openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
readf,1,fn_out
readf,1,title_flt
readf,1,fltno
readf,1,fn_hvps
readf,1,fn_reduced
readf,1,fn_2dc
readf,1,fssp_chn
close,1

fltnos = fltno
nl = strlen(fn_reduced)
start_point = nl-20
year_str = strtrim(strmid(fn_reduced, start_point, 4),2)

fn_hail = dir1 + 'yr' + year_str + path_sep()+'tables'+path_sep()+'hail.chn'

print,'HAIL file = ',fn_hail
;stop

num_chan = 14

data = fltarr(9,num_chan)
str = ''

openr,unit,fn_hail,/get_lun

for i=0,3 do readf,unit,str

readf,unit,data

vol       = data(7,*)
bin_width = data(4,*)
bins      = data(1,*)
bine      = data(2,*)

free_lun,unit

end

