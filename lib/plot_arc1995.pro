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

;- Modified plot_arc2.pro to accomodate for the 1995 HVPS data.
;- LAST MODIFIED: Jan 2002
;-----------------------------------------------------------------------------

pro plot_arc1995

@buff_struct
@part_struct
@set_colors


probe_type = 6			; refering to 1995 HVPS

specs = get_specs(probe_type-1)

device,decomposed=0

;- Get filenames for the arc data and pick a file
fn_buf = dialog_pickfile(path = specs.buf_path, filter = '*.buf')
len = strlen(fn_buf)
fn_xpr = strmid(fn_buf,0,len-3) + 'xpr'

;print,'fn_buf: ',fn_buf
;print,'fn_xpr: ',fn_xpr

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
;tac           = b_info_arr(start_buff:end_buff).tac
num_frames    = b_info_arr(start_buff:end_buff).num_frames
;charge_time   = b_info_arr(start_buff:end_buff).charge_time
tas           = b_info_arr(start_buff:end_buff).calc_tas_buff
ptrs          = b_info_arr(start_buff:end_buff).p_info_ptr
;mult_fac      = b_info_arr(start_buff:end_buff).mult_fac
;div_fac       = b_info_arr(start_buff:end_buff).div_fac

;if probe_type eq 2 then charge_time = 0.06 / tas		;60 mm / tas = elapsed time

;- Back calculate tas from mult and div factors
;tas_clock = mult_fac * specs.clock_factor / div_fac
;md_tas = tas_clock * (specs.x_resolution * 1.e-6)

;- Find the indices for the p_info corresponding to the selected buffers
if start_buff ne 0 then start_p_info = total(b_info_arr(0:start_buff-1).num_blobs) else start_p_info = 0
num_blobs = b_info_arr(start_buff:end_buff).num_blobs
end_p_info = start_p_info + total(num_blobs) - 1
print,'start_p_info,end_p_info: ',start_p_info,end_p_info

;- Read the p_info for the buffers of interest
print,'b_info_arr(start_buff,end_buff).p_info_ptr: ',b_info_arr(start_buff).p_info_ptr,b_info_arr(end_buff).p_info_ptr
;ptr = b_info_arr(start_buff).p_info_ptr
;num_blobs = b_info_arr(start_buff:end_buff).num_blobs
;tot_num_blobs = total(num_blobs)

;- Replace/filter large or zero tac values
;tac_charge = tac_filter(tac,specs.der_thresh,num_frames,charge_time,time_hrs,flt_no_str)

;- Calculate the total distance
tt = fltarr(end_buff-start_buff)
for d = start_buff, end_buff-1 do begin
  tt(d) = (b_info_arr(d+1).time_hrs - b_info_arr(d).time_hrs)*3600.
endfor
total_dist= total(tas(0:end_buff-1) * tt(0:end_buff-1))  ; in m
;stop


;- Extract p_info quantities - NOT MEANINGFUL FOR THE 1995 HVPS DATA???
inter_part_time = get_p_info(fn_xpr,3)
inter_part_time = inter_part_time(start_p_info:end_p_info)

frame_num = get_p_info(fn_xpr,0)
frame_num = frame_num(start_p_info:end_p_info)

seq_num = get_p_info(fn_xpr,9)
seq_num = seq_num(start_p_info:end_p_info)

;- Calculate mean inter particle time for each buffer (in msec)
;- NOT MEANINGFUL FOR THE 1995 HVPS DATA???
mean_time = sv2(inter_part_time,seq_num,num_blobs)

;- Extract the 1st interparticle time for each buffer
;- NOT MEANINGFUL FOR THE 1995 HVPS DATA???
ind = where(frame_num eq 0.,cnt)
first_time = inter_part_time(ind) * 1000.		;1000 is conversion to ms

time_str = strtrim(time_hms(0),2) + ' to ' + strtrim(time_hms(num_buffs-1),2)

!p.multi = 0
plot_sw = 0
while plot_sw ne 7 do begin
	plot_sw = menu_wid_new(['Select Plot Type:', $
                    	'Habit Count/Concentration', $
                    	'Concentration', $
                    	'Scatter Plot', $
                    	'Time Histogram', $
                    	'Particle Info - Time Series', $
                    	'Particle Info - Histogram', $
                    	'Plot Buffer Info', $
                    	'Exit'])

	case plot_sw of

		0: plot_habits1995,fn_xpr,time_hrs,flt_no_str,num_blobs,start_p_info,end_p_info
		1: plot_hist1995,fn_xpr,total_dist,time_str,probe_type,start_p_info,end_p_info
		2: plot_scat1995,fn_xpr,probe_type,start_p_info,end_p_info
		3: plot_time_hist1995,time_hrs,fn_xpr,num_blobs,probe_type,start_p_info,end_p_info
		4: plot_p_info1995,fn_xpr,time_str,probe_type,start_p_info,end_p_info
		5: p_info_hist1995,fn_xpr,time_str,probe_type,start_p_info,end_p_info
		6: plot_b_info1995,b_info_arr(start_buff:end_buff)
		else:

	endcase
endwhile

mes = 'The Raw Data Processing Is Done Now!'
result = dialog_message(mes, /Information)
print,result

end
