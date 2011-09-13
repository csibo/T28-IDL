; Copyright © 2001, IAS, SD School of Mines and Technology.
; This software is provided as is without any warranty whatsoever.
; It may be freely used, copied or distributed, for non-commercial
; purposes. This copyright notice must be kept with any copy of this
; software.  If this software shall be used commercially or sold
; as part of a larger package, please contact the copyright holder
; to arrange payment. Bugs and comments should be directed to
; t28user@typhoon.ias.sdsmt.edu with subject "t28display IDL routine".
;
;------------------------------------------------------------------------------------------

;- img_sort4.pro
;
;- Last Modified: 10/29/2002
;          - changed the way we calculate the height of the
;   sample volume, by eliminating the term which is size dependent
;   (i.e.,size_mid); this works in the case of the image sample
;   volume (when we use the time accumulation for calculations)
;            -added the shadow_or sample time and shadow_or
;   sample volume, which corresponds to counting particles for
;   each seconds (from start_buff to end_buff).  These values are
;   larger than the image sample volume, because of the difference
;   in the time and distance considered.
;          -added the new read_rnd3.pro routine to read the
;   shadow_or information from the reduced file
;-----------------------------------------------------------------

pro img_sort4

@buff_struct
@part_struct
@habit_names
@set_colors

;- Input
max_images = 2000
xwid = 500
ywid = 700
xmargin = 5
ymargin = 10
color1 = 5

device,decomposed=0

fn1 = FILE_WHICH('t28idl.txt')
dir1 = ''
openr,1,fn1
readf,1,dir1
close,1

fn2 = FILE_WHICH('t28data.txt')
dir2 = ''
openr,1,fn2
readf,1,dir2
close,1

buff_size = n_tags(b_info)
part_size = n_tags(p_info)
size_p_info = n_tags(p_info,/length)

;- Flights in which 2D data is available
probe = menu_wid_new([ 'Select Probe:' , '2DC Probe'     , $
                           'HVPS Probe'  , $
                           'HAIL Probe'])
probe = probe + 1


; FOR 2DC PROBE
;=====================================================
if probe eq 1 then begin
  ; select year for the data
  yr = intarr(1)
  yrnos = ['Year 1995 (VORTEX Project)', $
           'Year 1998 (CHILL) Project',$
           'Year 1999 (Turbulence Project)',$
           'Year 2000 (STEPS Project)', $
           'Year 2001 (Rapid City)', $
           'Year 2002 (Rapid City and Colorado)', $
           'Year 2003 (Rapid City-Norman)', $
           'Year 2004 ',$
         'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
  if yr_ind eq 0 then yr_number = 1995
  if yr_ind eq 1 then yr_number = 1998
  if yr_ind eq 2 then yr_number = 1999
  if yr_ind eq 3 then yr_number = 2000
  if yr_ind eq 4 then yr_number = 2001
  if yr_ind eq 5 then yr_number = 2002
  if yr_ind eq 6 then yr_number = 2003
  if yr_ind eq 7 then yr_number = 2004
  print,'yr_ind = ',yr
  ;- Get the constants for a specific probe type
  specs = get_specs_2dc(probe-1)

  ;select_flight_s1,yr, flt_num, titl, year, fltno, dir1, dir2
  select_flight_2dc1, yr, fn_2dc, titl, year, fltno
  title = '2DC'
endif


; FOR HVPS PROBE
;=====================================================
if probe eq 2 then begin
  ; select year for the data
  yr = intarr(1)
  yrnos = ['Year 1995 (VORTEX Project)', $
           'Year 1998 (CHILL) Project',$
           'Year 1999 Project',$
           'Year 2000 (STEPS Project)', $
           'Year 2001 (Rapid City)', $
           'Year 2002 (Rapid City and Colorado)', $
           'Year 2003 (Rapid City-Norman)', $
           'Year 2004 Project',$
           'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
  if yr_ind eq 0 then begin
     yr_number = 1995
     buf_size = 2048
     skip_bytes = bytarr(12)
     skip_bytes2=bytarr(1)
     ;select_flight_s1,yr, flt_num, titl, year, fltno, dir1, dir2
     select_flight_hvps1, yr, fn_hvps, titl, year, fltno
     title = 'HVPS'
     ;init_1995,flt_num,specs,files1995,b_info_arr,buf_ptrs,year
  endif else begin
   if yr_ind eq 1 then yr_number = 1998
   if yr_ind eq 2 then yr_number = 1999
   if yr_ind eq 3 then yr_number = 2000
   if yr_ind eq 4 then yr_number = 2001
   if yr_ind eq 5 then yr_number = 2002
   if yr_ind eq 6 then yr_number = 2003
   if yr_ind eq 7 then yr_number = 2004
   print,'yr_ind = ',yr
   ;- Get the constants for a specific probe type
   specs = get_specs_hvps(probe-1)

   ;select_flight_s1,yr, flt_num, titl, year, fltno, dir1, dir2
   select_flight_hvps1, yr, fn_hvps, titl, year, fltno
   title = 'HVPS'
  endelse

endif


; FOR HAIL PROBE
;=====================================================
if probe eq 3 then begin
  ; select year for the data
  yr = intarr(1)
  yrnos = ['Year 1995 (VORTEX Project)', $
        'Year 1998 (CHILL) Project',$
        'Year 1999 (Turbulence) Project',$
         'Year 2000 (STEPS Project)', $
         'Year 2001 (Rapid City)', $
         'Year 2002 (Rapid City and Colorado)', $
         'Year 2003 (Rapid City-Norman)', $
         'Year 2004 Rapid City',$
         'Exit']
  yr_ind = menu_wid_wide(['Select The Year:',yrnos])
  yr = yr_ind
  if yr_ind eq 0 then yr_number = 1995
  if yr_ind eq 1 then yr_number = 1998
  if yr_ind eq 2 then yr_number = 1999
  if yr_ind eq 3 then yr_number = 2000
  if yr_ind eq 4 then yr_number = 2001
  if yr_ind eq 5 then yr_number = 2002
  if yr_ind eq 6 then yr_number = 2003
  if yr_ind eq 7 then yr_number = 2004
  print,'yr_ind = ',yr
  ;- Get the constants for a specific probe type
  specs = get_specs_hail(probe-1)

  ;select_flight_s1,yr, flt_num, titl, year, fltno, dir1, dir2
  select_flight_hail1, yr, fn_hail, titl, year, fltno
  title = 'HAIL'
endif




;included this statement to accomodate for the 1995 HVPS data
;if probe_type eq 6 then begin
if yr_ind eq 0 then begin
    img_sort1995
endif else begin

specs = get_specs(probe-1)

dir = specs.buf_path

;- Windows
window,xs=xwid,ys=ywid,1,title = 'Extracted Particle Images'
window,xs=1000,ys=specs.nl,2,title = 'Scaled Buffer Image'

;- Get filenames for the arc data and pick a file
fn_buf = dialog_pickfile(path = dir, filter = '*.buf')
len = strlen(fn_buf)
fn_ind = strmid(fn_buf,0,len-3) + 'ind'
fn_xpr = strmid(fn_buf,0,len-3) + 'xpr'
fn_par = strmid(fn_buf, 0, len-3) + 'par'


;print,'fn_buf: ',fn_buf
;print,'fn_ind: ',fn_ind
;print,'fn_xpr: ',fn_xpr

flt_no_str = fn_buf

inter      = fltarr(max_images)
frame_time = fltarr(max_images)
sort_ind   = intarr(4,max_images)
pa         = fltarr(max_images)
rose       = fltarr(max_images)
lw         = fltarr(max_images)
year_str = 'yr' + strtrim(string(yr_number),2)
;stop
;- to extract the reduced data file
if (probe eq 1) then begin
 n2dc = strlen(fn_2dc)
 start_point = n2dc-10
 flt_num = strtrim(strmid(fn_2dc,start_point,3),2)
 fn_reduced = dir2 + year_str + path_sep()+'f' + flt_num + path_sep()+'flt' + flt_num + '.rnd'
endif

if (probe eq 2) then begin
 nhvps = strlen(fn_hvps)
 start_point = nhvps-11
 flt_num = strtrim(strmid(fn_hvps,start_point,3),2)
 fn_reduced = dir2 + year_str + path_sep()+'f' + flt_num + path_sep()+'flt' + flt_num + '.rnd'
endif

if (probe eq 3) then begin
 nhail = strlen(fn_hail)
 start_point = nhail-11
 flt_num = strtrim(strmid(fn_hail,start_point,3),2)
 fn_reduced = dir2 + year_str + path_sep()+'f' + flt_num + path_sep()+'flt' + flt_num + '.rnd'
endif
;stop
;fn_reduced = strmid(fn_buf,0,7) + 'data\' + strmid(fn_buf,28,7) + $
;         'f' + strmid(fn_buf,35,3) + '\flt' + strmid(fn_buf,35,3) + $
;         '.rnd'
;fn_reduced = 'K:\IAS-Staff\Donna\T28\data\yr2003\f805\flt805.rnd'
;ns = strlen(fn_buf)
;start_str = ns - 11
;fltno = float(strmid(fn_buf,start_str,3))

read_rnd3,fn_reduced,num_tags,tags,tag_ind,data,num,time_in,time_out,fltno

shadow_or_2dc = intarr(num)
;data = data(rec_size,num) ; recsize = 140
ind = where(tags eq 147,n1)
shadow_or_2dc(*) = data(ind+1,*)

;- Read buf file
b_info_arr = read_buf(fn_buf)

;- Select the buffers of interest
se = time_wid_mainNew(strtrim(double(b_info_arr(*).time_hms),2))
;print,'se: ',se

start_buff = se(0)
end_buff   = se(1)
print,'start_buff: ',start_buff
print,'end_buff: ',end_buff

;- Get the necessary b_info data
num_occluded = b_info_arr(*).num_occluded
time_hms     = b_info_arr(*).time_hms
time_hrs     = b_info_arr(*).time_hrs
num_blobs    = b_info_arr(*).num_blobs
;stop
;- for reduced data - extract for the time interval we are interested
;  in
ind_time = where((data(0,*) ge min(time_hms)) and $
              (data(0,*) le max(time_hms)),nt)
;stop
nn=size(ind_time)
temp_2dc = fltarr(nn(1))
shad_or_ind=ind+1
temp_2dc(0:nn(1)-1) = data(49,ind_time)


;- For computing sample volume
charge_time  = b_info_arr(start_buff:end_buff).charge_time
tas          = b_info_arr(start_buff:end_buff).calc_tas_buff
tac          = b_info_arr(start_buff:end_buff).tac
time         = b_info_arr(start_buff:end_buff).time_hrs
num_frames   = b_info_arr(start_buff:end_buff).num_frames
num_blobs    = b_info_arr(start_buff:end_buff).num_blobs
buff_num     = b_info_arr(start_buff:end_buff).buff_num
;stop
;- Read the p_info for all the buffers
pixel_areas = get_p_info(fn_xpr,11)
habits      = get_p_info(fn_xpr,41)
llxs        = get_p_info(fn_xpr,49)
llys        = get_p_info(fn_xpr,50)
urxs        = get_p_info(fn_xpr,51)
urys        = get_p_info(fn_xpr,52)
xsizes      = get_p_info(fn_xpr,13)
ysizes      = get_p_info(fn_xpr,14)

max_size = max(urxs - llxs)
;sizes = size_wid_main(specs.y_resolution,specs.num_diodes + 10)
sizes = size_wid_main(specs.y_resolution,max_size + 10)
size1 = sizes(0)
size2 = sizes(1)
size1_str = strtrim(size1,2)
size2_str = strtrim(size2,2)
print,'size1,size2: ',size1,size2

;- Open the file containing the image indices (.ind)
openr,unit_ind,fn_ind,/get_lun

i = 0l
j = 0l
;del = 20
ydel = 0
ymax = 0
s1 = xmargin
s2 = ymargin

;- Initialize the array that will contain the unsorted particle images
img_hab = bytarr(xwid,ywid)
img_hab(*,*) = 255
;- Initialize the array for the buffer image
img = bytarr(b_info_arr(0).np,specs.nl)

; initialize values for volume and concentration
img_sample_volume = 0.0
img_conc = 0.0

;- Start loop to excise all particle images that fall within the selected size range
;- (size1 to size2) and within the selected buffer range (start_buff to end_buff)
i = start_buff > 1
while i le end_buff do begin
print,'buff = ',i
;stop
    ptr = total(num_occluded(0:i-1)) * 4l
    point_lun,unit_ind,long(ptr)
    img_ind = lonarr(num_occluded(i))
    readu,unit_ind,img_ind

    img(*,*) = 255
    img(img_ind) = 0
    wset,2
    tv,img

    k1 = total(num_blobs(0:i-1))
    k2 = k1 + num_blobs(i) - 1
    pixel_area = pixel_areas(k1:k2)
    habit     = habits(k1:k2)
    llx          = llxs(k1:k2)
    lly          = llys(k1:k2)
    urx          = urxs(k1:k2)
    ury          = urys(k1:k2)
    xsize      = xsizes(k1:k2)
    ysize      = ysizes(k1:k2)

    ;- Particle size in pixels
    x_dim = urx - llx
    y_dim = ury - lly
;stop

;- Particles in this buffer that meet this size criterion
    ind_acc = where(xsize ge size1 and xsize lt size2 and $
                 habit ge 8 and ysize gt specs.y_resolution,cnt_acc)
;stop
    print,'buff number,time,cnt: ',i,time_hms(i),cnt_acc

    if cnt_acc ne 0 then begin
   ;- Cycle through each particle to extract and display
       for ll=0,cnt_acc-1 do begin
         l = ind_acc(ll)
         if y_dim(l) gt ydel then ydel = y_dim(l)
         del = x_dim(l) + 5
         if (s1 + del) ge xwid then begin
          s1 = 5
          s2 = s2 + ydel + 5
          if ydel gt ymax then ymax = ydel
          ydel = y_dim(l)
          print,'s1,s2: ',s1,s2
          if s2 gt (ywid-ymax-10) then end_buff = i
         endif
         if i lt end_buff then begin
         ;- Extract next image to display
          img_tem = img(llx(l):urx(l),lly(l):ury(l))
          ind = where(img_tem eq 0,cnt)
          ;- Color image based on classification
          case habit(l) of
              8 :cvalue = 0 + color1
              9 :cvalue = 1 + color1
              10:cvalue = 2 + color1
              11:cvalue = 3 + color1
              12:cvalue = 4 + color1
              else:cvalue = 0
          endcase
          img_tem(ind) = cvalue
          ;- Copy image into page
          img_hab(s1:s1+x_dim(l),s2:s2+y_dim(l)) = img_tem
          ;- Save the image corners for sorting later
          sort_ind(*,j) = [s1,s1+x_dim(l),s2,s2+y_dim(l)]
          ;- Save pixel area for each particle
          pa(j) = pixel_area(l)
          ;- Save Rosemount temp for each particle
          rose(j) = b_info_arr(i).rose_buff
          ;- Save LW for each particle
          lw(j) = b_info_arr(i).fssp_lw_buff
          ;- Increment x coordinate for next image
          s1 = s1 + del
          ;- Counter for the number of images extracted
          j = j + 1
         endif
       endfor ;Done looping through all images in this buffer
    endif

    wset,1
    tv,img_hab

    i = i + 1

endwhile       ;Done looping through all the selected buffers

;- Number of particle images extracted
num_images = j
;- The last buffer number used for extracting images
end_buff = i - 1

;print,size1_str,size2_str
;stop
if num_images eq 0 then begin
  ;mes = ''
  mes = 'No images found in the size range: ' + size1_str + ' - ' + size2_str
  result = dialog_message(mes, /Information)
  print,result
  GOTO, JUMP1
endif
;- Find the min/mean/max/range of the temp and lw for the selected group of buffers
rose = rose(0:j-1)
rose_min = min(rose)
rose_max = max(rose)
rose_sd = stdev(rose,rose_mean)
rose_rng = rose_max - rose_min
;print,'rose_min,rose_max,rose_rng: ',rose_min,rose_max,rose_rng

lw = lw(0:j-1)
lw_min = min(lw)
lw_max = max(lw)
lw_sd = stdev(lw,lw_mean)
lw_rng = lw_max - lw_min
;print,'lw_min,lw_max,lw_rng: ',lw_min,lw_max,lw_rng

;- Find the concentration of particles for the selected size range and buffers
;- Replace/filter large or zero tac values
img_tac_charge = tac_filter(tac,specs.der_thresh,num_frames,charge_time,time,flt_no_str)
;img_total_dist = total(img_tac_charge(0:end_buff-start_buff) * tas(0:end_buff-start_buff))
img_total_dist = total(abs(img_tac_charge(0:end_buff-start_buff)) * tas(0:end_buff-start_buff))
;- Middle of the size range (adjustment to sample area for occluded images)
size_mid = 0.5 * (size1 + size2)

;modified 10/28/2002 - to estimate the concentration better
;height = (float(specs.mask2 - specs.mask1 + 1) * specs.y_resolution + 0.72 * size_mid) * 1.e-4 ;cm
;if size_mid lt specs.fresnel_dcl then $
;   sample_area = 2.37 * height * size_mid^2 * 1.e-8 else $
;   sample_area = specs.arm_width * height * 1.e-4       ;m^2
;sample_volume = total_dist * sample_area
height = (float(specs.mask2 - specs.mask1 + 1) * specs.y_resolution)*1.e-4 ; cm
sample_area = specs.arm_width * height * 1.e-4   ;m^2
img_sample_volume = img_total_dist * sample_area


img_conc = float(num_images) / img_sample_volume
print,'sample_volume: ',img_sample_volume
print,'conc         : ',img_conc
;stop
;concentration from shadow_or_2dc total
shadow_or_total_dist=total(tas(0:end_buff-start_buff)*1.0)
shadow_or_sample_vol = shadow_or_total_dist * sample_area
shadow_or_conc = float(total(temp_2dc))/shadow_or_sample_vol

;stop
;- These arrays were overdimensioned - prune them to the number of images extracted
sort_ind = sort_ind(*,0:j-1)
pa = pa(0:j-1)

;- Sort the particle images by pixel area
ind1 = sort(pa)  ;Indices of images sorted by pixel area

;- Initialize the window/page that will hold the sorted images
img_hab_sort = bytarr(xwid,ywid)
img_hab_sort(*,*) = 255

;- Initialize values for new page of sorted images
s1 = xmargin			;x coordinate for the LL corner of image
s2 = ymargin			;y coordinate for the LL corner of image
ydel = 0

;- Loop through all the particle images extracted above
for i=0,num_images-1 do begin
    j = ind1(i)			;The index of the particles by descending size
    x1 = sort_ind(0,j)	;LL and UR cordinates of next image
    x2 = sort_ind(1,j)
    y1 = sort_ind(2,j)
    y2 = sort_ind(3,j)
    x_dim = x2 - x1		;Width and height of next image
    y_dim = y2 - y1

    if y_dim gt ydel then ydel = y_dim		;Track the tallest image on current row
    del = x_dim + 5							;Put the next image 5 pixels to the right of current one
    if (s1 + del) ge xwid then begin		;Start a new row
       s1 = 5								;Start the new row at the x margin
       s2 = s2 + ydel + 5					;Start new row 5 pixels above tallest image
       if ydel gt ymax then ymax = ydel		;Track the tallest image on the page
       ydel = y_dim							;Initialize tallest image to height of 1st one
       ;print,'s1,s2: ',s1,s2
       ;- If the page is not big enough jump out of the loop
       if s2 gt (ywid-ymax-10) then goto, jump2
    endif
    ;- Copy the current image into the page
    img_hab_sort(s1:s1+x_dim,s2:s2+y_dim) = img_hab(x1:x2,y1:y2)
    s1 = s1 + del					;Set x coordinate for next image
endfor

jump2:

;- Display the sorted images with annotations
wset,1
sw = 0
while sw ne 4 do begin

    tv,img_hab_sort

   temp_flt_no_str = strmid(flt_no_str,6,45)


    str1 = 'Flight: ' + strtrim(temp_flt_no_str,2) ;+ ' - ' + specs.probe_name
    str2 = 'Size Range: ' + size1_str + ' to ' + size2_str + ' um'
    str3 = 'Buffer Times: ' + $
            string(format = '(f10.3)',time_hms(start_buff)) + '(' + strtrim(fix(start_buff),2) + ')' + ' to ' + $
         string(format = '(f10.3)',time_hms(end_buff))   + '(' + strtrim(fix(end_buff),2) + ')'
    str4 = 'Number Particles: ' + strtrim(num_images,2)
    ;str5 = 'Img Sample Time: ' + string((total(img_tac_charge(0:end_buff-start_buff)))) + ' s'
    str5 = 'Img Sample Time: ' + string((total(abs(img_tac_charge(0:end_buff-start_buff))))) + ' s'

    str6 = 'Img Sample Volume: ' + string(format = '(f10.5)',img_sample_volume) + $
             ' m!E3!N  (' + string(format = '(f10.0)',img_conc) + ' #/m!E3!N)'

    str7 = 'Shadow_Or Sample Time: ' + strtrim(end_buff - start_buff + 1,2) + ' buffers  ' + $
                          strtrim((b_info_arr(end_buff).time_hrs - b_info_arr(start_buff).time_hrs) * 3600.,2) + ' s'


    str8  = 'Shadow_Or Sample Volume: ' +  string(format = '(f10.5)',shadow_or_sample_vol) + $
               ' m!E3!N  (' + string(format = '(f9.0)',shadow_or_conc) + ' #/m!E3!N)'

    str9 = 'Min/Mean/Max Temp: ' + string(format = '(f7.2)',rose_min) + '/' + $
                                    string(format = '(f7.2)',rose_mean) + '/' + $
                                    string(format = '(f7.2)',rose_max) + ' (C)'
;    str10 = 'Min/Mean/Max FSSP-LW: ' + string(format = '(f7.2)',lw_min) + '/' + $
;                                    string(format = '(f7.2)',lw_mean) + '/' + $
;                                    string(format = '(f7.2)',lw_max) + ' (g/m!E3!N)'



    str11 = '
    xyouts,5,ywid-10,str1,charsize = 0.9,color=0,/device
    xyouts,5,ywid-20,str2,charsize = 0.9,color=0,/device
    xyouts,5,ywid-30,str3,charsize = 0.9,color=0,/device
    xyouts,5,ywid-40,str4,charsize = 0.9,color=0,/device
    xyouts,5,ywid-50,str5,charsize = 0.9,color=0,/device
    xyouts,5,ywid-60,str6,charsize = 1.0,color=0,/device
    xyouts,5,ywid-70,str7,charsize = 0.9,color=0,/device
    xyouts,5,ywid-80,str8,charsize = 1.0,color=0,/device
    xyouts,5,ywid-90,str9,charsize = 1.0,color=0,/device
    ;xyouts,5,ywid-100,str10,charsize = 1.0,color=0,/device

    box = bytarr(8,8)
    for i=0,4 do begin
       box(*,*) = i + color1
       tv,box,3.*xwid/4.,ywid-10.*(i+1)
       xyouts,3.*xwid/4.+15.,ywid-10.*(i+1),hab_titl(i+8),charsize=0.9,color=0,/device
    endfor

    colorimg_wid,sw,img_hab_sort

endwhile

free_lun,unit_ind
JUMP1:

 wset,1
 sw = 0
 while sw ne 4 do begin
    if ((probe eq 1) OR (probe eq 2)) then begin
    write_xy_output_wid, sw, specs.probe_type, b_info_arr, xsizes, ysizes, flt_num, fn_buf, img_sample_volume, img_conc
    ;write_maxDim_output_wid, sw, specs.probe_type, b_info_arr, xsizes, ysizes, flt_num, fn_buf, img_sample_volume, img_conc
    endif

    if (probe eq 3) then begin

    write_output_hail_wid, sw, fn_reduced,num_tags,tags,tag_ind,data,num,time_in,time_out,$
                           specs.probe_type, b_info_arr, xsizes, ysizes, flt_num, fn_buf, $
                           img_sample_volume, img_conc
    endif

 endwhile

mes = 'The Raw Data Processing Is Done Now!'
result = dialog_message(mes, /Information)
print,result

;stop
wdelete,1
wdelete,2

endelse

end
