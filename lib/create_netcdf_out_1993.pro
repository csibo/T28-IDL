;******************************************************************
;
;- create_netCDF_out_1993.pro
;
; Author: Dr. Donna Kliche
; This program will read the reduced files, since we do not have the raw files.
; Valid for flights: 655.
;
; Created: 01/22/2009
;
; Last update:01/22/2009
;
;*************************************************************************

pro create_netCDF_out_1993

select_flight_1993, yr

;read the needed fn from flightselected.txt
dir1 = ''
openr, 1,'t28data.txt'
readf,1,dir1
close,1

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read data from reduced file!!!!
;=====================================================================
title_flt = 'Flt ' + string(fltno)
print,'fn_reduced: ',fn_reduced
fn_titles = dir1 +year + '\tables\tag_names1.txt'
fn_units = dir1 + year + '\tables\tag_units1.txt'

;- Read the reduced data file to get time,lat,lon,and calc_tas
 ;read_rnd,fn_reduced,num_tags,tags,tag_ind,data,num,fltno
 read_rnd1993,fn_reduced,num_tags,tags,tag_ind,data,num,hrs,hms,err
 ;stop
 ;valid for Flight 655!!!!
 year = 1993
 day = 5
 month = 5
 date_str = string(format = '(i2,1h-,i2,1h-,i4)',month,day,year)
 ;stop
 print,'num: ',num
 times_red = long(reform(data(0,*)))

 times_red = strtrim(string(times_red),2)

 ;- transform to decimal time
 hms2hrs,times_red,time_red

 ;select time interval to process
 hours_str=strtrim(strmid(times_red,0,2),2)
 minutes_str=strtrim(strmid(times_red,2,2),2)
 seconds_str=strtrim(strmid(times_red,4,2),2)

ind = where(strlen(hours_str) eq 1,cnt)
if cnt ne 0 then hours_str(ind) = '0' + hours_str(ind)
ind = where(strlen(minutes_str) eq 1,cnt)
if cnt ne 0 then minutes_str(ind) = '0' + minutes_str(ind)
ind = where(strlen(seconds_str) eq 1,cnt)
if cnt ne 0 then seconds_str(ind) = '0' + seconds_str(ind)
b_times = hours_str + minutes_str + seconds_str

se_buffs = time_wid_main2(b_times)

start_buff = se_buffs(0) - 1
end_buff   = se_buffs(1) - 1
print,'start_buff: ',start_buff
print,'end_buff  : ',end_buff

num_records = end_buff - start_buff + 1
hours   = hours_str(start_buff:end_buff)
minutes = minutes_str(start_buff:end_buff)
seconds = seconds_str(start_buff:end_buff)

time_red = time_red(start_buff:end_buff)

;- Get data for tags
read_posttel,tag_post,tag_labels,fn_posttel

;- Initialize the structures for reduced data and metadata (tag numbers, labels, format, min/max)
num_pts = num_records
num=num_records
;number of records on output at 20 per second
size_dn_hirate = (num_records - 1l) * long(output_rate) + 1l

init_tagsT2_yr1993, size_dn_hirate, hdata_1993, metadata_1993,num_tags_rnd,list_var
data = data(*,start_buff:end_buff)
;stop

data_into_hdata_1993, start_buff, end_buff, data, hdata_1993,hours_str, minutes_str, seconds_str, list_var, size_dn_hirate
print,'the number of tags is: ',num_tags_rnd
;stop

;init_tags,num_pts,hdata,metadata,num_tags_rnd
tag_nums = metadata_1993.tag_num
plabels = metadata_1993.plabel

plabels = strtrim(tag_nums) + '-' + plabels
;stop

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

;------------------------------------------------------------------
;- Save every tag data into an array
;------------------------------------------------------------------
tag=tag_nums
output_rate = 20   ;Hz


; GPS time (Tag 179) not available for 1993
; use system time instead
dec_hours_gps = fltarr(size_dn_hirate)
dec_hours_gps(*) = dec_hours_hirate


;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; END MODULAR CODE
; The code from this point on is important to generation of the netCDF files.
; It contains some additional products generated from the previously generated data.
;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; convert HH:MM:SS time into decimal seconds
time = hdata_1993.hours_hirate*3600 + hdata_1993.minutes_hirate*60 + hdata_1993.dec_seconds_hirate
;stop
;calculate total number of records at 1 second data rate
n=end_buff+1

;calculate total number of records at 1 second data rate
range=size(times,/n_elements)

;generate ASCII strings for time at first and last data point in HH:MM:SS format
timeinit=strcompress(string(fix(hdata_1993.hours_hirate(0)),format = '(I02)')+":"+$
         string(fix(hdata_1993.minutes_hirate(0)),format = '(I02)')+":"+$
         string(fix(hdata_1993.dec_seconds_hirate(0)),format = '(I02)'),/remove_all)

trng = strcompress(timeinit + "-" + $
	   string(fix(hdata_1993.hours_hirate(range-1)),format = '(I02)')+":"+$
	   string(fix(hdata_1993.minutes_hirate(range-1)),format = '(I02)')+":"+$
	   string(fix(hdata_1993.dec_seconds_hirate(range-1)),format = '(I02)'),/remove_all)
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
hdata_1993.FSSP_MIX_RATIO = hdata_1993.FSSP_LW/(hdata_1993.DENSMID)
hdata_1993.HAIL_MIX_RATIO = hdata_1993.HAIL_WATER/(hdata_1993.DENSMID)
;stop
;convert event_bits array into binary array
hdata_1993.event_bits = (-1*hdata_1993.event_bits-1)/2

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
      NCDF_ATTPUT, id, DEC_SECONDS_HIRATEID, 'units', 'seconds'
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
   NCDF_ATTPUT, id, NO_CONCID, 'title', 'NO Concentration'


;------------------------------------------------------------------------------------
; Define Particle Data
;------------------------------------------------------------------------------------
; FSSP
   FSSP_LWID = NCDF_VARDEF(id,'FSSP_LIQUID_WATER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FSSP_LWID, 'units', 'gram/meter^3'
      NCDF_ATTPUT, id, FSSP_LWID, 'title', 'FSSP Liquid Water'
      print,' FSSP_LWID=', FSSP_LWID

   FSSP_TOT_CNTSID = NCDF_VARDEF(id,'FSSP_TOTAL_COUNTS', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FSSP_TOT_CNTSID, 'units', 'count'
      NCDF_ATTPUT, id, FSSP_TOT_CNTSID, 'title', 'FSSP Total Counts'
      print,'FSSP_TOT_CNTSID=',FSSP_TOT_CNTSID

   FSSP_AVE_DIAMID = NCDF_VARDEF(id,'FSSP_AVERAGE_DIAMETER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FSSP_AVE_DIAMID, 'units', 'umeter'
      NCDF_ATTPUT, id, FSSP_AVE_DIAMID, 'title', 'FSSP Average Diameter'
      print,'FSSP_AVE_DIAMID=',FSSP_AVE_DIAMID

   TOT_PART_CONCID = NCDF_VARDEF(id,'FSSP_TOTAL_PARTICLE_CONCENTRATION', [rate20, timeID], /float)
      NCDF_ATTPUT, id, TOT_PART_CONCID, 'units', 'count/cmeter3'
      NCDF_ATTPUT, id, TOT_PART_CONCID, 'title', 'FSSP Concentration'
      print,'TOT_PART_CONCID=',TOT_PART_CONCID

   EQUIV_DIAMID = NCDF_VARDEF(id,'FSSP_EQUIVALENT_DIAMETER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EQUIV_DIAMID, 'units', 'umeter'
      NCDF_ATTPUT, id, EQUIV_DIAMID, 'title', 'FSSP Equivelant Diameter'
      print,'EQUIV_DIAMID=',EQUIV_DIAMID

   VARID = NCDF_VARDEF(id,'FSSP_EQUIVALENT_DIAMETER_VARIANCE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, VARID, 'units', 'umeter'
      NCDF_ATTPUT, id, VARID, 'title', 'FSSP Equivalent Diameter Variance'
      print,'VARID=',VARID

   FSSP_MIX_RATIOID = NCDF_VARDEF(id,'FSSP_LIQUID_WATER_MIXING_RATIO'  , [rate20, timeID], /float)
      NCDF_ATTPUT, id, FSSP_MIX_RATIOID, 'units', 'gram/kgram'
      NCDF_ATTPUT, id, FSSP_MIX_RATIOID, 'title', 'FSSP Liquid Water Mixing Ratio'

   GATED_STROBESID = NCDF_VARDEF(id,'FSSP_GATED_STROBES'   , [rate20, timeID], /float)
      NCDF_ATTPUT, id, GATED_STROBESID, 'units', 'count'
      NCDF_ATTPUT, id, GATED_STROBESID, 'title', 'FSSP Gated Strobes'
      print,'GATED_STROBESID=',GATED_STROBESID

   TOTAL_STROBESID = NCDF_VARDEF(id,'FSSP_TOTAL_STROBES'   , [rate20, timeID], /float)
      NCDF_ATTPUT, id, TOTAL_STROBESID, 'units', 'count'
      NCDF_ATTPUT, id, TOTAL_STROBESID, 'title', 'FSSP Total Strobes'
      print,'TOTAL_STROBESID=',TOTAL_STROBESID

   ACTIVITYID = NCDF_VARDEF(id,'FSSP_ACTIVITY', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACTIVITYID, 'units', 'percent'
      NCDF_ATTPUT, id, ACTIVITYID, 'title', 'FSSP Activity'
      print,'ACTIVITYID=',ACTIVITYID

  ;HAIL
     HAIL_WATERID = NCDF_VARDEF(id,'HAIL_WATER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_WATERID, 'units', 'gram/m^3'
      NCDF_ATTPUT, id, HAIL_WATERID, 'title', 'HAIL Liquid Water Content'
      print,'HAIL_WATERID=',HAIL_WATERID

   HAIL_TOT_CNTSID = NCDF_VARDEF(id,'HAIL_TOTAL_COUNTS', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_TOT_CNTSID, 'units', 'count'
      NCDF_ATTPUT, id, HAIL_TOT_CNTSID, 'title', 'HAIL Total Counts'
      print,'HAIL_TOT_CNTSID=',HAIL_TOT_CNTSID

   HAIL_AVE_DIAMID = NCDF_VARDEF(id,'HAIL_AVERAGE_DIAMETER', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_AVE_DIAMID, 'units', 'cmeter'
      NCDF_ATTPUT, id, HAIL_AVE_DIAMID, 'title', 'HAIL Average Diameter'
      print,'HAIL_AVE_DIAMID=',HAIL_AVE_DIAMID

   HAIL_CONCID = NCDF_VARDEF(id,'HAIL_CONCENTRATION', [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_CONCID, 'units', 'count/meter^3'
      NCDF_ATTPUT, id, HAIL_CONCID, 'title', 'HAIL Concentration'
      print,'HAIL_CONCID=',HAIL_CONCID

   HAIL_MIX_RATIOID = NCDF_VARDEF(id,'HAIL_LIQUID_WATER_MIXING_RATIO'  , [rate20, timeID], /float)
      NCDF_ATTPUT, id, HAIL_MIX_RATIOID, 'units', 'gram/kgram'
      NCDF_ATTPUT, id, HAIL_MIX_RATIOID, 'title', 'HAIL Liquid Water Mixing Ratio'


;2D Probe
   SHAD_OR_2DCID = NCDF_VARDEF(id,'SHADOW_OR_PMS', [rate20, timeID], /float)
      NCDF_ATTPUT, id, SHAD_OR_2DCID, 'units', 'count'
      NCDF_ATTPUT, id, SHAD_OR_2DCID, 'title', 'PMS Shadow/Or'
      print,'SHADOW_OR_2DCID=',SHAD_OR_2DCID

   PMS_EE1ID = NCDF_VARDEF(id,'PMS_END_ELEMENT_1', [rate20, timeID], /float)
      NCDF_ATTPUT, id, PMS_EE1ID, 'units', 'V'
      NCDF_ATTPUT, id, PMS_EE1ID, 'title', 'PMS End Element 1'
      print,'PMS_EE1ID=',PMS_EE1ID

   PMS_EE2ID = NCDF_VARDEF(id,'PMS_END_ELEMENT_2', [rate20, timeID], /float)
      NCDF_ATTPUT, id, PMS_EE2ID, 'units', 'V'
      NCDF_ATTPUT, id, PMS_EE2ID, 'title', 'PMS End Element 2'
      print,'PMS_EE2ID=',PMS_EE2ID
;stop
   LWCID = NCDF_VARDEF(id,'LWC_DMT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, LWCID, 'units', 'gram/meter^3'
      NCDF_ATTPUT, id, LWCID, 'title', 'J-W Liquid Water'
      print,'LWCID=',LWCID


;------------------------------------------------------------------------------------
; Define Kinematic Data
;------------------------------------------------------------------------------------
   KOPP_UPDRAFTID = NCDF_VARDEF(id,'UPDRAFT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, KOPP_UPDRAFTID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, KOPP_UPDRAFTID, 'title', 'Updraft'

   TURBID = NCDF_VARDEF(id,'TURBULENCE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, TURBID, 'units', 'cm^2/3sec^-1'
      NCDF_ATTPUT, id, TURBID, 'title', 'Turbulence'

   DYN_PRESS_1ID = NCDF_VARDEF(id,'PRESSURE_DYNAMIC_1', [rate20, timeID], /float)
      NCDF_ATTPUT, id, DYN_PRESS_1ID, 'units', 'hPa'
      NCDF_ATTPUT, id, DYN_PRESS_1ID, 'title', 'Dynamic Pressure 1'
      print,'DYN_PRESS_1ID=',DYN_PRESS_1ID

   DYN_PRESS_2ID = NCDF_VARDEF(id,'PRESSURE_DYNAMIC_2', [rate20, timeID], /float)
      NCDF_ATTPUT, id, DYN_PRESS_2ID, 'units', 'hPa'
      NCDF_ATTPUT, id, DYN_PRESS_2ID, 'title', 'Dynamic Pressure 2'
      print,'DYN_PRESS_2ID=',DYN_PRESS_2ID

	; Unstabilized Accelerometers
   ACCEL_XID = NCDF_VARDEF(id,'ACCELERATION_X', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACCEL_XID, 'units', 'g'
      NCDF_ATTPUT, id, ACCEL_XID, 'title', 'X Acceleration (Unstabilized)'

   ACCEL_YID = NCDF_VARDEF(id,'ACCELERATION_Y', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACCEL_YID, 'units', 'g'
      NCDF_ATTPUT, id, ACCEL_YID, 'title', 'Y Acceleration (Unstabilized)'

   ACCEL_ZID = NCDF_VARDEF(id,'ACCELERATION_Z', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACCEL_ZID, 'units', 'g'
      NCDF_ATTPUT, id, ACCEL_ZID, 'title', 'Z Acceleration (Unstabilized)'

   ACCELID = NCDF_VARDEF(id,'ACCELERATION_VERTICAL', [rate20, timeID], /float)
      NCDF_ATTPUT, id, ACCELID, 'units', 'g'
      NCDF_ATTPUT, id, ACCELID, 'title', 'Acceleration Vertical - Gyro Stabilized'
      print,'ACCELID=',ACCELID

   tempID = NCDF_VARDEF(id,'DZDT_POINT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, tempID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, tempID, 'title', 'dz/dt'
      print,'tempID=',tempID

   GPS_ROC_VARID = NCDF_VARDEF(id,'GPS_RATE_OF_CLIMB', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_ROC_VARID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, GPS_ROC_VARID, 'title', 'Rate of Climb'
      print,'GPS_ROC_VARID=',GPS_ROC_VARID

;------------------------------------------------------------------------------------
; Define Electric Field Data
;------------------------------------------------------------------------------------
; Indiv. Mills
   TFM_LOID = NCDF_VARDEF(id,'FIELD_METER_TOP', [rate20, timeID], /float)
      NCDF_ATTPUT, id, TFM_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, TFM_LOID, 'title', 'Top Field Mill, low res'
      print,'TFM_LOID=',TFM_LOID

   BFM_LOID = NCDF_VARDEF(id,'FIELD_METER_BOTTOM', [rate20, timeID], /float)
      NCDF_ATTPUT, id, BFM_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, BFM_LOID, 'title', 'Bottom Field Mill, low res'
      print,'BFM_LOID=',BFM_LOID

   LFM_LOID = NCDF_VARDEF(id,'FIELD_METER_LEFT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, LFM_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, LFM_LOID, 'title', 'Left Field Mill, low res'
      print,'LFM_LOID=',LFM_LOID

   RFM_LOID = NCDF_VARDEF(id,'FIELD_METER_RIGHT', [rate20, timeID], /float)
      NCDF_ATTPUT, id, RFM_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, RFM_LOID, 'title', 'Right Field Mill, low res'
      print,'RFM_LOID=',RFM_LOID

   FM5_LOID = NCDF_VARDEF(id,'FIELD_METER_5', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FM5_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, FM5_LOID, 'title', 'Fifth Field Mill, low res'
      print,'FM5_LOID=',FM5_LOID

   FM6_LOID = NCDF_VARDEF(id,'FIELD_METER_6', [rate20, timeID], /float)
      NCDF_ATTPUT, id, FM6_LOID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, FM6_LOID, 'title', 'Sixth Field Mill, low res'
      print,'FM6_LOID=',FM6_LOID
; Airframe Rel E
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

; Path Rel E
   EZ_PATHID = NCDF_VARDEF(id,'EZ_PATH', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EZ_PATHID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EZ_PATHID, 'title', 'Z Electric Field (path relative)'

   EY_PATHID = NCDF_VARDEF(id,'EY_PATH', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EY_PATHID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EY_PATHID, 'title', 'Y Electric Field (path relative)'

   EX_PATHID = NCDF_VARDEF(id,'EX_PATH', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EX_PATHID, 'units', 'kV/meter'
      NCDF_ATTPUT, id, EX_PATHID, 'title', 'X Electric Field (path relative)'

; Earth Rel E
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

   GPS_GRD_SPDID = NCDF_VARDEF(id,'GPS_GROUNDSPEED', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_GRD_SPDID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, GPS_GRD_SPDID, 'title', 'GPS Ground Speed'
      print,'GPS_GRD_SPDID=',GPS_GRD_SPDID

   INDIC_ASID = NCDF_VARDEF(id,'INDICATED_AIRSPEED', [rate20, timeID], /float)
      NCDF_ATTPUT, id, INDIC_ASID, 'units', 'meter/sec'
      NCDF_ATTPUT, id, INDIC_ASID, 'title', 'Indicated Air Speed'
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
      NCDF_ATTPUT, id, GPS_GRD_TRK_ANGLEID, 'title', 'GPS Ground Track Angle'
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
; Define Position Data
;------------------------------------------------------------------------------------
   LAT_DEC_DEG_HIRATEID = NCDF_VARDEF(id,'LATITUDE_DECIMAL_DEG_20Hz', [rate20, timeID], /float)
      NCDF_ATTPUT, id, LAT_DEC_DEG_HIRATEID, 'units', 'degree'
      NCDF_ATTPUT, id, LAT_DEC_DEG_HIRATEID, 'title', 'GPS Latitude'
      print,'LAT_DEC_DEG_HIRATEID=',LAT_DEC_DEG_HIRATEID

   LON_DEC_DEG_HIRATEID = NCDF_VARDEF(id,'LONGITUDE_DECIMAL_DEG_20Hz', [rate20, timeID], /float)
      NCDF_ATTPUT, id, LON_DEC_DEG_HIRATEID, 'units', 'degree'
      NCDF_ATTPUT, id, LON_DEC_DEG_HIRATEID, 'title', 'GPS Longitude'
      print,'LON_DEC_DEG_HIRATEID=',LON_DEC_DEG_HIRATEID

   PELEVID = NCDF_VARDEF(id,'PRESSURE_ALTITUDE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, PELEVID, 'units', 'meter'
      NCDF_ATTPUT, id, PELEVID, 'title', 'Pressure Altitude'
      print,'PELEVID=',PELEVID

   GPS_ALTID = NCDF_VARDEF(id,'GPS_ALTITUDE', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_ALTID, 'units', 'meter'
      NCDF_ATTPUT, id, GPS_ALTID, 'title', 'GPS Altitude'
      print,'GPS_ALTID=',GPS_ALTID


;------------------------------------------------------------------------------------
; Define Housekeeping Data
;------------------------------------------------------------------------------------

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

   GPS_TIMEID = NCDF_VARDEF(id,'TIME_GPS_DECIMAL', [rate20, timeID], /float)
      NCDF_ATTPUT, id, GPS_TIMEID, 'units', 'decimal hour'
      NCDF_ATTPUT, id, GPS_TIMEID, 'title', 'GPS decimal hours'
      print,'GPS_TIMEID=',GPS_TIMEID

; Pilot Reported Cloud
   EVENTID = NCDF_VARDEF(id, 'EVENT_MARKERS', [rate20, timeID], /float)
      NCDF_ATTPUT, id, EVENTID, 'title', 'Event Trigger'

; more data

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

   container(0:range-1) = hdata_1993.HOURS_HIRATE(*)
   NCDF_VARPUT, id, HOURS_HIRATEID, container

   container(0:range-1) = hdata_1993.MINUTES_HIRATE(*)
   NCDF_VARPUT, id, MINUTES_HIRATEID, container

   container(0:range-1) = hdata_1993.DEC_SECONDS_HIRATE(*)
   NCDF_VARPUT, id, DEC_SECONDS_HIRATEID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write State Variables to netCDF file
;====================================================================================
   container(0:range-1) = hdata_1993.STAT_PRESS_1(*)
   NCDF_VARPUT, id, STAT_PRESS_1ID, container

   container(0:range-1) = hdata_1993.STAT_PRESS_2(*)
   NCDF_VARPUT, id, STAT_PRESS_2ID, container

   container(0:range-1) = hdata_1993.ROSE(*)
   NCDF_VARPUT, id, ROSEID, container

   container(0:range-1) = hdata_1993.RFT(*)
   NCDF_VARPUT, id, RFTID, container

   container(0:range-1) = hdata_1993.THETAE(*)
   NCDF_VARPUT, id, THETAEID, container

   container(0:range-1) = hdata_1993.DENSMID(*)
   NCDF_VARPUT, id, DENSMIDID, container

   ; all NO values are zero; no recordings during STEPS project
   container(0:range-1) = hdata_1993.NO_CONC(*)
   NCDF_VARPUT, id, NO_CONCID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Particle Data to netCDF file
;====================================================================================
; FSSP
   container(0:range-1) = hdata_1993.FSSP_LW(*)
   NCDF_VARPUT, id, FSSP_LWID, container

   container(0:range-1) = hdata_1993.FSSP_TOT_CNTS(*)
   NCDF_VARPUT, id, FSSP_TOT_CNTSID,  container

   container(0:range-1) = hdata_1993.FSSP_AVE_DIAM(*)
   NCDF_VARPUT, id, FSSP_AVE_DIAMID, container

   container(0:range-1) = hdata_1993.TOT_PART_CONC(*)
   NCDF_VARPUT, id, TOT_PART_CONCID, container

   container(0:range-1) = hdata_1993.EQUIV_DIAM(*)
   NCDF_VARPUT, id, EQUIV_DIAMID, container

   container(0:range-1) = hdata_1993.VAR(*)
   NCDF_VARPUT, id, VARID, container

   container(0:range-1) = hdata_1993.FSSP_MIX_RATIO(*)
   NCDF_VARPUT, id, FSSP_MIX_RATIOID, container

   container(0:range-1) = hdata_1993.GATED_STROBES(*)
   NCDF_VARPUT, id, GATED_STROBESID, container

   container(0:range-1) = hdata_1993.TOTAL_STROBES(*)
   NCDF_VARPUT, id, TOTAL_STROBESID, container

   container(0:range-1) = hdata_1993.ACTIVITY(*)
   NCDF_VARPUT, id, ACTIVITYID, container


; HAIL
   container(0:range-1) = hdata_1993.HAIL_WATER(*)
   NCDF_VARPUT, id, HAIL_WATERID, container

   container(0:range-1) = hdata_1993.HAIL_TOT_CNTS(*)
   NCDF_VARPUT, id, HAIL_TOT_CNTSID, container

   container(0:range-1) = hdata_1993.HAIL_AVE_DIAM(*)
   NCDF_VARPUT, id, HAIL_AVE_DIAMID, container

   container(0:range-1) = hdata_1993.HAIL_CONC(*)
   NCDF_VARPUT, id, HAIL_CONCID, container

   container(0:range-1) = hdata_1993.HAIL_MIX_RATIO(*)
   NCDF_VARPUT, id, HAIL_MIX_RATIOID, container

; 2D Probe
   container(0:range-1) = hdata_1993.SHAD_OR_2DC(*)
   NCDF_VARPUT, id, SHAD_OR_2DCID, container

   container(0:range-1) = hdata_1993.PMS_EE1(*)
   NCDF_VARPUT, id, PMS_EE1ID, container

   container(0:range-1) = hdata_1993.PMS_EE2(*)
   NCDF_VARPUT, id, PMS_EE2ID, container
;stop
;   container(0:range-1) = hdata_1993.LWC(*)
   container(0:range-1) = hdata_1993.JWLW(*)    ; DMT was not available for 1993; we use J-W instrument instead
   NCDF_VARPUT, id, LWCID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Kinematic Data to netCDF file
;====================================================================================
   container(0:range-1) = hdata_1993.KOPP_UPDRAFT(*)
   NCDF_VARPUT, id, KOPP_UPDRAFTID, container

   container(0:range-1) = hdata_1993.TURB(*)
   NCDF_VARPUT, id, TURBID, container

   container(0:range-1) = hdata_1993.DYN_PRESS_1(*)
   NCDF_VARPUT, id, DYN_PRESS_1ID, container

   container(0:range-1) = hdata_1993.DYN_PRESS_2(*)
   NCDF_VARPUT, id, DYN_PRESS_2ID, container

; Unstabilized Accelerometers
   container(0:range-1) = hdata_1993.ACCEL_X(*)
   NCDF_VARPUT, id, ACCEL_XID, container

   container(0:range-1) = hdata_1993.ACCEL_Y(*)
   NCDF_VARPUT, id, ACCEL_YID, container

   container(0:range-1) = hdata_1993.ACCEL_Z(*)
   NCDF_VARPUT, id, ACCEL_ZID, container

   container(0:range-1) = hdata_1993.ACCEL(*)	; acceleration vertical
   NCDF_VARPUT, id, ACCELID, container

   container(0:range-1) = hdata_1993.DZDT(*)
   NCDF_VARPUT, id, tempID, container

;   container(0:range-1) = hdata_1993.GPS_ROC(*)	; Tag 185
   container(0:range-1) = hdata_1993.ROC(*)	; Tag 105 used this one during 1993!
   NCDF_VARPUT, id, GPS_ROC_VARID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Electric Field Data to netCDF file
;====================================================================================
; Indiv. Mills
   container(0:range-1) = hdata_1993.TFM_LO(*)
   NCDF_VARPUT, id, TFM_LOID, container

   container(0:range-1) = hdata_1993.BFM_LO(*)
   NCDF_VARPUT, id, BFM_LOID, container

   container(0:range-1) = hdata_1993.LFM_LO(*)
   NCDF_VARPUT, id, LFM_LOID, container

   container(0:range-1) = hdata_1993.RFM_LO(*)
   NCDF_VARPUT, id, RFM_LOID, container
;stop
   container(0:range-1) = hdata_1993.FM5_LO(*)
   NCDF_VARPUT, id, FM5_LOID, container

   ;included just to be consistent with the previous years display on the web
   container(0:range-1) = hdata_1993.FM6_LO(*)
   NCDF_VARPUT, id, FM6_LOID, container
stop
; Airframe Relative
   container(0:range-1) = hdata_1993.EZ_AIRCRAFT(*)
   NCDF_VARPUT, id, EZ_AIRCRAFTID, container

   container(0:range-1) = hdata_1993.EY_AIRCRAFT(*)
   NCDF_VARPUT, id, EY_AIRCRAFTID, container

   container(0:range-1) = hdata_1993.EX_AIRCRAFT(*)
   NCDF_VARPUT, id, EX_AIRCRAFTID, container

   container(0:range-1) = hdata_1993.EQ_AIRCRAFT(*)
   NCDF_VARPUT, id, EQ_AIRCRAFTID, container

; Path Relative
   container(0:range-1) = hdata_1993.EZ_PATH(*)
   NCDF_VARPUT, id, EZ_PATHID, container

   container(0:range-1) = hdata_1993.EY_PATH(*)
   NCDF_VARPUT, id, EY_PATHID, container

   container(0:range-1) = hdata_1993.EX_PATH(*)
   NCDF_VARPUT, id, EX_PATHID, container

; Earth Relative
   container(0:range-1) = hdata_1993.EZ_EARTH(*)
   NCDF_VARPUT, id, EZ_EARTHID, container

   container(0:range-1) = hdata_1993.EY_EARTH(*)
   NCDF_VARPUT, id, EY_EARTHID, container

   container(0:range-1) = hdata_1993.EX_EARTH(*)
   NCDF_VARPUT, id, EX_EARTHID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Aircraft Motion Data to netCDF file
;====================================================================================

   container(0:range-1) = hdata_1993.GPS_GRD_SPD(*)
   NCDF_VARPUT, id, GPS_GRD_SPDID, container

   container(0:range-1) = hdata_1993.INDIC_AS(*)
   NCDF_VARPUT, id, INDIC_ASID, container

   container(0:range-1) = hdata_1993.CALC_TAS(*)
   NCDF_VARPUT, id, CALC_TASID, container

   container(0:range-1) = hdata_1993.NCAR_TAS(*)
   NCDF_VARPUT, id, NCAR_TASID, container

   container(0:range-1) = hdata_1993.GPS_GRD_TRK_ANGLE(*)
   NCDF_VARPUT, id, GPS_GRD_TRK_ANGLEID, container

   container(0:range-1) = hdata_1993.PITCH(*)
   NCDF_VARPUT, id, PITCHID, container

   container(0:range-1) = hdata_1993.ROLL(*)
   NCDF_VARPUT, id, ROLLID, container

   container(0:range-1) = hdata_1993.HEADING(*)
   NCDF_VARPUT, id, HEADINGID, container

   container(0:range-1) = hdata_1993.GPS_MAG_VAR(*)	;Tag 176
   NCDF_VARPUT, id, GPS_MAGNETIC_DEVID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Position Data to netCDF file
;====================================================================================

   container(0:range-1) = hdata_1993.LAT_DEC_DEG_HIRATE(*)
   NCDF_VARPUT, id, LAT_DEC_DEG_HIRATEID, container

   container(0:range-1) = hdata_1993.LON_DEC_DEG_HIRATE(*)
   NCDF_VARPUT, id, LON_DEC_DEG_HIRATEID, container

   container(0:range-1) = hdata_1993.PELEV(*)
   NCDF_VARPUT, id, PELEVID, container

   container(0:range-1) = hdata_1993.GPS_ALT(*)
   NCDF_VARPUT, id, GPS_ALTID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Housekeeping Data to netCDF file
;====================================================================================

   container(0:range-1) = hdata_1993.MAN_PRESS(*)
   NCDF_VARPUT, id, MAN_PRESSID, container

   container(0:range-1) = hdata_1993.VOLT_REG(*)
   NCDF_VARPUT, id, VOLT_REGID, container

   container(0:range-1) = hdata_1993.INT_TEMP(*)
   NCDF_VARPUT, id, INT_TEMPID,  container
stop
   container(0:range-1) = hdata_1993.HTR_CURRENT(*)
   NCDF_VARPUT, id, HTR_CURRENTID, container

   container(0:range-1) = DEC_HOURS_GPS(*)
   NCDF_VARPUT, id, GPS_TIMEID, container

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write Pilot Reported Cloud Data to netCDF file
;====================================================================================
   container(0:range-1) = hdata_1993.event_bits(*)
   NCDF_VARPUT, id, EVENTID,  container


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write more data to netCDF file
;====================================================================================

   container(0:range-1) = time(*)
   NCDF_VARPUT, id, FLSID,  container

   container(0:range-1) = TTime(0:range-1)
   NCDF_VARPUT, id, UNITTIMEID,  container

;close netCDF file
ncdf_close, id

print, "File " + dir_out + fltno + ".nc sucessfully generated"

end

