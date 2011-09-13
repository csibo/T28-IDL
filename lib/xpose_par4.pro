; Copyright © 2001, IAS, SD School of Mines and Technology.
; This software is provided as is without any warranty whatsoever.
; It may be freely used, copied or distributed, for non-commercial
; purposes. This copyright notice must be kept with any copy of this
; software.  If this software shall be used commercially or sold
; as part of a larger package, please contact the copyright holder
; to arrange payment. Bugs and comments should be directed to
; t28user@typhoon.ias.sdsmt.edu with subject "t28display IDL routine".
;
;------------------------------------------------------------------------------------------

;- xpose_par.pro
;- Transpose the .par file from quantity ordered to blob ordered (e.g., change from the
;- first record as all quantities for the 1st blob to all the blobs for the 1st quantity)
;- Makes accessing a quantity like x_dim for all blobs easier

pro xpose_par4

@part_struct

;- Inputs
p_num    = 14			;quantity to plot (as a test) (14 is y dimension)
inc      = 10000l		;Number of blobs to extract on each pass
skip_sw  = 1			;1-Xpose the file and test plot  2-Test plot only

;- Flights in which 2D data is available
probe = menu_wid_new([ 'Select Probe:' , '2DC Probe'		, $
										'HVPS Probe'	, $
										'HAIL Probe'])
probe = probe + 1


; FOR 2DC PROBE
;=====================================================
if probe eq 1 then begin
  ; select year for the data
  yr = intarr(1)
  yrnos = ['Year 1995 (VORTEX Project)', $
		 'Year 1998 (CHILL) Project',$
		 'Year 1999 (Turbulence) Project',$
         'Year 2000 (STEPS Project)', $
         'Year 2001 (Rapid City)', $
         'Year 2002 (Rapid City and Colorado)', $
         'Year 2003 (Rapid City-Norman)', $
         'Year 2004  Project',$
         'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
  if yr_ind eq 0 then yr_number = 1995
  if yr_ind eq 1 then yr_number = 1998
  if yr_ind eq 2 then yr_number = 1999
  if yr_ind eq 3 then yr_number = 2000
  if yr_ind eq 4 then yr_number = 2001
  if yr_ind eq 5 then yr_number = 2002
  if yr_ind eq 6 then yr_number = 2003
  if yr_ind eq 7 then yr_number = 2004
  print,'yr_ind = ',yr
  ;- Get the constants for a specific probe type
  specs = get_specs_2dc(probe-1)

  select_flight_s1,yr, flt_num, titl, year
  title = '2DC'
endif


; FOR HVPS PROBE
;=====================================================
if probe eq 2 then begin
  ; select year for the data
  yr = intarr(1)
  yrnos = ['Year 1995 (VORTEX Project)', $
		 'Year 1998 (CHILL) Project',$
		 'Year 1999 (Turbulence Project)',$
         'Year 2000 (STEPS Project)', $
         'Year 2001 (Rapid City)', $
         'Year 2002 (Rapid City and Colorado)', $
         'Year 2003 (Rapid City-Norman)', $
         'Year 2004 ', $]
         'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
  if yr_ind eq 0 then begin
     yr_number = 1995
     buf_size = 2048
     skip_bytes = bytarr(12)
     skip_bytes2=bytarr(1)
     select_flight_s1,yr, flt_num, titl, year
     title = 'HVPS'
  endif else begin
   if yr_ind eq 1 then yr_number = 1998
   if yr_ind eq 2 then yr_number = 1999
   if yr_ind eq 3 then yr_number = 2000
   if yr_ind eq 4 then yr_number = 2001
   if yr_ind eq 5 then yr_number = 2002
   if yr_ind eq 6 then yr_number = 2003
   if yr_ind eq 7 then yr_number = 2004
   print,'yr_ind = ',yr
   ;- Get the constants for a specific probe type
   specs = get_specs_hvps(probe-1)

   select_flight_s1,yr, flt_num, titl, year
   title = 'HVPS'
  endelse

endif


; FOR HAIL PROBE
;=====================================================
if probe eq 3 then begin
  ; select year for the data
  yr = intarr(1)
  yrnos = ['Year 1995 (VORTEX Project)', $
		 'Year 1998 (CHILL Project)',$
		 'Year 1999 (Turbulence Project)',$
         'Year 2000 (STEPS Project)', $
         'Year 2001 (Rapid City)', $
         'Year 2002 (Rapid City and Colorado)', $
         'Year 2003 (Rapid City-Norman)', $
         'Year 2004 Project',$
         'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
  if yr_ind eq 0 then yr_number = 1995
  if yr_ind eq 1 then yr_number = 1998
  if yr_ind eq 2 then yr_number = 1999
  if yr_ind eq 3 then yr_number = 2000
  if yr_ind eq 4 then yr_number = 2001
  if yr_ind eq 5 then yr_number = 2002
  if yr_ind eq 6 then yr_number = 2003
  if yr_ind eq 7 then yr_number = 2004
  print,'yr_ind = ',yr
  ;- Get the constants for a specific probe type
  specs = get_specs_hail(probe-1)

  select_flight_hail1,yr, flt_num, titl, year
  title = 'HAIL'
endif


;- Get filenames for the arc data and pick a file
fn_par = dialog_pickfile(path = specs.buf_path, filter = '*.par')
len = strlen(fn_par)
fn_xpr = strmid(fn_par,0,len-3) + 'xpr'

num_quan = n_tags(p_info)

num = long((float(num_quan) - 1.) / 10.)

if skip_sw eq 1 then begin

record_size = num_quan * 4l	;bytes per record

openr,unit,fn_par,/get_lun
openw,unit_out,fn_xpr,/get_lun

status = fstat(unit)
num_blobs = status.size / record_size
print,'num_blobs: ',num_blobs

for i=0l,num do begin		;Loop through num times and get 10 quantities each time

	print,'Extracting set ',i+1,' of ',num+1
	sw = 1
	j = 1l
	nb = inc
	nb_last = 0l									;Number of blobs to get
	if i ne num then $
		data2 = fltarr(num_blobs,10) else $			;Get 10 quantities at a time
		data2 = fltarr(num_blobs,num_quan-(num*10))

	while sw eq 1 do begin

		if (j * inc) gt num_blobs then begin		;the last group of blobs
			nb = num_blobs - (j - 1l) * inc
			sw = 2
		endif
		data = fltarr(num_quan,nb)
		point_lun,unit,record_size * nb_last
		readu,unit,data
		data = transpose(data)		;data is now (nb,record_length)
		s1 = nb_last
		s2 = nb_last + nb - 1l
		i1 = i * 10l
		i2 = ((i + 1l) * 10l - 1l) < (num_quan - 1)
		data2(s1:s2,*) = data(*,i1:i2)
		nb_last = nb_last + nb
		j = j + 1l

	endwhile

	writeu,unit_out,data2

endfor

free_lun,unit
free_lun,unit_out

endif

;- Try reading the file just created and plot something
openr,unit,fn_xpr,/get_lun
status = fstat(unit)
print,'status.size: ',status.size
num_blobs = status.size / record_size
print,'num_blobs: ',num_blobs
point_lun,unit,p_num * num_blobs * 4l
data = fltarr(num_blobs)
readu,unit,data
free_lun,unit
;stop
;win_num = !d.window
!p.multi = 0
plot,data, $
	background = 255, $
	color = 0, $
	;xtitle = 'Sequence Number', $  ; modified 8/31/2001
	xtitle = 'Buffer Number', $
	;ytitle = 'Y Dimension (um)', $
	ytitle = 'Image Height (um)' ;, $
	;title = 'Test Plot'

mes = 'The Raw Data Processing Is Done Now!'
result = dialog_message(mes, /Information)
print,result
;stop
wdelete, 0
end
