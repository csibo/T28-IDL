
;- buff_struct.pro

b_info = { $;struct2, $
           buff_num     : 0. , $		;0
           num_frames   : 0. , $		;1
           num_blobs    : 0. , $		;2
           num_occluded : 0. , $		;3
           time_hrs     : 0. , $		;4
           time_hms     : 0. , $		;5
           time_rnd     : 0. , $		;6
           p_info_ptr   : 0. , $		;7
           tac          : 0. , $		;8
           dur          : 0. , $		;9
           elapsed_time : 0. , $		;10
           mult_fac     : 0. , $		;11
           div_fac      : 0. , $		;12
           charge_time  : 0. , $		;13
           press1_buff  : 0. , $		;14
           rose_buff    : 0. , $		;15
           fssp_lw_buff : 0. , $		;16
           calc_tas_buff: 0. , $		;17
           mean_mass    : 0. , $		;18
           total_mass   : 0. , $		;19
           mean_area    : 0. , $		;20
           mean_diam    : 0. , $		;21
           sd_diam      : 0. , $		;22
           mass_conc    : 0. , $		;23
           smass_conc   : 0. , $		;24
           snow_conc    : 0. , $		;25
           y_resolution : 0. , $		;26
           np			: 0. , $		;27
           img_ptr      : 0. }			;28

num_buf_tags = n_tags(b_info)

bmetadata = replicate({bmd,BUFF_IND:0,YT:'',UNITS:'',YMN:0.,YMX:0.,BINS:0.},num_buf_tags)
;bmetadata = replicate({BUFF_IND:0,YT:'',UNITS:'',YMN:0.,YMX:0.,BINS:0.},num_buf_tags)

;bmetadata(0)  = { 0,    'Buffer Number',      '',   0.,   30000.,     1.     }
;bmetadata(1)  = { 1,    'Number Frames',      '',   0.,    1000.,     1.     }
;bmetadata(2)  = { 2,          '# Blobs',      '',   0.,    1000.,     1.     }
;bmetadata(3)  = { 3,       '# Occluded',      '',   0.,   20000.,     1.     }
;bmetadata(4)  = { 4,      'Buffer Time',   'hrs',   0.,      24.,     1.     }
;bmetadata(5)  = { 5,      'Buffer Time','hhmmss',   0.,  240000.,     1.     }
;bmetadata(6)  = { 6,     'Reduced Time',   'hrs',   0.,      24.,     1.     }
;bmetadata(7)  = { 7,     'Particle Ptr',      '',   0.,  300000.,     1.     }
;bmetadata(8)  = { 8,              'TAC',   'sec',   0.,     200.,     0.5    }
;bmetadata(9)  = { 9,              'Dur',   'sec',   0.,     200.,     0.5    }
;bmetadata(10) = {10,     'Elapsed Time',   'sec',   0.,     200.,     0.5    }
;bmetadata(11) = {11,      'Mult Factor',      '',   0.,     200.,     1.     }
;bmetadata(12) = {12,       'Div Factor',      '',   0.,     200.,     1.     }
;bmetadata(13) = {13,      'Charge Time',   'sec',   0.,       0.001,  0.0001 }
;bmetadata(14) = {14,         'Pressure',    'mb', 200.,    1000.,    10.0    }
;bmetadata(15) = {15,        'Rose Temp',     'C', -30.,      30.,     1.0    }
;bmetadata(16) = {16,          'FSSP LW', 'g/cm3',   0.,       5.,     0.5    }
;bmetadata(17) = {17,         'Calc TAS',   'm/s',   0.,     150.,     1.0    }
;bmetadata(18) = {18,        'Mass Mean',    'ng',   0.,  200000., 10000.0    }
;bmetadata(19) = {19,       'Mass Total',    'ng',   0., 1000000., 20000.0    }
;bmetadata(20) = {20,        'Mean Area',   'um2',   0., 1000000., 20000.0    }
;bmetadata(21) = {21,        'Mean Diam',    'um',   0.,   20000.,  1000.0    }
;bmetadata(22) = {22,          'Diam SD',    'um',   0.,   20000.,  1000.0    }
;bmetadata(23) = {23,        'Mass Conc',  'g/m3',   0.,      50.,     1.0    }
;bmetadata(24) = {24,       'SMass Conc',  'g/m3',   0.,      50.,     1.0    }
;bmetadata(25) = {25,        'Snow Conc',  'g/m3',   0.,      50.,     1.0    }
;bmetadata(26) = {26,  'Vert Resolution',    'um',   0.,     200.,    10.0    }
;bmetadata(27) = {27,      'Image Width',      '',   0.,    5000.,   100.0    }
;bmetadata(28) = {28,        'Image Ptr',      '',   0., 1000000.,100000.0    }

bmetadata(0)  = {bmd, 0,    'Buffer Number',      '',   0.,   30000.,     1.     }
bmetadata(1)  = {bmd, 1,    'Number Frames',      '',   0.,    1000.,     1.     }
bmetadata(2)  = {bmd, 2,          '# Blobs',      '',   0.,    1000.,     1.     }
bmetadata(3)  = {bmd, 3,       '# Occluded',      '',   0.,   20000.,     1.     }
bmetadata(4)  = {bmd, 4,      'Buffer Time',   'hrs',   0.,      24.,     1.     }
bmetadata(5)  = {bmd, 5,      'Buffer Time','hhmmss',   0.,  240000.,     1.     }
bmetadata(6)  = {bmd, 6,     'Reduced Time',   'hrs',   0.,      24.,     1.     }
bmetadata(7)  = {bmd, 7,     'Particle Ptr',      '',   0.,  300000.,     1.     }
bmetadata(8)  = {bmd, 8,              'TAC',   'sec',   0.,     200.,     0.5    }
bmetadata(9)  = {bmd, 9,              'Dur',   'sec',   0.,     200.,     0.5    }
bmetadata(10) = {bmd,10,     'Elapsed Time',   'sec',   0.,     200.,     0.5    }
bmetadata(11) = {bmd,11,      'Mult Factor',      '',   0.,     200.,     1.     }
bmetadata(12) = {bmd,12,       'Div Factor',      '',   0.,     200.,     1.     }
bmetadata(13) = {bmd,13,      'Charge Time',   'sec',   0.,       0.001,  0.0001 }
bmetadata(14) = {bmd,14,         'Pressure',    'mb', 200.,    1000.,    10.0    }
bmetadata(15) = {bmd,15,        'Rose Temp',     'C', -30.,      30.,     1.0    }
bmetadata(16) = {bmd,16,          'FSSP LW', 'g/cm3',   0.,       5.,     0.5    }
bmetadata(17) = {bmd,17,         'Calc TAS',   'm/s',   0.,     150.,     1.0    }
bmetadata(18) = {bmd,18,        'Mass Mean',    'ng',   0.,  200000., 10000.0    }
bmetadata(19) = {bmd,19,       'Mass Total',    'ng',   0., 1000000., 20000.0    }
bmetadata(20) = {bmd,20,        'Mean Area',   'um2',   0., 1000000., 20000.0    }
bmetadata(21) = {bmd,21,        'Mean Diam',    'um',   0.,   20000.,  1000.0    }
bmetadata(22) = {bmd,22,          'Diam SD',    'um',   0.,   20000.,  1000.0    }
bmetadata(23) = {bmd,23,        'Mass Conc',  'g/m3',   0.,      50.,     1.0    }
bmetadata(24) = {bmd,24,       'SMass Conc',  'g/m3',   0.,      50.,     1.0    }
bmetadata(25) = {bmd,25,        'Snow Conc',  'g/m3',   0.,      50.,     1.0    }
bmetadata(26) = {bmd,26,  'Vert Resolution',    'um',   0.,     200.,    10.0    }
bmetadata(27) = {bmd,27,      'Image Width',      '',   0.,    5000.,   100.0    }
bmetadata(28) = {bmd,28,        'Image Ptr',      '',   0., 1000000.,100000.0    }
