;-
;- hvps98_buff622_times.pro
;
; for flight 757 skip_bytes should be 62 because we added
; the elapsed time (2 words = unsigned long int), and
; the elapsed shadow or (1 word = unsigned int)
; directory before                      = 86 bytes
; directory entrance for elapsed time   = 16 bytes
; elapsed time                          =  4 bytes
; directory entrance for elapsed shadow = 16 bytes
; elapsed shadow or                     =  2 bytes
; =================================================
; total                                 = 124 bytes = 62 words
;-
pro hvps98_buff622_times,fn, $
                      buf_ptr,time,times

print,fn

; this is valid for flights before 6/22/00
;header = intarr(41)
;buff_size = 4182l  ;4182l

; write the values for the elapsed_time and elapsed_shadow_or
; in an output file, for all HVPS buffers
;fn_out = 'D:\T28\yr2000\Programs\Idl\IdlTesting\Elaps_times.txt'
;fn_out = 'c:\T28\t28display3.0\output\Elaps_times.txt'
fn_out = 'K:\IAS-Staff\Donna\T28\t28display4.0\output\Elaps_times.txt'
;fn_out = 'd:\backup62500\programs\idl\elaps_times.txt'
openw,unit_out,fn_out,/get_lun
printf,unit_out,'Buffer_time Buffer_Nr HVPSElaps_time(counts)  HVPSElaps_time(Hex) HVPSElaps_time(s)  HVPSElaps_Shadow_Or'

; For data after 6/22/00 including F757 the arrays are:
header = intarr(62)
buff_size = 4220l
openr,unit,fn,/get_lun

status = fstat(unit)
print,'status.size:',status.size
num_buffers = status.size / buff_size
print,'num_buffers: ',num_buffers

time    = fltarr(num_buffers)
buf_ptr = lonarr(num_buffers)

for i=0,num_buffers-1 do begin
; if i mod 200 eq 0 then print,i
 point_lun,unit,long(i) * buff_size
 buf_ptr(i) = long(i) * buff_size
 buffer_displayed = i+1

 readu,unit,header
; byteorder,header
;This way of finding time is valid for the flights before F757 (6/22/00)
;time(i) = float(header(35)) + float(header(36)) / 60. + float(header(37)) / 3600. + float(header(38)) / 360000.
;This way of finding time is valid for the flights starting with F757 (6/22/00)
time(i) = float(header(51)) + float(header(52)) / 60. + float(header(53)) / 3600. + float(header(54)) / 360000.
mult = header(57)
div  = header(58)
;HVPSelapsed_time = ulong(1)
;HVPSelaps_shadow_or = uint(1)
elapsed_timeh = ishft(ulong(header(59)),16)
;elaps_shadow_or = ishft(uint(skip_bytes(61)),16)
;elapsed_time = ishft(ulong(header(59)),16) or long(header(60)); problem in reading this data
elapsed_time = header(59)
elapsed_time_sec = float(elapsed_time) * 25.0 * 1e-6
elaps_shadow_or = header(61)

printf,unit_out,format='(1x,f12.6,2x,i8,3x,i16,8x,Z8,2x,F12.6,8x,i8)',time(i),buffer_displayed,elapsed_time,elapsed_timeh,elapsed_time_sec,elaps_shadow_or

 ;  if (buffer_displayed eq 1592) then begin
     ;print,'Buffer number: ',buffer_displayed
     ;print,'mult,div: ',mult, div
     ;print,'elapsed_time: ',elapsed_time
     ;print,'elaps_shadow_or: ',elaps_shadow_or
;   endif
;stop


endfor
close,unit_out
free_lun,unit
free_lun,unit_out
ind = where(time lt 6.0,cnt)
if cnt ne 0 then time(ind) = time(ind) + 24.

hrs2hms_mili,time,times

end

