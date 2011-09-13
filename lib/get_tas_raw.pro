;- get_tas_raw.pro

function get_tas_raw,fn_src,buff_times,FNDIR=fndir

;- Return slow data for the specified times (buff_times) from fn_src

;- Input
;-	fn_src - File name for the SEA raw file
;-	buff_times - Times for which slow data are required

;- Output
;-	raw_struct - A structure of arrays for the following slow data:
;-		calc_tas, rose, press1, fssp_lw, time_raw, fssp_cnts

tag_num_dn = [ 1, 3, 6, 40 ]			;SEA tag numbers needed to calculate the desired slow data
tag_num_rnd = [ 101, 103, 106, 144 ]	;The reduced tag number for the desired slow data

num_tags = n_elements(tag_num_dn)
num_times = n_elements(buff_times)

raw_struct = { calc_tas :fltarr(num_times), $
               rose     :fltarr(num_times), $
               press1   :fltarr(num_times), $
               fssp_lw  :fltarr(num_times), $
               time_raw :fltarr(num_times), $
               fssp_cnts:fltarr(num_times) }

;- Extract the slow data
print,'Extract slow data from src file ...'

;- Loop through each slow data tag number
for j=0,num_tags-1 do begin

	;- A way to monitor the progress of this routine (a little slow)
	progress_bar,j,num_tags,'Extract Slow Data',wnum

	;- This routine will return the time for all the slow data
	time_struct = get_sea_ptrs2(fn_src,tag_num_dn(j),1,fn_dir=fndir)

	openr,unit,fn_src,/get_lun

	data = 0s
	dn = intarr(num_times)

	;- There are 21 values in each slow data buffer for the fssp tag
	dataf = intarr(21)
	fssp_data = intarr(21,num_times)

	;- Loop through each buff_time
	for i=0,num_times-1 do begin

		;- The closest slow data time to the current image buffer time is the minimum difference
		time_diff = min(abs(buff_times(i) - time_struct.time_hrs(*)),min_ind)

		;- Read the slow data for the closest time
		point_lun,unit,time_struct.buf_ptrs(min_ind)

		if tag_num_rnd(j) ne 144 then begin		;- For slow data other than fssp
			readu,unit,data
			dn(i) = data
		endif else begin						;- For fssp data
			readu,unit,dataf
			fssp_data(*,i) = dataf
		endelse

		raw_struct.time_raw(i) = time_struct.time_hms(min_ind)

	endfor

	case tag_num_rnd(j) of

		101: begin
			 dyn_press_1  = dn * 6.30452e-3 - 0.0489
			 end

		103: begin
	     	 raw_struct.press1 = dn * 1.5791e-2 + 530.37
	     	 end

		106: begin		;rose
	     	 rose = calc_rose2(dn,dyn_press_1,raw_struct.press1,calc_tas_rose)
	     	 raw_struct.calc_tas(*) = calc_tas_rose(*)
	     	 raw_struct.rose(*) = rose(*)
	     	 end

		144: begin		;fssp lw
		     fssp_struct = fssp(fssp_data,calc_tas_rose)
		     raw_struct.fssp_lw(*) = fssp_struct.fssp_lw(*)
		     raw_struct.fssp_cnts(*) = fssp_struct.fssp_tot_cnts(*)
	     	 end

	endcase

endfor

wdelete, wnum

return, raw_struct

end

