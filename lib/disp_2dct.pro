;-
;- disp_2dc.pro
;-
pro disp_2dct_event,ev
print,'called disp_2dct'

widget_control,ev.top,get_uvalue=state2

buffer_num  = state2.buffer_num
time = state2.time
skip_bytes = state2.skip_bytes
buf_size = state2.buf_size
time_between_particles=state2.time_between_particles

track2_sw = 0
;fssp_sw = 0
num_disp_buffs = 1
bin_size = 100
min_size = 1
widget_control,ev.id,get_uvalue=uval

print,'ev: ',ev
print,'uval: ',uval
color_sw = 0

case uval of

;  'FSSP'	 :begin
;		  fssp_sw=1
;		  end

  'TIMER'	:begin
 			end

 'DONE'   :begin
           widget_control,ev.top,/destroy
           free_lun, state2.unit2
           return
           end

 'SLIDER_BUFFER' :begin
                  ;buffer_num = ev.value - 1
				   buffer_num = ev.value
                  ;str = 'From: ' + state.times(buffer_num) + $
                  ;' (' + string(format = '(i5)',buffer_num) + ')   ' + $
                  ;'To: ' + state.times(buffer_num+5) + $
                  ;' (' + string(format = '(i5)',buffer_num+5) + ')'
                  ;widget_control,state.text_slider,set_value=str
                  end

 'TRACK2'  :begin
           track2_sw = 1
           print,'Track2: ',ev.x,ev.y
           tem = min(abs(state2.dlon - ev.x) + abs(state2.dlat - ev.y),ind_red)
           tem = min(abs(state2.time - state2.time_red(ind_red)),buffer_num)
           print,'state2.time_red(ind_red): ',state2.time_red(ind_red)
           print,'min/max time,ind_red: ',min(state2.time),max(state2.time),ind_red
           print,'min/max time_red: ',min(state2.time_red),max(state2.time_red)
           print,'Buffer/Time: ',buffer_num,state2.time(buffer_num)
           widget_control,state2.slider_buffer,set_value = buffer_num
           end

 'IMG'    :begin
           color_sw = 1
           end

 'NEXT'   :begin
           ;play_sw = 1
           ;widget_control,label_image,timer=2.
           buffer_num = buffer_num + 1
           if buffer_num gt (state2.num_buffers-1) then buffer_num = (state2.num_buffers-1)
           widget_control,state2.slider_buffer,set_value = buffer_num
           ;str = 'From: ' + state.times(buffer_num) + $
                  ;' (' + string(format = '(i5)',buffer_num) + ')   ' + $
                  ;;'To: ' + state.times(buffer_num+5) + $
                  ;' (' + string(format = '(i5)',buffer_num+5) + ')'
           ;widget_control,state.text_slider,set_value=str
           end

 'PREV'   :begin
           ;play_sw = 0
           ;print,'play_sw: ',play_sw
           buffer_num = buffer_num - 1
           if buffer_num lt 0 then buffer_num = 0
           widget_control,state2.slider_buffer,set_value = buffer_num
           end

endcase

widget_control,/hourglass

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;plot the location of the buffer on the track2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wset,state2.index_track2
!p.multi = 0
plot,state2.lon,state2.lat, $
     background = 255, $
     color = 0, $
     /ynozero

ind = where(state2.shad_or_2dc ne 0,cnt)
if cnt ne 0 then $
oplot,state2.lon(ind),state2.lat(ind), $
      psym = 4, $
      symsize = 0.2, $
      color = 3

if track2_sw eq 1 then begin
 oplot,[state2.lon(ind_red),state2.lon(ind_red)],[state2.lat(ind_red),state2.lat(ind_red)], $
       psym = 4, $
       color = 1
       symsize = 0.8

 track2_sw = 0
endif else begin
 tem = min(abs(state2.time_red - state2.time(buffer_num)),ind_reds)
 tem = min(abs(state2.time_red - state2.time(buffer_num + num_disp_buffs)),ind_rede)
 oplot,[state2.lon(ind_reds),state2.lon(ind_reds)],[state2.lat(ind_reds),state2.lat(ind_reds)], $
       psym = 4, $
       color = 2
       symsize = 0.8

 oplot,[state2.lon(ind_rede),state2.lon(ind_rede)],[state2.lat(ind_rede),state2.lat(ind_rede)], $
       psym = 4, $
       color = 1
       symsize = 0.8

endelse


;- Get the buffer images
;- Process the buffer if the mask flag is not set
;- Convert the HVPS buffer into an image

buf = lonarr(buf_size)
num_disp_buffs = 1  ; 6/6/00
print,'buf_size = ',buf_size
;mult = 0l           ; 6/6/00
;div = 0l            ; 6/6/00
dummy = lonarr(3)
;dummy=intarr(3)	; valid for 1999
md = intarr(4)
data_2dc = lonarr(buf_size,num_disp_buffs)

for kb=0,num_disp_buffs-1 do begin
;for kb=0,num_disp_buffs do begin
 point_lun,state2.unit2,state2.buf_ptr(buffer_num + kb)
 buffer_num_str = strtrim(fix(buffer_num),2)
 skip_bytes2=7*16+18	; for 1999 data

 ;readu,state2.unit2,skip_bytes
 readu,state2.unit2,skip_bytes2
 readu,state2.unit2,md
 mult = md(0)
 div = md(1)
 print,'mult,div: ',mult,div
 readu,state2.unit2,dummy

 readu,state2.unit2,buf
 data_2dc(*,kb) = buf(*)

endfor

get_img_2dc,data_2dc,num_disp_buffs,pan_x,pan_y,time(buffer_num), $
            img_buff,num_particles,particle_area,time_between_particles, $
            particle_start,particle_end	;,particle_bottom,particle_top
;stop
;window,xs=1024,ys=32,1
;tv,img_buff(*,*),0,0
;
; img_top = bytarr(1024,16)
; img_bottom = bytarr(1024,16)
;; image is split in half;
; ; switch bottom image with top, and viceversa
; img_top = img_buff(*,16:31)
; img_bottom = img_buff(*,0:15)
;
; ;rebuild the image
; img_buff(*,0:15)=img_top(*,*)
; img_buff(*,16:31)=img_bottom(*,*)
;window,xs=1024,ys=32,2
;tv,img_buff(*,*),0,0
;stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; To do the histogram use the x dimension only.  It is just a qualitative information.
; Use the histogram as just #/bin instead of #/m3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xdims = particle_end - particle_start + 1
;ydims = particle_top - particle_bottom + 1
;print,'ydims: ',ydims
print,'xdims: ',xdims

;calc_tas = 90.
calc_tas = 100.		; valid as of 7/21/00
;sa = 5.0 * 10.0 * 1e-4   ;sample area in m^2
elapsed_time = total(time_between_particles)   ;number seconds
;elapsed_volume = elapsed_time * calc_tas * sa

;bin_size = 5
;min_size = 5
bin_size = 100  ; 7/20/00
min_size = 1
;num_per_bin = histogram(ydims,min=min_size,max=80,binsize=bin_size)
;num_bins = n_elements(num_per_bin)
;bins = findgen(num_bins) * float(bin_size) + 0.5 * float(bin_size) + min_size
num_per_bin = histogram(xdims*25,min=min_size,max=3500,binsize=bin_size) ; 7/19/00
num_bins = n_elements(num_per_bin)
bins = findgen(num_bins) * float(bin_size) + 0.5 * float(bin_size) + min_size
;num_conc = num_per_bin / elapsed_volume
num_conc = num_per_bin   ; 7/19/00

;img_buff = congrid(img_buff,1000,128)
img_disp = bytarr(1024*num_disp_buffs,32)
img_disp(*,*) = 255
;ind_clear = where(img_buff eq 0,cnt_clear)
ind_occluded = where(img_buff gt 0,cnt_occluded)
img_disp(ind_occluded) = 0

print,'Size particle_start: ',size(particle_start)
print,'size img_buff: ',size(img_buff)
print,'num_particles: ',num_particles

color_sw = 0
if color_sw eq 1 then begin
 ind = where(particle_start lt ev.x,cnt)
 particle_num = ind(cnt-1) + 1
 s1 = particle_start(ind(cnt-1))
 s2 = particle_end(ind(cnt-1))
 ;;;h1 = particle_bottom(ind(cnt-1))
 ;;;h2 = particle_top(ind(cnt-1))
 ;print,'s1,s2: ',s1,s2
 ;print,'h1,h2,h2-h1: ',h1,h2,h2-h1
 ind2 = where(img_buff eq particle_num,cnt_color)
 ;ind3 = where(img_buff eq particle_num-1,cnt_color)
 ;ind4 = where(img_buff eq particle_num+1,cnt_color)
 img_disp(ind2) = 1
 ;img_disp(ind3) = 2
 ;img_disp(ind4) = 3
 ;;;img_disp(s1,h1:h2) = 2
 ;;;img_disp(s2,h1:h2) = 3
 ;;;img_disp(s1:s2,h1:h1+1) = 2
 ;;;img_disp(s1:s2,h2:h2+1) = 3
 ;img_buff(ind2) = 1
 ;img_buff(s1:s2,0:20) = 1
 ;color_sw = 0
endif

;- Display the images
wset,state2.index_image
tv,img_buff
;tv,img_disp

wset,state2.index_plot

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Particle size Distribution
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;window,xs=300,ys=150,1,title='Number Conc'
plot,bins,num_conc, $
	 xtitle = 'Particle Size (!7l!6m!N)   (bin-size = 100!7l!6m!N)', $
	 ;;;ytitle = 'Number of particles/m!E3!N', $
	 ytitle = 'Number of particles', $
	 title = '2DC Size Distribution', $
     psym = 10, $  ; used for histograms
     background = 255, $
     color = 0
plots,[bins(0)-.5*bin_size,bins(0)-.5*bin_size],[!y.crange(0),num_conc(0)], color = 0  ; min and mas for y values
plots,[bins(0)-.5*bin_size,bins(0)],[num_conc(0),num_conc(0)],color=0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;FSSP data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;if fssp_sw eq 1 then begin
;;- Get the reduced TAS for the time closest to the HVPS buffer_num
; tem = min(abs(state2.time_red - state2.time(state2.buffer_num)),ind_red)
;print,'tem=',tem
;print,'ind_red=',ind_red
; reduced_time = state2.time_red(ind_red)
; print,'reduced_time=',reduced_time
; calc_tas = state2.calc_tas(ind_red)
; print,'calc_tas=',calc_tas
;;- Extract the fssp data for the 5 seconds following the current HVPS buffer time
;print,'size(state2.fssp_cnts):', size(state2.fssp_cnts)
; ;fssp5 = state2.fssp_cnts(*,ind_red:ind_red + 4)
; fssp5 = state2.fssp_cnts(*,ind_red:ind_red)
; print,'fssp5=',fssp5
; ;fssp_total = total(fssp5,2)
; fssp_total = total(fssp5)
; print,'fssp_total=',fssp_total
; fssp_mean = float(fssp_total) / 5.
; print,'fssp_mean=',fssp_mean
; ;stop
;;- Read the FSSP channel data
; ;fssp_chn = 'c:\T28\Code\Post1997\IDLCode\PlotRnd\fssp.chn'
; ;fssp_chn = 'fssp.chn'
; read_fssp_chn,state2.fssp_chn,vol,bin_width,bins,bine
; print,'fssp_chn=',state2.fssp_chn
; print,'vol=',vol
; print,'bin_width=',bin_width
; print,'bins=',bins
; print,'bine=',bine
;;stop
; ;- Convert mean fssp counts to #/cm3-um
;;- 20. is the ~ volume sampled per second by the fssp probe
;;- at 100 m/s in cm3
;;- dividing by bin_width converts from #/cm3 to #/cm3-um
; elap_time = 5.0  ;seconds
; sample_volume = calc_tas * 100. * elap_time * 0.223 / 100.
; ;sample_volume = mean_tas * 100. * 0.223 / 100.
; print,'elap_time (s)      : ',elap_time
; print,'sample_volume (cm3): ',sample_volume
; print,'part conc          : ',total(fssp_mean) / sample_volume
; fssp_conc = fssp_mean / (sample_volume * bin_width)
; print,'fssp_conc=',fssp_conc
; tem = findgen(15) + 1.
; window,xs=300,ys=150,2,title='FSSP Conc'
; plot_io,tem,fssp_conc, $
;     charsize = 0.8, $
;     psym = 10, $
;     xtitle = 'Particle Size (um)', $
;     ytitle = 'Conc (#/cm!E3!N-um)', $
;     yrange = [0.001,100.], $
;     title = 'FSSP Spectrum', $
;     xrange = [0.,100.], $
;     background = 255, $
;     color = 0, $
;     /nodata
; for i=0,14 do begin
;  plots,[bins(i),bins(i)],[0.001,fssp_conc(i)>0.001],linestyle=0,color=0
;  plots,[bine(i),bine(i)],[0.001,fssp_conc(i)>0.001],linestyle=0,color=0
;  plots,[bins(i),bine(i)],[fssp_conc(i)>0.001,fssp_conc(i)>0.001],color=0
; endfor
;endif
;;mult = 50.
;;div  = 20.
time_between_particles = findgen(5)
;dur = (state.time(buffer_num-1+num_disp_buffs) - state.time(buffer_num-1)) * 3600.
dur = (state2.time(buffer_num+num_disp_buffs) - state2.time(buffer_num)) * 3600.
str = 'From: ' + state2.times(buffer_num) + $
      ;' (' + string(format = '(i5)',buffer_num-1) + ')   ' + $
      ' (' + string(format = '(i5)',buffer_num) + ')   ' + $
      ;'To: ' + state.times(buffer_num-1+num_disp_buffs) + $
      'To: ' + state2.times(buffer_num+num_disp_buffs) + $
      ;' (' + string(format = '(i5)',buffer_num-1+num_disp_buffs) + ')' + $
      ' (' + string(format = '(i5)',buffer_num+num_disp_buffs) + ')' + $
      '  Duration: ' + string(format = '(f8.3)',dur) + ' s' + $
      '       Distance: ' + string(format = '(i5)',fix(dur * 100.)) + ' m' + $
      ;'  Sum Inters: ' + string(format = '(f5.1)',total(time_between_particles)) + ' s' + $
      '     Mult: ' + string(format = '(i5)',mult) + '     Div: ' + string(format = '(i5)',div)

widget_control,state2.text_slider,set_value=str

;- Update the text info on the buffer and blob parameters
state2.buffer_num = buffer_num

widget_control,ev.top,set_uvalue=state2

end

;---------- ---------- ----------
pro disp_2dct, fn_2dc, fn_reduced, fssp_chn, fn_posttel, fltno

;print,'called disp_2dct total_buffer_size : ',total_buffer_size
print,'called disp_2dct'

;stop
pan_x = 1024
pan_y = 32

tvlct,255,0,0,1
tvlct,0,255,0,2
tvlct,0,0,255,3

device,decomposed=0

;- Filename for HVPS data

;fn_2dc = 'c:\Sea\Raw\F748_2dc.raw'
;fn_2dc = 'd:\t28\yr2000\raw\F747\F747_2dc.raw'
print,'2DC file name: ',fn_2dc
print,'reduced file name: ',fn_reduced
print,'fssp_chn file name: ',fssp_chn
print,'fn_posttel file name: ',fn_posttel
print,'fltno',fltno

num_disp_buffs = 1
;skip_bytes = bytarr(16*7+18)	;supposedly valid for years >= 2000
if ((fltno ge 725) AND (fltno lt 733)) then begin
 skip_bytes = bytarr(16*7+18+14) ;actually valid for 1999
endif

if ((fltno ge 733) AND (fltno lt 738)) then begin
 skip_bytes = bytarr(16*7+18+14+6) ;actually valid for 1999
endif

buf_size = 1024

dir_data = intarr(8,7)
time     = intarr(9)
data_2dc = lonarr(1024)

buff_times_2dc_1999,fn_2dc, $
               buf_ptr,time,times,fltno

num_buffers = n_elements(time)

print,'Number of buffers = ', num_buffers
;stop
base = widget_base(/column)

base1       = widget_base(base,/row)
button_prev = widget_button(base1,value='Previous Buffer',uvalue='PREV')
button_next = widget_button(base1,value='Next Buffer',uvalue='NEXT')
button_done = widget_button(base1,value='Done',uvalue='DONE')

slider_buffer = widget_slider(base,uvalue='SLIDER_BUFFER',minimum=1,maximum=num_buffers,title='Buffer #',/frame)

text_slider = widget_text(base,xsize=30,/frame)
label_image = widget_label(base,value = 'Buffer Image',/align_left, uvalue = 'TIMER')
draw_image = widget_draw(base,/scroll,x_scroll_size=900,xsize=5000, $
             uvalue='IMG',/button_events,y_scroll_size=32,ysize=33,retain=2)

base2		= widget_base(base,/row)
draw_track2  = widget_draw(base2,xsize=350, ysize = 300,/frame,uvalue='TRACK2',/button_events,retain=2)
draw_plot	= widget_draw(base2,xsize=500, ysize = 200,/frame)

;base3		= widget_base(base,/row)
;button_fssp	= widget_button(base3,value = 'FSSP Spectrum',uvalue='FSSP',/frame)

widget_control,base,/realize

;buffer_num = 10
buffer_num = 2

;- Open the 2dc data file for reading
openr,unit2,fn_2dc,/get_lun

status = fstat(unit2)
file_size = status.size

;num_buffers = file_size / (2123l * 2)			;2123
num_buffers = file_size / (2120l * 2)			;2120

print,'file_size  : ',file_size
print,'num_buffers: ',num_buffers
;stop

multiply_factor = 0l
divide_factor   = 0l		;Remember some files from 1999 do not have this parameter
elapsed_time    = 0l
elapsed_tas     = 0l
elapsed_shad_or = 0l

buf = lonarr(buf_size)
num_disp_buffs = 1
data_2dc = lonarr(buf_size,num_disp_buffs)
for kb=0,num_disp_buffs-1 do begin
;for kb=1,num_disp_buffs-1 do begin
;for kb=0,num_disp_buffs do begin
point_lun,unit2,buf_ptr(buffer_num + kb)
buffer_num_str = strtrim(fix(buffer_num),2)

readu,unit2,skip_bytes

readu,unit2,buf
data_2dc(*,kb) = buf(*)
;stop
endfor
;stop
get_img_2dc,data_2dc,num_disp_buffs,pan_x,pan_y,time(buffer_num), $
            img_buff,num_particles,particle_area,time_between_particles, $
            particle_start,particle_end	;,particle_bottom,particle_top

;- Get the indices of the draw windows
widget_control,draw_image,get_value=index_image
widget_control,draw_plot,get_value=index_plot
widget_control,draw_track2,get_value=index_track2

wset,index_image
;;;tv,img_buff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;- Read the reduced data file to get time,lat,lon,and calc_tas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_rnd,fn_reduced,num_tags,tags,tag_ind,data,num, fltno
times_red = long(reform(data(0,*)))
times_red = times_red 		;+ 60000l
times_red = strtrim(string(times_red),2)
hms2hrs,times_red,time_red

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;- Get data for tags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_posttel,tag_post,tag_labels, fn_posttel

get_tag,tags,data,num,tag_post,tag_labels,172,lat,lat_lab
get_tag,tags,data,num,tag_post,tag_labels,173,lon,lon_lab
get_tag,tags,data,num,tag_post,tag_labels,211,calc_tas,calc_tas_lab
get_tag,tags,data,num,tag_post,tag_labels,147,shad_or_2dc,shad_or_2dc_lab

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;- Get the FSSP counts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ind_fssp = where(tags eq 140,cnt_fssp)
;fssp_cnts = data(ind_fssp(0)+1:ind_fssp(cnt_fssp-1)+1,*)
 ;stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;plot the track2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wset,index_track2
!p.multi = 0
;plot,state.lon,state.lat, $
plot,lon,lat, $
     background = 255, $
     color = 0, $
     /ynozero
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;- Convert lat/lon to device coordinates so we can click on the track2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dlatlon = convert_coord(lon,lat,/data,/to_device)
dlon = dlatlon(0,*)
dlat = dlatlon(1,*)
;print,'min/max dlon: ',min(dlon),max(dlon)
;print,'min/max dlat: ',min(dlat),max(dlat)

particle_number = 2l


state2 = {BASE:base, $
         INDEX_PLOT:index_plot, $
         INDEX_IMAGE:index_image, $
         INDEX_TRACK2:index_track2, $
         SLIDER_BUFFER:slider_buffer, $
         TEXT_SLIDER:text_slider, $
         PARTICLE_NUMBER:particle_number, $
         TIME_BETWEEN_PARTICLES:time_between_particles, $
         UNIT2:unit2, $
         SKIP_BYTES:skip_bytes, $
         BUF_SIZE:buf_size, $
         BUF_PTR:buf_ptr, $
         NUM_BUFFERS:num_buffers, $
         TIMES:times, $
         TIME:time, $
         BUFFER_NUM:buffer_num, $
         PAN_X:pan_x, $
         PAN_Y:pan_y, $
         TIMES_RED:times_red, $
         TIME_RED:time_red, $
         TAGS:tags, $
         DATA:data, $
         NUM:num, $
         TAG_POST:tag_post, $
         TAG_LABELS:tag_labels, $
         DLAT:dlat, $
         DLON:dlon, $
         LAT:lat, $
         LON:lon, $
         ;FSSP_CNTS:fssp_cnts, $
         CALC_TAS:calc_tas, $
         SHAD_OR_2DC:shad_or_2dc, $
         FSSP_CHN:fssp_chn, $
         FN_2DC: fn_2dc, $
         FN_REDUCED: fn_reduced, $
		 FN_POSTTEL: fn_posttel}

widget_control,base,set_uvalue=state2

xmanager,'disp_2dct',base

end

