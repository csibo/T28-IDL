;-
;- init_tags.pro
;- initialize the structure that contains all the reduced quantities
;- and the tag numbers, labels, format, and min/max

pro init_tagsT2_yr1999,num_pts,hdata_1999,metadata,num_tags, list_var

hdata_1999 = { hours_hirate:       fltarr(num_pts), $    ;0  100
          minutes_hirate:     fltarr(num_pts), $    ;1  100
          dec_seconds_hirate: fltarr(num_pts), $    ;2  100
          dyn_press_1:        fltarr(num_pts), $	;3  101
          dyn_press_2:        fltarr(num_pts), $	;4  102
          stat_press_1:       fltarr(num_pts), $	;5  103
          stat_press_2:       fltarr(num_pts), $	;6  104
          ;roc:                fltarr(num_pts), $	;7  105
          rose:               fltarr(num_pts), $	;7  106
          rft:                fltarr(num_pts), $	;8  107
          man_press:          fltarr(num_pts), $	;9 108
          accel:              fltarr(num_pts), $	;10 109
          pitch:              fltarr(num_pts), $	;11 110
          roll:               fltarr(num_pts), $	;12 111
          vor:                fltarr(num_pts), $	;13 113
          dme1:               fltarr(num_pts), $	;14 114
          volt_reg:           fltarr(num_pts), $	;15 116
          heading:            fltarr(num_pts), $	;16 117
          ncar_tas:           fltarr(num_pts), $	;17 118
          pms_ee1:            fltarr(num_pts), $	;18 119
          pms_ee2:            fltarr(num_pts), $	;19 120
          int_temp:           fltarr(num_pts), $	;20 121
          ;hv_current:         fltarr(num_pts), $	;22 123
          htr_current:         fltarr(num_pts), $	;21 124
          dmt_lw:             fltarr(num_pts), $	;22 186 -
          event_bits:         fltarr(num_pts), $	;23 130 -
          gated_strobes:      fltarr(num_pts), $	;24 190
          total_strobes:      fltarr(num_pts), $	;25 191
          fssp_range:         fltarr(num_pts), $	;26 192
          fssp_tot_cnts:      fltarr(num_pts), $	;27 141
          fssp_ave_diam:      fltarr(num_pts), $	;28 142
          tot_part_conc:      fltarr(num_pts), $	;29 143
          fssp_lw:            fltarr(num_pts), $	;30 144
          activity:           fltarr(num_pts), $	;31 145
          equiv_diam:         fltarr(num_pts), $	;32 148
          var:                fltarr(num_pts), $	;33 149
          ;jw_water:           fltarr(num_pts), $	;36 244 -
          shad_or_2dc:        fltarr(num_pts), $	;34 147
          slow_particle:      fltarr(num_pts), $	;35 151 -
          hail_tot_cnts:      fltarr(num_pts), $	;36 152
          hail_ave_diam:      fltarr(num_pts), $	;37 153
          hail_conc:          fltarr(num_pts), $	;38 154
          hail_water:         fltarr(num_pts), $	;39 155
          tfm_lo:             fltarr(num_pts), $	;40 160
          bfm_lo:             fltarr(num_pts), $	;41 161
          lfm_lo:             fltarr(num_pts), $	;42 162
          rfm_lo:             fltarr(num_pts), $	;43 163
          fm5_hi:             fltarr(num_pts), $	;44 168
          ;fm6_hi:             fltarr(num_pts), $	;45 169 ; only voltage because it was not calibrated
          accel_x:            fltarr(num_pts), $	;45 290 -
          accel_y:            fltarr(num_pts), $	;46 291 -
          accel_z:            fltarr(num_pts), $	;47 292 -
          lat_dec_deg_hirate: fltarr(num_pts), $	;48 172
          lon_dec_deg_hirate: fltarr(num_pts), $	;49 173
          gps_grd_spd:        fltarr(num_pts), $	;50 174
          gps_grd_trk_angle:  fltarr(num_pts), $	;51 175
          gps_mag_var:        fltarr(num_pts), $	;52 176
          gps_alt:            fltarr(num_pts), $	;53 178
          gps_roc:            fltarr(num_pts), $    ;54 185
          pelev:              fltarr(num_pts), $	;55 205
          thetae:             fltarr(num_pts), $	;56 206
          ;sat_mix_ratio:      fltarr(num_pts), $	;61 207
          dzdt:               fltarr(num_pts), $	;57 208
          indic_as:           fltarr(num_pts), $	;58 209
          ;updraft_uncor:      fltarr(num_pts), $	;64 210
          calc_tas:           fltarr(num_pts), $	;59 211
          ;updrft_cor_factor:  fltarr(num_pts), $	;66 212
          cooper_updraft:     fltarr(num_pts), $	;60 213
          kopp_updraft:       fltarr(num_pts), $	;61 214
          turb:               fltarr(num_pts), $	;62 216
          ;densmid:            fltarr(num_pts), $	;70 217
          fssp_mix_ratio:     fltarr(num_pts), $	;63 219
          hail_mix_ratio:     fltarr(num_pts), $	;64 220
          ;rft_uncorr:         fltarr(num_pts), $	;73 221 -
          ez_aircraft:		  fltarr(num_pts), $	;65 260
          ey_aircraft:        fltarr(num_pts), $	;66 261
          ex_aircraft:        fltarr(num_pts), $	;67 262
          ez_path:            fltarr(num_pts), $	;68 263
          ey_path:    		  fltarr(num_pts), $	;69 264
          ex_path:    		  fltarr(num_pts), $	;70 265
          ex_earth:           fltarr(num_pts), $	;71 266
          ey_earth:           fltarr(num_pts), $	;72 267
          ez_earth:           fltarr(num_pts), $	;73 268
          eq_aircraft:        fltarr(num_pts)}   	;74 269
          ;gps_lat_deg:        fltarr(num_pts), $	;84 272 -
          ;gps_lat_min:        fltarr(num_pts), $	;85 273 -
          ;gps_lon_deg:        fltarr(num_pts), $	;86 274 -
          ;gps_lon_min:        fltarr(num_pts), $	;87 275 -
          ;gps_grd_track:      fltarr(num_pts)}	    ;88 276 -


num_tags = n_elements(tag_names(hdata_1999))
list_var = tag_names(hdata_1999)
;stop
metadata = replicate({md,tag_num: 0, plabel: '', slabel: '', units: '', form: '', dmin: 0., dmax: 0.},num_tags)

metadata(0)  = { md , 100 , 'Hours'              , 'Hrs'  , 'hr'      , 'i6'   ,    0. ,   24. }
metadata(1)  = { md , 100 , 'Minutes'            , 'Min'  , 'mn'      , 'i6'   ,    0. ,   60. }
metadata(2)  = { md , 100 , 'Seconds'            , 'Sec'  , 'sc'      , 'f8.2' ,    0. ,   60. }
metadata(3)  = { md , 101 , 'Dynamic Pressure 1' , 'DP1'  , 'mb'      , 'f8.4' ,    0. ,   25. }
metadata(4)  = { md , 102 , 'Dynamic Pressure 2' , 'DP2'  , 'mb'      , 'f8.4' ,    0. ,   25. }
metadata(5)  = { md , 103 , 'Static Pressure 1'  , 'SP1'  , 'mb'      , 'f9.4' ,  500. , 1000. }
metadata(6)  = { md , 104 , 'Static Pressure 2'  , 'SP2'  , 'mb'      , 'f9.4' ,  500. , 1000. }
;metadata(7)  = { md , 105 , 'Rate of Climb'      , 'ROC'  , 'm/s'     , 'f9.4' ,  -15. ,   15. }
metadata(7)  = { md , 106 , 'Rosemount Temp'     , 'Rose' , 'deg C'   , 'f9.4' ,  -10. ,   30. }
metadata(8)  = { md , 107 , 'RFT'                , 'RFT'  , 'deg C'   , 'f9.4' ,  -10. ,   30. }
metadata(9) = { md , 108 , 'Manifold Pressure'  , 'MP'   , 'inches'  , 'f5.1' ,    0. ,   50. }
metadata(10) = { md , 109 , 'Acceleration'       , 'Accel', 'g'       , 'f7.4' ,    0. ,    2. }
metadata(11) = { md , 110 , 'Pitch'              , 'Pitch', 'deg'     , 'f9.4' ,  -10. ,   15. }
metadata(12) = { md , 111 , 'Roll'               , 'Roll' , 'deg'     , 'f9.4' ,  -40. ,   40. }
metadata(13) = { md , 113 , 'VOR'                , 'VOR'  , 'deg'     , 'f6.1' ,    0. ,  360. }
metadata(14) = { md , 114 , 'DME1'               , 'DME'  , 'n mi'    , 'f6.1' ,    0. ,  100. }
metadata(15) = { md , 116 , 'Voltage Regulator'  , 'VReg' , 'V'       , 'f5.1' ,   -5. ,    5. }
metadata(16) = { md , 117 , 'Heading'            , 'Hdg'  , 'deg'     , 'f6.1' ,    0. ,  360. }
metadata(17) = { md , 118 , 'NCAR TAS'           , 'NTAS' , 'm/s'     , 'f6.1' ,   50. ,  125. }
metadata(18) = { md , 119 , 'PMS End Element 1'  , 'EE1'  , 'V'       , 'f5.1' ,    0. ,   50. }
metadata(19) = { md , 120 , 'PMS End Element 2'  , 'EE2'  , 'V'       , 'f5.1' ,    0. ,   50. }
metadata(20) = { md , 121 , 'Internal Temp'      , 'IntT' , 'deg C'   , 'f6.1' ,  -10. ,   40. }
;metadata(22) = { md , 123 , 'HV Current'         , 'HVCur', 'A'       , 'f4.1' ,    0. ,    1. }
metadata(21) = { md , 124 , 'Heater Current'     , 'HtrCr', 'A'       , 'f6.1' ,    0. ,  100. }
metadata(22) = { md , 186 , 'DMT Probe LW'       , 'DMTLW', 'g/m3'    , 'f4.1' ,    0. ,    4. } ;-
metadata(23) = { md , 130 , 'Event Bits'         , 'EBts',' '         , 'f4.1' ,    0. ,    4. } ;-
metadata(24) = { md , 190 , 'FSSP Gated Strobes' , 'GStrb', '#'       , 'f7.1' ,    0. , 1000. }
metadata(25) = { md , 191 , 'FSSP Total Strobes' , 'TStrb', '#'       , 'f7.1' ,    0. , 1000. }
metadata(26) = { md , 192 , 'FSSP Range'         , 'Rng'  , 'V'       , 'f5.1' ,    0. ,   30. }
metadata(27) = { md , 141 , 'FSSP Total Counts'  , 'TCnts', '#'       , 'f7.1' ,    0. , 1000. }
metadata(28) = { md , 142 , 'FSSP Average Diam'  , 'ADiam', 'um'      , 'f5.1' ,    0. ,   40. }
metadata(29) = { md , 143 , 'FSSP Concentration' , 'Conc' , '#/cm3'   , 'f6.1' ,    0. ,  400. }
metadata(30) = { md , 144 , 'FSSP LW'            , 'FLWC' , 'g/m3'    , 'f9.6' ,    0. ,    4. }
metadata(31) = { md , 145 , 'FSSP Activity'      , 'Act'  , '%'       , 'f6.1' ,    0. ,  100. }
metadata(32) = { md , 148 , 'FSSP Equiv Diam'    , 'EqDia', 'um'      , 'f5.1' ,    0. ,   40. }
metadata(33) = { md , 149 , 'FSSP ED Variance'   , 'Var'  , 'um'      , 'f5.1' ,    0. ,   10. }
;metadata(36) = { md , 244 , 'JW Equivalent Water', 'JWwater','g/m3'   , 'f4.1' ,    0. ,    4. } ;-
metadata(34) = { md , 147 , '2DC Shadow OR'      , 'ShdOR', '#'       , 'f7.1' ,    0. , 1000. } ;-
metadata(35) = { md , 151 , 'Slow Particle Counts', 'SPcnts', '#'     , 'f7.1' ,    0. , 1000. } ;-
metadata(36) = { md , 152 , 'Hail Total Counts'  , 'HTCnt', '#'       , 'f6.1' ,    0. ,  100. }
metadata(37) = { md , 153 , 'Hail Average Diam'  , 'HADia', 'cm'      , 'f4.1' ,    0. ,    5. }
metadata(38) = { md , 154 , 'Hail Concentration' , 'HConc', '#/m3'    , 'f5.1' ,    0. ,   10. }
metadata(39) = { md , 155 , 'Hail Water'         , 'HWatr', 'g/m3'    , 'f4.1' ,    0. ,    1. }
metadata(40) = { md , 160 , 'Top FM (Low Res)'   , 'TFM'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(41) = { md , 161 , 'Bottom FM (Low Res)', 'BFM'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(42) = { md , 162 , 'Left FM (Low Res)'  , 'LFM'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(43) = { md , 163 , 'Right FM (Low Res)' , 'RFM'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(44) = { md , 168 , 'Fifth FM (Low Res)' , 'FM5'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
;metadata(45) = { md , 169 , 'Sixth FM (Low Res)' , 'FM6'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(45) = { md , 290 , 'Accel X'            , 'AccX' , 'g'       , 'f5.1' ,   -1. ,    1. } ;-
metadata(46) = { md , 291 , 'Accel Y'            , 'AccY' , 'g'       , 'f5.1' ,   -1. ,    1. } ;-
metadata(47) = { md , 292 , 'Accel Z'            , 'AccZ' , 'g'       , 'f4.1' ,    0. ,    2. } ;-
metadata(48) = { md , 172 , 'Latitude'           , 'Lat'  , 'deg'     , 'f11.5' ,   30. ,   50. }
metadata(49) = { md , 173 , 'Longitude'          , 'Lon'  , 'deg'     , 'f11.5' , -100. , -130. }
metadata(50) = { md , 174 , 'GPS Ground Speed'   , 'GSpd' , 'm/s'     , 'f6.1' ,    0. ,  125. }
metadata(51) = { md , 175 , 'GPS Grd Track Angle', 'GTA'  , 'deg'     , 'f6.1' ,    0. ,  360. }
metadata(52) = { md , 176 , 'GPS Magnetic Dev'   , 'MDev' , 'deg'     , 'f5.1' ,    0. ,   20. }
metadata(53) = { md , 178 , 'GPS Altitude'       , 'Alt'  , 'm'       , 'f7.1' ,    0. , 5000. }
metadata(54) = { md , 185 , 'GPS Rate of Climb'  , 'GROC' , 'm/s'     , 'f6.1' ,  -15. ,   15. }
metadata(55) = { md , 205 , 'Pressure Altitude'  , 'PAlt' , 'm'       , 'f9.4' ,    0. , 5000. }
metadata(56) = { md , 206 , 'Theta E'            , 'ThE'  , 'deg K'   , 'f6.1' ,  275. ,  325. }
;metadata(61) = { md , 207 , 'Saturation Mix Rat' , 'SMR'  , 'g/kg'    , 'f4.1' ,    0. ,    1. }
metadata(57) = { md , 208 , 'dzdt'               , 'DZDT' , 'm/s'     , 'f9.4' ,  -10. ,   10. }
metadata(58) = { md , 209 , 'Indicated Air Speed', 'IAS'  , 'm/s'     , 'f9.4' ,    0. ,  200. }
;metadata(60) = { md , 210 , 'Updraft (Uncorr)'   , 'UpUn' , 'm/s'     , 'f6.1' ,  -10. ,   10. }
metadata(59) = { md , 211 , 'Calculated TAS'     , 'CTAS' , 'm/s'     , 'f6.1' ,    0. ,  125. }
;metadata(66) = { md , 212 , 'Updraft Corr Factor', 'UCF'  , 'm/s'     , 'f6.1' ,  -10. ,   10. }
metadata(60) = { md , 213 , 'Cooper Updraft'     , 'CooUp', 'm/s'     , 'f6.1' ,  -15. ,   15. }
metadata(61) = { md , 214 , 'Updraft'            , 'KoppU', 'm/s'     , 'f9.4' ,  -15. ,   15. }
metadata(62) = { md , 216 , 'Turbulence'         , 'Turb' , 'cm2/3 /s', 'f5.1' ,    0. ,   15. }
;metadata(70) = { md , 217 , 'Air Density'        , 'AirDe', 'kg/m3'   , 'f4.1' ,    0. ,    2. }
metadata(63) = { md , 219 , 'FSSP Mixing Ratio'  , 'FMR'  , 'g/kg'    , 'f4.1' ,    0. ,    1. }
metadata(64) = { md , 220 , 'Hail Mixing Ratio'  , 'HMR'  , 'g/kg'    , 'f4.1' ,    0. ,    1. }
;metadata(73) = { md , 221 , 'RFT Uncorrected'    , 'RFT_un'  , 'deg C'    , 'f9.4' ,    -10. ,    30. } ;-
metadata(65) = { md , 260 , 'Ex Aircraft Ref'    , 'EzAirc', 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(66) = { md , 261 , 'Ey Aircraft Ref'    , 'EyAirc', 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(67) = { md , 262 , 'Ez Aircraft Ref'    , 'ExAirc', 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(68) = { md , 263 , 'Ex Flight Path Ref' , 'EzFPR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(69) = { md , 264 , 'Ey Flight Path Ref' , 'EyFPR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(70) = { md , 265 , 'Ez Flight Path Ref' , 'ExFPR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(71) = { md , 266 , 'Ex Earth Ref'       , 'ExER' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(72) = { md , 267 , 'Ey Earth Ref'       , 'EyFR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(73) = { md , 268 , 'Ez Earth Ref'       , 'EzFR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(74) = { md , 269 , 'Airplane Charge'    , 'EqA'  , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
;metadata(84) = { md , 272 , 'GPS Latitude'        ,'GPSLat_d'  , 'deg'    , 'f11.5' ,   30. ,    50. } ;-
;metadata(85) = { md , 273 , 'GPS Latitude'        ,'GPSLat_m'  , 'min'    , 'f11.5' ,   0. ,    60. } ;-
;metadata(86) = { md , 274 , 'GPS Longitude'       , 'GPSLon_d'  , 'deg'    , 'f11.5' ,   -100. ,    -130. } ;-
;metadata(87) = { md , 275 , 'GPS Longitude'       , 'GPSLon_m'  , 'min'    , 'f11.5' ,   0. ,    -60. } ;-
;metadata(88) = { md , 276 , 'Ground Trk Angle'    , 'GTAng'  , 'deg'    , 'f5.1' ,   0. ,    360. } ;-


end


