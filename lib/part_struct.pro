
;- part_struct.pro

p_info = { $;struct1, $
           frame_num        : 0., $		;0
           start_frame      : 0., $		;1
           end_frame        : 0., $		;2
           inter_part_time	: 0., $		;3
           inter_part_time2	: 0., $		;4
           frame_time		: 0., $		;5
           overflow         : 0., $		;6
           charge_ind       : 0., $		;7
           num_in_frame     : 0., $		;8
           seq_num	        : 0., $		;9
           blob_num			: 0., $		;10
           pixel_area		: 0., $		;11
           area				: 0., $		;12
           x_dim			: 0., $		;13
           y_dim			: 0., $		;14
           max_length		: 0., $		;15
           orient			: 0., $		;16
           max1_ind			: 0., $		;17
           max2_ind			: 0., $		;18
           area_max			: 0., $		;19
           y_dim_re			: 0., $		;20
           area_re			: 0., $		;21
           bottom_occulted	: 0., $		;22
           top_occulted		: 0., $		;23
           heyms_diam		: 0., $		;24
           holroyd_diam		: 0., $		;25
           holroyd_width	: 0., $		;26
           holroyd_angle	: 0., $		;27
           linearity		: 0., $		;28
           holroyd_sigma	: 0., $		;29
           com_x			: 0., $		;30
           com_y			: 0., $		;31
           equiv_cir		: 0., $		;32
           area_ratio		: 0., $		;33
           streak			: 0., $		;34
           pda				: 0., $		;35
           chi				: 0., $		;36
           num_per_in		: 0., $		;37
           num_per_out		: 0., $		;38
           eccen			: 0., $		;39
           theta			: 0., $		;40
           habit			: 0., $		;41
           mass				: 0., $		;42
           mass_dens		: 0., $		;43
           smass			: 0., $		;44
           smass_dens		: 0., $		;45
           snow_mass		: 0., $		;46
           snow_mas_den		: 0., $		;47
           sample_area      : 0., $		;48
           llx				: 0., $		;49
           lly				: 0., $		;50
           urx				: 0., $		;51
           ury				: 0., $		;52
           indind			: 0., $		;53
           date_create		: 0., $		;54
           date_edit		: 0., $		;55
           buffer_num		: 0.  }		;56

num_par_tags = n_tags(p_info)
pmetadata = replicate({pmd,QUAN_IND:0,XT:'',UNITS:'',HMN:0.,HMX:0.,BINS:0.},num_par_tags)
;pmetadata = replicate({QUAN_IND:0,XT:'',UNITS:'',HMN:0.,HMX:0.,BINS:0.},num_par_tags)

;pmetadata(0)  = { 0,     'Frame Number',     '',  0.,  50., 1.}
;pmetadata(1)  = { 1,      'Start Frame',     '',  0.,  50., 1.}	;pixel number
;pmetadata(2)  = { 2,        'End Frame',     '',  0.,  50., 1.}
;pmetadata(3)  = { 3,  'Inter-Part Time',  'sec',  0.,  50., 1.}	;unfiltered
;pmetadata(4)  = { 4,  'Inter-Part Time',  'sec',  0.,  50., 1.}	;filtered
;pmetadata(5)  = { 5,       'Frame Time',  'hrs',  0.,  50., 1.}
;pmetadata(6)  = { 6,         'Overflow',     '',  0.,  50., 1.}
;pmetadata(7)  = { 7,       'Charge Ind',     '',  0.,  50., 1.}
;pmetadata(8)  = { 8,     'Num in Frame',     '',  0.,  20., 1.}
;pmetadata(9)  = { 9,  'Sequence Number',     '',  0.,  50., 1.}
;pmetadata(10) = {10,      'Blob Number',     '',  0.,  50., 1.}
;pmetadata(11) = {11,       'Pixel Area',     '',  0.,1000., 1.}
;pmetadata(12) = {12,             'Area', 'um!E2!N',  0.,300000., 10000.}
;pmetadata(13) = {13,            'X Dim',   'um',  0.,  2000., 100.}
;pmetadata(14) = {14,            'Y Dim',   'um',  0.,  2000., 100.}
;pmetadata(15) = {15,       'Max Length',   'um',  0.,  2000., 100.}
;pmetadata(16) = {16,      'Orientation',  'deg',  -180., 180., 5.}	;angle along max line
;pmetadata(17) = {17,         'Max1_ind',     '',  0.,  15., 1.}	;indices of pixels
;pmetadata(18) = {18,         'Max2_ind',     '',  0.,  15., 1.}	;at max length
;pmetadata(19) = {19,         'Area Max', 'um!E2!N',  0.,  600000., 20000.}
;pmetadata(20) = {20,      'Y Dim Recon',   'um',  0.,  2000., 100.}
;pmetadata(21) = {21,       'Area Recon', 'um!E2!N',  0.,  300000., 10000.}
;pmetadata(22) = {22,  'Bottom Occulted',   'um',  0.,  10000., 500.}
;pmetadata(23) = {23,     'Top Occulted',   'um',  0.,  10000., 500.}
;pmetadata(24) = {24,       'Heyms Diam',   'um',  0.,  2000., 100.}
;pmetadata(25) = {25,     'Holroyd Diam',   'um',  0.,  2000., 100.}
;pmetadata(26) = {26,    'Holroyd Width',   'um',  0.,  2000., 100.}
;pmetadata(27) = {27,    'Holroyd Angle',  'deg',  -100., 100., 10.}
;pmetadata(28) = {28,        'Linearity',     '',  0.,   1., 0.05}
;pmetadata(29) = {29,    'Holroyd Sigma',     '',  0.,  10., 1.}
;pmetadata(30) = {30,            'COM X',     '',  0.,1000., 1.}	;center of mass
;pmetadata(31) = {31,            'COM Y',     '',  0.,1000., 1.}
;pmetadata(32) = {32,     'Equiv Circle',   'um',  0.,  1000., 50.}
;pmetadata(33) = {33,       'Area Ratio',     '',  0.,  2.0, 0.1}
;pmetadata(34) = {34,           'Streak',     '',  0.,  20., 1.}
;pmetadata(35) = {35,              'PDA',     '',  0.,  20., 1.}
;pmetadata(36) = {36,              'CHI',   'um',  0.,  300., 20.}
;pmetadata(37) = {37, 'Inside Perimeter',   'um',  0.,  50., 1.}
;pmetadata(38) = {38,'Outside Perimeter',   'um',  0.,  50., 1.}
;pmetadata(39) = {39,     'Eccentricity',     '',  -200.,  200., 20.}
;pmetadata(40) = {40,            'Theta',  'deg',  -50.,  50., 5.}
;pmetadata(41) = {41,            'Habit',     '',  0.,  15., 1.}
;pmetadata(42) = {42,             'Mass',   'ng',  0.,  200000., 10000.}
;pmetadata(43) = {43,        'Mass Dens','g/m^2',  0.,  50., 1.}
;pmetadata(44) = {44,            'SMass',   'ng',  0.,  200000., 10000.}
;pmetadata(45) = {45,       'SMass Dens','g/m^2',  0.,  50., 1.}
;pmetadata(46) = {46,        'Snow Mass',   'ng',  0.,  200000., 10000.}
;pmetadata(47) = {47,   'Snow Mass Dens','g/m^2',  0.,  50., 1.}
;pmetadata(48) = {48,      'Sample Area',  'm^2',  0.,  50., 1.}
;pmetadata(49) = {49,              'LLX',     '',  0.,  15., 1.}	;Lower Left
;pmetadata(50) = {50,              'LLY',     '',  0.,  15., 1.}
;pmetadata(51) = {51,              'URX',     '',  0.,  15., 1.}	;Upper Right
;pmetadata(52) = {52,              'URY',     '',  0.,  15., 1.}
;pmetadata(53) = {53,           'IndInd',     '',  0., 300., 1.}	;Image location
;pmetadata(54) = {54,      'Date Create',     '',1011960.,1012100., 1.}
;pmetadata(55) = {55,        'Date Edit',     '',1011960.,1012100., 1.}
;pmetadata(56) = {56,    'Buffer Number',     '',  0.,100000., 1.}

pmetadata(0)  = {pmd, 0,     'Frame Number',     '',  0.,  50., 1.}
pmetadata(1)  = {pmd, 1,      'Start Frame',     '',  0.,  50., 1.}	;pixel number
pmetadata(2)  = {pmd, 2,        'End Frame',     '',  0.,  50., 1.}
pmetadata(3)  = {pmd, 3,  'Inter-Part Time (NOT FOR 95-HVPS)',  'sec',  0.,  50., 1.}	;unfiltered
pmetadata(4)  = {pmd, 4,  'Inter-Part Time (NOT FOR 95-HVPS)',  'sec',  0.,  50., 1.}	;filtered
pmetadata(5)  = {pmd, 5,       'Frame Time',  'hrs',  0.,  50., 1.}
pmetadata(6)  = {pmd, 6,         'Overflow',     '',  0.,  50., 1.}
pmetadata(7)  = {pmd, 7,       'Charge Ind (NOT FOR 95-HVPS)',     '',  0.,  50., 1.}
pmetadata(8)  = {pmd, 8,     'Num in Frame',     '',  0.,  20., 1.}
pmetadata(9)  = {pmd, 9,  'Sequence Number',     '',  0.,  50., 1.}
pmetadata(10) = {pmd,10,      'Blob Number',     '',  0.,  50., 1.}
pmetadata(11) = {pmd,11,       'Pixel Area',     '',  0.,1000., 1.}
pmetadata(12) = {pmd,12,             'Area', 'um!E2!N',  0.,300000., 10000.}
pmetadata(13) = {pmd,13,            'X Dim',   'um',  0.,  2000., 100.}
pmetadata(14) = {pmd,14,            'Y Dim',   'um',  0.,  2000., 100.}
pmetadata(15) = {pmd,15,       'Max Length',   'um',  0.,  2000., 100.}
pmetadata(16) = {pmd,16,      'Orientation',  'deg',  -180., 180., 5.}	;angle along max line
pmetadata(17) = {pmd,17,         'Max1_ind',     '',  0.,  15., 1.}	;indices of pixels
pmetadata(18) = {pmd,18,         'Max2_ind',     '',  0.,  15., 1.}	;at max length
pmetadata(19) = {pmd,19,         'Area Max', 'um!E2!N',  0.,  600000., 20000.}
pmetadata(20) = {pmd,20,      'Y Dim Recon',   'um',  0.,  2000., 100.}
pmetadata(21) = {pmd,21,       'Area Recon', 'um!E2!N',  0.,  300000., 10000.}
pmetadata(22) = {pmd,22,  'Bottom Occulted',   'um',  0.,  10000., 500.}
pmetadata(23) = {pmd,23,     'Top Occulted',   'um',  0.,  10000., 500.}
pmetadata(24) = {pmd,24,       'Heyms Diam',   'um',  0.,  2000., 100.}
pmetadata(25) = {pmd,25,     'Holroyd Diam',   'um',  0.,  2000., 100.}
pmetadata(26) = {pmd,26,    'Holroyd Width',   'um',  0.,  2000., 100.}
pmetadata(27) = {pmd,27,    'Holroyd Angle',  'deg',  -100., 100., 10.}
pmetadata(28) = {pmd,28,        'Linearity',     '',  0.,   1., 0.05}
pmetadata(29) = {pmd,29,    'Holroyd Sigma',     '',  0.,  10., 1.}
pmetadata(30) = {pmd,30, 'Center Of Mass - X',     '',  0.,1000., 1.}	;center of mass
pmetadata(31) = {pmd,31, 'Center Of Mass - Y',     '',  0.,1000., 1.}
pmetadata(32) = {pmd,32,     'Equiv Circle',   'um',  0.,  1000., 50.}
pmetadata(33) = {pmd,33,       'Area Ratio',     '',  0.,  2.0, 0.1}
pmetadata(34) = {pmd,34,           'Streak',     '',  0.,  20., 1.}
pmetadata(35) = {pmd,35,              'PDA',     '',  0.,  20., 1.}
pmetadata(36) = {pmd,36,              'CHI',   'um',  0.,  300., 20.}
pmetadata(37) = {pmd,37, 'Inside Perimeter',   'um',  0.,  50., 1.}
pmetadata(38) = {pmd,38,'Outside Perimeter',   'um',  0.,  50., 1.}
pmetadata(39) = {pmd,39,     'Eccentricity',     '',  -200.,  200., 20.}
pmetadata(40) = {pmd,40,            'Theta',  'deg',  -50.,  50., 5.}
pmetadata(41) = {pmd,41,            'Habit',     '',  0.,  15., 1.}
pmetadata(42) = {pmd,42,             'Mass',   'ng',  0.,  200000., 10000.}
pmetadata(43) = {pmd,43,        'Mass Dens','g/m^2',  0.,  50., 1.}
pmetadata(44) = {pmd,44,            'SMass',   'ng',  0.,  200000., 10000.}
pmetadata(45) = {pmd,45,       'SMass Dens','g/m^2',  0.,  50., 1.}
pmetadata(46) = {pmd,46,        'Snow Mass',   'ng',  0.,  200000., 10000.}
pmetadata(47) = {pmd,47,   'Snow Mass Dens','g/m^2',  0.,  50., 1.}
pmetadata(48) = {pmd,48,      'Sample Area',  'm^2',  0.,  50., 1.}
pmetadata(49) = {pmd,49,              'LLX',     '',  0.,  15., 1.}	;Lower Left
pmetadata(50) = {pmd,50,              'LLY',     '',  0.,  15., 1.}
pmetadata(51) = {pmd,51,              'URX',     '',  0.,  15., 1.}	;Upper Right
pmetadata(52) = {pmd,52,              'URY',     '',  0.,  15., 1.}
pmetadata(53) = {pmd,53,           'IndInd',     '',  0., 300., 1.}	;Image location
pmetadata(54) = {pmd,54,      'Date Create',     '',1011960.,1012100., 1.}
pmetadata(55) = {pmd,55,        'Date Edit',     '',1011960.,1012100., 1.}
pmetadata(56) = {pmd,56,    'Buffer Number',     '',  0.,100000., 1.}

mnmx_2dc = replicate({mm2dc,MN:0.,MX:0.,BINS:0.},num_par_tags)
;mnmx_2dc = replicate({MN:0.,MX:0.,BINS:0.},num_par_tags)

;mnmx_2dc(0)  = {    0.,     50.,     1.   }		;frame_num
;mnmx_2dc(1)  = {    0.,     50.,     1.   }		;start_frame
;mnmx_2dc(2)  = {    0.,     50.,     1.   }		;end_frame
;mnmx_2dc(3)  = {    0.,     50.,     1.   }		;interpart time unfiltered
;mnmx_2dc(4)  = {    0.,     50.,     1.   }		;interpart time filtered
;mnmx_2dc(5)  = {    0.,     50.,     1.   }		;frame_time
;mnmx_2dc(6)  = {    0.,     50.,     1.   }		;overflow
;mnmx_2dc(7)  = {    0.,     50.,     1.   }
;mnmx_2dc(8)  = {    0.,     20.,     1.   }		;num_in_frame
;mnmx_2dc(9)  = {    0.,     50.,     1.   }		;seq_num
;mnmx_2dc(10) = {    0.,     50.,     1.   }		;blob_num
;mnmx_2dc(11) = {    0.,   1000.,     1.   }		;pixel_area
;mnmx_2dc(12) = {    0., 300000., 10000.   }		;area
;mnmx_2dc(13) = {    0.,   2000.,    50.   }		;x_dim
;mnmx_2dc(14) = {    0.,   2000.,    50.   }		;y_dim
;mnmx_2dc(15) = {    0.,   2000.,    50.   }		;max_length
;mnmx_2dc(16) = { -180.,    180.,     5.   }		;orient - angle along max line
;mnmx_2dc(17) = {    0.,     15.,     1.   }		;indices of pixels
;mnmx_2dc(18) = {    0.,     15.,     1.   }		;at max length
;mnmx_2dc(19) = {    0., 600000., 20000.   }		;area_max
;mnmx_2dc(20) = {    0.,   2000.,    50.   }		;y_dim_re
;mnmx_2dc(21) = {    0., 300000., 10000.   }		;area_re
;mnmx_2dc(22) = {    0.,  10000.,   500.   }		;bottom_occulted
;mnmx_2dc(23) = {    0.,  10000.,   500.   }		;top_occulted
;mnmx_2dc(24) = {    0.,   2000.,    50.   }		;heyms_diam
;mnmx_2dc(25) = {    0.,   2000.,    50.   }		;holroyd_diam
;mnmx_2dc(26) = {    0.,   2000.,    50.   }		;holroyd_width
;mnmx_2dc(27) = { -100.,    100.,    10.   }		;holroyd_angle
;mnmx_2dc(28) = {    0.,      1.,     0.05 }		;linearity
;mnmx_2dc(29) = {    0.,     10.,     1.   }		;holroyd_sigma
;mnmx_2dc(30) = {    0.,   1000.,     1.   }		;center of mass
;mnmx_2dc(31) = {    0.,   1000.,     1.   }		;center of mass
;mnmx_2dc(32) = {    0.,   1000.,    50.   }		;equiv_cir
;mnmx_2dc(33) = {    0.,      2.0,    0.1  }		;area_ratio
;mnmx_2dc(34) = {    0.,     20.,     1.   }		;streak
;mnmx_2dc(35) = {    0.,     20.,     1.   }		;pda
;mnmx_2dc(36) = {    0.,    300.,    20.   }		;chi
;mnmx_2dc(37) = {    0.,     50.,     1.   }		;num_per_in
;mnmx_2dc(38) = {    0.,     50.,     1.   }		;num_per_out
;mnmx_2dc(39) = { -200.,    200.,    20.   }		;eccen
;mnmx_2dc(40) = {  -50.,     50.,     5.   }		;theta
;mnmx_2dc(41) = {    0.,     15.,     1.   }		;habit
;mnmx_2dc(42) = {    0., 200000., 10000.   }		;mass
;mnmx_2dc(43) = {    0.,     50.,     1.   }		;mass_dens
;mnmx_2dc(44) = {    0., 200000., 10000.   }		;smass
;mnmx_2dc(45) = {    0.,     50.,     1.   }		;smass_dens
;mnmx_2dc(46) = {    0., 200000., 10000.   }		;snow_mass
;mnmx_2dc(47) = {    0.,     50.,     1.   }		;snow_mas_den
;mnmx_2dc(48) = {    0.,     50.,     1.   }		;sample_area
;mnmx_2dc(49) = {    0.,     15.,     1.   }		;Lower Left x
;mnmx_2dc(50) = {    0.,     15.,     1.   }		;lly
;mnmx_2dc(51) = {    0.,     15.,     1.   }		;Upper Right x
;mnmx_2dc(52) = {    0.,     15.,     1.   }		;ury
;mnmx_2dc(53) = {    0.,    300.,     1.   }		;indind - Image location
;mnmx_2dc(54) = {    0.,     15.,     1.   }
;mnmx_2dc(55) = {    0.,     15.,     1.   }
;mnmx_2dc(56) = {    0., 100000.,     1.   }

mnmx_2dc(0)  = {mm2dc,    0.,     50.,     1.   }		;frame_num
mnmx_2dc(1)  = {mm2dc,    0.,     50.,     1.   }		;start_frame
mnmx_2dc(2)  = {mm2dc,    0.,     50.,     1.   }		;end_frame
mnmx_2dc(3)  = {mm2dc,    0.,     50.,     1.   }		;interpart time unfiltered
mnmx_2dc(4)  = {mm2dc,    0.,     50.,     1.   }		;interpart time filtered
mnmx_2dc(5)  = {mm2dc,    0.,     50.,     1.   }		;frame_time
mnmx_2dc(6)  = {mm2dc,    0.,     50.,     1.   }		;overflow
mnmx_2dc(7)  = {mm2dc,    0.,     50.,     1.   }
mnmx_2dc(8)  = {mm2dc,    0.,     20.,     1.   }		;num_in_frame
mnmx_2dc(9)  = {mm2dc,    0.,     50.,     1.   }		;seq_num
mnmx_2dc(10) = {mm2dc,    0.,     50.,     1.   }		;blob_num
mnmx_2dc(11) = {mm2dc,    0.,   1000.,     1.   }		;pixel_area
mnmx_2dc(12) = {mm2dc,    0., 300000., 10000.   }		;area
mnmx_2dc(13) = {mm2dc,    0.,   2000.,    50.   }		;x_dim
mnmx_2dc(14) = {mm2dc,    0.,   2000.,    50.   }		;y_dim
mnmx_2dc(15) = {mm2dc,    0.,   2000.,    50.   }		;max_length
mnmx_2dc(16) = {mm2dc, -180.,    180.,     5.   }		;orient - angle along max line
mnmx_2dc(17) = {mm2dc,    0.,     15.,     1.   }		;indices of pixels
mnmx_2dc(18) = {mm2dc,    0.,     15.,     1.   }		;at max length
mnmx_2dc(19) = {mm2dc,    0., 600000., 20000.   }		;area_max
mnmx_2dc(20) = {mm2dc,    0.,   2000.,    50.   }		;y_dim_re
mnmx_2dc(21) = {mm2dc,    0., 300000., 10000.   }		;area_re
mnmx_2dc(22) = {mm2dc,    0.,  10000.,   500.   }		;bottom_occulted
mnmx_2dc(23) = {mm2dc,    0.,  10000.,   500.   }		;top_occulted
mnmx_2dc(24) = {mm2dc,    0.,   2000.,    50.   }		;heyms_diam
mnmx_2dc(25) = {mm2dc,    0.,   2000.,    50.   }		;holroyd_diam
mnmx_2dc(26) = {mm2dc,    0.,   2000.,    50.   }		;holroyd_width
mnmx_2dc(27) = {mm2dc, -100.,    100.,    10.   }		;holroyd_angle
mnmx_2dc(28) = {mm2dc,    0.,      1.,     0.05 }		;linearity
mnmx_2dc(29) = {mm2dc,    0.,     10.,     1.   }		;holroyd_sigma
mnmx_2dc(30) = {mm2dc,    0.,   1000.,     1.   }		;center of mass
mnmx_2dc(31) = {mm2dc,    0.,   1000.,     1.   }		;center of mass
mnmx_2dc(32) = {mm2dc,    0.,   1000.,    50.   }		;equiv_cir
mnmx_2dc(33) = {mm2dc,    0.,      2.0,    0.1  }		;area_ratio
mnmx_2dc(34) = {mm2dc,    0.,     20.,     1.   }		;streak
mnmx_2dc(35) = {mm2dc,    0.,     20.,     1.   }		;pda
mnmx_2dc(36) = {mm2dc,    0.,    300.,    20.   }		;chi
mnmx_2dc(37) = {mm2dc,    0.,     50.,     1.   }		;num_per_in
mnmx_2dc(38) = {mm2dc,    0.,     50.,     1.   }		;num_per_out
mnmx_2dc(39) = {mm2dc, -200.,    200.,    20.   }		;eccen
mnmx_2dc(40) = {mm2dc,  -50.,     50.,     5.   }		;theta
mnmx_2dc(41) = {mm2dc,    0.,     15.,     1.   }		;habit
mnmx_2dc(42) = {mm2dc,    0., 200000., 10000.   }		;mass
mnmx_2dc(43) = {mm2dc,    0.,     50.,     1.   }		;mass_dens
mnmx_2dc(44) = {mm2dc,    0., 200000., 10000.   }		;smass
mnmx_2dc(45) = {mm2dc,    0.,     50.,     1.   }		;smass_dens
mnmx_2dc(46) = {mm2dc,    0., 200000., 10000.   }		;snow_mass
mnmx_2dc(47) = {mm2dc,    0.,     50.,     1.   }		;snow_mas_den
mnmx_2dc(48) = {mm2dc,    0.,     50.,     1.   }		;sample_area
mnmx_2dc(49) = {mm2dc,    0.,     15.,     1.   }		;Lower Left x
mnmx_2dc(50) = {mm2dc,    0.,     15.,     1.   }		;lly
mnmx_2dc(51) = {mm2dc,    0.,     15.,     1.   }		;Upper Right x
mnmx_2dc(52) = {mm2dc,    0.,     15.,     1.   }		;ury
mnmx_2dc(53) = {mm2dc,    0.,    300.,     1.   }		;indind - Image location
mnmx_2dc(54) = {mm2dc,    0.,     15.,     1.   }
mnmx_2dc(55) = {mm2dc,    0.,     15.,     1.   }

mnmx_hvps = replicate({mmhvps,MN:0.,MX:0.,BINS:0.},num_par_tags)
;mnmx_hvps = replicate({MN:0.,MX:0.,BINS:0.},num_par_tags)

;mnmx_hvps(0)  = {    0.,     50.,     1.   }		;frame_num
;mnmx_hvps(1)  = {    0.,     50.,     1.   }		;start_frame
;mnmx_hvps(2)  = {    0.,     50.,     1.   }		;end_frame
;mnmx_hvps(3)  = {    0.,     50.,     1.   }		;interpart time unfiltered
;mnmx_hvps(4)  = {    0.,     50.,     1.   }		;interpart time filtered
;mnmx_hvps(5)  = {    0.,     50.,     1.   }		;frame_time
;mnmx_hvps(6)  = {    0.,     50.,     1.   }		;overflow
;mnmx_hvps(7)  = {    0.,     50.,     1.   }
;mnmx_hvps(8)  = {    0.,     20.,     1.   }		;num_in_frame
;mnmx_hvps(9)  = {    0.,     50.,     1.   }		;seq_num
;mnmx_hvps(10) = {    0.,     50.,     1.   }		;blob_num
;mnmx_hvps(11) = {    0.,   1000.,     1.   }		;pixel_area
;mnmx_hvps(12) = {    0.,2000000.,100000.   }		;area
;mnmx_hvps(13) = {    0.,  10000.,   500.   }		;x_dim
;mnmx_hvps(14) = {    0.,  10000.,   250.   }		;y_dim
;mnmx_hvps(15) = {    0.,  10000.,   500.   }		;max_length
;mnmx_hvps(16) = { -180.,    180.,     5.   }		;orient - angle along max line
;mnmx_hvps(17) = {    0.,     15.,     1.   }		;indices of pixels
;mnmx_hvps(18) = {    0.,     15.,     1.   }		;at max length
;mnmx_hvps(19) = {    0.,2000000.,100000.   }		;area_max
;mnmx_hvps(20) = {    0.,  10000.,   500.   }		;y_dim_re
;mnmx_hvps(21) = {    0.,2000000.,100000.   }		;area_re
;mnmx_hvps(22) = {    0.,  10000.,   500.   }		;bottom_occulted
;mnmx_hvps(23) = {    0.,  10000.,   500.   }		;top_occulted
;mnmx_hvps(24) = {    0.,  10000.,   500.   }		;heyms_diam
;mnmx_hvps(25) = {    0.,  10000.,   500.   }		;holroyd_diam
;mnmx_hvps(26) = {    0.,  10000.,   500.   }		;holroyd_width
;mnmx_hvps(27) = { -100.,    100.,    10.   }		;holroyd_angle
;mnmx_hvps(28) = {    0.,      1.,     0.05 }		;linearity
;mnmx_hvps(29) = {    0.,     10.,     1.   }		;holroyd_sigma
;mnmx_hvps(30) = {    0.,   5000.,     1.   }		;center of mass
;mnmx_hvps(31) = {    0.,   5000.,     1.   }		;center of mass
;mnmx_hvps(32) = {    0.,  10000.,   500.   }		;equiv_cir
;mnmx_hvps(33) = {    0.,      2.0,    0.1  }		;area_ratio
;mnmx_hvps(34) = {    0.,     20.,     1.   }		;streak
;mnmx_hvps(35) = {    0.,     20.,     1.   }		;pda
;mnmx_hvps(36) = {    0.,   1000.,   100.   }		;chi
;mnmx_hvps(37) = {    0.,     50.,     1.   }		;num_per_in
;mnmx_hvps(38) = {    0.,     50.,     1.   }		;num_per_out
;mnmx_hvps(39) = { -200.,    200.,    20.   }		;eccen
;mnmx_hvps(40) = {  -50.,     50.,     5.   }		;theta
;mnmx_hvps(41) = {    0.,     15.,     1.   }		;habit
;mnmx_hvps(42) = {    0.,2000000.,100000.   }		;mass
;mnmx_hvps(43) = {    0.,     50.,     1.   }		;mass_dens
;mnmx_hvps(44) = {    0.,2000000.,100000.   }		;smass
;mnmx_hvps(45) = {    0.,     50.,     1.   }		;smass_dens
;mnmx_hvps(46) = {    0.,2000000.,100000.   }		;snow_mass
;mnmx_hvps(47) = {    0.,     50.,     1.   }		;snow_mas_den
;mnmx_hvps(48) = {    0.,     50.,     1.   }		;sample_area
;mnmx_hvps(49) = {    0.,     15.,     1.   }		;Lower Left x
;mnmx_hvps(50) = {    0.,     15.,     1.   }		;lly
;mnmx_hvps(51) = {    0.,     15.,     1.   }		;Upper Right x
;mnmx_hvps(52) = {    0.,     15.,     1.   }		;ury
;mnmx_hvps(53) = {    0.,    300.,     1.   }		;indind - Image location
;mnmx_hvps(54) = {    0.,     15.,     1.   }
;mnmx_hvps(55) = {    0.,     15.,     1.   }
;mnmx_hvps(56) = {    0., 100000.,     1.   }

mnmx_hvps(0)  = {mmhvps,    0.,     50.,     1.   }		;frame_num
mnmx_hvps(1)  = {mmhvps,    0.,     50.,     1.   }		;start_frame
mnmx_hvps(2)  = {mmhvps,    0.,     50.,     1.   }		;end_frame
mnmx_hvps(3)  = {mmhvps,    0.,     50.,     1.   }		;interpart time unfiltered
mnmx_hvps(4)  = {mmhvps,    0.,     50.,     1.   }		;interpart time filtered
mnmx_hvps(5)  = {mmhvps,    0.,     50.,     1.   }		;frame_time
mnmx_hvps(6)  = {mmhvps,    0.,     50.,     1.   }		;overflow
mnmx_hvps(7)  = {mmhvps,    0.,     50.,     1.   }
mnmx_hvps(8)  = {mmhvps,    0.,     20.,     1.   }		;num_in_frame
mnmx_hvps(9)  = {mmhvps,    0.,     50.,     1.   }		;seq_num
mnmx_hvps(10) = {mmhvps,    0.,     50.,     1.   }		;blob_num
mnmx_hvps(11) = {mmhvps,    0.,   1000.,     1.   }		;pixel_area
mnmx_hvps(12) = {mmhvps,    0.,2000000.,100000.   }		;area
mnmx_hvps(13) = {mmhvps,    0.,  10000.,   500.   }		;x_dim
mnmx_hvps(14) = {mmhvps,    0.,  10000.,   250.   }		;y_dim
mnmx_hvps(15) = {mmhvps,    0.,  10000.,   500.   }		;max_length
mnmx_hvps(16) = {mmhvps, -180.,    180.,     5.   }		;orient - angle along max line
mnmx_hvps(17) = {mmhvps,    0.,     15.,     1.   }		;indices of pixels
mnmx_hvps(18) = {mmhvps,    0.,     15.,     1.   }		;at max length
mnmx_hvps(19) = {mmhvps,    0.,2000000.,100000.   }		;area_max
mnmx_hvps(20) = {mmhvps,    0.,  10000.,   500.   }		;y_dim_re
mnmx_hvps(21) = {mmhvps,    0.,2000000.,100000.   }		;area_re
mnmx_hvps(22) = {mmhvps,    0.,  10000.,   500.   }		;bottom_occulted
mnmx_hvps(23) = {mmhvps,    0.,  10000.,   500.   }		;top_occulted
mnmx_hvps(24) = {mmhvps,    0.,  10000.,   500.   }		;heyms_diam
mnmx_hvps(25) = {mmhvps,    0.,  10000.,   500.   }		;holroyd_diam
mnmx_hvps(26) = {mmhvps,    0.,  10000.,   500.   }		;holroyd_width
mnmx_hvps(27) = {mmhvps, -100.,    100.,    10.   }		;holroyd_angle
mnmx_hvps(28) = {mmhvps,    0.,      1.,     0.05 }		;linearity
mnmx_hvps(29) = {mmhvps,    0.,     10.,     1.   }		;holroyd_sigma
mnmx_hvps(30) = {mmhvps,    0.,   5000.,     1.   }		;center of mass
mnmx_hvps(31) = {mmhvps,    0.,   5000.,     1.   }		;center of mass
mnmx_hvps(32) = {mmhvps,    0.,  10000.,   500.   }		;equiv_cir
mnmx_hvps(33) = {mmhvps,    0.,      2.0,    0.1  }		;area_ratio
mnmx_hvps(34) = {mmhvps,    0.,     20.,     1.   }		;streak
mnmx_hvps(35) = {mmhvps,    0.,     20.,     1.   }		;pda
mnmx_hvps(36) = {mmhvps,    0.,   1000.,   100.   }		;chi
mnmx_hvps(37) = {mmhvps,    0.,     50.,     1.   }		;num_per_in
mnmx_hvps(38) = {mmhvps,    0.,     50.,     1.   }		;num_per_out
mnmx_hvps(39) = {mmhvps, -200.,    200.,    20.   }		;eccen
mnmx_hvps(40) = {mmhvps,  -50.,     50.,     5.   }		;theta
mnmx_hvps(41) = {mmhvps,    0.,     15.,     1.   }		;habit
mnmx_hvps(42) = {mmhvps,    0.,2000000.,100000.   }		;mass
mnmx_hvps(43) = {mmhvps,    0.,     50.,     1.   }		;mass_dens
mnmx_hvps(44) = {mmhvps,    0.,2000000.,100000.   }		;smass
mnmx_hvps(45) = {mmhvps,    0.,     50.,     1.   }		;smass_dens
mnmx_hvps(46) = {mmhvps,    0.,2000000.,100000.   }		;snow_mass
mnmx_hvps(47) = {mmhvps,    0.,     50.,     1.   }		;snow_mas_den
mnmx_hvps(48) = {mmhvps,    0.,     50.,     1.   }		;sample_area
mnmx_hvps(49) = {mmhvps,    0.,     15.,     1.   }		;Lower Left x
mnmx_hvps(50) = {mmhvps,    0.,     15.,     1.   }		;lly
mnmx_hvps(51) = {mmhvps,    0.,     15.,     1.   }		;Upper Right x
mnmx_hvps(52) = {mmhvps,    0.,     15.,     1.   }		;ury
mnmx_hvps(53) = {mmhvps,    0.,    300.,     1.   }		;indind - Image location
mnmx_hvps(54) = {mmhvps,    0.,     15.,     1.   }
mnmx_hvps(55) = {mmhvps,    0.,     15.,     1.   }
mnmx_hvps(56) = {mmhvps,    0., 100000.,     1.   }



