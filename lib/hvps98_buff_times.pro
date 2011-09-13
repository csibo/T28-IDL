;-
;- hvps98_buff_times.pro
;-
pro hvps98_buff_times,fn, $
                      buf_ptr,time,times,fltno


; this is valid for flights before 6/22/00
;header = intarr(41)
header = intarr(43) ;changed 9/11/2002
buff_size = 4182l  ;4182l

;;; For data after 6/22/00 including F757 the arrays are:
;;;header = intarr(62)
;;;buff_size = 4220l
openr,unit,fn,/get_lun

status = fstat(unit)
num_buffers = status.size / buff_size
print,'num_buffers: ',num_buffers

time    = fltarr(num_buffers)
buf_ptr = lonarr(num_buffers)

for i=0,num_buffers-1 do begin
; if i mod 200 eq 0 then print,i
 point_lun,unit,long(i) * buff_size
 buf_ptr(i) = long(i) * buff_size
 ;buffer_displayed = i+1

 readu,unit,header
; byteorder,header
;This way of finding time is valid for the flights before F757 (6/22/00)
time(i) = float(header(35)) + float(header(36)) / 60. + float(header(37)) / 3600. + float(header(38)) / 360000.
;;;This way of finding time is valid for the flights starting with F757 (6/22/00)
;;;time(i) = float(header(51)) + float(header(52)) / 60. + float(header(53)) / 3600. + float(header(54)) / 360000.
;;;mult = header(57)
;;;div  = header(58)
;HVPSelapsed_time = ulong(1)
;HVPSelaps_shadow_or = uint(1)
;elapsed_time = ishft(ulong(skip_bytes(59)),16)
;elaps_shadow_or = ishft(uint(skip_bytes(61)),16)
;elapsed_time = ishft(ulong(header(59)),16) or long(header(60)); problem in reading this data
;;;elapsed_time = header(59)
;;;elaps_shadow_or = header(61)

;;;   if (buffer_displayed eq 1592) then begin
;;;     print,'Buffer number: ',buffer_displayed
;;;     print,'mult,div: ',mult, div
;;;     print,'elapsed_time: ',elapsed_time
;;;     print,'elaps_shadow_or: ',elaps_shadow_or
;;;   endif
;;;stop


endfor

free_lun,unit
print,'time(0:10)=',time(0:10)

;need to make correction for the flight 751; the computer
; was slow, 1 minute and 47 seconds
if (fltno eq 751) then begin
   time_correction_f751 = 1.0/60.0+47.0/3600.0
   time(*) = time(*) + time_correction_f751
   print,'NOTE: for Flight 751 we have a time correctuion of 1 minute 47 seconds!!! (computer was slow)'
endif
print,'time(0:10)=',time(0:10)

;stop

ind = where(time lt 6.0,cnt)
if cnt ne 0 then time(ind) = time(ind) + 24.
;stop
hrs2hms_mili,time,times
;stop
end

