;-
;- init_tags.pro
;- initialize the structure that contains all the reduced quantities
;- and the tag numbers, labels, format, and min/max

pro init_tagsT2,num_pts,hdata,metadata,num_tags

hdata = { hours_hirate:       fltarr(num_pts), $    ;0  100
          minutes_hirate:     fltarr(num_pts), $    ;1  100
          dec_seconds_hirate: fltarr(num_pts), $    ;2  100
          dyn_press_1:        fltarr(num_pts), $	;3  101
          dyn_press_2:        fltarr(num_pts), $	;4  102
          stat_press_1:       fltarr(num_pts), $	;5  103
          stat_press_2:       fltarr(num_pts), $	;6  104
          roc:                fltarr(num_pts), $	;7  105
          rose:               fltarr(num_pts), $	;6  106
          rft:                fltarr(num_pts), $	;7  107
          man_press:          fltarr(num_pts), $	;8 108
          accel:              fltarr(num_pts), $	;9 109
          pitch:              fltarr(num_pts), $	;10 110
          roll:               fltarr(num_pts), $	;11 111
          vor:                fltarr(num_pts), $	;12 113
          dme1:               fltarr(num_pts), $	;13 114
          volt_reg:           fltarr(num_pts), $	;14 116
          heading:            fltarr(num_pts), $	;15 117
          ncar_tas:           fltarr(num_pts), $	;16 118
          pms_ee1:            fltarr(num_pts), $	;17 119
          pms_ee2:            fltarr(num_pts), $	;18 120
          int_temp:           fltarr(num_pts), $	;19 121
          hv_current:         fltarr(num_pts), $	;20 123
          htr_curent:         fltarr(num_pts), $	;21 124
          sr1:                fltarr(num_pts), $	;22 128
          sr2:                fltarr(num_pts), $	;23 129
          fssp_tot_cnts:      fltarr(num_pts), $	;24 141
          fssp_ave_diam:      fltarr(num_pts), $	;25 142
          tot_part_conc:      fltarr(num_pts), $	;26 143
          fssp_lw:            fltarr(num_pts), $	;27 144
          activity:           fltarr(num_pts), $	;28 145
          shad_or_2dc:        fltarr(num_pts), $	;29 147
          equiv_diam:         fltarr(num_pts), $	;30 148
          var:                fltarr(num_pts), $	;31 149
          hail_tot_cnts:      fltarr(num_pts), $	;32 152
          hail_ave_diam:      fltarr(num_pts), $	;33 153
          hail_conc:          fltarr(num_pts), $	;34 154
          hail_water:         fltarr(num_pts), $	;35 155
          tfm_lo:             fltarr(num_pts), $	;36 160
          bfm_lo:             fltarr(num_pts), $	;37 161
          lfm_lo:             fltarr(num_pts), $	;38 162
          rfm_lo:             fltarr(num_pts), $	;39 163
          fm5_lo:             fltarr(num_pts), $	;40 168
          fm6_lo:             fltarr(num_pts), $	;41 169
          shad_or_hvps:       fltarr(num_pts), $	;42 170
          lat_dec_deg_hirate: fltarr(num_pts), $	;43 172
          lon_dec_deg_hirate: fltarr(num_pts), $	;44 173
          gps_grd_spd:        fltarr(num_pts), $	;45 174
          gps_grd_trk_angle:  fltarr(num_pts), $	;46 175
          gps_mag_var:        fltarr(num_pts), $	;47 176
          gps_time_since_sol: fltarr(num_pts), $	;48 177
          gps_alt:            fltarr(num_pts), $	;49 178
          gps_hours:          fltarr(num_pts), $	;50 179?
          gps_minutes:        fltarr(num_pts), $	;51 180?
          gps_seconds:        fltarr(num_pts), $	;52 181?
          gps_roc:            fltarr(num_pts), $    ;53 185
          lwc:                fltarr(num_pts), $	;54 186
          gated_strobes:      fltarr(num_pts), $	;55 190
          total_strobes:      fltarr(num_pts), $	;56 191
          fssp_range:         fltarr(num_pts), $	;57 192
          pelev:              fltarr(num_pts), $	;58 205
          thetae:             fltarr(num_pts), $	;59 206
          sat_mix_ratio:      fltarr(num_pts), $	;60 207
          dzdt:               fltarr(num_pts), $	;61 208
          indic_as:           fltarr(num_pts), $	;62 209
          updraft_uncor:      fltarr(num_pts), $	;63 210
          calc_tas:           fltarr(num_pts), $	;64 211
          updrft_cor_factor:  fltarr(num_pts), $	;65 212
          cooper_updraft:     fltarr(num_pts), $	;66 213
          kopp_updraft:       fltarr(num_pts), $	;67 214
          geopot_alt:         fltarr(num_pts), $	;68 215
          turb:               fltarr(num_pts), $	;60 216
          densmid:            fltarr(num_pts), $	;70 217
          fssp_mix_ratio:     fltarr(num_pts), $	;71 219
          hail_mix_ratio:     fltarr(num_pts), $	;72 220
          ez_aircraft:		  fltarr(num_pts), $	;73 260
          ey_aircraft:        fltarr(num_pts), $	;74 261
          ex_aircraft:        fltarr(num_pts), $	;75 262
          ez_path:            fltarr(num_pts), $	;76 263
          ey_path:    		  fltarr(num_pts), $	;77 264
          ex_path:    		  fltarr(num_pts), $	;78 265
          ex_earth:           fltarr(num_pts), $	;79 266
          ey_earth:           fltarr(num_pts), $	;80 267
          ez_earth:           fltarr(num_pts), $	;81 268
          eq_aircraft:        fltarr(num_pts), $	;82 269
          eq_temp:            fltarr(num_pts), $	;83 270
          accel_x:            fltarr(num_pts), $	;84 290
          accel_y:            fltarr(num_pts), $	;85 291
          accel_z:            fltarr(num_pts), $ 	;86 292
          hvps_house1:        fltarr(num_pts), $	;87 671
          hvps_house2:        fltarr(num_pts), $	;88 672
          hvps_house3:        fltarr(num_pts), $	;89 673
          hvps_house4:        fltarr(num_pts), $	;90 674
          hvps_house5:        fltarr(num_pts), $	;91 675
          hvps_house6:        fltarr(num_pts), $	;92 676
          hvps_house7:        fltarr(num_pts), $	;93 677
          hvps_house8:        fltarr(num_pts),$ 	;94 678
		  dyn_diff:			  fltarr(num_pts), $    ;95 900
		  stat_diff:          fltarr(num_pts), $	;96 901
          temp_diff:          fltarr(num_pts), $	;97 902
          heading_gps_trk_angl:fltarr(num_pts), $	;98 903
          accelZ_accel:        fltarr(num_pts), $	;99 904
          NCARTAS_CalcTAS:     fltarr(num_pts), $	;100 905
          NCARTAS_GPSgrdSpd:   fltarr(num_pts), $	;101 906
          GPSalt_Pelev:        fltarr(num_pts)} 	;102 907

num_tags = n_elements(tag_names(hdata))

metadata = replicate({md,tag_num: 0, plabel: '', slabel: '', units: '', form: '', dmin: 0., dmax: 0.},num_tags)

metadata(0)  = { md , 100 , 'Hours'              , 'Hrs'  , 'hr'      , 'i6'   ,    0. ,   24. }
metadata(1)  = { md , 100 , 'Minutes'            , 'Min'  , 'mn'      , 'i6'   ,    0. ,   60. }
metadata(2)  = { md , 100 , 'Seconds'            , 'Sec'  , 'sc'      , 'f8.2' ,    0. ,   60. }
metadata(3)  = { md , 101 , 'Dynamic Pressure 1' , 'DP1'  , 'mb'      , 'f8.4' ,    0. ,   25. }
metadata(4)  = { md , 102 , 'Dynamic Pressure 2' , 'DP2'  , 'mb'      , 'f8.4' ,    0. ,   25. }
metadata(5)  = { md , 103 , 'Static Pressure 1'  , 'SP1'  , 'mb'      , 'f9.4' ,  500. , 1000. }
metadata(6)  = { md , 104 , 'Static Pressure 2'  , 'SP2'  , 'mb'      , 'f9.4' ,  500. , 1000. }
metadata(7)  = { md , 105 , 'Rate of Climb'      , 'ROC'  , 'm/s'     , 'f9.4' ,  -15. ,   15. }
metadata(8)  = { md , 106 , 'Rosemount Temp'     , 'Rose' , 'deg C'   , 'f9.4' ,  -10. ,   30. }
metadata(9)  = { md , 107 , 'RFT'                , 'RFT'  , 'deg C'   , 'f9.4' ,  -10. ,   30. }
metadata(10) = { md , 108 , 'Manifold Pressure'  , 'MP'   , 'inches'  , 'f5.1' ,    0. ,   50. }
metadata(11) = { md , 109 , 'Acceleration'       , 'Accel', 'g'       , 'f7.4' ,    0. ,    2. }
metadata(12) = { md , 110 , 'Pitch'              , 'Pitch', 'deg'     , 'f9.4' ,  -10. ,   15. }
metadata(13) = { md , 111 , 'Roll'               , 'Roll' , 'deg'     , 'f9.4' ,  -40. ,   40. }
metadata(14) = { md , 113 , 'VOR'                , 'VOR'  , 'deg'     , 'f6.1' ,    0. ,  360. }
metadata(15) = { md , 114 , 'DME1'               , 'DME'  , 'n mi'    , 'f6.1' ,    0. ,  100. }
metadata(16) = { md , 116 , 'Voltage Regulator'  , 'VReg' , 'V'       , 'f5.1' ,   -5. ,    5. }
metadata(17) = { md , 117 , 'Heading'            , 'Hdg'  , 'deg'     , 'f6.1' ,    0. ,  360. }
metadata(18) = { md , 118 , 'NCAR TAS'           , 'NTAS' , 'm/s'     , 'f6.1' ,   50. ,  125. }
metadata(19) = { md , 119 , 'PMS End Element 1'  , 'EE1'  , 'V'       , 'f5.1' ,    0. ,   50. }
metadata(20) = { md , 120 , 'PMS End Element 2'  , 'EE2'  , 'V'       , 'f5.1' ,    0. ,   50. }
metadata(21) = { md , 121 , 'Internal Temp'      , 'IntT' , 'deg C'   , 'f6.1' ,  -10. ,   40. }
metadata(22) = { md , 123 , 'HV Current'         , 'HVCur', 'A'       , 'f4.1' ,    0. ,    1. }
metadata(23) = { md , 124 , 'Heater Current'     , 'HtrCr', 'A'       , 'f6.1' ,    0. ,  100. }
metadata(24) = { md , 128 , 'SR1'                , 'SR1'  , 'V'       , 'f5.1' ,   -5. ,    5. }
metadata(25) = { md , 129 , 'SR2'                , 'SR2'  , 'V'       , 'f5.1' ,   -5. ,    5. }
metadata(26) = { md , 141 , 'FSSP Total Counts'  , 'TCnts', '#'       , 'f7.1' ,    0. , 1000. }
metadata(27) = { md , 142 , 'FSSP Average Diam'  , 'ADiam', 'um'      , 'f5.1' ,    0. ,   40. }
metadata(28) = { md , 143 , 'FSSP Concentration' , 'Conc' , '#/cm3'   , 'f6.1' ,    0. ,  400. }
metadata(29) = { md , 144 , 'FSSP LW'            , 'FLWC' , 'g/m3'    , 'f9.6' ,    0. ,    4. }
metadata(30) = { md , 145 , 'FSSP Activity'      , 'Act'  , '%'       , 'f6.1' ,    0. ,  100. }
metadata(31) = { md , 147 , '2DC Shadow OR'      , 'ShdOR', '#'       , 'f7.1' ,    0. , 1000. }
metadata(32) = { md , 148 , 'FSSP Equiv Diam'    , 'EqDia', 'um'      , 'f5.1' ,    0. ,   40. }
metadata(33) = { md , 149 , 'FSSP ED Variance'   , 'Var'  , 'um'      , 'f5.1' ,    0. ,   10. }
metadata(34) = { md , 152 , 'Hail Total Counts'  , 'HTCnt', '#'       , 'f6.1' ,    0. ,  100. }
metadata(35) = { md , 153 , 'Hail Average Diam'  , 'HADia', 'cm'      , 'f4.1' ,    0. ,    5. }
metadata(36) = { md , 154 , 'Hail Concentration' , 'HConc', '#/m3'    , 'f5.1' ,    0. ,   10. }
metadata(37) = { md , 155 , 'Hail Water'         , 'HWatr', 'g/m3'    , 'f4.1' ,    0. ,    1. }
metadata(38) = { md , 160 , 'Top FM (Low Res)'   , 'TFM'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(39) = { md , 161 , 'Bottom FM (Low Res)', 'BFM'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(40) = { md , 162 , 'Left FM (Low Res)'  , 'LFM'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(41) = { md , 163 , 'Right FM (Low Res)' , 'RFM'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(42) = { md , 168 , 'Fifth FM (Low Res)' , 'FM5'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(43) = { md , 169 , 'Sixth FM (Low Res)' , 'FM6'  , 'kV/m'    , 'f6.1' ,    0. ,  600. }
metadata(44) = { md , 170 , 'HVPS Shadow OR'     , 'ShadORHVPS'  , '#'    , 'f7.1' ,0. , 1000. }
metadata(45) = { md , 172 , 'Latitude'           , 'Lat'  , 'deg'     , 'f11.5' ,   30. ,   50. }
metadata(46) = { md , 173 , 'Longitude'          , 'Lon'  , 'deg'     , 'f11.5' , -100. , -130. }
metadata(47) = { md , 174 , 'GPS Ground Speed'   , 'GSpd' , 'm/s'     , 'f6.1' ,    0. ,  125. }
metadata(48) = { md , 175 , 'GPS Grd Track Angle', 'GTA'  , 'deg'     , 'f6.1' ,    0. ,  360. }
metadata(49) = { md , 176 , 'GPS Magnetic Dev'   , 'MDev' , 'deg'     , 'f5.1' ,    0. ,   20. }
metadata(50) = { md , 177 , 'GPS Time Since Soln', 'TSS'  , 'sec'     , 'f4.1' ,    0. ,    5. }
metadata(51) = { md , 178 , 'GPS Altitude'       , 'Alt'  , 'm'       , 'f7.1' ,    0. , 5000. }
metadata(52) = { md , 179 , 'GPS Hours'          , 'GHr'  , 'hr'      , 'i4'   ,    0  ,   30  }
metadata(53) = { md , 180 , 'GPS Minutes'        , 'GMn'  , 'mn'      , 'i4'   ,    0  ,   60  }
metadata(54) = { md , 181 , 'GPS Seconds'        , 'GSc'  , 'sc'      , 'f6.2' ,    0. ,   60. }
metadata(55) = { md , 185 , 'GPS Rate of Climb'  , 'GROC' , 'm/s'     , 'f6.1' ,  -15. ,   15. }
metadata(56) = { md , 186 , 'DMT Probe LW'       , 'DMTLW', 'g/m3'    , 'f4.1' ,    0. ,    4. }
metadata(57) = { md , 190 , 'FSSP Gated Strobes' , 'GStrb', '#'       , 'f7.1' ,    0. , 1000. }
metadata(58) = { md , 191 , 'FSSP Total Strobes' , 'TStrb', '#'       , 'f7.1' ,    0. , 1000. }
metadata(59) = { md , 192 , 'FSSP Range'         , 'Rng'  , 'V'       , 'f5.1' ,    0. ,   30. }
metadata(60) = { md , 205 , 'Pressure Altitude'  , 'PAlt' , 'm'       , 'f9.4' ,    0. , 5000. }
metadata(61) = { md , 206 , 'Theta E'            , 'ThE'  , 'deg K'   , 'f6.1' ,  275. ,  325. }
metadata(62) = { md , 207 , 'Saturation Mix Rat' , 'SMR'  , 'g/kg'    , 'f4.1' ,    0. ,    1. }
metadata(63) = { md , 208 , 'dzdt'               , 'DZDT' , 'm/s'     , 'f9.4' ,  -10. ,   10. }
metadata(64) = { md , 209 , 'Indicated Air Speed', 'IAS'  , 'm/s'     , 'f9.4' ,    0. ,  200. }
metadata(65) = { md , 210 , 'Updraft (Uncorr)'   , 'UpUn' , 'm/s'     , 'f6.1' ,  -10. ,   10. }
metadata(66) = { md , 211 , 'Calculated TAS'     , 'CTAS' , 'm/s'     , 'f6.1' ,    0. ,  125. }
metadata(67) = { md , 212 , 'Updraft Corr Factor', 'UCF'  , 'm/s'     , 'f6.1' ,  -10. ,   10. }
metadata(68) = { md , 213 , 'Cooper Updraft'     , 'CooUp', 'm/s'     , 'f6.1' ,  -15. ,   15. }
;metadata(68) = { md , 214 , 'Kopp Updraft'       , 'KoppU', 'm/s'     , 'f9.4' ,  -15. ,   15. }
metadata(69) = { md , 214 , 'Updraft'            , 'KoppU', 'm/s'     , 'f9.4' ,  -15. ,   15. }
metadata(70) = { md , 215 , 'Geopotential Alt'   , 'GAlt' , 'm'       , 'f7.1' ,    0. , 5000. }
metadata(71) = { md , 216 , 'Turbulence'         , 'Turb' , 'cm2/3 /s', 'f5.1' ,    0. ,   15. }
metadata(72) = { md , 217 , 'Air Density'        , 'AirDe', 'kg/m3'   , 'f4.1' ,    0. ,    2. }
metadata(73) = { md , 219 , 'FSSP Mixing Ratio'  , 'FMR'  , 'g/kg'    , 'f4.1' ,    0. ,    1. }
metadata(74) = { md , 220 , 'Hail Mixing Ratio'  , 'HMR'  , 'g/kg'    , 'f4.1' ,    0. ,    1. }
metadata(75) = { md , 260 , 'Ez Aircraft Ref'    , 'EzAirc', 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(76) = { md , 261 , 'Ey Aircraft Ref'    , 'EyAirc', 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(77) = { md , 262 , 'Ex Aircraft Ref'    , 'ExAirc', 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(78) = { md , 263 , 'Ez Flight Path Ref' , 'EzFPR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(79) = { md , 264 , 'Ey Flight Path Ref' , 'EyFPR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(80) = { md , 265 , 'Ex Flight Path Ref' , 'ExFPR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(81) = { md , 266 , 'Ex Earth Ref'       , 'ExER' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(82) = { md , 267 , 'Ey Earth Ref'       , 'EyFR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(83) = { md , 268 , 'Ez Earth Ref'       , 'EzFR' , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(84) = { md , 269 , 'Airplane Charge'    , 'EqA'  , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(85) = { md , 270 , 'Temp Airplane Charge', 'TEqA'  , 'kV/m'    , 'f5.1' ,   -5. ,    5. }
metadata(86) = { md , 290 , 'Accel X'            , 'AccX' , 'g'       , 'f5.1' ,   -1. ,    1. }
metadata(87) = { md , 291 , 'Accel Y'            , 'AccY' , 'g'       , 'f5.1' ,   -1. ,    1. }
metadata(88) = { md , 292 , 'Accel Z'            , 'AccZ' , 'g'       , 'f4.1' ,    0. ,    2. }
metadata(89) = { md , 671 , 'HVPS House1'        , 'HVPS1' ,'C'       , 'f6.1' ,  -50. ,   50. }
metadata(90) = { md , 672 , 'HVPS House2'        , 'HVPS2' ,'C'       , 'f6.1' ,  -50. ,   50. }
metadata(91) = { md , 673 , 'HVPS House3'        , 'HVPS3' ,'C'       , 'f6.1' ,  -50. ,   50. }
metadata(92) = { md , 674 , 'HVPS House4'        , 'HVPS4' ,'C'       , 'f6.1' ,  -50. ,   50. }
metadata(93) = { md , 675 , 'HVPS House5'        , 'HVPS5' ,'C'       , 'f6.1' ,  -50. ,   50. }
metadata(94) = { md , 676 , 'HVPS House6'        , 'HVPS6' ,'V'       , 'f6.3' ,  -25. ,   25. }
metadata(95) = { md , 677 , 'HVPS House7'        , 'HVPS7' ,'V'       , 'f6.3' ,  -25. ,   25. }
metadata(96) = { md , 678 , 'HVPS House8'        , 'HVPS8' ,'mW'      , 'f6.4' ,  -25. ,   25. }
metadata(97) = { md , 900 , 'Dyn_Pressure_1 - Dyn_Pressure_2', 'dyn12' ,'mb', 'f6.4' ,  -400. ,   1100. }
metadata(98) = { md , 901 , 'Stat_Pressure_1 - Stat_Pressure_2', 'stat12' ,'mb', 'f6.4' ,  -400. ,   1100. }
metadata(99) = { md , 902 , 'Rosemount - RFT Temperature', 'temp12' ,'Deg C', 'f6.4' ,  -50. ,   50. }
metadata(100) = { md , 903 , 'Heading - GPS_Grd_Trk_angle', 'head12' ,'Deg', 'f6.1' ,  -360. ,   360. }
metadata(101) = { md , 904 , 'AccelZ - Accel ', 'accel12' ,'g' , 'f6.4' ,  -10. ,   10. }
metadata(102) = { md , 905 , 'NCAR_TAS - Calc_TAS', 'ncar12' ,'m/s'      , 'f6.4' ,  -400. ,   1100. }
metadata(103) = { md , 906 , 'NCAR_TAS - GPS_Grd_Spd', 'ncar34' ,'m/s'      , 'f6.4' ,  -500. ,   500. }
metadata(104) = { md , 907 , 'GPS_Alt - Pressure_Elev', 'alt12' ,'m MSL'      , 'f6.4' ,  -0. ,   10000. }

end


