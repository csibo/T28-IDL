; Copyright © 2001, IAS, SD School of Mines and Technology.
; This software is provided as is without any warranty whatsoever.
; It may be freely used, copied or distributed, for non-commercial
; purposes. This copyright notice must be kept with any copy of this
; software.  If this software shall be used commercially or sold
; as part of a larger package, please contact the copyright holder
; to arrange payment. Bugs and comments should be directed to
; t28user@typhoon.ias.sdsmt.edu with subject "t28display IDL routine".
;
;--------------------------------------------------------------------
; Last modified: 11/08/2002 to include the new routine to plot
;                habits - plot_habits2.pro -
;
;====================================================================
pro plot_arc4

@buff_struct
@part_struct
@set_colors


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
         'Year 2000 (STEPS Project)', $
         'Year 2001 (Rapid City)', $
         'Year 2002 (Rapid City and Colorado)', $
         'Year 2003 (Rapid City-Norman)', $
         'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
  if yr_ind eq 0 then yr_number = 1995
  if yr_ind eq 1 then yr_number = 1998
  if yr_ind eq 2 then yr_number = 2000
  if yr_ind eq 3 then yr_number = 2001
  if yr_ind eq 4 then yr_number = 2002
  if yr_ind eq 5 then yr_number = 2003
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
         'Year 2000 (STEPS Project)', $
         'Year 2001 (Rapid City)', $
         'Year 2002 (Rapid City and Colorado)', $
         'Year 2003 (Rapid City-Norman)', $
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
   if yr_ind eq 2 then yr_number = 2000
   if yr_ind eq 3 then yr_number = 2001
   if yr_ind eq 4 then yr_number = 2002
   if yr_ind eq 5 then yr_number = 2003
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
		 'Year 1998 (CHILL) Project',$
         'Year 2000 (STEPS Project)', $
         'Year 2001 (Rapid City)', $
         'Year 2002 (Rapid City and Colorado)', $
         'Year 2003 (Rapid City-Norman)', $
         'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
  if yr_ind eq 0 then yr_number = 1995
  if yr_ind eq 1 then yr_number = 1998
  if yr_ind eq 2 then yr_number = 2000
  if yr_ind eq 3 then yr_number = 2001
  if yr_ind eq 4 then yr_number = 2002
  if yr_ind eq 5 then yr_number = 2003
  print,'yr_ind = ',yr
  ;- Get the constants for a specific probe type
  specs = get_specs_hail(probe-1)

  select_flight_s1,yr, flt_num, titl, year
  title = 'HAIL'
endif

if yr_ind eq 0 then begin
	plot_arc1995
endif else begin


specs = get_specs(probe-1)

device,decomposed=0

;- Get filenames for the arc data and pick a file
fn_buf = dialog_pickfile(path = specs.buf_path, filter = '*.buf')
len = strlen(fn_buf)
fn_xpr = strmid(fn_buf,0,len-3) + 'xpr'

flt_no_str = strmid(fn_buf,len-11,3)

;- Read buf file
b_info_arr = read_buf(fn_buf)

;- Select the buffer range of interest
se = time_wid_mainNew(strtrim(double(b_info_arr(*).time_hms),2))
print,'se: ',se

start_buff = se(0)
end_buff   = se(1)
num_buffs = end_buff - start_buff + 1

time_hrs      = b_info_arr(start_buff:end_buff).time_hrs
time_hms      = b_info_arr(start_buff:end_buff).time_hms
dur           = b_info_arr(start_buff:end_buff).dur
et            = b_info_arr(start_buff:end_buff).elapsed_time
tac           = b_info_arr(start_buff:end_buff).tac
num_frames    = b_info_arr(start_buff:end_buff).num_frames
charge_time   = b_info_arr(start_buff:end_buff).charge_time
tas           = b_info_arr(start_buff:end_buff).calc_tas_buff
ptrs          = b_info_arr(start_buff:end_buff).p_info_ptr
mult_fac      = b_info_arr(start_buff:end_buff).mult_fac
div_fac       = b_info_arr(start_buff:end_buff).div_fac

;if probe_type eq 2 then charge_time = 0.06 / tas		;60 mm / tas = elapsed time

;- Back calculate tas from mult and div factors
tas_clock = mult_fac * specs.clock_factor / div_fac
md_tas = tas_clock * (specs.x_resolution * 1.e-6)

;- Find the indices for the p_info corresponding to the selected buffers
if start_buff ne 0 then start_p_info = total(b_info_arr(0:start_buff-1).num_blobs) else start_p_info = 0
num_blobs = b_info_arr(start_buff:end_buff).num_blobs
end_p_info = start_p_info + total(num_blobs) - 1
print,'start_p_info,end_p_info: ',start_p_info,end_p_info

;- Read the p_info for the buffers of interest
print,'b_info_arr(start_buff,end_buff).p_info_ptr: ',b_info_arr(start_buff).p_info_ptr,b_info_arr(end_buff).p_info_ptr

;- Replace/filter large or zero tac values
tac_charge = tac_filter(tac,specs.der_thresh,num_frames,charge_time,time_hrs,flt_no_str)
total_dist = total(tas * tac_charge)

;- Extract p_info quantities
inter_part_time = get_p_info(fn_xpr,3)
inter_part_time = inter_part_time(start_p_info:end_p_info)

frame_num = get_p_info(fn_xpr,0)
frame_num = frame_num(start_p_info:end_p_info)

seq_num = get_p_info(fn_xpr,9)
seq_num = seq_num(start_p_info:end_p_info)

;- Calculate mean inter particle time for each buffer (in msec)
mean_time = sv2(inter_part_time,seq_num,num_blobs)

;- Extract the 1st interparticle time for each buffer
ind = where(frame_num eq 0.,cnt)
first_time = inter_part_time(ind) * 1000.		;1000 is conversion to ms

time_str = strtrim(time_hms(0),2) + ' to ' + strtrim(time_hms(num_buffs-1),2)

!p.multi = 0
plot_sw = 0
while plot_sw ne 13 do begin
	plot_sw = menu_wid_new(['Select Plot Type:', $
          	          	'TAC(Sum of Interparticle Times)/Dur(buffer acquiring time)', $
          	          	'TAC/ET(Elapsed Time)', $
          	          	'ET/Dur', $
          	          	'TAS (True Air Speed) Clock/TAS', $
                   	 	'Hist 1st Inter Part Times', $
                    	'Hist Mean Inter Part Times', $
                    	'Habit Count/Concentration', $
                    	'Concentration', $
                    	'Scatter Plot', $
                    	'Time Histogram', $
                    	'Particle Info - Time Series', $
                    	'Particle Info - Histogram', $
                    	'Plot Buffer Info', $
                    	'Exit'])

	case plot_sw of

		0: plot_ratio,tac,dur,dur,specs.time_thresh,flt_no_str,0.05,1.5,'TAC/Dur'
		1: plot_ratio,tac, et,dur,specs.time_thresh,flt_no_str,0.05,5.,'TAC/ET'
		2: plot_ratio, et,dur,dur,specs.time_thresh,flt_no_str,0.05,2.0,'ET/Dur'
		3: plot_ratio,md_tas,tas,dur,specs.time_thresh,flt_no_str,0.05,1.5,'MD/TAS'
		4: plot_first,first_time,mean_time,tac,dur,specs.time_thresh,flt_no_str
		5: plot_mean,mean_time,dur,specs.time_thresh,flt_no_str
		6: plot_habits2,fn_xpr,time_hrs,flt_no_str,num_blobs,start_p_info,end_p_info,$
		                probe,specs,fn_buf,start_buff, end_buff
		7: plot_hist,fn_xpr,total_dist,time_str,probe,start_p_info,end_p_info
		8: plot_scat,fn_xpr,probe,start_p_info,end_p_info
		9: plot_time_hist,time_hrs,fn_xpr,num_blobs,probe,start_p_info,end_p_info
		10:plot_p_info,fn_xpr,time_str,probe,start_p_info,end_p_info
		11:p_info_hist,fn_xpr,time_str,probe,start_p_info,end_p_info
		12:plot_b_info,b_info_arr(start_buff:end_buff)
		else:

	endcase
endwhile

mes = 'The Raw Data Processing Is Done Now!'
result = dialog_message(mes, /Information)
print,result

endelse

end
