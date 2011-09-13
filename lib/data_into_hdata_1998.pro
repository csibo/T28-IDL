;
;data_into_hdata.pro
;
; Program written: April 11, 2008
; Reviewed: April 11, 2008
; Author: Donna Kliche
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO data_into_hdata_1998, start_buff, end_buff, data, hdata_1998, hours_str, minutes_str, seconds_str,list_var

;populate hdata with the values we need to display
  hdata_1998.hours_hirate(*) = float(hours_str(start_buff:end_buff))
  hdata_1998.minutes_hirate(*) = float(minutes_str(start_buff:end_buff))
  hdata_1998.dec_seconds_hirate(*) = float(seconds_str(start_buff:end_buff))
  hdata_1998.dyn_press_1(*) = float(data(1,*))			; 101
  hdata_1998.dyn_press_2(*) = float(data(2,*))			; 102
  hdata_1998.stat_press_1(*) = float(data(3,*))			; 103
  hdata_1998.stat_press_2(*) = float(data(4,*))			; 104
  ;hdata_1998.roc(*) = float(data(5,*))					; 105
  hdata_1998.rose(*) = float(data(6,*))					; 106
  hdata_1998.rft(*) = float(data(7,*))					; 107
  hdata_1998.man_press(*) = float(data(8,*))			; 108
  hdata_1998.accel(*) = float(data(9,*))				; 109
  hdata_1998.pitch(*) = float(data(10,*))				; 110
  hdata_1998.roll(*) = float(data(11,*))				; 111
  hdata_1998.vor(*) = float(data(12,*))					; 113
  hdata_1998.dme1(*) = float(data(13,*))				; 114
  hdata_1998.volt_reg(*) = float(data(14,*))			; 116
  hdata_1998.heading(*) = float(data(15,*))				; 117
  hdata_1998.ncar_tas(*) = float(data(16,*))			; 118
  hdata_1998.pms_ee1(*) = float(data(17,*))				; 119
  hdata_1998.pms_ee2(*) = float(data(18,*))				; 120
  hdata_1998.int_temp(*) = float(data(19,*))			; 121
  ;hdata_1998.hv_current(*) = float(data(20,*))			; 123
  hdata_1998.htr_current(*) = float(data(21,*))			; 124
  hdata_1998.dmt_lw(*) = float(data(22,*))				; 186
  hdata_1998.event_bits(*) = float(data(23,*))			; 130
  hdata_1998.gated_strobes(*) = float(data(40,*))		; 190
  hdata_1998.total_strobes(*) = float(data(41,*))		; 191
  hdata_1998.fssp_range(*) = float(data(42,*))			; 192
  hdata_1998.fssp_tot_cnts(*) = float(data(43,*))		; 141
  hdata_1998.fssp_ave_diam(*) = float(data(44,*))		; 142
  hdata_1998.tot_part_conc(*) = float(data(45,*))		; 143
  hdata_1998.fssp_lw(*) = float(data(46,*))				; 144
  hdata_1998.activity(*) = float(data(47,*))			; 145
  hdata_1998.equiv_diam(*) = float(data(48,*))			; 148
  hdata_1998.var(*) = float(data(49,*))					; 149
  ;hdata_1998.jw_water(*) = float(data(50,*))			; 244
  hdata_1998.shad_or_2dc(*) = float(data(51,*))			; 147
  hdata_1998.slow_particle(*) = float(data(66,*))		; 151
  hdata_1998.hail_tot_cnts(*) = float(data(67,*))		; 152
  hdata_1998.hail_ave_diam(*) = float(data(68,*))		; 153
  hdata_1998.hail_conc(*) = float(data(69,*))			; 154
  hdata_1998.hail_water(*) = float(data(70,*))			; 155
  hdata_1998.tfm_lo(*) = float(data(71,*))				; 160
  hdata_1998.bfm_lo(*) = float(data(72,*))				; 161
  hdata_1998.lfm_lo(*) = float(data(73,*))				; 162
  hdata_1998.rfm_lo(*) = float(data(74,*))				; 163
  hdata_1998.tfm_hi(*) = float(data(75,*))				; 164
  hdata_1998.bfm_hi(*) = float(data(76,*))				; 165
  hdata_1998.lfm_hi(*) = float(data(77,*))				; 166
  hdata_1998.rfm_hi(*) = float(data(78,*))				; 167
  hdata_1998.fm5_hi(*) = float(data(79,*))				; 168
  hdata_1998.quad_1(*) = float(data(80,*))				; 132
  hdata_1998.quad_2(*) = float(data(81,*))				; 133
  hdata_1998.quad_3(*) = float(data(82,*))				; 134
  hdata_1998.quad_4(*) = float(data(83,*))				; 135
  hdata_1998.quad_5(*) = float(data(84,*))				; 136
  hdata_1998.quad_6(*) = float(data(85,*))				; 137
  hdata_1998.quad_7(*) = float(data(86,*))				; 138
  hdata_1998.quad_8(*) = float(data(87,*))				; 139
  hdata_1998.lat_dec_deg_hirate(*) = float(data(88,*))	; 172
  hdata_1998.lon_dec_deg_hirate(*) = float(data(89,*))	; 173
  hdata_1998.gps_grd_spd(*) = float(data(90,*))			; 174
  hdata_1998.gps_grd_trk_angle(*) = float(data(91,*))	; 175
  hdata_1998.gps_mag_var(*) = float(data(92,*))			; 176
  hdata_1998.gps_alt(*) = float(data(94,*))				; 178
  hdata_1998.gps_roc(*) = float(data(95,*))				; 185
  hdata_1998.pelev(*) = float(data(101,*))				; 205
  hdata_1998.thetae(*) = float(data(102,*))				; 206
  ;hdata_1998.sat_mix_ratio(*) = float(data(103,*))		; 207
  hdata_1998.dzdt(*) = float(data(104,*))				; 208
  hdata_1998.indic_as(*) = float(data(105,*))			; 209
  ;hdata_1998.updraft_uncor(*) = float(data(106,*))		; 210
  hdata_1998.calc_tas(*) = float(data(107,*))			; 211
  ;hdata_1998.updrft_cor_factor(*) = float(data(108,*))	; 212
  hdata_1998.cooper_updraft(*) = float(data(109,*))		; 213
  hdata_1998.kopp_updraft(*) = float(data(110,*))		; 214
  hdata_1998.turb(*) = float(data(111,*))				; 216
  ;hdata_1998.densmid(*) = float(data(112,*))			; 217
  hdata_1998.fssp_mix_ratio(*) = float(data(113,*))		; 219
  hdata_1998.hail_mix_ratio(*) = float(data(114,*))		; 220
  ;hdata_1998.rft_uncorr(*) = float(data(115,*))			; 221

; recalculate the electric field relative to airplane, the way Dr. Mo described
; in his article in 1998; I used the equations from read_rawD.pro program
;============================================================================
;- Electric field calculations
;- new method developed by Dr. Mo - valid from 1993 - 1998 - Aircraft Reference Frame
; original equations are using fm5_lo, but in 1995 we do not record but fm5_hi
;-----------------------------------------------------------------------
hdata_1998.ex_aircraft =   0.0357 * hdata_1998.lfm_lo + 0.0496 * hdata_1998.rfm_lo + 0.0528 * hdata_1998.fm5_hi     ;tag 260? Eqx aircraft relative
hdata_1998.ey_aircraft  = -(0.0231 * hdata_1998.lfm_lo - 0.0230 * hdata_1998.rfm_lo + 0.0031 * hdata_1998.fm5_hi)   ;tag 261? Ey aircraft relative
hdata_1998.ez_aircraft  =   0.0843 * hdata_1998.lfm_lo + 0.0229 * hdata_1998.rfm_lo - 0.1735 * hdata_1998.fm5_hi    ;tag 262? Ez aircraft relative
;stop
;Flight Path Reference Frame - valid as April 1, 2002
;---------preliminary calculations---------------------------
PI = 3.1415927
p = hdata_1998.pitch*PI/180.     ;pitch in radians
r = hdata_1998.roll*PI/180.   ;roll in radians
;ht = htd*PI/180.          ;conversion of true heading to radians
gta = hdata_1998.gps_grd_trk_angle*PI/180. ; in radians
sp = sin(p)           ;sine of pitch
sr = sin(r)
;sht = sin(ht)
sgta = sin(gta)
cp = cos(p)           ;sine of pitch
cr = cos(r)
;cht = cos(ht)
cgta = cos(gta)
;-------------------------------------------------------------------
hdata_1998.ex_path = hdata_1998.ex_aircraft*cp+hdata_1998.ey_aircraft*(-sp)*(-sr) + hdata_1998.ez_aircraft*(-sp)*cr		;tag 263? Ex path relative
hdata_1998.ey_path = hdata_1998.ey_aircraft*cr + hdata_1998.ez_aircraft*sr                              				;tag 264? Ey path relative
hdata_1998.ez_path = hdata_1998.ex_aircraft*sp + hdata_1998.ey_aircraft*cp*(-sr)+hdata_1998.ez_aircraft*cp*cr    		;tag 265? Ez path relative
;stop
;Earth reference frame - valid as April 1, 2002
;--------------------------------------------------------------------
hdata_1998.ex_earth = hdata_1998.ex_aircraft*(sgta*cp) + hdata_1998.ey_aircraft*(sgta*(-sp)*(-sr) +$					;tag 266? Ex Earth relative
         (-cgta)*cr) + hdata_1998.ez_aircraft*(sgta(-sp)*cr + (-cgta)*sr)

hdata_1998.ey_earth = hdata_1998.ex_aircraft*(cgta*cp) + hdata_1998.ey_aircraft*(cgta*(-sp)*(-sr) + $					;tag 267? Ey Earth relative
         sgta*cr) + hdata_1998.ez_aircraft*(cgta*(-sp)*cr + sgta*sr)

hdata_1998.ez_earth = hdata_1998.ex_aircraft*(sp) + hdata_1998.ey_aircraft*(cp*(-sr)) + hdata_1998.ez_aircraft*(cp*cr) 	;tag 268? Ez Earth relative

; For 1993- 1998 the hdata.eq_aircraft = hdata.ex_aircraft the best estimate of both
hdata_1998.eq_aircraft = hdata_1998.ex_aircraft
																	;tag 269? charge Eq on aircraft

;  hdata_1998.gps_lat_deg(*) = float(data(127,*))		; 272
;  hdata_1998.gps_lat_min(*) = float(data(128,*))		; 273
;  hdata_1998.gps_lon_deg(*) = float(data(129,*))		; 274
;  hdata_1998.gps_lon_min(*) = float(data(130,*))		; 275
;  hdata_1998.gps_grd_track(*) = float(data(131,*))		; 276

;stop
end