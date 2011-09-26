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

;- img_sort1995.pro
;
;-adapted from img_sort2.pro
;
;- LAST MODIFIED (DVK): Jan, 2002 for tas and tt
;==============================================================================

pro img_sort1995

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

buff_size = n_tags(b_info)
part_size = n_tags(p_info)
size_p_info = n_tags(p_info,/length)


probe_type = 6		; for 1995 HVPS data


specs = get_specs(probe_type-1)

dir = specs.buf_path

;- Windows
window,xs=xwid,ys=ywid,1,title = 'Extracted Particle Images'
window,xs=1000,ys=specs.nl,2,title = 'Scaled Buffer Image'

;- Get filenames for the arc data and pick a file
fn_buf = dialog_pickfile(path = dir, filter = '*.buf')
len = strlen(fn_buf)
fn_ind = strmid(fn_buf,0,len-3) + 'ind'
fn_xpr = strmid(fn_buf,0,len-3) + 'xpr'

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

;- Read buf file
b_info_arr = read_buf(fn_buf)

;- Select the buffers of interest
se = time_wid_mainNew(strtrim(double(b_info_arr(*).time_hms),2))
;print,'se: ',se

start_buff = se(0)
end_buff   = se(1)
print,'start_buff: ',start_buff
print,'end_buff: ',end_buff
;end_buff   = se(1)+1
;stop
;- Get the necessary b_info data
num_occluded = b_info_arr(*).num_occluded
time_hms     = b_info_arr(*).time_hms
time_hrs     = b_info_arr(*).time_hrs
num_blobs    = b_info_arr(*).num_blobs

;- For computing sample volume
;charge_time  = b_info_arr(start_buff:end_buff).charge_time
tas          = b_info_arr(start_buff:end_buff).calc_tas_buff
;tac          = b_info_arr(start_buff:end_buff).tac
time         = b_info_arr(start_buff:end_buff).time_hrs
num_frames   = b_info_arr(start_buff:end_buff).num_frames
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
;stop
openr,unit_ind,fn_ind,/get_lun

i = 0l
j = 0l
;del = 20
ydel = 0
ymax = 0
s1 = xmargin
s2 = ymargin
img_hab = bytarr(xwid,ywid)
img_hab(*,*) = 255
img = bytarr(b_info_arr(0).np,specs.nl)

;- Start loop to excise all particle images that fall within the selected size range
i = start_buff > 1
while i le end_buff do begin
;while i lt end_buff do begin
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
	habit	   = habits(k1:k2)
	llx		   = llxs(k1:k2)
	lly		   = llys(k1:k2)
	urx		   = urxs(k1:k2)
	ury		   = urys(k1:k2)
	xsize      = xsizes(k1:k2)
	ysize      = ysizes(k1:k2)

	;- Draw boxes around particles
	;tem = total(num_blobs(0:i-1))
	;for k1=0l,num_blobs(i)-1l do begin
		;k = k1 + tem
		;plots,[llx(k),urx(k)],[lly(k),lly(k)],/device,color=2
		;plots,[llx(k),urx(k)],[ury(k),ury(k)],/device,color=2
		;plots,[llx(k),llx(k)],[lly(k),ury(k)],/device,color=2
		;plots,[urx(k),urx(k)],[lly(k),ury(k)],/device,color=2
	;endfor
	;stop

	;- Particle size in pixels
	x_dim = urx - llx
	y_dim = ury - lly

	ind_acc = where(xsize ge size1 and xsize lt size2 and $
			        habit ge 8 and ysize gt specs.y_resolution,cnt_acc)

	print,'buff number,time,cnt: ',i,time_hms(i),cnt_acc

	if cnt_acc ne 0 then begin
		for ll=0,cnt_acc-1 do begin
			l = ind_acc(ll)
			if y_dim(l) gt ydel then ydel = y_dim(l)
			del = x_dim(l) + 5
			if (s1 + del) ge xwid then begin
				s1 = 5
				s2 = s2 + ydel + 5
				if ydel gt ymax then ymax = ydel
				ydel = y_dim(l)
				;print,'s1,s2: ',s1,s2
				if s2 gt (ywid-ymax-10) then end_buff = i
			endif
			if i lt end_buff then begin
				img_tem = img(llx(l):urx(l),lly(l):ury(l))
				ind = where(img_tem eq 0,cnt)
				case habit(l) of
				    ;8 :cvalue = color1 - 2 ;green
					;9 :cvalue = color1 + 1 ;orange
					;10:cvalue = 2 + color1 ;blue
					;11:cvalue = color1 -3  ;red
					;12:cvalue = - 4 + color1  ;black
					8 :cvalue = 0 + color1
					9 :cvalue = 1 + color1
					10:cvalue = 2 + color1
					11:cvalue = 3 + color1
					12:cvalue = 4 + color1
					else:cvalue = 0
				endcase
				img_tem(ind) = cvalue
				img_hab(s1:s1+x_dim(l),s2:s2+y_dim(l)) = img_tem
				sort_ind(*,j) = [s1,s1+x_dim(l),s2,s2+y_dim(l)]
				pa(j) = pixel_area(l)
				rose(j) = b_info_arr(i).rose_buff
				lw(j) = b_info_arr(i).fssp_lw_buff
				s1 = s1 + del
				j = j + 1
			endif
		endfor
	endif

	wset,1
	tv,img_hab

	i = i + 1

endwhile		;end loop

num_images = j
end_buff = i - 1
;;;end_buff = i
;stop
;print,size1_str,size2_str
;stop
if num_images eq 0 then begin
  ;mes = ''
  mes = 'No images found in the size range: ' + size1_str + ' - ' + size2_str
  result = dialog_message(mes, /Information)
  print,result
  GOTO, JUMP1
endif
;- Find the min/mean/max of the temp and lw
rose = rose(0:j-1)
rose_min = min(rose)
rose_max = max(rose)
rose_sd = stdev(rose,rose_mean)
rose_rng = rose_max - rose_min
print,'rose_min,rose_max,rose_rng: ',rose_min,rose_max,rose_rng

lw = lw(0:j-1)
lw_min = min(lw)
lw_max = max(lw)
lw_sd = stdev(lw,lw_mean)
lw_rng = lw_max - lw_min
print,'lw_min,lw_max,lw_rng: ',lw_min,lw_max,lw_rng

;- Replace/filter large or zero tac values
;tac_charge = tac_filter(tac,specs.der_thresh,num_frames,charge_time,time,flt_no_str)
;total_dist = total(tac_charge(0:end_buff-start_buff) * tas(0:end_buff-start_buff))

;size_mid = 0.5 * (size1 + size2)
;height = (float(specs.mask2 - specs.mask1 + 1) * specs.y_resolution + 0.72 * size_mid) * 1.e-4	;cm
;if size_mid lt specs.fresnel_dcl then $
;	sample_area = 2.37 * height * size_mid^2 * 1.e-8 else $
;	sample_area = specs.arm_width * height * 1.e-4		;m^2

sample_area = 4.5 * 20.3 * 1e-4 ; for the 1995 HVPS
;- Calculate the total distance
if start_buff eq 0 then tt = fltarr(end_buff-start_buff)

if start_buff gt 0 then tt = fltarr(end_buff-start_buff)

;stop
start = start_buff + 1
temp=0
for d = start, end_buff do begin
;stop
  tt(temp) = (b_info_arr(d).time_hrs - b_info_arr(d-1).time_hrs)*3600.
  temp = temp + 1
endfor

;;t = (b_info_arr(end_buff).time_hrs - b_info_arr(start_buff).time_hrs) * 3600.
;stop
;;total_distance = max(tas(0:end_buff-start_buff))*t
;;;total_distance = total(tas(0:end_buff-1)*tt(0:end_buff-1))
;stop
total_distance = total(tas(0:end_buff-start_buff-1)*tt(0:end_buff-start_buff-1))
;stop
;total_distance = total(tas(end_buff-start_buff)*tt(end_buff-start_buff))

sample_volume = total_distance * sample_area

conc = float(num_images) / sample_volume
;stop
;print,'sample_volume: ',sample_volume
;print,'conc         : ',conc

;- Sort the particle images by pixel area
sort_ind = sort_ind(*,0:j-1)
pa = pa(0:j-1)

ind1 = sort(pa)
img_hab_sort = bytarr(xwid,ywid)
img_hab_sort(*,*) = 255

s1 = xmargin
s2 = ymargin
ydel = 0
for i=0,num_images-1 do begin
	j = ind1(i)
	x1 = sort_ind(0,j)
	x2 = sort_ind(1,j)
	y1 = sort_ind(2,j)
	y2 = sort_ind(3,j)
	x_dim = x2 - x1
	y_dim = y2 - y1

	if y_dim gt ydel then ydel = y_dim
	del = x_dim + 5
	if (s1 + del) ge xwid then begin
		s1 = 5
		s2 = s2 + ydel + 5
		if ydel gt ymax then ymax = ydel
		ydel = y_dim
		;print,'s1,s2: ',s1,s2
		if s2 gt (ywid-ymax-10) then goto, jump2
	endif
	img_hab_sort(s1:s1+x_dim,s2:s2+y_dim) = img_hab(x1:x2,y1:y2)
	s1 = s1 + del
endfor

jump2:

;bar = bytarr(300,20)
;for i=0,299 do bar(i,*) = fix(float(i) * 4. / 300.) + 1

;- Display the sorted images with annotations
wset,1
sw = 0
while sw ne 4 do begin

	tv,img_hab_sort

	str1 = 'Flight ' + strtrim(flt_no_str,2) + ' - ' + specs.probe_name
	str2 = 'Size Range: ' + size1_str + ' to ' + size2_str + ' um'
    str3 = 'Buffer Times: ' + $
            string(format = '(f10.3)',time_hms(start_buff)) + '(' + strtrim(fix(start_buff),2) + ')' + ' to ' + $
      		string(format = '(f10.3)',time_hms(end_buff))   + '(' + strtrim(fix(end_buff),2) + ')'
    str4 = 'Duration: ' + strtrim(end_buff - start_buff + 1,2) + ' buffers  ' + $
                          strtrim((b_info_arr(end_buff).time_hrs - b_info_arr(start_buff).time_hrs) * 3600.,2) + ' s'
    str5 = 'Number Particles: ' + strtrim(num_images,2)
    str6 = 'Min/Mean/Max Temp: ' + string(format = '(f7.2)',rose_min) + '/' + $
                                    string(format = '(f7.2)',rose_mean) + '/' + $
                                    string(format = '(f7.2)',rose_max)
    str7 = 'Min/Mean/Max DMTLW: ' + string(format = '(f7.2)',lw_min) + '/' + $
                                    string(format = '(f7.2)',lw_mean) + '/' + $
                                    string(format = '(f7.2)',lw_max)
    str8 = 'Sample Volume: ' + string(format = '(f10.5)',sample_volume) + $
    			' m!E3!N  ( Conc:' + string(format = '(f7.0)',conc) + ' #/m!E3!N)'

	xyouts,5,ywid-10,str1,charsize = 0.9,color=0,/device
	xyouts,5,ywid-20,str2,charsize = 0.9,color=0,/device
	xyouts,5,ywid-30,str3,charsize = 0.9,color=0,/device
	xyouts,5,ywid-40,str4,charsize = 0.9,color=0,/device
	xyouts,5,ywid-50,str5,charsize = 0.9,color=0,/device
	xyouts,5,ywid-60,str6,charsize = 0.9,color=0,/device
	xyouts,5,ywid-70,str7,charsize = 0.9,color=0,/device
	xyouts,5,ywid-80,str8,charsize = 0.9,color=0,/device

	box = bytarr(8,8)
	for i=0,4 do begin
		box(*,*) = i + color1
		tv,box,3.*xwid/4.,ywid-10.*(i+1)
		xyouts,3.*xwid/4.+15.,ywid-10.*(i+1),hab_titl(i+8),charsize=0.9,color=0,/device
	endfor

	;tv,bar,100,600

	;laser_widNew,sw
	colorimg_wid,sw,img_hab_sort

endwhile

free_lun,unit_ind
JUMP1:
mes = 'The Raw Data Processing Is Done Now!'
result = dialog_message(mes, /Information)
print,result

;stop
wdelete,1
wdelete,2

end