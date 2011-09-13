;-
;- buff_times_2dc.pro
;-
pro buff_times_2dc,fn, $
                   buf_ptr,time,times,fltno

;header = intarr(65)       ;size of SEA 2DC dir (8 * 7) plus time (9)
header = bytarr(81)
;stop
;;; 6/20/2000  For the flights starting after 00Z
;;; the 2dc probe puts out a first buffer of 150 BYTES
;;; as happened with flight F756 on 6/19/2000

dir_2dc  = intarr(8 * 7)
time_2dc = intarr(7)

buff_size = 4246l  ;4182l-HVPS  4240 4096 + 56 + 18 + 76
;skip_factor = 0l
;stop
openr,unit,fn,/get_lun

status = fstat(unit)
print,'2DC size is: ', status.size
;stop
;;;valid for files started after midnight
;;;  num_buffers = status.size / buff_size
;;;  print,'num_buffers: ',num_buffers
;readu, unit, first_buf_after_midnight
;print,'first_buf_after_midnight:', first_buf_after_midnight

readu, unit, dir_2dc
;;;print,'dir_2dc: ', dir_2dc
;;;print,'dir_2dc(48): ',dir_2dc(48)
;;;print,'dir_2dc(49): ',dir_2dc(49)

if (dir_2dc(49) eq 150) then skip_factor = 150l else skip_factor = 0l
;;;changed for files after mifnight
num_buffers = (status.size-skip_factor)/ buff_size
;;;print,'num_buffers: ',num_buffers
;;;print,'skip_factor: ', skip_factor
;;;stop
time    = fltarr(num_buffers)
buf_ptr = lonarr(num_buffers)

;stop
for i=0l,num_buffers-1l do begin
; if i mod 200 eq 0 then print,i
;;;valid for files after midnight
;;;if (skip_factor ne 0l) then print,'skip_factor: ', skip_factor
;;;print,'skip_factor: ',skip_factor
 buf_ptr(i) = long(i) * buff_size + skip_factor

 point_lun,unit,buf_ptr(i)
;;; valid for data before midnight
;;;buf_ptr(i) = long(i) * buff_size
 readu,unit,dir_2dc
;print,'dir_2dc: ',dir_2dc
;stop
 readu,unit,time_2dc
;print,'time_2dc: ',time_2dc
;stop
 ;if i eq 6 then stop
 ;byteorder,header
 time(i) = float(time_2dc(3)) + float(time_2dc(4)) / 60. + float(time_2dc(5)) / 3600. + float(time_2dc(6)) / 360000.
;if (i eq 2450) then stop
;print,'time(i): ', time(i)
;stop
endfor


free_lun,unit

;make correction for flight 751, when the computer was slow
; about 1min 47sec.
if (fltno eq 751) then begin
;stop
  time_correction_f751 = 1.0/60.0+47.0/3600.0
  time(*)=time(*)+time_correction_f751
;stop
endif

;;;ind = where(time le 0., cnt)
ind = where(time le 6., cnt)  ;6/20/00
if cnt ne 0. then time(ind) = time(ind) + 24.

hrs2hms_mili,time,times
;stop
end

