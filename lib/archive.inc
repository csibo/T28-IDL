;-
;- archive.inc
;-
buff_size  = 120

hvalues  = ['Streakers       ', $
            'Tiny            ', $
            'Circular        ', $
            'Nearly Circular ', $
            'Regular         ', $
            'Irregular       ', $
            'Linear          ']

huvalues = ['STRE','TINY','CIRC','NCIR','REGU','IRRE','LINE']

havalues  = ['                ', $
             '                ', $
             'Streakers       ', $
             '                ', $
             '                ', $
             '                ', $
             'Tiny            ', $
             'Circular        ', $
             'Nearly Circular ', $
             'Regular         ', $
             'Irregular       ', $
             'Linear          ']

h_ids = [ 3 , 7 , 8 , 9 , 10 , 11 , 12 ]

mon_str = [ 'Jan' , 'Feb' , 'Mar' , 'Apr' , 'May' , 'Jun' , 'Jul' , 'Aug' , 'Sep' , 'Oct' , 'Nov' , 'Dec' ]

bt_values  = ['# Occluded ', $
              'Rose Temp  ', $
              'FSSP LW    ', $
              'Mean Area  ']

btu_values  = ['NUMOCC', $
               'ROSETE', $
               'FSSPLW', $
               'MEANAR' ]

bh_values  = ['Diameter    ', $
              'Equiv Circle', $
              'Area Ratio  ', $
              'PDA         ']

bhu_values  = ['DIAM', $
               'EQUI', $
               'AR', $
               'PDA']

desc1 = [ '1\Plot Time Sequence', $
          '1\Buffer Data       ', $
          '0\# Blobs           ', $
          '0\# Occluded        ', $
          '0\TAC               ', $
          '0\Mult Factor       ', $
          '2\Div Factor        ', $
          '1\Slow Data         ', $
          '0\Pressure          ', $
          '0\Rose Temp         ', $
          '0\FSSP LW           ', $
          '2\Calc TAS          ', $
          '1\Derivative        ', $
          '1\Mass              ', $
          '0\Mean              ', $
          '2\Total             ', $
          '0\Mean Area         ', $
          '1\Diam              ', $
          '0\Mean              ', $
          '2\SD                ', $
          '1\Conc              ', $
          '0\Mass Conc         ', $
          '0\SMass Conc        ', $
          '2\Snow Conc         ', $
          '0\Dur               ', $
          '2\Ywid              ' ]
 
desc2 = [ '1\Plot Histogram    ', $
          '1\Simple Metrics    ', $
          '0\X Dim             ', $
          '0\Y Dim             ', $
          '0\Area              ', $
          '2\Heymsfield Diam   ', $
          '1\Holroyd           ', $
          '0\Diameter          ', $
          '0\Width             ', $
          '0\Angle             ', $
          '0\Linearity         ', $
          '2\Sigma             ', $
          '1\COM               ', $
          '0\X                 ', $
          '2\Y                 ', $
          '1\Misc              ', $
          '0\Equivalent Circle ', $
          '0\Area Ratio        ', $
          '0\Streak            ', $
          '0\PDA               ', $
          '2\CHI               ', $
          '1\Perimeter         ', $
          '0\Inside            ', $
          '2\Outside           ', $
          '1\Mass Params       ', $
          '0\Mass              ', $
          '0\Mass Dens         ', $
          '0\SMass             ', $
          '0\SMass Dens        ', $
          '0\Snow Mass         ', $
          '2\Snow Mass Dens    ', $
          '1\Moments           ', $
          '0\Eccen             ', $
          '2\Theta             ', $
          '1\Custom            ', $
          '0\Max Length        ', $
          '2\Orientation       ', $
          '2\Habit             ' ]
 
b_info = { anon1, $
           buff_num     : 0. , $                   ;0
           num_blobs    : 0. , $                   ;1
           num_occluded : 0. , $                   ;2
           buff_time    : 0. , $                   ;3
           timer_buff   : 0. , $                   ;4
           p_info_ptr   : 0. , $                   ;5
           tac          : 0. , $                   ;6
           mult_fac     : 0. , $                   ;7
           div_fac      : 0. , $                   ;8
           press1_buff  : 0. , $                   ;9
           rose_buff    : 0. , $                   ;10
           fssp_lw_buff : 0. , $                   ;11
           calc_tas_buff: 0. , $                   ;12
           mean_mass    : 0. , $                   ;13
           total_mass   : 0. , $                   ;14
           mean_area    : 0. , $                   ;15
           mean_diam    : 0. , $                   ;16
           sd_diam      : 0. , $                   ;17
           mass_conc    : 0. , $                   ;18
           smass_conc   : 0. , $                   ;19
           snow_conc    : 0. , $                   ;20
           dur          : 0. , $                   ;21
           ywid         : 0. , $                   ;22
           b_blank      : fltarr(7) }              ;23-29

p_info = { anon2, $
           blob_num    : 0., $                        ;0
           area        : 0., $                        ;1
           indind      : 0., $                        ;2
           xdim        : 0., $                        ;3
           ydim        : 0., $                        ;4
           heyms_diam  : 0., $                        ;5
           holroyd_diam: 0., $                        ;6
           holroyd_wid : 0., $                        ;7
           com_x       : 0., $                        ;8
           com_y       : 0., $                        ;9
           equiv_cir   : 0., $                        ;10
           area_ratio  : 0., $                        ;11
           streak      : 0., $                        ;12
           num_per1    : 0., $                        ;13
           num_per2    : 0., $                        ;14
           pda         : 0., $                        ;15
           chi         : 0., $                        ;16
           angled      : 0., $                        ;17
           linearity   : 0., $                        ;18
           width       : 0., $                        ;19
           mass        : 0., $                        ;20
           mass_dens   : 0., $                        ;21
           smass       : 0., $                        ;22
           smass_dens  : 0., $                        ;23
           snow_mass   : 0., $                        ;24
           snow_mas_den: 0., $                        ;25
           mean_time   : 0., $                        ;26
           eccen       : 0., $                        ;27
           theta       : 0., $                        ;28
           llx         : 0., $                        ;29
           lly         : 0., $                        ;30
           urx         : 0., $                        ;31
           ury         : 0., $                        ;32
           habit       : 0., $                        ;33
           c1_ind      : 0., $                        ;34
           c2_ind      : 0., $                        ;35
           max_length  : 0., $                        ;36
           orient      : 0., $                        ;37
           dtma        : 0., $                        ;38
           year_create : 0., $                        ;39
           month_create: 0., $                        ;40
           day_create  : 0., $                        ;41
           year_edit   : 0., $                        ;42
           month_edit  : 0., $                        ;43
           day_edit    : 0., $                        ;44
           p_blank     : fltarr(5) }                  ;45-49


tem1 = {star,BUFF_IND:0,YT:'',YMN:0.,YMX:0.}
buffp = replicate({star},26)
num_buffp = 19
buffp(2)  = {star, 1,          '# Blobs',  0., 200.}
buffp(3)  = {star, 2,       '# Occluded',  0., 200.}
buffp(4)  = {star, 6,              'TAC',  0., 200.}
buffp(5)  = {star, 7,      'Mult Factor',  0., 200.}
buffp(6)  = {star, 8,       'Div Factor',  0., 200.}
buffp(8)  = {star, 9,    'Pressure (mb)',200.,1000.}
buffp(9)  = {star,10,'Rose Temp (deg C)',-30.,  30.}
buffp(10) = {star,11,  'FSSP LW (g/cm3)',  0.,   5.}
buffp(11) = {star,12,   'Calc TAS (m/s)',  0., 100.}
buffp(14) = {star,13,   'Mass Mean (ng)',  0., 100.}
buffp(15) = {star,14,  'Mass Total (ng)',  0., 100.}
buffp(16) = {star,15,        'Mean Area',  0., 100.}
buffp(18) = {star,16,        'Mean Diam',  0., 100.}
buffp(19) = {star,17,          'Diam SD',  0., 100.}
buffp(21) = {star,18, 'Mass Conc (g/m3)',  0., 100.}
buffp(22) = {star,19,'SMass Conc (g/m3)',  0., 100.}
buffp(23) = {star,20, 'Snow Conc (g/m3)',  0., 100.}
buffp(24) = {star,21,              'Dur',  0., 100.}
buffp(25) = {star,22,             'Ywid',  0., 100.}

tem2 = {star2,BUFF_IND:0,XT:'',HMN:0.,HMX:0.,BINS:0.}
blobp = replicate({star2},38)
num_blobp = 29
blobp(2)  = {star2, 3,            'X Dim',  0.,  50., 1.}
blobp(3)  = {star2, 4,            'Y Dim',  0.,  50., 1.}
blobp(4)  = {star2, 1,             'Area',  0., 300., 1.}
blobp(5)  = {star2, 5,  'Heyms Diam (um)',  0.,  50., 1.}
blobp(7)  = {star2, 6,     'Holroyd Diam',  0.,  50., 1.}
blobp(8)  = {star2, 7,    'Holroyd Width',  0.,  50., 1.}
blobp(9)  = {star2,17,    'Holroyd Angle',  0., 360., 1.}
blobp(10) = {star2,18,        'Linearity',  0.,   1., 1.}
blobp(11) = {star2,19,            'Sigma',  0.,  10., 1.}
blobp(13) = {star2, 8,            'COM X',  0.,1000., 1.}
blobp(14) = {star2, 9,            'COM Y',  0.,1000., 1.}
blobp(16) = {star2,10,     'Equiv Circle',  0.,  50., 1.}
blobp(17) = {star2,11,       'Area Ratio',  0.,  20., 1.}
blobp(18) = {star2,12,           'Streak',  0.,  20., 1.}
blobp(19) = {star2,15,              'PDA',  0.,  20., 1.}
blobp(20) = {star2,16,              'CHI',  0.,  20., 1.}
blobp(22) = {star2,13, 'Inside Perimeter',  0.,  50., 1.}
blobp(23) = {star2,14,'Outside Perimeter',  0.,  50., 1.}
blobp(25) = {star2,20,             'Mass',  0.,  50., 1.}
blobp(26) = {star2,21,        'Mass Dens',  0.,  50., 1.}
blobp(27) = {star2,22,            'SMass',  0.,  50., 1.}
blobp(28) = {star2,23,       'SMass Dens',  0.,  50., 1.}
blobp(29) = {star2,24,        'Snow Mass',  0.,  50., 1.}
blobp(30) = {star2,25,   'Snow Mass Dens',  0.,  50., 1.}
blobp(32) = {star2,27,     'Eccentricity',  0.,  50., 1.}
blobp(33) = {star2,28,            'Theta',  0.,  50., 1.}
blobp(35) = {star2,36,       'Max Length',  0.,  50., 1.}
blobp(36) = {star2,37,      'Orientation',  0., 360., 1.}
blobp(37) = {star2,33,            'Habit',  0.,  15., 1.}

;part_ind = [  0, $   ;0 
;              0, $   ;1
;              3, $   ;2
;              4, $   ;3
;              1, $   ;4
;              5, $   ;5
;              0, $   ;6
;              6, $   ;7
;              7, $   ;8
;             17, $   ;9
;             18, $   ;10
;             19, $   ;11
;              0, $   ;12
;              8, $   ;13
;              9, $   ;14
;              0, $   ;15
;             10, $   ;16
;             11, $   ;17
;             12, $   ;18
;             15, $   ;19
;             16, $   ;20
;              0, $   ;21
;             13, $   ;22
;             14, $   ;23
;              0, $   ;24
;             20, $   ;25
;             21, $   ;26
;             22, $   ;27
;             23, $   ;28
;             24, $   ;29
;             25, $   ;30
;              0, $   ;31
;             27, $   ;32
;             28, $   ;33
;              0, $   ;34
;             36, $   ;35
;             37, $   ;36
;             33  ]   ;37
