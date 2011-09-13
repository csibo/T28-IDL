;
;data_into_hdata.pro
;
; Program written: April 11, 2008
; Reviewed: April 11, 2008
; Author: Donna Kliche
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO data_into_hdata_1995, start_buff,end_buff,data, hdata_1995, hours_str, minutes_str, seconds_str,list_var, size_dn_hirate,fltno

if ((fltno eq 655) OR (fltno eq 656) or (fltno eq 658)) then begin
;populate hdata with the values we need to display
hours_hirate=float(hours_str(start_buff:end_buff))
  hdata_1995.hours_hirate(*) = interpol(hours_hirate,size_dn_hirate)
  print,'min,max(hdata_1994.hours_hirate): ',min(hdata_1995.hours_hirate),max(hdata_1995.hours_hirate)
  hdata_1995.hours_hirate = hdata_1995.hours_hirate -1.0
  print,'min,max(hdata_1995.hours_hirate): ',min(hdata_1995.hours_hirate),max(hdata_1995.hours_hirate)
  stop
minutes_hirate= float(minutes_str(start_buff:end_buff))
  hdata_1995.minutes_hirate(*) = interpol(minutes_hirate,size_dn_hirate)
dec_seconds_hirate= float(seconds_str(start_buff:end_buff))
  hdata_1995.dec_seconds_hirate(*) = interpol(dec_seconds_hirate,size_dn_hirate)

  hdata_1995.dyn_press_1(*) = interpol(float(data(1,*)), size_dn_hirate)			; 101
  hdata_1995.dyn_press_2(*) = interpol(float(data(2,*)), size_dn_hirate)			; 102
  hdata_1995.stat_press_1(*) = interpol(float(data(3,*)), size_dn_hirate)			; 103
  hdata_1995.stat_press_2(*) = interpol(float(data(4,*)), size_dn_hirate)			; 104
  hdata_1995.roc(*) = interpol(float(data(5,*)), size_dn_hirate)					; 105
  hdata_1995.rose(*) = interpol(float(data(6,*)), size_dn_hirate)					; 106
  hdata_1995.rft(*) = interpol(float(data(7,*)), size_dn_hirate)					; 107
  hdata_1995.man_press(*) = interpol(float(data(8,*)), size_dn_hirate)				; 108
  hdata_1995.accel(*) = interpol(float(data(9,*)), size_dn_hirate)					; 109
  hdata_1995.pitch(*) = interpol(float(data(10,*)), size_dn_hirate)					; 110
  ;stop
  hdata_1995.roll(*) = interpol(float(data(11,*)), size_dn_hirate)					; 111
  hdata_1995.jwlw(*) = interpol(float(data(12,*)), size_dn_hirate)					; 112
  hdata_1995.vor(*) = interpol(float(data(13,*)), size_dn_hirate)					; 113
  hdata_1995.dme1(*) = interpol(float(data(14,*)), size_dn_hirate)					; 114
  hdata_1995.volt_reg(*) = interpol(float(data(15,*)), size_dn_hirate)				; 116
  ;stop
  hdata_1995.heading(*) = interpol(float(data(16,*)), size_dn_hirate)				; 117
  hdata_1995.ncar_tas(*) = interpol(float(data(17,*)), size_dn_hirate)				; 118
  hdata_1995.pms_ee1(*) = interpol(float(data(18,*)), size_dn_hirate)				; 119

  hdata_1995.pms_ee2(*) = interpol(float(data(19,*)), size_dn_hirate)				; 120
  hdata_1995.int_temp(*) = interpol(float(data(20,*)), size_dn_hirate)				; 121
  hdata_1995.hv_current(*) = interpol(float(data(21,*)), size_dn_hirate)			; 123
  hdata_1995.htr_current(*) = interpol(float(data(22,*)), size_dn_hirate)			; 124
  hdata_1995.King_lwc(*) = interpol(float(data(23,*)), size_dn_hirate)				; 125
  print,'min(hdata_1995.King_lwc),max(hdata_1995.King_lwc): ',min(hdata_1995.King_lwc),max(hdata_1995.King_lwc)
  ;hdata_1995.disc_fwd(*) = interpol(float(data(24,*)), size_dn_hirate)				; 128
  ;hdata_1995.disc_aft(*) = interpol(float(data(25,*)), size_dn_hirate)				; 129

  hdata_1995.event_bits(*) = interpol(float(data(24,*)), size_dn_hirate)			; 130
  hdata_1995.gps_codes(*) = interpol(float(data(25,*)), size_dn_hirate)		    	; 131
stop
  hdata_1995.fssp_size_counts(*) = interpol(float(data(26,*)), size_dn_hirate)	    ; 140

  ;for flight 655, gated and total strobes were reversed!!!!!!
  hdata_1995.gated_strobes(*) = interpol(float(data(42,*)), size_dn_hirate)			; 190
  print,'min,max(hdata_1995.gated_strobes):',min(hdata_1995.gated_strobes),max(hdata_1995.gated_strobes)
  hdata_1995.total_strobes(*) = interpol(float(data(41,*)), size_dn_hirate)			; 191
  print,'min,max(hdata_1995.total_strobes):',min(hdata_1995.total_strobes),max(hdata_1995.total_strobes)

  hdata_1995.fssp_range(*) = interpol(float(data(43,*)), size_dn_hirate)			; 192
  stop
  hdata_1995.fssp_tot_cnts(*) = interpol(float(data(44,*)), size_dn_hirate)			; 141
  hdata_1995.fssp_ave_diam(*) = interpol(float(data(45,*)), size_dn_hirate)			; 142
  hdata_1995.tot_part_conc(*) = interpol(float(data(46,*)), size_dn_hirate)			; 143
  hdata_1995.fssp_lw(*) = interpol(float(data(47,*)), size_dn_hirate)				; 144
  hdata_1995.activity(*) = interpol(float(data(48,*)), size_dn_hirate)				; 145
  hdata_1995.equiv_diam(*) = interpol(float(data(49,*)), size_dn_hirate)			; 148
  hdata_1995.var(*) = interpol(float(data(50,*)), size_dn_hirate)					; 149
  hdata_1995.fssp_equivJW(*) = interpol(float(data(51,*)), size_dn_hirate)	    	; 244


  hdata_1995.shad_or_2dc(*) = interpol(float(data(52,*)), size_dn_hirate)			; 146

  print,'hdata_1995.shad_or_2dc(min,max,median): ',min(hdata_1995.shad_or_2dc),max(hdata_1995.shad_or_2dc),median(hdata_1995.shad_or_2dc)
  stop

  hdata_1995.hail_size_cnts(*) = interpol(float(data(53,*)), size_dn_hirate)		; 150

  hdata_1995.slow_particle(*) = interpol(float(data(67,*)), size_dn_hirate)			; 151
  hdata_1995.hail_tot_cnts(*) = interpol(float(data(68,*)), size_dn_hirate)			; 152
  hdata_1995.hail_ave_diam(*) = interpol(float(data(69,*)), size_dn_hirate)			; 153
  hdata_1995.hail_conc(*) = interpol(float(data(70,*)), size_dn_hirate)				; 154
  hdata_1995.hail_water(*) = interpol(float(data(71,*)), size_dn_hirate)			; 155
  ;stop
  hdata_1995.tfm_lo(*) = interpol(float(data(72,*)), size_dn_hirate)				; 160
  hdata_1995.bfm_lo(*) = interpol(float(data(73,*)), size_dn_hirate)				; 161
  hdata_1995.lfm_lo(*) = interpol(float(data(74,*)), size_dn_hirate)				; 162
  hdata_1995.rfm_lo(*) = interpol(float(data(75,*)), size_dn_hirate)				; 163
  hdata_1995.tfm_hi(*) = interpol(float(data(76,*)), size_dn_hirate)				; 164
  hdata_1995.bfm_hi(*) = interpol(float(data(77,*)), size_dn_hirate)				; 165
  hdata_1995.lfm_hi(*) = interpol(float(data(78,*)), size_dn_hirate)				; 166
  hdata_1995.rfm_hi(*) = interpol(float(data(79,*)), size_dn_hirate)				; 167
  hdata_1995.fm5_lo(*) = interpol(float(data(80,*)), size_dn_hirate)				; 168
  ;stop
  hdata_1995.lat_dec_deg_hirate(*) = interpol(float(data(81,*)), size_dn_hirate)	; 172
  hdata_1995.lon_dec_deg_hirate(*) = interpol(float(data(82,*)), size_dn_hirate)	; 173
  print,'hdata.lat_dec_deg_hirate(min,max,median): ',min(hdata_1995.lat_dec_deg_hirate),max(hdata_1995.lat_dec_deg_hirate),median(hdata_1995.lat_dec_deg_hirate)
  print,'hdata.lon_dec_deg_hirate(min,max,median): ',min(hdata_1995.lon_dec_deg_hirate),max(hdata_1995.lon_dec_deg_hirate),median(hdata_1995.lon_dec_deg_hirate)
stop
  hdata_1995.gps_grd_spd(*) = interpol(float(data(83,*)), size_dn_hirate)			; 174
  hdata_1995.gps_grd_trk_angle(*) = interpol(float(data(84,*)), size_dn_hirate)		; 175
  hdata_1995.gps_mag_var(*) = interpol(float(data(85,*)), size_dn_hirate)			; 176
  hdata_1995.time_since_sol(*) = interpol(float(data(86,*)), size_dn_hirate)		; 177
  hdata_1995.gps_alt(*) = interpol(float(data(87,*)), size_dn_hirate)				; 178
  print,'hdata.gps_alt(min,max,median): ',min(hdata_1995.gps_alt),max(hdata_1995.gps_alt),median(hdata_1995.gps_alt)

  hdata_1995.gps_roc(*) = interpol(float(data(88,*)), size_dn_hirate)				; 185
  stop
  hdata_1995.pelev(*) = interpol(float(data(94,*)), size_dn_hirate)					; 205
  hdata_1995.thetae(*) = interpol(float(data(95,*)), size_dn_hirate)				; 206
  hdata_1995.sat_mix_ratio(*) = interpol(float(data(96,*)), size_dn_hirate)			; 207
  hdata_1995.dzdt(*) = interpol(float(data(97,*)), size_dn_hirate)					; 208
  hdata_1995.indic_as(*) = interpol(float(data(98,*)), size_dn_hirate)				; 209
  hdata_1995.uncorr_updraft(*) = interpol(float(data(99,*)), size_dn_hirate)		; 210
  ;stop
  hdata_1995.calc_tas(*) = interpol(float(data(100,*)), size_dn_hirate)				; 211
  hdata_1995.updraft_corrFact(*) = interpol(float(data(101,*)), size_dn_hirate)		; 212
  hdata_1995.cooper_updraft(*) = interpol(float(data(102,*)), size_dn_hirate)		; 213
  hdata_1995.kopp_updraft(*) = interpol(float(data(103,*)), size_dn_hirate)			; 214
  print,'hdata.kopp_updraft(min,max,median): ',min(hdata_1995.kopp_updraft),max(hdata_1995.kopp_updraft),median(hdata_1995.kopp_updraft)

  p=where(hdata_1995.kopp_updraft gt 100.0, np)
  if (np gt 0) then hdata_1995.kopp_updraft(p) = 100.0
  print,'hdata.kopp_updraft(min,max,median): ',min(hdata_1995.kopp_updraft),max(hdata_1995.kopp_updraft),median(hdata_1995.kopp_updraft)

  p=where(hdata_1995.kopp_updraft lt -100.0, np)
  if (np gt 0) then hdata_1995.kopp_updraft(p) = -100.0
  print,'hdata.kopp_updraft(min,max,median): ',min(hdata_1995.kopp_updraft),max(hdata_1995.kopp_updraft),median(hdata_1995.kopp_updraft)

  stop
  ;hdata_1995.geopot_hght(*) = interpol(float(data(103,*)), size_dn_hirate)			; 215
  hdata_1995.turb(*) = interpol(float(data(104,*)), size_dn_hirate)					; 216
  hdata_1995.densmid(*) = interpol(float(data(105,*)), size_dn_hirate)				; 217
  hdata_1995.JW_mix_ratio(*) = interpol(float(data(106,*)), size_dn_hirate)			; 218
  hdata_1995.fssp_mix_ratio(*) = interpol(float(data(107,*)), size_dn_hirate)		; 219
  hdata_1995.hail_mix_ratio(*) = interpol(float(data(108,*)), size_dn_hirate)		; 220
  hdata_1995.NO_conc(*) = 0.0														; 500  put in for web design consistency
  hdata_1995.fm6_lo(*) = 0.0														; 504

endif ; for flights 655 & 656 & 658



if ((fltno eq 660) OR (fltno eq 661)) then begin

;populate hdata with the values we need to display
hours_hirate=float(hours_str(start_buff:end_buff))
  hdata_1995.hours_hirate(*) = interpol(hours_hirate,size_dn_hirate)
  print,'min,max(hdata_1995.hours_hirate): ',min(hdata_1995.hours_hirate),max(hdata_1995.hours_hirate)
  hdata_1995.hours_hirate = hdata_1995.hours_hirate -1.0
  print,'min,max(hdata_1995.hours_hirate): ',min(hdata_1995.hours_hirate),max(hdata_1995.hours_hirate)
  stop
minutes_hirate= float(minutes_str(start_buff:end_buff))
  hdata_1995.minutes_hirate(*) = interpol(minutes_hirate,size_dn_hirate)
dec_seconds_hirate= float(seconds_str(start_buff:end_buff))
  hdata_1995.dec_seconds_hirate(*) = interpol(dec_seconds_hirate,size_dn_hirate)

  hdata_1995.dyn_press_1(*) = interpol(float(data(1,*)), size_dn_hirate)			; 101
  hdata_1995.dyn_press_2(*) = interpol(float(data(2,*)), size_dn_hirate)			; 102
  hdata_1995.stat_press_1(*) = interpol(float(data(3,*)), size_dn_hirate)			; 103
  hdata_1995.stat_press_2(*) = interpol(float(data(4,*)), size_dn_hirate)			; 104
  hdata_1995.roc(*) = interpol(float(data(5,*)), size_dn_hirate)					; 105
  hdata_1995.rose(*) = interpol(float(data(6,*)), size_dn_hirate)					; 106
  hdata_1995.rft(*) = interpol(float(data(7,*)), size_dn_hirate)					; 107
  hdata_1995.man_press(*) = interpol(float(data(8,*)), size_dn_hirate)				; 108
  hdata_1995.accel(*) = interpol(float(data(9,*)), size_dn_hirate)					; 109
  hdata_1995.pitch(*) = interpol(float(data(10,*)), size_dn_hirate)					; 110
  ;stop
  hdata_1995.roll(*) = interpol(float(data(11,*)), size_dn_hirate)					; 111
  hdata_1995.jwlw(*) = interpol(float(data(12,*)), size_dn_hirate)					; 112
  hdata_1995.vor(*) = interpol(float(data(13,*)), size_dn_hirate)					; 113
  hdata_1995.dme1(*) = interpol(float(data(14,*)), size_dn_hirate)					; 114
  hdata_1995.volt_reg(*) = interpol(float(data(15,*)), size_dn_hirate)				; 116
  ;stop
  hdata_1995.heading(*) = interpol(float(data(16,*)), size_dn_hirate)				; 117
  hdata_1995.ncar_tas(*) = interpol(float(data(17,*)), size_dn_hirate)				; 118

  hdata_1995.pms_ee1 = fltarr(size_dn_hirate)
  hdata_1995.pms_ee2 = fltarr(size_dn_hirate)
  hdata_1995.pms_ee1(*) = 0.0														; 119
  hdata_1995.pms_ee2(*) = 0.0														; 120

  hdata_1995.int_temp(*) = interpol(float(data(18,*)), size_dn_hirate)				; 121
  hdata_1995.hv_current(*) = interpol(float(data(19,*)), size_dn_hirate)			; 123
  hdata_1995.htr_current(*) = interpol(float(data(20,*)), size_dn_hirate)			; 124
  hdata_1995.King_lwc(*) = interpol(float(data(21,*)), size_dn_hirate)				; 125
  print,'min(hdata_1995.King_lwc),max(hdata_1995.King_lwc): ',min(hdata_1995.King_lwc),max(hdata_1995.King_lwc)

  hdata_1995.disc_fwd(*) = interpol(float(data(22,*)), size_dn_hirate)				; 128
  hdata_1995.disc_aft(*) = interpol(float(data(23,*)), size_dn_hirate)				; 129

  hdata_1995.event_bits(*) = interpol(float(data(24,*)), size_dn_hirate)			; 130
  hdata_1995.gps_codes(*) = interpol(float(data(25,*)), size_dn_hirate)		    	; 131
stop
  hdata_1995.fssp_size_counts(*) = interpol(float(data(26,*)), size_dn_hirate)	    ; 140

  ;for flight 655, gated and total strobes were reversed!!!!!!
  hdata_1995.gated_strobes(*) = interpol(float(data(42,*)), size_dn_hirate)			; 190
  print,'min,max(hdata_1995.gated_strobes):',min(hdata_1995.gated_strobes),max(hdata_1995.gated_strobes)
  hdata_1995.total_strobes(*) = interpol(float(data(41,*)), size_dn_hirate)			; 191
  print,'min,max(hdata_1995.total_strobes):',min(hdata_1995.total_strobes),max(hdata_1995.total_strobes)

  hdata_1995.fssp_range(*) = interpol(float(data(43,*)), size_dn_hirate)			; 192
  stop
  hdata_1995.fssp_tot_cnts(*) = interpol(float(data(44,*)), size_dn_hirate)			; 141
  hdata_1995.fssp_ave_diam(*) = interpol(float(data(45,*)), size_dn_hirate)			; 142
  hdata_1995.tot_part_conc(*) = interpol(float(data(46,*)), size_dn_hirate)			; 143
  hdata_1995.fssp_lw(*) = interpol(float(data(47,*)), size_dn_hirate)				; 144
  hdata_1995.activity(*) = interpol(float(data(48,*)), size_dn_hirate)				; 145
  hdata_1995.equiv_diam(*) = interpol(float(data(49,*)), size_dn_hirate)			; 148
  hdata_1995.var(*) = interpol(float(data(50,*)), size_dn_hirate)					; 149
  hdata_1995.fssp_equivJW(*) = interpol(float(data(51,*)), size_dn_hirate)	    	; 244


  hdata_1995.shad_or_2dc(*) = interpol(float(data(52,*)), size_dn_hirate)			; 146

  print,'hdata_1995.shad_or_2dc(min,max,median): ',min(hdata_1995.shad_or_2dc),max(hdata_1995.shad_or_2dc),median(hdata_1995.shad_or_2dc)
  stop

  hdata_1995.hail_size_cnts(*) = interpol(float(data(53,*)), size_dn_hirate)		; 150

  hdata_1995.slow_particle(*) = interpol(float(data(67,*)), size_dn_hirate)			; 151
  hdata_1995.hail_tot_cnts(*) = interpol(float(data(68,*)), size_dn_hirate)			; 152
  hdata_1995.hail_ave_diam(*) = interpol(float(data(69,*)), size_dn_hirate)			; 153
  hdata_1995.hail_conc(*) = interpol(float(data(70,*)), size_dn_hirate)				; 154
  hdata_1995.hail_water(*) = interpol(float(data(71,*)), size_dn_hirate)			; 155
  ;stop
  hdata_1995.tfm_lo(*) = interpol(float(data(72,*)), size_dn_hirate)				; 160
  hdata_1995.bfm_lo(*) = interpol(float(data(73,*)), size_dn_hirate)				; 161
  hdata_1995.lfm_lo(*) = interpol(float(data(74,*)), size_dn_hirate)				; 162
  hdata_1995.rfm_lo(*) = interpol(float(data(75,*)), size_dn_hirate)				; 163
  hdata_1995.tfm_hi(*) = interpol(float(data(76,*)), size_dn_hirate)				; 164
  hdata_1995.bfm_hi(*) = interpol(float(data(77,*)), size_dn_hirate)				; 165
  hdata_1995.lfm_hi(*) = interpol(float(data(78,*)), size_dn_hirate)				; 166
  hdata_1995.rfm_hi(*) = interpol(float(data(79,*)), size_dn_hirate)				; 167
  hdata_1995.fm5_lo(*) = interpol(float(data(80,*)), size_dn_hirate)				; 168
  ;stop
  hdata_1995.lat_dec_deg_hirate(*) = interpol(float(data(81,*)), size_dn_hirate)	; 172
  hdata_1995.lon_dec_deg_hirate(*) = interpol(float(data(82,*)), size_dn_hirate)	; 173
  print,'hdata.lat_dec_deg_hirate(min,max,median): ',min(hdata_1995.lat_dec_deg_hirate),max(hdata_1995.lat_dec_deg_hirate),median(hdata_1995.lat_dec_deg_hirate)
  print,'hdata.lon_dec_deg_hirate(min,max,median): ',min(hdata_1995.lon_dec_deg_hirate),max(hdata_1995.lon_dec_deg_hirate),median(hdata_1995.lon_dec_deg_hirate)
stop
  hdata_1995.gps_grd_spd(*) = interpol(float(data(83,*)), size_dn_hirate)			; 174
  hdata_1995.gps_grd_trk_angle(*) = interpol(float(data(84,*)), size_dn_hirate)		; 175
  hdata_1995.gps_mag_var(*) = interpol(float(data(85,*)), size_dn_hirate)			; 176
  hdata_1995.time_since_sol(*) = interpol(float(data(86,*)), size_dn_hirate)		; 177
  hdata_1995.gps_alt(*) = interpol(float(data(87,*)), size_dn_hirate)				; 178
  print,'hdata.gps_alt(min,max,median): ',min(hdata_1995.gps_alt),max(hdata_1995.gps_alt),median(hdata_1995.gps_alt)

  hdata_1995.gps_roc(*) = interpol(float(data(88,*)), size_dn_hirate)				; 185
  stop
  hdata_1995.pelev(*) = interpol(float(data(94,*)), size_dn_hirate)					; 205
  hdata_1995.thetae(*) = interpol(float(data(95,*)), size_dn_hirate)				; 206
  hdata_1995.sat_mix_ratio(*) = interpol(float(data(96,*)), size_dn_hirate)			; 207
  hdata_1995.dzdt(*) = interpol(float(data(97,*)), size_dn_hirate)					; 208
  hdata_1995.indic_as(*) = interpol(float(data(98,*)), size_dn_hirate)				; 209
  hdata_1995.uncorr_updraft(*) = interpol(float(data(99,*)), size_dn_hirate)		; 210
  ;stop
  hdata_1995.calc_tas(*) = interpol(float(data(100,*)), size_dn_hirate)				; 211
  hdata_1995.updraft_corrFact(*) = interpol(float(data(101,*)), size_dn_hirate)		; 212
  hdata_1995.cooper_updraft(*) = interpol(float(data(102,*)), size_dn_hirate)		; 213
  hdata_1995.kopp_updraft(*) = interpol(float(data(103,*)), size_dn_hirate)			; 214
  print,'hdata.kopp_updraft(min,max,median): ',min(hdata_1995.kopp_updraft),max(hdata_1995.kopp_updraft),median(hdata_1995.kopp_updraft)

  p=where(hdata_1995.kopp_updraft gt 100.0, np)
  if (np gt 0) then hdata_1995.kopp_updraft(p) = 100.0
  print,'hdata.kopp_updraft(min,max,median): ',min(hdata_1995.kopp_updraft),max(hdata_1995.kopp_updraft),median(hdata_1995.kopp_updraft)

  p=where(hdata_1995.kopp_updraft lt -100.0, np)
  if (np gt 0) then hdata_1995.kopp_updraft(p) = -100.0
  print,'hdata.kopp_updraft(min,max,median): ',min(hdata_1995.kopp_updraft),max(hdata_1995.kopp_updraft),median(hdata_1995.kopp_updraft)

  stop
  ;hdata_1995.geopot_hght(*) = interpol(float(data(103,*)), size_dn_hirate)			; 215
  hdata_1995.turb(*) = interpol(float(data(104,*)), size_dn_hirate)					; 216
  hdata_1995.densmid(*) = interpol(float(data(105,*)), size_dn_hirate)				; 217
  hdata_1995.JW_mix_ratio(*) = interpol(float(data(106,*)), size_dn_hirate)			; 218
  hdata_1995.fssp_mix_ratio(*) = interpol(float(data(107,*)), size_dn_hirate)		; 219
  hdata_1995.hail_mix_ratio(*) = interpol(float(data(108,*)), size_dn_hirate)		; 220
  hdata_1995.NO_conc(*) = 0.0														; 500  put in for web design consistency
  hdata_1995.fm6_lo(*) = 0.0														; 504


endif

if ((fltno eq 666) OR (fltno eq 667) OR (fltno eq 668) OR (fltno eq 670) OR (fltno eq 671)) then begin
;stop
;populate hdata with the values we need to display
hours_hirate=float(hours_str(start_buff:end_buff))
  hdata_1995.hours_hirate(*) = interpol(hours_hirate,size_dn_hirate)
  print,'min,max(hdata_1995.hours_hirate): ',min(hdata_1995.hours_hirate),max(hdata_1995.hours_hirate)
;  if ((fltno eq 668) or (fltno eq 670) or (fltno eq 671)) then begin
;   hdata_1995.hours_hirate = hdata_1995.hours_hirate +6.0
;   print,'min,max(hdata_1995.hours_hirate): ',min(hdata_1995.hours_hirate),max(hdata_1995.hours_hirate)
;  endif
;  stop
minutes_hirate= float(minutes_str(start_buff:end_buff))
  hdata_1995.minutes_hirate(*) = interpol(minutes_hirate,size_dn_hirate)
dec_seconds_hirate= float(seconds_str(start_buff:end_buff))
  hdata_1995.dec_seconds_hirate(*) = interpol(dec_seconds_hirate,size_dn_hirate)

  hdata_1995.dyn_press_1(*) = interpol(float(data(1,*)), size_dn_hirate)			; 101
  hdata_1995.dyn_press_2(*) = interpol(float(data(2,*)), size_dn_hirate)			; 102
  hdata_1995.stat_press_1(*) = interpol(float(data(3,*)), size_dn_hirate)			; 103
  hdata_1995.stat_press_2(*) = interpol(float(data(4,*)), size_dn_hirate)			; 104
  hdata_1995.roc(*) = interpol(float(data(5,*)), size_dn_hirate)					; 105
  hdata_1995.rose(*) = interpol(float(data(6,*)), size_dn_hirate)					; 106
  hdata_1995.rft(*) = interpol(float(data(7,*)), size_dn_hirate)					; 107
  hdata_1995.man_press(*) = interpol(float(data(8,*)), size_dn_hirate)				; 108
  hdata_1995.accel(*) = interpol(float(data(9,*)), size_dn_hirate)					; 109
  hdata_1995.pitch(*) = interpol(float(data(10,*)), size_dn_hirate)					; 110
  ;stop
  hdata_1995.roll(*) = interpol(float(data(11,*)), size_dn_hirate)					; 111
  hdata_1995.jwlw(*) = interpol(float(data(12,*)), size_dn_hirate)					; 112
  hdata_1995.vor(*) = interpol(float(data(13,*)), size_dn_hirate)					; 113
  hdata_1995.dme1(*) = interpol(float(data(14,*)), size_dn_hirate)					; 114
  hdata_1995.volt_reg(*) = interpol(float(data(15,*)), size_dn_hirate)				; 116
  ;stop
  hdata_1995.heading(*) = interpol(float(data(16,*)), size_dn_hirate)				; 117
  hdata_1995.ncar_tas(*) = interpol(float(data(17,*)), size_dn_hirate)				; 118

  hdata_1995.pms_ee1 = fltarr(size_dn_hirate)
  hdata_1995.pms_ee2 = fltarr(size_dn_hirate)
  hdata_1995.pms_ee1(*) = 0.0														; 119
  hdata_1995.pms_ee2(*) = 0.0														; 120

  hdata_1995.int_temp(*) = interpol(float(data(18,*)), size_dn_hirate)				; 121
  hdata_1995.hv_current(*) = interpol(float(data(19,*)), size_dn_hirate)			; 123
  hdata_1995.htr_current(*) = interpol(float(data(20,*)), size_dn_hirate)			; 124
  hdata_1995.King_lwc(*) = interpol(float(data(21,*)), size_dn_hirate)				; 125
  print,'min(hdata_1995.King_lwc),max(hdata_1995.King_lwc): ',min(hdata_1995.King_lwc),max(hdata_1995.King_lwc)

  hdata_1995.disc_fwd(*) = interpol(float(data(22,*)), size_dn_hirate)				; 128
  hdata_1995.disc_aft(*) = interpol(float(data(23,*)), size_dn_hirate)				; 129

  hdata_1995.event_bits(*) = interpol(float(data(24,*)), size_dn_hirate)			; 130
  hdata_1995.gps_codes(*) = interpol(float(data(25,*)), size_dn_hirate)		    	; 131
stop
  hdata_1995.fssp_size_counts(*) = interpol(float(data(26,*)), size_dn_hirate)	    ; 140

  ;for flight 655, gated and total strobes were reversed!!!!!!
  hdata_1995.gated_strobes(*) = interpol(float(data(42,*)), size_dn_hirate)			; 190
  hdata_1995.total_strobes(*) = interpol(float(data(41,*)), size_dn_hirate)			; 191

  hdata_1995.fssp_range(*) = interpol(float(data(43,*)), size_dn_hirate)			; 192
  stop
  hdata_1995.fssp_tot_cnts(*) = interpol(float(data(44,*)), size_dn_hirate)			; 141
  hdata_1995.fssp_ave_diam(*) = interpol(float(data(45,*)), size_dn_hirate)			; 142
  hdata_1995.tot_part_conc(*) = interpol(float(data(46,*)), size_dn_hirate)			; 143
  hdata_1995.fssp_lw(*) = interpol(float(data(47,*)), size_dn_hirate)				; 144
  hdata_1995.activity(*) = interpol(float(data(48,*)), size_dn_hirate)				; 145
  hdata_1995.equiv_diam(*) = interpol(float(data(49,*)), size_dn_hirate)			; 148
  hdata_1995.var(*) = interpol(float(data(50,*)), size_dn_hirate)					; 149
  hdata_1995.fssp_equivJW(*) = interpol(float(data(51,*)), size_dn_hirate)	    	; 244

  hdata_1995.shad_or_2dc = fltarr(size_dn_hirate)									;; 146 this tag is missing from Flight 666
  hdata_1995.shad_or_2dc(*) = 0.0

  print,'hdata_1995.shad_or_2dc(min,max,median): ',min(hdata_1995.shad_or_2dc),max(hdata_1995.shad_or_2dc),median(hdata_1995.shad_or_2dc)
  stop

  hdata_1995.hail_size_cnts(*) = interpol(float(data(52,*)), size_dn_hirate)		; 150

  hdata_1995.slow_particle(*) = interpol(float(data(66,*)), size_dn_hirate)			; 151
  hdata_1995.hail_tot_cnts(*) = interpol(float(data(67,*)), size_dn_hirate)			; 152
  hdata_1995.hail_ave_diam(*) = interpol(float(data(68,*)), size_dn_hirate)			; 153
  hdata_1995.hail_conc(*) = interpol(float(data(69,*)), size_dn_hirate)				; 154
  hdata_1995.hail_water(*) = interpol(float(data(70,*)), size_dn_hirate)			; 155
  ;stop
  hdata_1995.tfm_lo(*) = interpol(float(data(71,*)), size_dn_hirate)				; 160
  hdata_1995.bfm_lo(*) = interpol(float(data(72,*)), size_dn_hirate)				; 161
  hdata_1995.lfm_lo(*) = interpol(float(data(73,*)), size_dn_hirate)				; 162
  hdata_1995.rfm_lo(*) = interpol(float(data(74,*)), size_dn_hirate)				; 163
  hdata_1995.tfm_hi(*) = interpol(float(data(75,*)), size_dn_hirate)				; 164
  hdata_1995.bfm_hi(*) = interpol(float(data(76,*)), size_dn_hirate)				; 165
  hdata_1995.lfm_hi(*) = interpol(float(data(77,*)), size_dn_hirate)				; 166
  hdata_1995.rfm_hi(*) = interpol(float(data(78,*)), size_dn_hirate)				; 167
  hdata_1995.fm5_lo(*) = interpol(float(data(79,*)), size_dn_hirate)				; 168
  ;stop
  hdata_1995.lat_dec_deg_hirate(*) = interpol(float(data(80,*)), size_dn_hirate)	; 172
  pl = where(hdata_1995.lat_dec_deg_hirate eq 0.0, npl)
  if (npl ne 0) then hdata_1995.lat_dec_deg_hirate(0:npl+20)= hdata_1995.lat_dec_deg_hirate(npl+20)		;replace bad lat values with the first ones that are good

  hdata_1995.lon_dec_deg_hirate(*) = interpol(float(data(81,*)), size_dn_hirate)	; 173
  pl0 = where(hdata_1995.lon_dec_deg_hirate eq 0.0, npl0)
  if (npl0 ne 0) then hdata_1995.lon_dec_deg_hirate(0:npl0+20)= hdata_1995.lon_dec_deg_hirate(npl0+20)

  print,'hdata.lat_dec_deg_hirate(min,max,median): ',min(hdata_1995.lat_dec_deg_hirate),max(hdata_1995.lat_dec_deg_hirate),median(hdata_1995.lat_dec_deg_hirate)
  print,'hdata.lon_dec_deg_hirate(min,max,median): ',min(hdata_1995.lon_dec_deg_hirate),max(hdata_1995.lon_dec_deg_hirate),median(hdata_1995.lon_dec_deg_hirate)

  stop
  hdata_1995.gps_grd_spd(*) = interpol(float(data(82,*)), size_dn_hirate)			; 174
  hdata_1995.gps_grd_trk_angle(*) = interpol(float(data(83,*)), size_dn_hirate)		; 175
  hdata_1995.gps_mag_var(*) = interpol(float(data(84,*)), size_dn_hirate)			; 176
  hdata_1995.time_since_sol(*) = interpol(float(data(85,*)), size_dn_hirate)		; 177
  hdata_1995.gps_alt(*) = interpol(float(data(86,*)), size_dn_hirate)				; 178
  print,'hdata.gps_alt(min,max,median): ',min(hdata_1995.gps_alt),max(hdata_1995.gps_alt),median(hdata_1995.gps_alt)

  hdata_1995.gps_roc(*) = interpol(float(data(87,*)), size_dn_hirate)				; 185
  stop
  hdata_1995.pelev(*) = interpol(float(data(93,*)), size_dn_hirate)					; 205
  hdata_1995.thetae(*) = interpol(float(data(94,*)), size_dn_hirate)				; 206
  hdata_1995.sat_mix_ratio(*) = interpol(float(data(95,*)), size_dn_hirate)			; 207
  hdata_1995.dzdt(*) = interpol(float(data(96,*)), size_dn_hirate)					; 208
  hdata_1995.indic_as(*) = interpol(float(data(97,*)), size_dn_hirate)				; 209
  hdata_1995.uncorr_updraft(*) = interpol(float(data(98,*)), size_dn_hirate)		; 210
  ;stop
  hdata_1995.calc_tas(*) = interpol(float(data(99,*)), size_dn_hirate)				; 211
  hdata_1995.updraft_corrFact(*) = interpol(float(data(100,*)), size_dn_hirate)		; 212
  hdata_1995.cooper_updraft(*) = interpol(float(data(101,*)), size_dn_hirate)		; 213
  hdata_1995.kopp_updraft(*) = interpol(float(data(102,*)), size_dn_hirate)			; 214
  p=where(hdata_1995.kopp_updraft gt 100.0, np)
  if (np gt 0) then hdata_1995.kopp_updraft(p) = 100.0
print,'hdata.kopp_updraft(min,max,median): ',min(hdata_1995.kopp_updraft),max(hdata_1995.kopp_updraft),median(hdata_1995.kopp_updraft)

  stop
  ;hdata_1995.geopot_hght(*) = interpol(float(data(103,*)), size_dn_hirate)			; 215
  hdata_1995.turb(*) = interpol(float(data(103,*)), size_dn_hirate)					; 216
  hdata_1995.densmid(*) = interpol(float(data(104,*)), size_dn_hirate)				; 217
  hdata_1995.JW_mix_ratio(*) = interpol(float(data(105,*)), size_dn_hirate)			; 218
  hdata_1995.fssp_mix_ratio(*) = interpol(float(data(106,*)), size_dn_hirate)		; 219
  hdata_1995.hail_mix_ratio(*) = interpol(float(data(107,*)), size_dn_hirate)		; 220
  hdata_1995.NO_conc(*) = 0.0														; 500  put in for web design consistency
  hdata_1995.fm6_lo(*) = 0.0														; 504


endif



; recalculate the electric field relative to airplane, the way Dr. Mo described
; in his article in 1999; I used the equations from read_rawD.pro program
;============================================================================
;- Electric field calculations
;- new method developed by Dr. Mo - valid from 1993 - 1999 - Aircraft Reference Frame
; original equations are using fm5_lo, but in 1995 we do not record but fm5_hi
;-----------------------------------------------------------------------
hdata_1995.ex_aircraft =   0.0357 * hdata_1995.lfm_lo + 0.0496 * hdata_1995.rfm_lo + 0.0528 * hdata_1995.fm5_lo     ;tag 260 Eqx aircraft relative
hdata_1995.ey_aircraft  = -(0.0231 * hdata_1995.lfm_lo - 0.0230 * hdata_1995.rfm_lo + 0.0031 * hdata_1995.fm5_lo)   ;tag 261 Ey aircraft relative
hdata_1995.ez_aircraft  =   0.0843 * hdata_1995.lfm_lo + 0.0229 * hdata_1995.rfm_lo - 0.1735 * hdata_1995.fm5_lo    ;tag 262 Ez aircraft relative
;stop
;Flight Path Reference Frame - valid as April 1, 2002
;---------preliminary calculations---------------------------
PI = 3.1415927
p = hdata_1995.pitch*PI/180.     ;pitch in radians
r = hdata_1995.roll*PI/180.   ;roll in radians
;ht = htd*PI/180.          ;conversion of true heading to radians
gta = hdata_1995.gps_grd_trk_angle*PI/180. ; in radians
sp = sin(p)           ;sine of pitch
sr = sin(r)
;sht = sin(ht)
sgta = sin(gta)
cp = cos(p)           ;sine of pitch
cr = cos(r)
;cht = cos(ht)
cgta = cos(gta)
;-------------------------------------------------------------------
hdata_1995.ex_path = hdata_1995.ex_aircraft*cp+hdata_1995.ey_aircraft*(-sp)*(-sr) + hdata_1995.ez_aircraft*(-sp)*cr		;tag 263  Ex path relative
hdata_1995.ey_path = hdata_1995.ey_aircraft*cr + hdata_1995.ez_aircraft*sr                              				;tag 264  Ey path relative
hdata_1995.ez_path = hdata_1995.ex_aircraft*sp + hdata_1995.ey_aircraft*cp*(-sr)+hdata_1995.ez_aircraft*cp*cr    		;tag 265  Ez path relative
;stop
;Earth reference frame - valid as April 1, 2002
;--------------------------------------------------------------------
hdata_1995.ex_earth = hdata_1995.ex_aircraft*(sgta*cp) + hdata_1995.ey_aircraft*(sgta*(-sp)*(-sr) +$					;tag 266  Ex Earth relative
         (-cgta)*cr) + hdata_1995.ez_aircraft*(sgta(-sp)*cr + (-cgta)*sr)

hdata_1995.ey_earth = hdata_1995.ex_aircraft*(cgta*cp) + hdata_1995.ey_aircraft*(cgta*(-sp)*(-sr) + $					;tag 267  Ey Earth relative
         sgta*cr) + hdata_1995.ez_aircraft*(cgta*(-sp)*cr + sgta*sr)

hdata_1995.ez_earth = hdata_1995.ex_aircraft*(sp) + hdata_1995.ey_aircraft*(cp*(-sr)) + hdata_1995.ez_aircraft*(cp*cr) 	;tag 268  Ez Earth relative

; For 1993- 1999 the hdata.eq_aircraft = hdata.ex_aircraft the best estimate of both
hdata_1995.eq_aircraft = hdata_1995.ex_aircraft																			;tag 269  charge Eq on aircraft

;  hdata_1995.gps_lat_deg(*) = float(data(136,*))		; 272
;  hdata_1995.gps_lat_min(*) = float(data(137,*))	    ; 273
;  hdata_1995.gps_lon_deg(*) = float(data(138,*))		; 274
;  hdata_1995.gps_lon_min(*) = float(data(139,*))		; 275
;  hdata_1995.gps_grd_track(*) = float(data(140,*))		; 276

;stop
end
