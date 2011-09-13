;
;data_into_hdata.pro
;
; Program written: April 11, 2008
; Reviewed: April 11, 2008
; Author: Donna Kliche
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO data_into_hdata_1999, start_buff, end_buff, data, hdata_1999, hours_str, minutes_str, seconds_str,list_var

;populate hdata with the values we need to display
  hdata_1999.hours_hirate(*) = float(hours_str(start_buff:end_buff))
  hdata_1999.minutes_hirate(*) = float(minutes_str(start_buff:end_buff))
  hdata_1999.dec_seconds_hirate(*) = float(seconds_str(start_buff:end_buff))
  hdata_1999.dyn_press_1(*) = float(data(1,*))			; 101
  hdata_1999.dyn_press_2(*) = float(data(2,*))			; 102
  hdata_1999.stat_press_1(*) = float(data(3,*))			; 103
  hdata_1999.stat_press_2(*) = float(data(4,*))			; 104
  ;hdata_1999.roc(*) = float(data(5,*))					; 105
  hdata_1999.rose(*) = float(data(6,*))					; 106
  hdata_1999.rft(*) = float(data(7,*))					; 107
  hdata_1999.man_press(*) = float(data(8,*))			; 108
  hdata_1999.accel(*) = float(data(9,*))				; 109
  hdata_1999.pitch(*) = float(data(10,*))				; 110
  hdata_1999.roll(*) = float(data(11,*))				; 111
  hdata_1999.vor(*) = float(data(12,*))					; 113
  hdata_1999.dme1(*) = float(data(13,*))				; 114
  hdata_1999.volt_reg(*) = float(data(14,*))			; 116
  hdata_1999.heading(*) = float(data(15,*))				; 117
  hdata_1999.ncar_tas(*) = float(data(16,*))			; 118
  hdata_1999.pms_ee1(*) = float(data(17,*))				; 119
  hdata_1999.pms_ee2(*) = float(data(18,*))				; 120
  hdata_1999.int_temp(*) = float(data(19,*))			; 121
  ;hdata_1999.hv_current(*) = float(data(20,*))			; 123
  hdata_1999.htr_current(*) = float(data(21,*))			; 124
  hdata_1999.dmt_lw(*) = float(data(22,*))				; 186
  hdata_1999.event_bits(*) = float(data(23,*))			; 130
  hdata_1999.gated_strobes(*) = float(data(40,*))		; 190
  hdata_1999.total_strobes(*) = float(data(41,*))		; 191
  hdata_1999.fssp_range(*) = float(data(42,*))			; 192
  hdata_1999.fssp_tot_cnts(*) = float(data(43,*))		; 141
  hdata_1999.fssp_ave_diam(*) = float(data(44,*))		; 142
  hdata_1999.tot_part_conc(*) = float(data(45,*))		; 143
  hdata_1999.fssp_lw(*) = float(data(46,*))				; 144
  hdata_1999.activity(*) = float(data(47,*))			; 145
  hdata_1999.equiv_diam(*) = float(data(48,*))			; 148
  hdata_1999.var(*) = float(data(49,*))					; 149
  ;hdata_1999.jw_water(*) = float(data(50,*))			; 244
  hdata_1999.shad_or_2dc(*) = float(data(51,*))			; 146
  hdata_1999.slow_particle(*) = float(data(66,*))		; 151
  hdata_1999.hail_tot_cnts(*) = float(data(67,*))		; 152
  hdata_1999.hail_ave_diam(*) = float(data(68,*))		; 153
  hdata_1999.hail_conc(*) = float(data(69,*))			; 154
  hdata_1999.hail_water(*) = float(data(70,*))/100.0			; 155
  hdata_1999.tfm_lo(*) = float(data(71,*))				; 160
  hdata_1999.bfm_lo(*) = float(data(72,*))				; 161
  hdata_1999.lfm_lo(*) = float(data(73,*))				; 162
  hdata_1999.rfm_lo(*) = float(data(74,*))				; 163
  hdata_1999.fm5_hi(*) = float(data(75,*))				; 168
  ;hdata_1999.fm6_hi(*) = float(data(76,*))				; 169
  hdata_1999.accel_x(*) = float(data(77,*))				; 290
  hdata_1999.accel_y(*) = float(data(78,*))				; 291
  hdata_1999.accel_z(*) = float(data(79,*))				; 292
  hdata_1999.lat_dec_deg_hirate(*) = float(data(80,*))	; 172
  hdata_1999.lon_dec_deg_hirate(*) = float(data(81,*))	; 173
  hdata_1999.gps_grd_spd(*) = float(data(82,*))			; 174
  hdata_1999.gps_grd_trk_angle(*) = float(data(83,*))	; 175
  hdata_1999.gps_mag_var(*) = float(data(84,*))			; 176
  hdata_1999.gps_alt(*) = float(data(86,*))				; 178
  hdata_1999.gps_roc(*) = float(data(87,*))				; 185
  hdata_1999.pelev(*) = float(data(93,*))				; 205
  hdata_1999.thetae(*) = float(data(94,*))				; 206
  ;hdata_1999.sat_mix_ratio(*) = float(data(95,*))		; 207
  hdata_1999.dzdt(*) = float(data(96,*))				; 208
  hdata_1999.indic_as(*) = float(data(97,*))			; 209
  ;hdata_1999.updraft_uncor(*) = float(data(98,*))		; 210
  hdata_1999.calc_tas(*) = float(data(99,*))			; 211
  ;hdata_1999.updrft_cor_factor(*) = float(data(100,*))	; 212
  hdata_1999.cooper_updraft(*) = float(data(101,*))		; 213
  hdata_1999.kopp_updraft(*) = float(data(102,*))		; 214
  hdata_1999.turb(*) = float(data(103,*))				; 216
  ;hdata_1999.densmid(*) = float(data(104,*))			; 217
  ;hdata_1999.JW_mix_ratio(*) = float(data(106,*))		; 218
  hdata_1999.fssp_mix_ratio(*) = float(data(105,*))		; 219
  hdata_1999.hail_mix_ratio(*) = float(data(106,*))/100.0		; 220
  ;hdata_1999.rft_uncorr(*) = float(data(107,*))			; 221

; recalculate the electric field relative to airplane, the way Dr. Mo described
; in his article in 1999; I used the equations from read_rawD.pro program
;============================================================================
;- Electric field calculations
;- new method developed by Dr. Mo - valid from 1993 - 1999 - Aircraft Reference Frame
; original equations are using fm5_lo, but in 1995 we do not record but fm5_hi
;-----------------------------------------------------------------------
hdata_1999.ex_aircraft =   0.0357 * hdata_1999.lfm_lo + 0.0496 * hdata_1999.rfm_lo + 0.0528 * hdata_1999.fm5_hi     ;tag 260? Eqx aircraft relative
hdata_1999.ey_aircraft  = -(0.0231 * hdata_1999.lfm_lo - 0.0230 * hdata_1999.rfm_lo + 0.0031 * hdata_1999.fm5_hi)   ;tag 261? Ey aircraft relative
hdata_1999.ez_aircraft  =   0.0843 * hdata_1999.lfm_lo + 0.0229 * hdata_1999.rfm_lo - 0.1735 * hdata_1999.fm5_hi    ;tag 262? Ez aircraft relative
;stop
;Flight Path Reference Frame - valid as April 1, 2002
;---------preliminary calculations---------------------------
PI = 3.1415927
p = hdata_1999.pitch*PI/180.     ;pitch in radians
r = hdata_1999.roll*PI/180.   ;roll in radians
;ht = htd*PI/180.          ;conversion of true heading to radians
gta = hdata_1999.gps_grd_trk_angle*PI/180. ; in radians
sp = sin(p)           ;sine of pitch
sr = sin(r)
;sht = sin(ht)
sgta = sin(gta)
cp = cos(p)           ;sine of pitch
cr = cos(r)
;cht = cos(ht)
cgta = cos(gta)
;-------------------------------------------------------------------
hdata_1999.ex_path = hdata_1999.ex_aircraft*cp+hdata_1999.ey_aircraft*(-sp)*(-sr) + hdata_1999.ez_aircraft*(-sp)*cr		;tag 263? Ex path relative
hdata_1999.ey_path = hdata_1999.ey_aircraft*cr + hdata_1999.ez_aircraft*sr                              				;tag 264? Ey path relative
hdata_1999.ez_path = hdata_1999.ex_aircraft*sp + hdata_1999.ey_aircraft*cp*(-sr)+hdata_1999.ez_aircraft*cp*cr    		;tag 265? Ez path relative
;stop
;Earth reference frame - valid as April 1, 2002
;--------------------------------------------------------------------
hdata_1999.ex_earth = hdata_1999.ex_aircraft*(sgta*cp) + hdata_1999.ey_aircraft*(sgta*(-sp)*(-sr) +$					;tag 266? Ex Earth relative
         (-cgta)*cr) + hdata_1999.ez_aircraft*(sgta(-sp)*cr + (-cgta)*sr)

hdata_1999.ey_earth = hdata_1999.ex_aircraft*(cgta*cp) + hdata_1999.ey_aircraft*(cgta*(-sp)*(-sr) + $					;tag 267? Ey Earth relative
         sgta*cr) + hdata_1999.ez_aircraft*(cgta*(-sp)*cr + sgta*sr)

hdata_1999.ez_earth = hdata_1999.ex_aircraft*(sp) + hdata_1999.ey_aircraft*(cp*(-sr)) + hdata_1999.ez_aircraft*(cp*cr) 	;tag 268? Ez Earth relative

; For 1993- 1999 the hdata.eq_aircraft = hdata.ex_aircraft the best estimate of both
hdata_1999.eq_aircraft = hdata_1999.ex_aircraft


;  hdata_1999.gps_lat_deg(*) = float(data(119,*))		; 272
;  hdata_1999.gps_lat_min(*) = float(data(120,*))		; 273
;  hdata_1999.gps_lon_deg(*) = float(data(121,*))		; 274
;  hdata_1999.gps_lon_min(*) = float(data(122,*))		; 275
;  hdata_1999.gps_grd_track(*) = float(data(123,*))		; 276

;stop
end