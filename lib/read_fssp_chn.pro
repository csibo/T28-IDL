;-
;- read_fssp_chn.pro
;-
pro read_fssp_chn,fn,vol,bin_width,bins,bine

;- Filename for HVPS data
dir2 = ''
idl_file=FILE_WHICH('t28idl.txt')
openr, 1,idl_file
readf,1,dir2
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
close,1
;stop
;valid for flights 2000-2003
if (fltno gt 737) then begin
 openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
 readf,1,fn_out
 readf,1,title_flt
 readf,1,fltno
 readf,1,fn_hvps
 readf,1,fn_reduced
 readf,1,fn_2dc
 readf,1,fssp_chn
 close,1
endif

;valid for 1999 flights
if (fltno le 737) then begin
 openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
 readf,1,fn_out
 readf,1,title_flt
 readf,1,fltno
 readf,1,fn_reduced
 readf,1,fn_2dc
 readf,1,fssp_chn
 close,1
endif


fltnos = fltno
;fn = fssp_chn

print,'FSSP file = ',fssp_chn
num_chan = 15
;stop
data = fltarr(9,num_chan)
str = ''

openr,unit,fssp_chn,/get_lun

for i=0,3 do readf,unit,str

readf,unit,data

vol       = data(7,*)
bin_width = data(4,*)
bins      = data(1,*)
bine      = data(2,*)

free_lun,unit

end

