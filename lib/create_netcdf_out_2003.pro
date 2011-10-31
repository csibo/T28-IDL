;******************************************************************
;
;- create_netCDF_out_2003.pro
;
; Author: Dr. Donna Kliche and Matt Beals
;
; Created: 10/24/2008
;
; Last update:10/24/2008
;
;*************************************************************************

pro create_netCDF_out_2003

select_flight_2003, yr

;read the needed fn from flightselected.txt
dir2 = ''
openr, 1,'t28idl.txt'
readf,1,dir2
close,1

fn_out = ''
title_flt = ''
fltno = intarr(1)
fltnos = ''
fn_hvps = ''
fn_reduced =''
fn_2dc = ''
fssp_chn = ''
fn_posttel = ''
year = ''
fn_hail = ''
fn_raw = ''

openr,1,dir2+'lib\flightselected.txt'
readf,1,fn_out
readf,1,title_flt
readf,1,fltnos
readf,1,fn_hvps
readf,1,fn_reduced
readf,1,fn_2dc
readf,1,fssp_chn
readf,1,fn_posttel
readf,1,year
readf,1,fn_hail
readf,1,fn_raw
close,1
;stop

fltno = strcompress(string(fltnos),/remove_all)
dir_out = 'K:\IAS-Staff\Donna\T28\ION-data\' + year + '\'
id = NCDF_CREATE(dir_out + fltno + '.nc', /clobber)


;- Set the output sample rate
output_rate = 20


;- FSSP constants
bdiam = 0.2           ;beam diameter in cm
dof = 2.39            ;depth of field in cm
bfrac = 0.54          ;beam fraction
beam_area = bdiam * dof * bfrac


;- 0=use Rosemount 1=use RFT (in derivative quantities)
temp_sw = 'Rose'

;- Read fssp.chn
openr,unit,fssp_chn, /get_lun
str = ''
fssp_data = fltarr(9,15)
for i=1,4 do readf,unit,str
readf,unit,fssp_data
free_lun,unit

fssp_min  = fssp_data(1,*)
fssp_max  = fssp_data(2,*)
fssp_mid  = fssp_data(3,*)
fssp_area = fssp_data(6,*)
fssp_vol  = fssp_data(7,*)

fdiam2 = fssp_mid^2
fdiam3 = fssp_mid^3
vol_const = (!pi * 1e-9) / (6. * 2.)
fssp_vol = vol_const * (fssp_min^3 + fssp_max^3)

read_dir,fn_raw, $
         output_rate, $
         tag, $        ;output
         offset, $
         freq, $
         num_tags, $
         dir_size, $
         record_size_byte, $
         num_records, $
         size_dn_hirate

;- Read the file into date/time and data arrays
;- Read in as integers
read_data,fn_raw,$
          num_records, $
          record_size_byte, $
          dir_size, $
          data, $          ;output
          data_byte, $
          date_str, $
          hours, $
          minutes, $
          seconds, $
          year, $
          month, $
          day


if fltno eq '727' then hours = hours + 12     ;Time fix for 727

se_buffs = [1,num_records]
start_buff = se_buffs(0) - 1
end_buff   = se_buffs(1) - 1

num_records = end_buff - start_buff + 1
hours   = hours(start_buff:end_buff)
minutes = minutes(start_buff:end_buff)
seconds = seconds(start_buff:end_buff)
data = data(*,start_buff:end_buff)
data_byte = data_byte(*,start_buff:end_buff)

;number of records on output at 20 per second
size_dn_hirate = (num_records - 1l) * long(output_rate) + 1l

;- Initialize the structures for reduced data and metadata
; (numbers, labels, format, min/max)
if fltno lt 782 then begin
init_tagst3,size_dn_hirate,hdata,metadata,num_tags_rnd
print,'the tags are: ',num_tags_rnd
endif

if fltno ge 782 then begin
 init_tagst4,size_dn_hirate,hdata,metadata,num_tags_rnd
 print,'the tags are: ',num_tags_rnd
endif

;- Convert one per second time to decimal hours and interpolate to output_rate
interp_time,hours, $          ;input
            minutes, $
            seconds, $
            output_rate, $
            hours_hirate, $        ;output
            minutes_hirate, $
            dec_seconds_hirate, $
            dec_hours_hirate, $
            times

hdata.hours_hirate       = hours_hirate
hdata.minutes_hirate     = minutes_hirate
hdata.dec_seconds_hirate = dec_seconds_hirate
stop
;------------------------------------------------------------------
;- Convert the digital numbers for each tag to engineering units
;------------------------------------------------------------------
for j=0,num_tags-1 do begin


 tag_num   = tag(j+1)
 print,'j, tag_num: ',j, tag_num
;stop
 ; the freq array was retrieved from read_dir subroutine
 samp_rate = freq(j+1)

 ;subtract out the directory and date/time byte lengths
 a1        = (offset(j+1) - dir_size - 18) / 2
 ind = lindgen(samp_rate) + a1
 ind_byte = a1 * 2
 dn = data(ind,*)   ;all samples for current tag for all records

 ; save the array values for the case of parameters recorded at 20Hz
 dn_raw = dn
;if (tag_num eq 9) then stop

 ;;if tag_num eq 990 then begin
 if (tag_num eq 93 or tag_num eq 990) then begin
   dn_byte_1 = data_byte(ind_byte,*)
   dn_byte_2 = data_byte(ind_byte + 1,*)
 endif else begin
  dn_byte_1 = data_byte(ind_byte,*)
  dn_byte_2 = data_byte(ind_byte + 1,*)
  dn_byte_3 = data_byte(ind_byte + 2,*)
  dn_byte_4 = data_byte(ind_byte + 3,*)
 endelse

 if tag_num eq 50 then begin
  hail_counts = intarr(14,num_records)
  hail_total_counts = lonarr(num_records)		;tag 152
  hail_ave_diameter = fltarr(num_records)		;tag 153

  hail_channel_ave_diam = [0.45, 0.55, 0.65, 0.75, 0.87, $
  						   1.02, 1.20, 1.43, 1.71, 2.02, $
  						   2.39, 2.91, 3.61, 4.50]
  for k=0,13 do hail_counts(k,*) = data(ind+k,*)

  count = 0
  for i = 0, num_records -1 do begin
    count = total(hail_counts(*,i))
    hail_total_counts(i) = count
    if (count ne 0) then begin
    hail_ave_diameter(i) = total(hail_channel_ave_diam*hail_counts(*,i))/hail_total_counts(i)
    endif

  endfor
  ;stop
 endif

; HVPS Housekeeping data
 if tag_num eq 71 then begin
  hvps_housekeeping = uintarr(8,num_records)
  for k=0,7 do hvps_housekeeping(k,*) = uint(data(ind+k,*))
 endif

;- FSSP quantities
 if tag_num eq 40 then begin
  fssp_counts   = intarr(15,num_records)
  fssp_gated_strobes = intarr(num_records)
  ;total_strobes = intarr(num_records)
  total_strobes = fltarr(num_records)
  activity      = intarr(num_records)
  blank18       = intarr(num_records)
  fssp_range    = intarr(num_records)
  ref_volt      = intarr(num_records)

  for k=0,14 do fssp_counts(k,*) = data(ind+k,*)
  fssp_gated_strobes = data(ind+15,*)	; good number of counts
;  total_strobes = data(ind+16,*)	; good and bad number of counts
  fssp_total_strobes = float(data(ind+16,*))	; good and bad number of counts
  v1 = where(fssp_total_strobes lt 0, nv1)	; negative numbers means we have values gt 2^15.
  max_val = 32768.0		; max value for 2^15
  temp_v1 = 0.0
  if (nv1 ne 0) then begin
    for i=0,nv1-1 do begin
     temp_v1 = max_val + fssp_total_strobes(v1(i))
     fssp_total_strobes(v1(i)) = max_val + temp_v1
     ;stop
    endfor
  endif

  activity      = data(ind+17,*)
  blank18       = data(ind+18,*)
  blank19       = data(ind+19,*)
  fssp_range    = data(ind+20,*) and 3
  ref_volt      = ishft(data(ind+20,*),-8)

;stop

 endif

 if tag_num eq 79 then gps_time = data_byte(ind_byte:ind_byte+9,*)

 ;- Interpolate/supersample the data to the desired rate
  new_dn = fltarr(size_dn_hirate)
if output_rate eq 1 AND (samp_rate eq 20 OR samp_rate eq 2) then begin
  for i=0,size_dn_hirate-1 do new_dn(i)=total(dn(*,i))/samp_rate
  dn = new_dn

endif

if output_rate gt 1 then dn = interpol(float(dn),size_dn_hirate)

;stop

 case tag_num of

  1: begin
     ;Dyn_press_1 recorded at 20Hz
     dyn_press_1 = fltarr(size_dn_hirate)
     for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
          ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           dyn_press_1(i*output_rate+m) = dn_raw(m,i) * 6.30452e-3 - 0.0489					;tag 101 (mb)
           GOTO, P1
          endif

          dyn_press_1(i*output_rate+m) = dn_raw(m,i) * 6.30452e-3 - 0.0489					;tag 101 (mb)

        endfor

        P1:

     endfor

     hdata.dyn_press_1 = dyn_press_1
     ;hdata.dyn_press_1  = dn * 6.30452e-3 - 0.0489                           ;tag 101 (mb)
     hdata.indic_as = sqrt(5.79e5 * ((1 + hdata.dyn_press_1 / 1013.3027)^0.28571 - 1.0))    ;tag 209 (m/s)
     ;stop
     end

  2: begin
     ;Dyn_press_2 recorded at 20Hz
     dyn_press_2 = fltarr(size_dn_hirate)
     for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin

         ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           dyn_press_2(i*output_rate+m) = dn_raw(m,i) * 5.28371e-3 - 1.5768					;tag 102 (mb)
           GOTO, P2
          endif
          dyn_press_2(i*output_rate+m) = dn_raw(m,i) * 5.28371e-3 - 1.5768					;tag 102 (mb)
        endfor
        P2:
     endfor
     hdata.dyn_press_2 = dyn_press_2
     ;hdata.dyn_press_2  = dn * 5.28371e-3 - 1.5768                           ;tag 102 (mb)
     ;stop
     end

  3: begin
     hdata.stat_press_1 = dn * 1.5791e-2 + 530.37   ;tag 103 (mb)

     hdata.pelev = 4.43077e4 * (1.0 - (hdata.stat_press_1 / 1013.3027)^0.190284)         ;tag 205 (m)
     hdata.dzdt = (shift(hdata.pelev,-output_rate) - shift(hdata.pelev,output_rate)) / 2.   ;tag 208 (m/s)

     end

  4: begin
     hdata.stat_press_2 = dn * 1.0917e-2 + 691.92          ;tag 104 (mb)

     end

  5: begin

     end

  6: begin
     calc_rose,dn, $          ;input
               hdata.dyn_press_1, $
               hdata.stat_press_1, $
               rose, $          ;output                                 ;tag 106 (deg C)
               calc_tas_rose
     hdata.rose = rose
     rose = 0
     end

  7: begin
     calc_rft,dn, $           ;input
              hdata.dyn_press_1, $
              hdata.stat_press_1, $
              rft, $          ;output                               ;tag 107 (deg C)
              calc_tas_rft
     hdata.rft = rft
     rft = 0
     end

  8: hdata.man_press    = dn * 3.1098041e-3 + 0.1592747                         ;tag 108 (inches)

  9: begin
     ;Acceleration_Vertical recorded at 20Hz
     accel_vert = fltarr(size_dn_hirate)
     for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           accel_vert(i*output_rate+m) = dn_raw(m,i) * 6.25e-5 + 1.0   					;tag 109 (g's)
           GOTO, P3
          endif
          accel_vert(i*output_rate+m) = dn_raw(m,i) * 6.25e-5 + 1.0   					;tag 109 (g's)
        endfor
        P3:
     endfor
     hdata.accel = accel_vert
     ;hdata.accel        = dn * 6.25e-5 + 1.0                              ;tag 109 (g's)
     ;stop
     end

  10: begin
      ;Pitch recorded at 20Hz
      pitch = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           pitch(i*output_rate+m) = dn_raw(m,i) * (-20.) * 1.5258789e-4 + 50.  ;tag 110 (deg)
           GOTO, P4
          endif
          pitch(i*output_rate+m) = dn_raw(m,i) * (-20.) * 1.5258789e-4 + 50.  ;tag 110 (deg)
        endfor
        P4:
      endfor
      hdata.pitch = pitch
      ;hdata.pitch = dn * (-20.) * 1.5258789e-4 + 50.  ;tag 110 (deg)

      if (temp_sw eq 'Rose') then begin
       temp = hdata.rose         ;temperature in C degrees
       hdata.calc_tas = calc_tas_rose
       ;stop                                  ;tag 211 (m/s)
      endif else begin
       temp = hdata.rft
       hdata.calc_tas = calc_tas_rft                                     ;tag 211 (m/s)
      stop
      endelse
      calc_tas_rose = 0     ;free memory
      calc_tas_rft  = 0

      grav = 9.775

    prev_stat_press = (shift(hdata.stat_press_1,1))

    ave_pressure = total(hdata.stat_press_1)/size_dn_hirate
    ave_height = total(hdata.pelev)/size_dn_hirate

    ptempk = (shift((temp+273.16),1)) ; previous temperature in Kelvin

    hdata.densmid = (0.34838 * prev_stat_press/ptempk)

    prev_pitch = (shift(hdata.pitch,1))

    angmid = (prev_pitch * 0.0174533)  ;radians

    ; must devide by 2* output_rate
    prev_accel = ((hdata.pelev) + shift(hdata.pelev,2*output_rate) - $
           2. * shift(hdata.pelev,output_rate))/(2.* output_rate) + grav

    ; in case hdata.accel is all zeroes, change it to this values...
    g = 9.775
    a_min = min(hdata.accel)
    a_max = max(hdata.accel)
    if ((a_min eq 0.0) AND (a_max eq 0.0)) then begin
     hdata.accel = prev_accel/g   ; DK 7-17-2001
     stop
    endif

    prod = (hdata.densmid*hdata.calc_tas)

    hdata.kopp_updraft = (hdata.dzdt) + (62.12/.65)*shift(prev_accel,1)/prod - $
                    ((0.02028/.65) + angmid)*hdata.calc_tas   ;valid as of 1/4/2001

    ind_tem = where(abs(hdata.kopp_updraft) gt 50.,cnt_tem)
    if cnt_tem ne 0 then hdata.kopp_updraft(ind_tem) = 50.                    ;tag 214 (m/s)
;stop
    end

  11: begin
      ;Roll recorded at 20Hz
      roll = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           roll(i*output_rate+m) = dn_raw(m,i) * 20. * 1.5258789e-4 - 50.	  ;tag 111 (deg)
           GOTO, P5
          endif
          roll(i*output_rate+m) = dn_raw(m,i) * 20. * 1.5258789e-4 - 50.	  ;tag 111 (deg)
        endfor
        P5:
      endfor
      hdata.roll = roll
      ;hdata.roll        = dn * 20. * 1.5258789e-4 - 50.                         ;tag 111 (deg)
      ;stop
      end

  13: begin

      end

  14: begin

      end

  16: begin
      hdata.volt_reg  = (5.0/32767.9)*dn ; generator voltage (Jan 23, 2004)

      end
  17: begin

      end                                                  ;tag 117 (deg)

  18: begin
      hdata.ncar_tas    = dn * 3.9674374e-3                               ;tag 118 (m/s)
      ;stop
      end

  19: begin
      hdata.pms_ee1     = dn * 1.5258789e-4                               ;tag 119
      ;stop
      end

  20: hdata.pms_ee2     = dn * 1.5258789e-4                               ;tag 120

  21: begin
      hdata.int_temp    = dn * 200. * 1.5258789e-4                           ;tag 121
      ;stop
      end
  23:

  24: begin
       htr_current       = dn * 20. * 1.5258789e-4                          ;tag 124 (amps)
      ;stop
      end

  28:                        ;

  29:

  30: begin
        event_bits  = dn
      end

  40: begin
      print,'Calculate FSSP quantities ...'
      fssp_tot_cnts = fltarr(num_records)
      sum_diam      = fltarr(num_records)
      sum_diam2     = fltarr(num_records)
      sum_diam3     = fltarr(num_records)
      equiv_diam    = fltarr(num_records)
      sum_var       = fltarr(num_records)
      water         = fltarr(num_records)
      ;initialize arrays
      fssp_tot_cnts(0:num_records-1)=0.0
      sum_diam(0:num_records-1)=0.0
      sum_diam2(0:num_records-1)=0.0
      sum_diam3(0:num_records-1)=0.0
      equiv_diam(0:num_records-1)=0.0
      sum_var(0:num_records-1)=0.0
      water(0:num_records-1)=0.0

      for k=0,num_records-1 do begin
       fssp_tot_cnts(k) = float(total(fssp_counts(*,k)))                           ;low rate
       sum_diam(k)   = total(fssp_counts(*,k) * fssp_mid(*))
       sum_diam2(k)  = total(fssp_counts(*,k) * fssp_mid(*)^2)
       sum_diam3(k)  = total(fssp_counts(*,k) * fssp_mid(*)^3)
       if sum_diam2(k) ne 0. then equiv_diam(k) = sum_diam3(k) / sum_diam2(k)             ;low rate
       sum_var(k)    = total(fssp_counts(*,k) * fssp_mid(*)^2 * (fssp_mid(*) - equiv_diam(k))^2)
       water(k)      = total(fssp_counts(*,k) * fssp_vol(*))

      endfor

      ; take care of zero values for equivalent diameter
      temp_equiv_diam = equiv_diam
      pequiv = where(temp_equiv_diam eq 0.0,np)
      ;print,np
      temp_equiv_diam(pequiv)=1.0	; avoid division by zero

	  temp_sum_diam2 = sum_diam2
	  psum = where(temp_sum_diam2 eq 0.0,ns)
	  ;print,ns
	  temp_sum_diam2(psum) = 1.0    ; avoid division by zero

      var = sum_var / (temp_equiv_diam^2 * temp_sum_diam2)                     ;low rate
      ;var = sum_var / (equiv_diam^2 * sum_diam2)                              ;low rate

      fssp_ave_diam = fltarr(num_records)

      ind = where(fssp_tot_cnts ne 0,cnt)
      if cnt ne 0 then begin
       fssp_ave_diam(ind) = sum_diam(ind) / fssp_tot_cnts(ind)

      hdata.fssp_ave_diam = interpol(fssp_ave_diam,size_dn_hirate)                    ;tag 142 (um)

      hdata.activity = interpol(activity / 10.,size_dn_hirate)                      ;tag 145 (%)

      sampling_volume = beam_area * hdata.calc_tas * (1. - (0.55 * hdata.activity / 100.))

      ;equiv_diam = sum_diam3 / sum_diam2
      equiv_diam = sum_diam3 / temp_sum_diam2	; to avoid division by zero

      hdata.equiv_diam = interpol(equiv_diam,size_dn_hirate)                        ;tag 148 (um)

      hdata.var = interpol(var,size_dn_hirate)                                ;tag 149 (um)

      fssp_tem = fssp_tot_cnts
      hdata.fssp_tot_cnts = interpol(fssp_tem,size_dn_hirate)                       ;tag 141 (#)
      fssp_counts = 0
      fssp_tem    = 0

      hdata.tot_part_conc = hdata.fssp_tot_cnts / sampling_volume                         ;tag 143 (#/cm3)
      hdata.fssp_lw = interpol(water,size_dn_hirate) / (sampling_volume*1e-3)   ;tag 144 (g/m3) changed on

      hdata.gated_strobes = interpol(fssp_gated_strobes,size_dn_hirate)                    ;tag 190 (#)
      hdata.total_strobes = interpol(fssp_total_strobes,size_dn_hirate)                    ;tag 191 (#)
      hdata.fssp_range = interpol(fssp_range * 100. + (ref_volt + 1.) / 25.5,size_dn_hirate)    ;tag 192 (v?)

      endif else result = dialog_message('The FSSP total counts is zero for the entire flight!')
      Print,'Done ...'
      end

  47: begin
      ;stop
      hdata.shad_or_2dc = dn
      end                                        ;tag 147 (#)

  50: begin
      hail_tot_cnts = fltarr(num_records)
      for k=0,num_records-1 do hail_tot_cnts(k) = float(total(hail_counts(*,k)))    ;tag 150 Hail channel cnts
      hail_tem = hail_tot_cnts
      hdata.hail_tot_cnts = interpol(hail_tem,size_dn_hirate)                       ;tag 152 (#)
      hdata.hail_conc = (hdata.hail_tot_cnts)/(0.1* hdata.calc_tas)  				;#/m3  tag 154

	  hail_water = fltarr(num_records)												;tag 155
      hail_channel_volume = [0.047713, 0.087114, 0.14379, 0.22089, 0.34479, $
      						 0.55565 , 0.90478 , 1.5311 , 2.6181 , 4.2837 , $
      						 7.1481 ,  12.903  , 24.531 , 47.713]

      for k=0,num_records-1 do  begin
        temp = total(hail_counts(*,k)*hail_channel_volume*0.9)
        hail_water(k) = temp/(0.1*hdata.calc_tas(k))								;tag 155
      endfor
      hail_water_tem = hail_water
      hdata.hail_water = interpol(hail_water_tem, size_dn_hirate)					;g/m3 tag 155

      temp2 = hail_ave_diameter
      hdata.hail_ave_diam = interpol(temp2, size_dn_hirate)
      ;stop

      hail_counts = 0
      hail_tem    = 0
      hail_water_tem = 0
      temp2=0
      end
                                                    ;tag 169 (needs cal factors)
  ;- 05/28/2002: Dr. Mo fixed the offset for tags 160-168 (field meals)
  60: begin
      ;TFM_LO recorded at 20Hz
      tfm_lo = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           tfm_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 138.39 + 0.094 - (- 0.35)   	  ;tag 160 (kV/m)
           GOTO, P6
          endif
          tfm_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 138.39 + 0.094 - (- 0.35)   	  ;tag 160 (kV/m)
        endfor
        P6:
      endfor
      hdata.tfm_lo = tfm_lo
      ;hdata.tfm_lo      = -dn * 1.5258789e-4 * 138.39 + 0.094 - (- 0.35) ;tag 160 (kV/m)

      ;stop
      end

  61: begin
      ;BFM_LO recorded at 20Hz
      bfm_lo = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           bfm_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 649.82 + 6.4869 - (+1.73)   	  ;tag 161 (kV/m)
           GOTO, P7
          endif
          bfm_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 649.82 + 6.4869 - (+1.73)   	  ;tag 161 (kV/m)
        endfor
        P7:
      endfor
      hdata.bfm_lo = bfm_lo
      ;hdata.bfm_lo      = -dn * 1.5258789e-4 * 649.82 + 6.4869 - (+1.73) ;tag 161 (kV/m)

      ;stop
      end

  62: begin
      ;LFM_LO recorded at 20Hz
      lfm_lo = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           lfm_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 633.88 - 0.9751 - (-1.71) ;tag 162 (kV/m)
           GOTO, P8
          endif
          lfm_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 633.88 - 0.9751 - (-1.71) ;tag 162 (kV/m)
        endfor
        P8:
      endfor
      hdata.lfm_lo = lfm_lo
      ;hdata.lfm_lo      = -dn * 1.5258789e-4 * 633.88 - 0.9751 - (-1.71) ;tag 162 (kV/m)

      ;stop
      end

  63: begin
      ;RFM_LO recorded at 20Hz
      rfm_lo = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           rfm_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 639.90 - 2.0759 - (-2.5)  ;tag 163 (kV/m)
           GOTO, P9
          endif
          rfm_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 639.90 - 2.0759 - (-2.5)  ;tag 163 (kV/m)
        endfor
        P9:
      endfor
      hdata.rfm_lo = rfm_lo
      ;hdata.rfm_lo      = -dn * 1.5258789e-4 * 639.90 - 2.0759 - (-2.5)  ;tag 163 (kV/m)

      ;stop
      end

  68: begin
      ;FM5_LO recorded at 20Hz
      fm5_lo = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           fm5_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 137.04 + 0.1814 - (+0.11) ;tag 168 (kV/m)
           GOTO, P10
          endif
          fm5_lo(i*output_rate+m) = -dn_raw(m,i) * 1.5258789e-4 * 137.04 + 0.1814 - (+0.11) ;tag 168 (kV/m)
        endfor
        P10:
      endfor
      hdata.fm5_lo = fm5_lo
      ;hdata.fm5_lo      = -dn * 1.5258789e-4 * 137.04 + 0.1814 - (+0.11) ;tag 168 (kV/m)
      ;stop
      end

  69: begin
      ;FM6_LO recorded at 20Hz
      fm6_lo = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           fm6_lo(i*output_rate+m) = +dn_raw(m,i) * 1.5258789e-4 * 252.0654 - 0.16678 - (+0.49);tag 169 (kV/m)
           GOTO, P11
          endif
          fm6_lo(i*output_rate+m) = +dn_raw(m,i) * 1.5258789e-4 * 252.0654 - 0.16678 - (+0.49);tag 169 (kV/m)
        endfor
        P11:
      endfor
      hdata.fm6_lo = fm6_lo
      ;hdata.fm6_lo      = +dn * 1.5258789e-4 * 252.0654 - 0.16678 - (+0.49);tag 169
      ;stop                                                  ;tag 169 (needs cal factors)
      end

  70:begin
     hdata.shad_or_hvps = +dn ; '#' tag 170
     end

  71: begin
      print,'Reading HVPS Housekeeping Data ...'
       hvps1 = float(hvps_housekeeping(0,*))*0.001 - 23.1   ;tag 671 (C)
       ;;print,hvps_housekeeping(0,*)
       ;;print,hvps1
       hvps2 = float(hvps_housekeeping(1,*))*0.001 - 23.1   ;tag 672 (C)
       hvps3 = float(hvps_housekeeping(2,*))*0.001 - 23.1   ;tag 673 (C)
       hvps4 = float(hvps_housekeeping(3,*))*0.001 - 23.1   ;tag 674 (C)
       hvps5 = float(hvps_housekeeping(4,*))*0.001 - 23.1   ;tag 675 (C)
       hvps6 = float(hvps_housekeeping(5,*))*0.0001 - 0.0   ;tag 676 (V)
       hvps7 = float(hvps_housekeeping(6,*))*0.0001 - 0.0   ;tag 677 (V)
       hvps8 = float(hvps_housekeeping(7,*))*0.0006 - 0.0   ;tag 678 (mW)

       hdata.hvps_house1=interpol(hvps1,size_dn_hirate)
       hdata.hvps_house2=interpol(hvps2,size_dn_hirate)
       hdata.hvps_house3=interpol(hvps3,size_dn_hirate)
       hdata.hvps_house4=interpol(hvps4,size_dn_hirate)
       hdata.hvps_house5=interpol(hvps5,size_dn_hirate)
       hdata.hvps_house6=interpol(hvps6,size_dn_hirate)
       hdata.hvps_house7=interpol(hvps7,size_dn_hirate)
       hdata.hvps_house8=interpol(hvps8,size_dn_hirate)
      end

  72: begin
      lat_deg     = dn_byte_2
      lat_min     = dn_byte_3
      lat_hun     = dn_byte_4
      lat_dec_min = float(lat_min) + float(lat_hun) / 100.
      lat_dec_deg = float(lat_deg) + lat_dec_min / 60.

      lat_deg_hirate     = interpol(lat_deg,size_dn_hirate)
      lat_dec_min_hirate = interpol(lat_dec_min,size_dn_hirate)
      hdata.lat_dec_deg_hirate = interpol(lat_dec_deg,size_dn_hirate)                          ;tag 172 (dec deg)
      ;stop
      lat_deg = 0     ;free memory
      lat_min = 0
      lat_hun = 0
      lat_dec_min = 0
      lat_dec_deg = 0
      lat_deg_hirate = 0
      lat_dec_min_hirate = 0
      end

  73: begin
      lon_deg     = dn_byte_2
      lon_min     = dn_byte_3
      lon_hun     = dn_byte_4
      lon_dec_min = float(lon_min) + float(lon_hun) / 100.
      lon_dec_deg = -(float(lon_deg) + lon_dec_min / 60.)
      stop
      lon_deg_hirate     = interpol(-float(lon_deg),size_dn_hirate)
      lon_dec_min_hirate = interpol(lon_dec_min,size_dn_hirate)
      hdata.lon_dec_deg_hirate = interpol(lon_dec_deg,size_dn_hirate)                         ;tag 173 (dec deg)
      stop
      lat_deg = 0     ;free memory
      lat_min = 0
      lat_hun = 0
      lat_dec_min = 0
      lat_dec_deg = 0
      lat_deg_hirate = 0
      lat_dec_min_hirate = 0
      end

  74: begin
      hdata.gps_grd_spd = dn * (1852. / 10. / 3600.)                             ;tag 174 (m/s)
      stop
      end

  75: begin
      hdata.gps_grd_trk_angle = dn / 10.                                     ;tag 175 (deg)
      stop
      end

  76: begin
      tem = float(dn_byte_1) + dn_byte_2 * 2.^8 + dn_byte_3 * 2.^16 + dn_byte_4 * 2.^24
      dn_tem = tem
      tem = interpol(dn_tem,size_dn_hirate)
      hdata.gps_mag_var = tem / 10.                                        ;tag 176 (deg)
      stop
      end

  78: begin
      tem = float(dn_byte_1) + dn_byte_2 * 2.^8 + dn_byte_3 * 2.^16 + dn_byte_4 * 2.^24
      dn_tem = tem
      tem = interpol(dn_tem,size_dn_hirate)
      hdata.gps_alt = tem * 0.03048                                        ;tag 178 (m ASL)
      end

  79: begin
      gps_seconds = fix(string(gps_time(6:7,*)))
      gps_s = interpol(gps_seconds,size_dn_hirate)
      hdata.gps_seconds = gps_s                          ;no tag yet

      gps_minutes = fix(string(gps_time(3:4,*)))
      gps_m = interpol(gps_minutes,size_dn_hirate)
      hdata.gps_minutes =  gps_m                          ;no tag yet

      gps_hours   = fix(string(gps_time(0:1,*)))
      gps_h = interpol(gps_hours,size_dn_hirate)
      hdata.gps_hours = gps_h

      dec_hours_gps = double(hdata.gps_hours) + double(hdata.gps_minutes) / 60. + double(hdata.gps_seconds) / 3600.

stop
      end

  85: begin
      gps_roc = dn*5.08e-4		; Tag 185 (m/s)
      hdata.GPS_ROC = gps_roc
      stop
      end

  86: begin
     dmt_lw,dn,hdata.stat_press_1,hdata.rose,hdata.calc_tas, $     ;input
            lwc                                               ;output               ;tag 186 (g/m3)
         hdata.lwc = lwc
         ;stop
      end

  ;unstabilized 3-axis accelerometer
  90: begin
      ;Accel_X recorded at 20Hz
      accel_x = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           accel_x(i*output_rate+m) = (dn_raw(m,i) * 1.5258789e-4 - 2.511) / 0.492  	  ;tag 290 (g's)
           GOTO, P12
          endif
          accel_x(i*output_rate+m) = (dn_raw(m,i) * 1.5258789e-4 - 2.511) / 0.492  	  ;tag 290 (g's)
        endfor
        P12:
      endfor
      hdata.accel_x = accel_x
      ;hdata.accel_x = (dn * 1.5258789e-4 - 2.511) / 0.492                         ;tag 290 (g's)
;stop
      end

  91: begin
      ;Accel_Y recorded at 20Hz
      accel_y = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0l,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           accel_y(i*output_rate+m) = (dn_raw(m,i) * 1.5258789e-4 - 2.490) / 0.5  	  ;tag 291 (g's)
           GOTO, P13
          endif
          accel_y(i*output_rate+m) = (dn_raw(m,i) * 1.5258789e-4 - 2.490) / 0.5  	  ;tag 291 (g's)
        endfor
        P13:
      endfor
      hdata.accel_y = accel_y
      ;hdata.accel_y = (dn * 1.5258789e-4 - 2.490) / 0.5                            ;tag 291 (g's)

      ;stop
      end

  92: begin
      ;Accel_Z recorded at 20Hz
      accel_z = fltarr(size_dn_hirate)
      for i=0l, num_records -1l do begin
        for m=0,output_rate-1l do begin
        ;for last point in the number of records
          if (i eq (num_records-1l)) then begin
           accel_z(i*output_rate+m) = (dn_raw(m,i) * 1.5258789e-4 - 2.513) / 0.503  	  ;tag 292 (g's)
           GOTO, P14
          endif
          accel_z(i*output_rate+m) = (dn_raw(m,i) * 1.5258789e-4 - 2.513) / 0.503  	  ;tag 292 (g's)
        endfor
        P14:
      endfor
      hdata.accel_z = accel_z
      ;hdata.accel_z = (dn * 1.5258789e-4 - 2.513) / 0.503                         ;tag 292 (g's)

      ;stop
      end


  else:

 endcase

endfor


;NO was not measured during STEPS 2000 Project; we will initiate the array with only zero values
NO_array = fltarr(num_records)
NO_array(*) = 0.0
hdata.NO_CONC = interpol(NO_array, size_dn_hirate)


; Tag 117 - HEADING was not recorded during STEPS 2000 Project; the array is initiated with only zero values
HEADING_array = fltarr(num_records)
HEADING_array(*) = 0.0
HEADING = interpol(HEADING_array, size_dn_hirate)

;- Calculate the derivative quantities
;- Calculate SMR and ThetaE
calc_thetae,temp, $          ;input
            hdata.stat_press_1, $
            sat_mix,      $    ;output           ;tag 207 (g/kg?)
            thetae
                                            ;tag 206 (deg C?)
         hdata.sat_mix_ratio = sat_mix
         hdata.thetae = thetae
;stop
calc_thetae,hdata.rft, $          ;input
            hdata.stat_press_1, $
            sat_mixrft,      $    ;output           ;tag 207 (g/kg?)
            thetaerft
temp = 0

;- Calculate turbulence
;- Note that the FFT width is constant so each output rate will give somewhat different
;- results
calc_turb,hdata.calc_tas, $     ;input
          turb            ;output            ;tag 216 (cm^2/3 /s)
          hdata.turb = turb

;- Electric field calculations - valid as April 1, 2002
;-----------------------------------------------------------
;Aircraft Reference Frame - valid as April 1, 2002
hdata.ex_aircraft = (hdata.fm6_lo-1.1*hdata.fm5_lo)/4.5
hdata.ey_aircraft = (hdata.lfm_lo-hdata.rfm_lo)/44.8

if ((year ne 2002) AND (year ne 2003)) then begin
hdata.ez_aircraft = 0.0843*hdata.lfm_lo+0.0229*hdata.rfm_lo-0.1735*hdata.fm5_lo
endif

if (year ge 2002) then begin
hdata.ez_aircraft = 0.0666*hdata.lfm_lo+0.0181*hdata.rfm_lo-0.1735*hdata.fm5_lo
endif

;Flight Path Reference Frame - valid as April 1, 2002
;---------preliminary calculations---------------------------
PI = 3.1415927
p = hdata.pitch*PI/180.     ;pitch in radians
r = hdata.roll*PI/180.   ;roll in radians
;ht = htd*PI/180.          ;conversion of true heading to radians
gta = hdata.gps_grd_trk_angle*PI/180. ; in radians
sp = sin(p)           ;sine of pitch
sr = sin(r)
;sht = sin(ht)
sgta = sin(gta)
cp = cos(p)           ;sine of pitch
cr = cos(r)
;cht = cos(ht)
cgta = cos(gta)
;-------------------------------------------------------------------
hdata.ex_path = hdata.ex_aircraft*cp+hdata.ey_aircraft*(-sp)*(-sr) + hdata.ez_aircraft*(-sp)*cr
hdata.ey_path = hdata.ey_aircraft*cr + hdata.ez_aircraft*sr
hdata.ez_path = hdata.ex_aircraft*sp + hdata.ey_aircraft*cp*(-sr)+hdata.ez_aircraft*cp*cr

;Earth reference frame - valid as April 1, 2002
;--------------------------------------------------------------------
hdata.ex_earth = hdata.ex_aircraft*(sgta*cp) + hdata.ey_aircraft*(sgta*(-sp)*(-sr) +$
         (-cgta)*cr) + hdata.ez_aircraft*(sgta(-sp)*cr + (-cgta)*sr)

hdata.ey_earth = hdata.ex_aircraft*(cgta*cp) + hdata.ey_aircraft*(cgta*(-sp)*(-sr) + $
         sgta*cr) + hdata.ez_aircraft*(cgta*(-sp)*cr + sgta*sr)

hdata.ez_earth = hdata.ex_aircraft*(sp) + hdata.ey_aircraft*(cp*(-sr)) + hdata.ez_aircraft*(cp*cr)

;Aircraft Charge - valid as April 1, 2002
hdata.eq_aircraft = -0.88*hdata.fm6_lo + 1.2*hdata.fm5_lo + 0.2*hdata.lfm_lo +$
            0.16*hdata.rfm_lo

;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; END MODULAR CODE
; The code from this point on is important to generation of the netCDF files.
; It contains some additional products generated from the previously generated data.
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; convert HH:MM:SS time into decimal seconds
time = hdata.hours_hirate*3600 + hdata.minutes_hirate*60 + hdata.dec_seconds_hirate
;stop
;calculate total number of records at 1 second data rate
n=end_buff+1

;calculate total number of records at 1 second data rate
range=size(times,/n_elements)

;generate ASCII strings for time at first and last data point in HH:MM:SS format
timeinit=strcompress(string(fix(hdata.hours_hirate(0)),format = '(I02)')+":"+$
         string(fix(hdata.minutes_hirate(0)),format = '(I02)')+":"+$
         string(fix(hdata.dec_seconds_hirate(0)),format = '(I02)'),/remove_all)

trng = strcompress(timeinit + "-" + $
	   string(fix(hdata.hours_hirate(range-1)),format = '(I02)')+":"+$
	   string(fix(hdata.minutes_hirate(range-1)),format = '(I02)')+":"+$
	   string(fix(hdata.dec_seconds_hirate(range-1)),format = '(I02)'),/remove_all)
;..................................................................................

;generate a reference array, in seconds since the first point
TTime = findgen(float(n)*20);
TTime = TTime/20;
;..................................................................................

;reformat the date string with '/' instead of '-' as a delimeter
dte = strsplit(date_str, '-',/extract)
newdate = string(dte(2),format = '(I04)') + '-' + $
          string(dte(0),format = '(I02)') + '-' + $
          string(dte(1),format = '(I02)')
timeunits = "seconds since " + newdate +" "+ timeinit + " +0000"

dateslash =string(dte(0),format = '(I02)') + '/' + $
           string(dte(1),format = '(I02)') + '/' + $
           string(dte(2),format = '(I04)')
;..................................................................................

;calculate mixing ratios for two LW probes
hdata.FSSP_MIX_RATIO = hdata.FSSP_LW/(hdata.DENSMID)
hdata.HAIL_MIX_RATIO = hdata.HAIL_WATER/(hdata.DENSMID)

;convert event_bits array into binary array
event_bits = (-1*event_bits-1)/2

;stop

;======================================================
;
;	GENERATE netCDF FILES
;
;======================================================
NCDF_CONTROL,0,/VERBOSE ; Set this keyword to cause netCDF error messages to be printed

;::::::::::::::::Define Global Variables :::::::::::::::::::::::::::::::::::::::::::::
NCDF_ATTPUT, id, 'FlightNumber', fltno, /global
NCDF_ATTPUT, id, 'Year', year, /global
NCDF_ATTPUT, id, 'FlightDate', dateslash, /global
NCDF_ATTPUT, id, 'coordinates', "LONGITUDE_DECIMAL_DEG_20Hz LATITUDE_DECIMAL_DEG_20Hz GPS_ALTITUDE Time", /global
NCDF_ATTPUT, id, 'TimeInterval', trng, /global
NCDF_ATTPUT, id, 'Conventions', "NCAR-RAF/nimbus", /global
NCDF_ATTPUT, id, 'slowpoints', n, /global
NCDF_ATTPUT, id, 'fastpoints', range, /global

;::::::::::::::::Define Dimensions :::::::::::::::::::::::::::::::::::::::::::::::::::
timeID = NCDF_DIMDEF(id, 'Time', n)		;slow rate dimension
rate20 = NCDF_DIMDEF(id, 'sps20', 20)   ;high-rate dimension

;::::::::::::::::Initialize Variables with Attributes ::::::::::::::::::::::::::::::::
; Atributes include the variables unit using Unidata standard format. The title is a
;plain text description of the variable. Both atributes are used in webT-28 for axis
;lables. the dimensions are set so that the data is a 20xn array,where row 0 is the
;slow rate data (every second). Each additional row consists of the hirate data,
;with a single column representing one second worth of data.
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
   HOURS_HIRATEID = NCDF_VARDEF(id,'TIME_HOURS_20Hz', [rate20,timeID], /float)
      NCDF_ATTPUT, id, HOURS_HIRATEID, 'units', 'hour'
      NCDF_ATTPUT, id, HOURS_HIRATEID, 'title', 'Hours'
      print,'HOURS_HIRATEID=',HOURS_HIRATEID

   MINUTES_HIRATEID = NCDF_VARDEF(id,'TIME_MINUTES_20Hz', [rate20,timeID], /float)
      NCDF_ATTPUT, id, MINUTES_HIRATEID, 'units', 'minute'
      NCDF_ATTPUT, id, MINUTES_HIRATEID, 'title', 'Minutes'
      print,'MINUTESS_HIRATEID=',MINUTES_HIRATEID

   DEC_SECONDS_HIRATEID = NCDF_VARDEF(id,'TIME_SECONDS_20Hz', [rate20,timeID], /float)
      NCDF_ATTPUT, id, DEC_SECONDS_HIRATEID, 'units', 'sec'
      NCDF_ATTPUT, id, DEC_SECONDS_HIRATEID, 'title', 'Seconds'
      print,'DEC_SECONDS_HIRATEID=',DEC_SECONDS_HIRATEID

;------------------------------------------------------------------------------------
; Define State Variables
;------------------------------------------------------------------------------------
STAT_PRESS_1ID = NCDF_VARDEF(id,'PRESSURE_STATIC_1', [rate20, timeID], /float)
      NCDF_ATTPUT, id, STAT_PRESS_1ID, 'units', 'hPa'
      NCDF_ATTPUT, id, STAT_PRESS_1ID, 'title', 'Static Pressure 1'
      print,'STAT_PRESS_1ID=',STAT_PRESS_1ID

   STAT_PRESS_2ID = NCDF_VARDEF(id,'PRESSURE_STATIC_2', [rate20, timeID], /float)
      NCDF_ATTPUT, id, STAT_PRESS_2ID, 'units', 'hPa'
      NCDF_ATTPUT, id, STAT_PRESS_2ID, 'title', 'Static Pressure 2'
      print,'STAT_PRESS_2ID=',STAT_PRESS_2ID

   ROSEID = NCDF_VARDEF(id,'TEMPERATURE_ROSEMOUNT_SENSOR', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ROSEID, 'units', 'Celsius'
      NCDF_ATTPUT, id, ROSEID, 'title', 'Temperature - Rosemount Sensor'
      print,'ROSEID=',ROSEID

   RFTID = NCDF_VARDEF(id,'TEMPERATURE_REVERSE_FLOW_SENSOR', [rate20, timeID], /float)
      NCDF_ATTPUT, id, RFTID, 'units', 'Celsius'
      NCDF_ATTPUT, id, RFTID, 'title', 'Temperature - Reverse Flow Sensor'
      print,'RFTID=',RFTID

   THETAEID = NCDF_VARDEF(id,'TEMPERATURE_EQUIVALENT_POTENTIAL', [rate20, timeID], /float)
      NCDF_ATTPUT, id, THETAEID, 'units', 'Kelven'
      NCDF_ATTPUT, id, THETAEID, 'title', 'Theta E'
      print,' THETAEID=', THETAEID

   DENSMIDID = NCDF_VARDEF(id,'DENSITY_AIR', [rate20, timeID], /float)
      NCDF_ATTPUT, id, DENSMIDID, 'units', 'kgram/meter^3'
      NCDF_ATTPUT, id, DENSMIDID, 'title', 'Air Density'

   ; NO not recorded during STEPS project; all values are initiated to zero
   NO_CONCID = NCDF_VARDEF(id,'NO_CONCENTRATION', [rate20, timeID], /float)
   NCDF_ATTPUT, id, NO_CONCID, 'units', 'ppb'
   NCDF_ATTPUT, id, NO_CONCID, 'title', 'NO concentration'


;------------------------------------------------------------------------------------
; Define Particle Data
;------------------------------------------------------------------------------------
; FSSP
   FSSP_LWID = NCDF_VARDEF(id,'FSSP_LIQUID_WATER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FSSP_LWID, 'units', 'gram/meter^3'
      NCDF_ATTPUT, id, FSSP_LWID, 'title', 'FSSP liquid water'
      print,' FSSP_LWID=', FSSP_LWID

   FSSP_TOT_CNTSID = NCDF_VARDEF(id,'FSSP_TOTAL_COUNTS', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FSSP_TOT_CNTSID, 'units', 'count'
      NCDF_ATTPUT, id, FSSP_TOT_CNTSID, 'title', 'FSSP total counts'
      print,'FSSP_TOT_CNTSID=',FSSP_TOT_CNTSID

   FSSP_AVE_DIAMID = NCDF_VARDEF(id,'FSSP_AVERAGE_DIAMETER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FSSP_AVE_DIAMID, 'units', 'umeter'
      NCDF_ATTPUT, id, FSSP_AVE_DIAMID, 'title', 'FSSP average diameter'
      print,'FSSP_AVE_DIAMID=',FSSP_AVE_DIAMID

   TOT_PART_CONCID = NCDF_VARDEF(id,'FSSP_TOTAL_PARTICLE_CONCENTRATION', [rate20, timeID], /float)
      NCDF_ATTPUT, id, TOT_PART_CONCID, 'units', 'count/cmeter3'
      NCDF_ATTPUT, id, TOT_PART_CONCID, 'title', 'FSSP Concentration'
      print,'TOT_PART_CONCID=',TOT_PART_CONCID

   EQUIV_DIAMID = NCDF_VARDEF(id,'FSSP_EQUIVALENT_DIAMETER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EQUIV_DIAMID, 'units', 'umeter'
      NCDF_ATTPUT, id, EQUIV_DIAMID, 'title', 'FSSP equivelant diameter'
      print,'EQUIV_DIAMID=',EQUIV_DIAMID

   VARID = NCDF_VARDEF(id,'FSSP_EQUIVALENT_DIAMETER_VARIANCE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, VARID, 'units', 'umeter'
      NCDF_ATTPUT, id, VARID, 'title', 'FSSP Equivalent Diameter variance'
      print,'VARID=',VARID

   FSSP_MIX_RATIOID = NCDF_VARDEF(id,'FSSP_LIQUID_WATER_MIXING_RATIO'  , [rate20, timeID], /float)
      NCDF_ATTPUT, id, FSSP_MIX_RATIOID, 'units', 'gram/kgram'
      NCDF_ATTPUT, id, FSSP_MIX_RATIOID, 'title', 'FSSP liquid water mixing ratio'
  ;HAIL
     HAIL_WATERID = NCDF_VARDEF(id,'HAIL_WATER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_WATERID, 'units', 'gram/m^3'
      NCDF_ATTPUT, id, HAIL_WATERID, 'title', 'HAIL liquid water content'
      print,'HAIL_WATERID=',HAIL_WATERID

   HAIL_TOT_CNTSID = NCDF_VARDEF(id,'HAIL_TOTAL_COUNTS', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_TOT_CNTSID, 'units', 'count'
      NCDF_ATTPUT, id, HAIL_TOT_CNTSID, 'title', 'HAIL total counts'
      print,'HAIL_TOT_CNTSID=',HAIL_TOT_CNTSID

   HAIL_AVE_DIAMID = NCDF_VARDEF(id,'HAIL_AVERAGE_DIAMETER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_AVE_DIAMID, 'units', 'cmeter'
      NCDF_ATTPUT, id, HAIL_AVE_DIAMID, 'title', 'HAIL average diameter'
      print,'HAIL_AVE_DIAMID=',HAIL_AVE_DIAMID

   HAIL_CONCID = NCDF_VARDEF(id,'HAIL_CONCENTRATION', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_CONCID, 'units', 'count/meter^3'
      NCDF_ATTPUT, id, HAIL_CONCID, 'title', 'HAIL concentration'
      print,'HAIL_CONCID=',HAIL_CONCID

   HAIL_MIX_RATIOID = NCDF_VARDEF(id,'HAIL_LIQUID_WATER_MIXING_RATIO'  , [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_MIX_RATIOID, 'units', 'gram/kgram'
      NCDF_ATTPUT, id, HAIL_MIX_RATIOID, 'title', 'HAIL liquid water mixing ratio'

   LWCID = NCDF_VARDEF(id,'LWC_DMT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, LWCID, 'units', 'gram/meter^3'
      NCDF_ATTPUT, id, LWCID, 'title', 'DMT liquid water'
      print,'LWCID=',LWCID

   SHAD_OR_2DCID = NCDF_VARDEF(id,'SHADOW_OR_PMS', [rate20, timeID], /float)
      NCDF_ATTPUT, id, SHAD_OR_2DCID, 'units', 'count'
      NCDF_ATTPUT, id, SHAD_OR_2DCID, 'title', '2DC Shadow or'
      print,'SHADOW_OR_2DCID=',SHAD_OR_2DCID

;------------------------------------------------------------------------------------
; Define Kinematic Data
;------------------------------------------------------------------------------------
   KOPP_UPDRAFTID = NCDF_VARDEF(id,'UPDRAFT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, KOPP_UPDRAFTID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, KOPP_UPDRAFTID, 'title', 'Updraft'

   TURBID = NCDF_VARDEF(id,'TURBULENCE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, TURBID, 'units', 'cm^2/3sec^-1'
      NCDF_ATTPUT, id, TURBID, 'title', 'Turbulence'
	; Unstabilized Accelerometers
   ACCEL_XID = NCDF_VARDEF(id,'ACCELERATION_X', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACCEL_XID, 'units', 'g'
      NCDF_ATTPUT, id, ACCEL_XID, 'title', 'X acceleration (Unstabilized)'

   ACCEL_YID = NCDF_VARDEF(id,'ACCELERATION_Y', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACCEL_YID, 'units', 'g'
      NCDF_ATTPUT, id, ACCEL_YID, 'title', 'Y acceleration (Unstabilized)'

   ACCEL_ZID = NCDF_VARDEF(id,'ACCELERATION_Z', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACCEL_ZID, 'units', 'g'
      NCDF_ATTPUT, id, ACCEL_ZID, 'title', 'Z acceleration (Unstabilized)'

   ACCELID = NCDF_VARDEF(id,'ACCELERATION_VERTICAL', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACCELID, 'units', 'g'
      NCDF_ATTPUT, id, ACCELID, 'title', 'Acceleration Vertical - Gyro Stabilized'
      print,'ACCELID=',ACCELID

   tempID = NCDF_VARDEF(id,'DZDT_POINT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, tempID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, tempID, 'title', 'dz/dt'
      print,'tempID=',tempID

   GPS_ROC_VARID = NCDF_VARDEF(id,'GPS_RATE_OF_CLIMB', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_ROC_VARID, 'units', 'm/s'
      NCDF_ATTPUT, id, GPS_ROC_VARID, 'title', 'GPS Rate of Climb'
      print,'GPS_ROC_VARID=',GPS_ROC_VARID

;------------------------------------------------------------------------------------
; Define Electric Field Data
;------------------------------------------------------------------------------------
; Low Res
   TFM_LOID = NCDF_VARDEF(id,'FIELD_METER_TOP', [rate20, timeID], /float)
      NCDF_ATTPUT, id, TFM_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, TFM_LOID, 'title', 'Top field mill, low res'
      print,'TFM_LOID=',TFM_LOID

   BFM_LOID = NCDF_VARDEF(id,'FIELD_METER_BOTTOM', [rate20, timeID], /float)
      NCDF_ATTPUT, id, BFM_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, BFM_LOID, 'title', 'Bottom field mill, low res'
      print,'BFM_LOID=',BFM_LOID

   LFM_LOID = NCDF_VARDEF(id,'FIELD_METER_LEFT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, LFM_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, LFM_LOID, 'title', 'Left field mill, low res'
      print,'LFM_LOID=',LFM_LOID

   RFM_LOID = NCDF_VARDEF(id,'FIELD_METER_RIGHT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, RFM_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, RFM_LOID, 'title', 'Right field mill, low res'
      print,'RFM_LOID=',RFM_LOID

   FM5_LOID = NCDF_VARDEF(id,'FIELD_METER_5', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FM5_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, FM5_LOID, 'title', 'Fifth field mill, low res'
      print,'FM5_LOID=',FM5_LOID

   FM6_LOID = NCDF_VARDEF(id,'FIELD_METER_6', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FM6_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, FM6_LOID, 'title', 'Sixth field mill, low res'
      print,'FM6_LOID=',FM6_LOID
; Airframe Rel
   EZ_AIRCRAFTID = NCDF_VARDEF(id,'EZ_AIRCRAFT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EZ_AIRCRAFTID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EZ_AIRCRAFTID, 'title', 'Z Electric Field (aircraft relative)'

   EY_AIRCRAFTID = NCDF_VARDEF(id,'EY_AIRCRAFT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EY_AIRCRAFTID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EY_AIRCRAFTID, 'title', 'Y Electric Field (aircraft relative)'

   EX_AIRCRAFTID = NCDF_VARDEF(id,'EX_AIRCRAFT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EX_AIRCRAFTID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EX_AIRCRAFTID, 'title', 'X Electric Field (aircraft relative)'

   EQ_AIRCRAFTID = NCDF_VARDEF(id,'EQ_AIRCRAFT_CHARGE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EQ_AIRCRAFTID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EQ_AIRCRAFTID, 'title', 'Electric Field from Aircraft Charge'

; Path Rel
   EZ_PATHID = NCDF_VARDEF(id,'EZ_PATH', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EZ_PATHID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EZ_PATHID, 'title', 'Z Electric Field (path relative)'

   EY_PATHID = NCDF_VARDEF(id,'EY_PATH', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EY_PATHID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EY_PATHID, 'title', 'Y Electric Field (path relative)'

   EX_PATHID = NCDF_VARDEF(id,'EX_PATH', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EX_PATHID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EX_PATHID, 'title', 'X Electric Field (path relative)'

; Earth Rel
   EZ_EARTHID = NCDF_VARDEF(id,'EZ_EARTH', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EZ_EARTHID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EZ_EARTHID, 'title', 'Z Electric Field (earth relative)'

   EY_EARTHID = NCDF_VARDEF(id,'EY_EARTH', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EY_EARTHID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EY_EARTHID, 'title', 'Y Electric Field (earth relative)'

   EX_EARTHID = NCDF_VARDEF(id,'EX_EARTH', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EX_EARTHID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EX_EARTHID, 'title', 'X Electric Field (earth relative)'

;------------------------------------------------------------------------------------
; Define Aircraft Motion Data
;------------------------------------------------------------------------------------
   GPS_ALTID = NCDF_VARDEF(id,'GPS_ALTITUDE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_ALTID, 'units', 'meter'
      NCDF_ATTPUT, id, GPS_ALTID, 'title', 'GPS altitude'
      print,'GPS_ALTID=',GPS_ALTID

   PELEVID = NCDF_VARDEF(id,'PRESSURE_ALTITUDE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, PELEVID, 'units', 'meter'
      NCDF_ATTPUT, id, PELEVID, 'title', 'Pressure Altitude'
      print,'PELEVID=',PELEVID

   GPS_GRD_SPDID = NCDF_VARDEF(id,'GPS_GROUNDSPEED', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_GRD_SPDID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, GPS_GRD_SPDID, 'title', 'GPS ground speed'
      print,'GPS_GRD_SPDID=',GPS_GRD_SPDID

   INDIC_ASID = NCDF_VARDEF(id,'INDICATED_AIRSPEED', [rate20, timeID], /float)
      NCDF_ATTPUT, id, INDIC_ASID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, INDIC_ASID, 'title', 'indicated Air Speed'
      print,'INDIC_ASID=',INDIC_ASID

   CALC_TASID = NCDF_VARDEF(id,'TRUE_AIRSPEED_CALCULATED'        , [rate20, timeID], /float)
      NCDF_ATTPUT, id, CALC_TASID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, CALC_TASID, 'title', 'Calculated True Air Speed'

   NCAR_TASID = NCDF_VARDEF(id,'TRUE_AIRSPEED_NCAR', [rate20, timeID], /float)
      NCDF_ATTPUT, id, NCAR_TASID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, NCAR_TASID, 'title', 'NCAR True Air Speed'
      print,'NCAR_TASID=',NCAR_TASID

   GPS_GRD_TRK_ANGLEID = NCDF_VARDEF(id,'GPS_GROUND_TRACK_ANGLE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_GRD_TRK_ANGLEID, 'units', 'degree'
      NCDF_ATTPUT, id, GPS_GRD_TRK_ANGLEID, 'title', 'GPS ground track angle'
      print,'GPS_GRD_TRK_ANGLEID=',GPS_GRD_TRK_ANGLEID

   PITCHID = NCDF_VARDEF(id,'PITCH'           , [rate20, timeID], /float)
      NCDF_ATTPUT, id, PITCHID, 'units', 'degree'
      NCDF_ATTPUT, id, PITCHID, 'title', 'Pitch'
      print,'PITCHID=',PITCHID

   ROLLID = NCDF_VARDEF(id,'ROLL', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ROLLID, 'units', 'degree'
      NCDF_ATTPUT, id, ROLLID, 'title', 'Roll'
      print,'ROLLID=',ROLLID

   HEADINGID = NCDF_VARDEF(id,'HEADING_MAGNETIC', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HEADINGID, 'units', 'degree'
      NCDF_ATTPUT, id, HEADINGID, 'title', 'HEADING'
      print,'HEADINGID=',HEADINGID

   GPS_MAGNETIC_DEVID = NCDF_VARDEF(id,'GPS_MAGNETIC_DEVIATION', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_MAGNETIC_DEVID, 'units', 'degree'
      NCDF_ATTPUT, id, GPS_MAGNETIC_DEVID, 'title', 'GPS Magnetic Deviation'
      print,'GPS_MAGNETIC_DEVID=',GPS_MAGNETIC_DEVID

;------------------------------------------------------------------------------------
; Define Probe Diagnostic Data
;------------------------------------------------------------------------------------
   PMS_EE1ID = NCDF_VARDEF(id,'PMS_END_ELEMENT_1', [rate20, timeID], /float)
      NCDF_ATTPUT, id, PMS_EE1ID, 'units', 'V'
      NCDF_ATTPUT, id, PMS_EE1ID, 'title', 'PMS end element 1'
      print,'PMS_EE1ID=',PMS_EE1ID

   PMS_EE2ID = NCDF_VARDEF(id,'PMS_END_ELEMENT_2', [rate20, timeID], /float)
      NCDF_ATTPUT, id, PMS_EE2ID, 'units', 'V'
      NCDF_ATTPUT, id, PMS_EE2ID, 'title', 'PMS end element 2'
      print,'PMS_EE2ID=',PMS_EE2ID

   ACTIVITYID = NCDF_VARDEF(id,'FSSP_ACTIVITY', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACTIVITYID, 'units', 'percent'
      NCDF_ATTPUT, id, ACTIVITYID, 'title', 'FSSP activity'
      print,'ACTIVITYID=',ACTIVITYID

;------------------------------------------------------------------------------------
; Define Housekeeping Data
;------------------------------------------------------------------------------------
   DYN_PRESS_1ID = NCDF_VARDEF(id,'PRESSURE_DYNAMIC_1', [rate20, timeID], /float)
      NCDF_ATTPUT, id, DYN_PRESS_1ID, 'units', 'hPa'
      NCDF_ATTPUT, id, DYN_PRESS_1ID, 'title', 'Dynamic Pressure 1'
      print,'DYN_PRESS_1ID=',DYN_PRESS_1ID

   DYN_PRESS_2ID = NCDF_VARDEF(id,'PRESSURE_DYNAMIC_2', [rate20, timeID], /float)
      NCDF_ATTPUT, id, DYN_PRESS_2ID, 'units', 'hPa'
      NCDF_ATTPUT, id, DYN_PRESS_2ID, 'title', 'Dynamic Pressure 2'
      print,'DYN_PRESS_2ID=',DYN_PRESS_2ID

   MAN_PRESSID = NCDF_VARDEF(id,'MANIFOLD_PRESSURE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, MAN_PRESSID, 'units', 'in_Hg'
      NCDF_ATTPUT, id, MAN_PRESSID, 'title', 'Manifold Pressure'
      print,'MAN_PRESSID=',MAN_PRESSID

   VOLT_REGID = NCDF_VARDEF(id,'VOLTAGE_REGULATOR', [rate20, timeID], /float)
      NCDF_ATTPUT, id, VOLT_REGID, 'units', 'V'
      NCDF_ATTPUT, id, VOLT_REGID, 'title', 'Voltage Regulator'
      print,'VOLT_REGID=',VOLT_REGID

   INT_TEMPID = NCDF_VARDEF(id,'INTERIOR_TEMPERATURE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, INT_TEMPID, 'units', 'Celsius'
      NCDF_ATTPUT, id, INT_TEMPID, 'title', 'Interior Temperature'
      print,'INT_TEMPID=',INT_TEMPID

   HTR_CURRENTID = NCDF_VARDEF(id,'HEATER_CURRENT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HTR_CURRENTID, 'units', 'A'
      NCDF_ATTPUT, id, HTR_CURRENTID, 'title', 'Heater Current'
      print,'HTR_CURENTID=',HTR_CURRENTID

   GATED_STROBESID = NCDF_VARDEF(id,'FSSP_GATED_STROBES'   , [rate20, timeID], /float)
      NCDF_ATTPUT, id, GATED_STROBESID, 'units', 'count'
      NCDF_ATTPUT, id, GATED_STROBESID, 'title', 'FSSP gated strobes'
      print,'GATED_STROBESID=',GATED_STROBESID

   TOTAL_STROBESID = NCDF_VARDEF(id,'FSSP_TOTAL_STROBES'   , [rate20, timeID], /float)
      NCDF_ATTPUT, id, TOTAL_STROBESID, 'units', 'count'
      NCDF_ATTPUT, id, TOTAL_STROBESID, 'title', 'FSSP total strobes'
      print,'TOTAL_STROBESID=',TOTAL_STROBESID

   GPS_TIMEID = NCDF_VARDEF(id,'TIME_GPS_DECIMAL', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_TIMEID, 'units', 'decimal hour'
      NCDF_ATTPUT, id, GPS_TIMEID, 'title', 'GPS decimal hours'
      print,'GPS_TIMEID=',GPS_TIMEID

; Pilot Reported Cloud
   EVENTID = NCDF_VARDEF(id, 'EVENT_MARKERS', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EVENTID, 'title', 'Event Trigger'

; more data
   LAT_DEC_DEG_HIRATEID = NCDF_VARDEF(id,'LATITUDE_DECIMAL_DEG_20Hz', [rate20, timeID], /float)
      NCDF_ATTPUT, id, LAT_DEC_DEG_HIRATEID, 'units', 'degree'
      NCDF_ATTPUT, id, LAT_DEC_DEG_HIRATEID, 'title', 'GPS Latitude'
      print,'LAT_DEC_DEG_HIRATEID=',LAT_DEC_DEG_HIRATEID

   LON_DEC_DEG_HIRATEID = NCDF_VARDEF(id,'LONGITUDE_DECIMAL_DEG_20Hz', [rate20, timeID], /float)
      NCDF_ATTPUT, id, LON_DEC_DEG_HIRATEID, 'units', 'degree'
      NCDF_ATTPUT, id, LON_DEC_DEG_HIRATEID, 'title', 'GPS Longitude'
      print,'LON_DEC_DEG_HIRATEID=',LON_DEC_DEG_HIRATEID

   FLSID = NCDF_VARDEF(id, 'time', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FLSID, 'units', 'seconds'
      NCDF_ATTPUT, id, FLSID, 'title', 'Time'

   UNITTIMEID = NCDF_VARDEF(id, 'Time', [rate20, timeID], /float)
      NCDF_ATTPUT, id, UNITTIMEID, 'units', timeunits
      NCDF_ATTPUT, id, UNITTIMEID, 'title', 'Time'



;end variable definition
NCDF_CONTROL, id, /ENDEF

;:::::::::::::::::::::Wite data to netCDF file:::::::::::::::::::::::::::::::::::::
;data original in a nx1 array is writen into 20xn array to match the dimension
;structure discussed above
container = dblarr(20,n)

   container(0:range-1) = hdata.HOURS_HIRATE(*)
   NCDF_VARPUT, id, HOURS_HIRATEID, container

   container(0:range-1) = hdata.MINUTES_HIRATE(*)
   NCDF_VARPUT, id, MINUTES_HIRATEID, container

   container(0:range-1) = hdata.DEC_SECONDS_HIRATE(*)
   NCDF_VARPUT, id, DEC_SECONDS_HIRATEID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write State Variables to netCDF file
;====================================================================================
   container(0:range-1) = hdata.STAT_PRESS_1(*)
   NCDF_VARPUT, id, STAT_PRESS_1ID, container

   container(0:range-1) = hdata.STAT_PRESS_2(*)
   NCDF_VARPUT, id, STAT_PRESS_2ID, container

   container(0:range-1) = hdata.ROSE(*)
   NCDF_VARPUT, id, ROSEID, container

   container(0:range-1) = hdata.RFT(*)
   NCDF_VARPUT, id, RFTID, container

   container(0:range-1) = hdata.THETAE(*)
   NCDF_VARPUT, id, THETAEID, container

   container(0:range-1) = hdata.DENSMID(*)
   NCDF_VARPUT, id, DENSMIDID, container

   ; all NO values are zero; no recordings during STEPS project
   container(0:range-1) = hdata.NO_CONC(*)
   NCDF_VARPUT, id, NO_CONCID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Particle Data to netCDF file
;====================================================================================
; FSSP
   container(0:range-1) = hdata.FSSP_LW(*)
   NCDF_VARPUT, id, FSSP_LWID, container

   container(0:range-1) = hdata.FSSP_TOT_CNTS(*)
   NCDF_VARPUT, id, FSSP_TOT_CNTSID,  container

   container(0:range-1) = hdata.FSSP_AVE_DIAM(*)
   NCDF_VARPUT, id, FSSP_AVE_DIAMID, container
   stop

   container(0:range-1) = hdata.TOT_PART_CONC(*)
   NCDF_VARPUT, id, TOT_PART_CONCID, container

   container(0:range-1) = hdata.EQUIV_DIAM(*)
   NCDF_VARPUT, id, EQUIV_DIAMID, container

   container(0:range-1) = hdata.VAR(*)
   NCDF_VARPUT, id, VARID, container

   container(0:range-1) = hdata.FSSP_MIX_RATIO(*)
   NCDF_VARPUT, id, FSSP_MIX_RATIOID, container

; HAIL
   container(0:range-1) = hdata.HAIL_WATER(*)
   NCDF_VARPUT, id, HAIL_WATERID, container

   container(0:range-1) = hdata.HAIL_TOT_CNTS(*)
   NCDF_VARPUT, id, HAIL_TOT_CNTSID, container

   container(0:range-1) = hdata.HAIL_AVE_DIAM(*)
   NCDF_VARPUT, id, HAIL_AVE_DIAMID, container

   container(0:range-1) = hdata.HAIL_CONC(*)
   NCDF_VARPUT, id, HAIL_CONCID, container

   container(0:range-1) = hdata.HAIL_MIX_RATIO(*)
   NCDF_VARPUT, id, HAIL_MIX_RATIOID, container

   container(0:range-1) = hdata.LWC(*)
   NCDF_VARPUT, id, LWCID, container

   container(0:range-1) = hdata.SHAD_OR_2DC(*)
   NCDF_VARPUT, id, SHAD_OR_2DCID, container
   stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Kinematic Data to netCDF file
;====================================================================================
   container(0:range-1) = hdata.KOPP_UPDRAFT(*)
   NCDF_VARPUT, id, KOPP_UPDRAFTID, container

   container(0:range-1) = hdata.TURB(*)
   NCDF_VARPUT, id, TURBID, container

; Unstabilized Accelerometers
   container(0:range-1) = hdata.ACCEL_X(*)
   NCDF_VARPUT, id, ACCEL_XID, container

   container(0:range-1) = hdata.ACCEL_Y(*)
   NCDF_VARPUT, id, ACCEL_YID, container

   container(0:range-1) = hdata.ACCEL_Z(*)
   NCDF_VARPUT, id, ACCEL_ZID, container

   container(0:range-1) = hdata.ACCEL(*)	; acceleration vertical
   NCDF_VARPUT, id, ACCELID, container

   container(0:range-1) = hdata.DZDT(*)
   NCDF_VARPUT, id, tempID, container

   container(0:range-1) = hdata.GPS_ROC(*)	; Tag 185
   NCDF_VARPUT, id, GPS_ROC_VARID, container
stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Electric Field Data to netCDF file
;====================================================================================
; Low Res
   container(0:range-1) = hdata.TFM_LO(*)
   NCDF_VARPUT, id, TFM_LOID, container

   container(0:range-1) = hdata.BFM_LO(*)
   NCDF_VARPUT, id, BFM_LOID, container

   container(0:range-1) = hdata.LFM_LO(*)
   NCDF_VARPUT, id, LFM_LOID, container

   container(0:range-1) = hdata.RFM_LO(*)
   NCDF_VARPUT, id, RFM_LOID, container

   container(0:range-1) = hdata.FM5_LO(*)
   NCDF_VARPUT, id, FM5_LOID, container

   container(0:range-1) = hdata.FM6_LO(*)
   NCDF_VARPUT, id, FM6_LOID, container

; Airframe Relative
   container(0:range-1) = hdata.EZ_AIRCRAFT(*)
   NCDF_VARPUT, id, EZ_AIRCRAFTID, container

   container(0:range-1) = hdata.EY_AIRCRAFT(*)
   NCDF_VARPUT, id, EY_AIRCRAFTID, container

   container(0:range-1) = hdata.EX_AIRCRAFT(*)
   NCDF_VARPUT, id, EX_AIRCRAFTID, container

   container(0:range-1) = hdata.EQ_AIRCRAFT(*)
   NCDF_VARPUT, id, EQ_AIRCRAFTID, container

; Path Relative
   container(0:range-1) = hdata.EZ_PATH(*)
   NCDF_VARPUT, id, EZ_PATHID, container

   container(0:range-1) = hdata.EY_PATH(*)
   NCDF_VARPUT, id, EY_PATHID, container

   container(0:range-1) = hdata.EX_PATH(*)
   NCDF_VARPUT, id, EX_PATHID, container

; Earth Relative
   container(0:range-1) = hdata.EZ_EARTH(*)
   NCDF_VARPUT, id, EZ_EARTHID, container

   container(0:range-1) = hdata.EY_EARTH(*)
   NCDF_VARPUT, id, EY_EARTHID, container

   container(0:range-1) = hdata.EX_EARTH(*)
   NCDF_VARPUT, id, EX_EARTHID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Aircraft Motion Data to netCDF file
;====================================================================================
   container(0:range-1) = hdata.GPS_ALT(*)
   NCDF_VARPUT, id, GPS_ALTID, container

   container(0:range-1) = hdata.PELEV(*)
   NCDF_VARPUT, id, PELEVID, container

   container(0:range-1) = hdata.GPS_GRD_SPD(*)
   NCDF_VARPUT, id, GPS_GRD_SPDID, container

   container(0:range-1) = hdata.INDIC_AS(*)
   NCDF_VARPUT, id, INDIC_ASID, container

   container(0:range-1) = hdata.CALC_TAS(*)
   NCDF_VARPUT, id, CALC_TASID, container
   stop
   container(0:range-1) = hdata.NCAR_TAS(*)
   NCDF_VARPUT, id, NCAR_TASID, container

   container(0:range-1) = hdata.GPS_GRD_TRK_ANGLE(*)
   NCDF_VARPUT, id, GPS_GRD_TRK_ANGLEID, container

   container(0:range-1) = hdata.PITCH(*)
   NCDF_VARPUT, id, PITCHID, container

   container(0:range-1) = hdata.ROLL(*)
   NCDF_VARPUT, id, ROLLID, container

   container(0:range-1) = HEADING(*)
   NCDF_VARPUT, id, HEADINGID, container

   container(0:range-1) = hdata.GPS_MAG_VAR(*)	;Tag 176
   NCDF_VARPUT, id, GPS_MAGNETIC_DEVID, container


   stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Probe Diagnostic Data to netCDF file
;====================================================================================
   container(0:range-1) = hdata.PMS_EE1(*)
   NCDF_VARPUT, id, PMS_EE1ID, container

   container(0:range-1) = hdata.PMS_EE2(*)
   NCDF_VARPUT, id, PMS_EE2ID, container

   container(0:range-1) = hdata.ACTIVITY(*)
   NCDF_VARPUT, id, ACTIVITYID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Housekeeping Data to netCDF file
;====================================================================================
   container(0:range-1) = hdata.DYN_PRESS_1(*)
   NCDF_VARPUT, id, DYN_PRESS_1ID, container

   container(0:range-1) = hdata.DYN_PRESS_2(*)
   NCDF_VARPUT, id, DYN_PRESS_2ID, container

   container(0:range-1) = hdata.MAN_PRESS(*)
   NCDF_VARPUT, id, MAN_PRESSID, container

   container(0:range-1) = hdata.VOLT_REG(*)
   NCDF_VARPUT, id, VOLT_REGID, container

   container(0:range-1) = hdata.INT_TEMP(*)
   NCDF_VARPUT, id, INT_TEMPID,  container

   container(0:range-1) = HTR_CURRENT(*)
   NCDF_VARPUT, id, HTR_CURRENTID, container
stop
   container(0:range-1) = hdata.GATED_STROBES(*)
   NCDF_VARPUT, id, GATED_STROBESID, container

   container(0:range-1) = hdata.TOTAL_STROBES(*)
   NCDF_VARPUT, id, TOTAL_STROBESID, container

   container(0:range-1) = DEC_HOURS_GPS(*)
   NCDF_VARPUT, id, GPS_TIMEID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Pilot Reported Cloud Data to netCDF file
;====================================================================================
   container(0:range-1) = event_bits(*)
   NCDF_VARPUT, id, EVENTID,  container


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write more data to netCDF file
;====================================================================================
   container(0:range-1) = hdata.LAT_DEC_DEG_HIRATE(*)
   NCDF_VARPUT, id, LAT_DEC_DEG_HIRATEID, container

   container(0:range-1) = hdata.LON_DEC_DEG_HIRATE(*)
   NCDF_VARPUT, id, LON_DEC_DEG_HIRATEID, container

   container(0:range-1) = time(*)
   NCDF_VARPUT, id, FLSID,  container

   container(0:range-1) = TTime(0:range-1)
   NCDF_VARPUT, id, UNITTIMEID,  container

;close netCDF file
ncdf_close, id

print, "File " + dir_out + fltno + ".nc sucessfully generated"

end

