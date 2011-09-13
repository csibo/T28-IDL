;-*************************************************
;- disp_buffs_hvps_only.pro
;
;- Routine used in the HVPSDisplayOnly.pro program.
;- It will display only the particles without the charge.
;
;- Last modified: 10/17/2002
;   - corrected the histogram to display the particle
;     concentrations for 3 buffers at a time
;
;- 10/24/2002 - added the option to display the hail
;  concentration on the HVPS window display.  The HVPS
;  data has 5 seconds of data.
;
;-*************************************************
pro disp_buffs_hvps_only_event,ev

common hbt,hvps_buffer_time

device,decomposed=0

@archive.inc

widget_control,ev.top,get_uvalue=state

buffer_num  = state.buffer_num
time = state.time
skip_bytes = state.skip_bytes
buf_size = state.buf_size
total_buffer_size = state.total_buffer_size

track_sw = 0
fssp_sw  = 0
hail_sw  = 0
num_disp_buffs = 3
;num_disp_buffs = 6
;num_disp_buffs = 1

bin_size = 5
min_size = 1

widget_control,ev.id,get_uvalue=uval

;print,'ev: ',ev
;print,'uval: ',uval
color_sw = 0

case uval of

 '2DC'    :begin
         ;- Get 2DC data
         total_buffer_size = state.total_buffer_size
         if total_buffer_size eq 4220 then begin
          disp622_2dct,state.fn_2dc,state.fn_reduced,$
                       state.fssp_chn,state.fn_posttel
          endif

          if total_buffer_size eq 4182 then begin
          disp_2dct,state.fn_2dc,state.fn_reduced,state.fssp_chn,$
                    state.fn_posttel
          endif

          end


 'CHARGE' :begin
       message,"This option does not work in this case!"
 ;      pn = 2l
 ;      openr,unit_tem,'pn_tem.dat',/get_lun
 ;         readu,unit_tem,pn
 ;          free_lun,unit_tem
 ;          print,'particle_number: ',pn
 ;          charge_wid,state.base,reform(state.charge_plates(pn,*,*))
           end

 'REDUCED':begin
          reduced_wid,state.base,state.tags,state.data,state.num,$
                      state.tag_post,state.tag_labels, $
                       state.time_red,state.slider_buffer,state.time
           end

 'FSSP'   :begin
           fssp_sw = 1
           end

 'HAIL'   :begin
         hail_sw = 1
         end

 'TIMER'  :begin

           end

 'DONE'   :begin
           widget_control,ev.top,/destroy
           close,/all
           return
           end

 'SLIDER_BUFFER' :begin
                  ;;;buffer_num = ev.value - 1
                  buffer_num = ev.value

                  end
'TRACK'  :begin
           track_sw = 1
           print,'Track: ',ev.x,ev.y
           tem = min(abs(state.dlon - ev.x) + abs(state.dlat - ev.y),ind_red)
           tem = min(abs(state.time - state.time_red(ind_red)),buffer_num)
           print,'state.time_red(ind_red): ',state.time_red(ind_red)
           print,'min/max time,ind_red: ',min(state.time),max(state.time),ind_red
           print,'min/max time_red: ',min(state.time_red),max(state.time_red)
           print,'Buffer/Time: ',buffer_num,state.time(buffer_num)
           widget_control,state.slider_buffer,set_value = buffer_num
           end


 'IMG'    :begin
           color_sw = 1
           end

 'NEXT'   :begin

           buffer_num = buffer_num + 1
           if buffer_num gt (state.num_buffers-1) then buffer_num = (state.num_buffers-1)
           widget_control,state.slider_buffer,set_value = buffer_num

           end

 'PREV'   :begin

           buffer_num = buffer_num - 1
           if buffer_num lt 0 then buffer_num = 0
           widget_control,state.slider_buffer,set_value = buffer_num

           end

endcase

widget_control,/hourglass

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;plot the location of the buffer on the track
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wset,state.index_track
!p.multi = 0
plot,state.lon,state.lat, $
     background = 255, $
     color = 0, $
     /ynozero

ind = where(state.shad_or_2dc ne 0,cnt)
if cnt ne 0 then $
oplot,state.lon(ind),state.lat(ind), $
      psym = 4, $
      symsize = 0.2, $
      color = 3

if track_sw eq 1 then begin
 oplot,[state.lon(ind_red),state.lon(ind_red)],[state.lat(ind_red),state.lat(ind_red)], $
       psym = 4, $
       color = 1
       symsize = 0.8

 track_sw = 0
endif else begin
 tem = min(abs(state.time_red - state.time(buffer_num)),ind_reds)
 tem = min(abs(state.time_red - state.time(buffer_num + num_disp_buffs)),ind_rede)
 oplot,[state.lon(ind_reds),state.lon(ind_reds)],[state.lat(ind_reds),state.lat(ind_reds)], $
       psym = 4, $
       color = 2
       symsize = 0.8

 oplot,[state.lon(ind_rede),state.lon(ind_rede)],[state.lat(ind_rede),state.lat(ind_rede)], $
       psym = 4, $
       color = 1
       symsize = 0.8

endelse


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;- Get the buffer images
;- Process the buffer if the mask flag is not set
;- Convert the HVPS buffer into an image
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ADED 2/5/2001 to adjust for the image
;=======================================================
clock_factor = 25000         ; added 2/5/2001
y_resolution = 200          ; in microns

buf = intarr(buf_size)
bufm = intarr(buf_size*(num_disp_buffs+1))

;fn='temp.doc'
;openw,10,fn

for kb=0,num_disp_buffs do begin

point_lun,state.unit,state.buf_ptr(buffer_num + kb)
buffer_num_str = strtrim(fix(buffer_num),2)

readu,state.unit,skip_bytes

if total_buffer_size eq 4182 then begin
  mult = skip_bytes(41)
  div  = skip_bytes(42)
endif

if total_buffer_size eq 4220 then begin
  mult = skip_bytes(57)
  div  = skip_bytes(58)
  elapsed_time = skip_bytes(59)
  elaps_shadow_or = skip_bytes(61)
endif

readu,state.unit,buf
bufm(kb*2048:(kb+1)*2048-1) = buf(*)
;writeu,10,buf(*)

endfor
;close,10
;stop
charge_sw = 0   ; will display only the images without charge
;get_img_hvps_only
start_buffer_num = buffer_num
get_img_only2,bufm,num_disp_buffs,pan_x,pan_y,start_buffer_num,time,charge_sw, $
                img_buff,time_img,num_particles,particle_area,charge_plates,time_between_particles, $
                particle_start,particle_end,particle_bottom,particle_top,particle_time,$
                total_buffer_size,skip_bytes,buf_size

state.charge_plates = charge_plates


xdims = particle_end - particle_start + 1
ydims = float(particle_top - particle_bottom + 1) * .2
;stop

calc_tas = 96.
;time_diff = time(buffer_num) - state.time_red
;min_time_diff = min(time_diff, ind_diff)
;calc_tas = calc_tas(ind_diff)

sa = 4.5 * 20.0 * 1e-4   ;sample area in m^2
elapsed_time = total(time_between_particles)   ;number seconds
elapsed_volume = elapsed_time * calc_tas * sa

num_per_bin = histogram(ydims,min=min_size,max=50,binsize = bin_size)
num_bins = n_elements(num_per_bin)
bins = findgen(num_bins) *float(bin_size) + 0.5 * float(bin_size) + min_size
;stop
if elapsed_volume gt 0. then num_conc = float(num_per_bin)/elapsed_volume else num_conc = fltarr(num_bins)

img_disp = img_buff(*,*)
img_disp(*,*) = 255
;ind_clear = where(img_buff eq 0,cnt_clear)
ind_occluded = where(img_buff ge 0,cnt_occluded)
if cnt_occluded ne 0 then img_disp(ind_occluded) = 0

;print,'Size particle_start: ',size(particle_start)
;print,'size img_buff: ',size(img_buff)
;print,'num_particles: ',num_particles

if color_sw eq 1 then begin
 ind = where(particle_start lt ev.x,cnt)

 img_disp(ind2) = 1

 img_disp(s1,h1:h2) = 2
 img_disp(s2,h1:h2) = 3
 img_disp(s1:s2,h1:h1+1) = 2
 img_disp(s1:s2,h2:h2+1) = 3

endif

;- Display the images
wset,state.index_image
;tv,img_buff
xs = size(img_disp)

;print,'xs = ',xs

; multiply by 4 in x direction to compensate.
;tv,congrid(img_disp,xs(1)*2,128),/order
tv,congrid(img_disp,xs(1)*4,128),/order

;tv,congrid(img_disp,1000,128),/order

wset,state.index_plot

ind_hail = where(state.tags eq 150,ni)
;use the reduced data to extract the channel info for the hail counts
hail_counts = intarr(14,state.num)

for i = 0, state.num-1 do begin
   hail_counts(*,i) = state.data(ind_hail+1,i)
endfor


;Particle size distribution
plot,bins,num_conc, $
     xtitle = 'Size (mm)   (bin-size = 5mm)', $
     ;ytitle = '#/m!E3!n', $
     ytitle = '# of Particles/m!E3!N', $
     title = 'HVPS Size Distribution', $
     background = 255, $
     color = 0, $
     psym = 10   ; used for histograms
plots,[bins(0)-.5*bin_size,bins(0)-.5*bin_size],[!y.crange(0),num_conc(0)], color = 0  ; min and mas for y values
plots,[bins(0)-.5*bin_size,bins(0)],[num_conc(0),num_conc(0)],color=0


;display fssp concentration
;------------------------------------------------------------
if fssp_sw eq 1 then begin
;- Get the reduced TAS for the time closest to the HVPS buffer_num
 tem = min(abs(state.time_red - state.time(state.buffer_num)),ind_red)
 reduced_time = state.time_red(ind_red)
 calc_tas = state.calc_tas(ind_red)
;- Extract the fssp data for the 5 seconds following the current HVPS
;  buffer time
temp_red = ind_red + 4
 fssp5 = state.fssp_cnts(*,ind_red:temp_red)
 fssp_total = total(fssp5,2)
 fssp_mean = float(fssp_total) / 5.
;- Read the FSSP channel data
 ;fssp_chn = 'c:\T28\Code\Post1997\IDLCode\PlotRnd\fssp.chn'
 ;fssp_chn = 'fssp.chn'
 read_fssp_chn,state.fssp_chn,vol,bin_width,bins,bine
;- Convert mean fssp counts to #/cm3-um
;- 20. is the ~ volume sampled per second by the fssp probe
;- at 100 m/s in cm3
;- dividing by bin_width converts from #/cm3 to #/cm3-um
 elap_time = 5.0  ;seconds
 sample_volume = calc_tas * 100. * elap_time * 0.223 / 100.
 ;sample_volume = mean_tas * 100. * 0.223 / 100.
 ;print,'elap_time (s)      : ',elap_time
 ;print,'sample_volume (cm3): ',sample_volume
 ;print,'part conc          : ',total(fssp_mean) / sample_volume
 fssp_conc = fssp_mean / (sample_volume * bin_width)
 tem = findgen(15) + 1.
 window,xs=400,ys=250,2,title='FSSP Conc'
 plot_io,tem,fssp_conc, $
     charsize = 0.8, $
     psym = 10, $
     xtitle = 'Particle Size (um)', $
     ytitle = 'Conc (#/cm!E3!N-um)', $
     yrange = [0.001,100.], $
     title = 'FSSP Spectrum', $
     xrange = [0.,100.], $
     background = 255, $
     color = 0, $
     /nodata
 for i=0,14 do begin
  plots,[bins(i),bins(i)],[0.001,fssp_conc(i)>0.001],linestyle=0,color=0
  plots,[bine(i),bine(i)],[0.001,fssp_conc(i)>0.001],linestyle=0,color=0
  plots,[bins(i),bine(i)],[fssp_conc(i)>0.001,fssp_conc(i)>0.001],color=0
 endfor
endif

;stop
;display HAIL counts
;------------------------------------------------------------
if hail_sw eq 1 then begin
;- Get the reduced TAS for the time closest to the HVPS buffer_num
 tem = min(abs(state.time_red - state.time(state.buffer_num)),ind_red)
 reduced_time = state.time_red(ind_red)
 calc_tas = state.calc_tas(ind_red)
;- Extract the hail data for the 5 seconds following the current HVPS buffer time
 hail5 = hail_counts(*,ind_red:ind_red + 4)
 hail_total = total(hail5,2)
 hail_mean = float(hail_total) / 5.
;- Read the hail channel data
 read_hail_chn,hail_chn,vol,bin_width,bins,bine

;- Convert mean hail counts to #/m3-mm
;- 100 m3/km is the ~ volume sampled HAIL probe
;- at 100 m/s in m3
;- dividing by bin_width converts from #/m3 to #/m3-cm
 elap_time = 5.0  ;seconds
 ;calc_tas (m/s)
 ;elap_time (s)
 ;100 m3/km
 ;1./1000. (in km)
 ;
 sample_volume = calc_tas * 1./1000. * elap_time * 100.

 ;print,'elap_time (s)      : ',elap_time
 ;print,'sample_volume (m3): ',sample_volume
 ;print,'part conc          : ',total(hail_mean) / sample_volume
 hail_conc = hail_mean / (sample_volume * bin_width)
 tem = findgen(14) + 1.

;stop
 window,xs=400,ys=250,10,title='HAIL Conc'
 plot_io,tem,hail_conc, $
 ;plot,tem,hail_conc, $
     charsize = 1.0, $
     psym = 10, $
     xtitle = 'Particle Size (cm)', $
     ytitle = 'Conc (#/m!E3!N-cm)', $
     yrange = [0.001,100.], $
     title = 'HAIL Spectrum ', $ ;(Conc - #/m!E3!N-cm)', $
     xrange = [0.,5.], $
     background = 255, $
     color = 0, $
     /nodata
 for i=0,13 do begin
  plots,[bins(i),bins(i)],[0.001,hail_conc(i)>0.001],linestyle=0,color=0
  plots,[bine(i),bine(i)],[0.001,hail_conc(i)>0.001],linestyle=0,color=0
  plots,[bins(i),bine(i)],[hail_conc(i)>0.001,hail_conc(i)>0.001],color=0
 endfor
endif




;if total_buffer_size eq 4182 then begin
;  dur = (state.time(buffer_num+num_disp_buffs) - state.time(buffer_num)) * 3600.
;  frq = float(mult)/float(div)  ; in khz
;  ;print,'frq: ',frq
;  str = 'From: ' + state.times(buffer_num) + $
;                  ' (' + string(format = '(i5)',buffer_num) + ')   ' + $
;                  ;'To: ' + state.times(buffer_num+num_disp_buffs-1) + $
;                  'To: ' + state.times(buffer_num+num_disp_buffs) + $
;                  ' (' + string(format = '(i5)',buffer_num+num_disp_buffs) + ')' + $
;                  '   Duration: ' + string(format = '(f6.3)',dur) + ' s' + $
;                  '   Distance: ' + string(format = '(i4)',fix(dur * 100.)) + ' m' + $
;                  '   Sum Inter Particle Times: ' + string(format = '(f6.3)',total(time_between_particles)) + ' s' + $
;                  '   Mult: ' + string(format = '(i3)',mult) + '  Div: ' + string(format = '(i3)',div) + $
;                  '    Frequency: ' + string(format = '(i5)',fix(frq * (50./2.))) + ' KHz'
;endif

;if total_buffer_size eq 4220 then begin
;  dur = elaps_time_sec
;  frq = float(mult)/float(div)  ; in khz
;  ;print,'frq: ',frq
;  str = 'From: ' + state.times(buffer_num) + $
;                  ' (' + string(format = '(i5)',buffer_num) + ')   ' + $
;                  ;'To: ' + state.times(buffer_num+num_disp_buffs-1) + $
;                  'To: ' + state.times(buffer_num+num_disp_buffs) + $
;                  ' (' + string(format = '(i5)',buffer_num+num_disp_buffs) + ')' + $
;                  '   Duration: ' + string(format = '(f6.3)',dur) + ' s' + $
;                  '   Distance: ' + string(format = '(i4)',fix(dur * 100.)) + ' m' + $
;                  '   Sum Inter Particle Times: ' + string(format = '(f6.3)',elapsed_time) + ' s' + $
;                  '   Mult: ' + string(format = '(i3)',mult) + '  Div: ' + string(format = '(i3)',div) + $
;                  '    Frequency: ' + string(format = '(i5)',fix(frq * (50./2.))) + ' KHz'
;endif

dur = (state.time(buffer_num+num_disp_buffs) - state.time(buffer_num)) * 3600.
str = 'From: ' + state.times(buffer_num) + $
                  ' (' + string(format = '(i5)',buffer_num) + ')   ' + $
                  'To: ' + state.times(buffer_num+num_disp_buffs-1) + $
                  ' (' + string(format = '(i5)',buffer_num+num_disp_buffs) + ')' + $
                  '  Duration: ' + string(format = '(f6.2)',dur) + ' s' + $
                  '  Distance: ' + string(format = '(i5)',fix(dur * 100.)) + ' m' + $
                  '  Sum Inter Particle Times: ' + string(format = '(f6.2)',total(time_between_particles)) + ' s' + $
                  '  Mult: ' + string(format = '(i5)',mult) + '  Div: ' + string(format = '(i5)',div)

widget_control,state.text_slider,set_value=str


;- Update the text info on the buffer and blob parameters

state.buffer_num = buffer_num

widget_control,ev.top,set_uvalue=state

end

;---------- ---------- ----------
pro disp_buffs_hvps_only

pan_x = 1000
pan_y = 256

tvlct,255,0,0,1
tvlct,0,255,0,2
tvlct,0,0,255,3

;- Filename for HVPS data
dir2 = ''

idl_file=FILE_WHICH('t28idl.txt')
openr, 1,idl_file
readf,1,dir2
close,1

fn_out = ''
title_flt = ''
fltno = intarr(1)
fn_hvps = ''
fn_reduced =''
fn_2dc = ''
fssp_chn = ''
fn_posttel = ''

openr,1,dir2+'lib'+path_sep()+'flightselected.txt'
readf,1,fn_out
readf,1,title_flt
readf,1,fltno
readf,1,fn_hvps
readf,1,fn_reduced
readf,1,fn_2dc
readf,1,fssp_chn
readf,1,fn_posttel
close,1

fltnos = fltno

;buf_size = 2050
read_hvps_bufsize,fn_hvps,total_buffer_size

buf_size = 2048
if fltnos lt 757 then begin
skip_bytes = intarr(43)        ; valid for flights before 6/22/00
skip_bytes2 = bytarr(1)
hvps98_buff_times,fn_hvps,buf_ptr,time,times,fltno

endif

if fltnos ge 757 then begin
skip_bytes = intarr(62)        ; valid for flights after 6/22/00
skip_bytes2 = bytarr(1)
hvps98_buff622_times,fn_hvps,buf_ptr,time,times

endif

;;skip_bytes = intarr(43)
;;skip_bytes2 = bytarr(1)
;;hvps98_buff_times,fn_hvps,buf_ptr,time,times

num_buffers = n_elements(time)

;@archive.inc

base = widget_base(/column)

base1       = widget_base(base,/row)
button_prev = widget_button(base1,value='Previous Buffer',uvalue='PREV')
button_next = widget_button(base1,value='Next Buffer',uvalue='NEXT')
button_done = widget_button(base1,value='Done',uvalue='DONE')

slider_buffer = widget_slider(base,uvalue='SLIDER_BUFFER',minimum=1,maximum=num_buffers,title='Buffer #',/frame)

text_slider = widget_text(base,xsize=30,/frame)

label_image = widget_label(base,value='Buffer Image',/align_left,uvalue = 'TIMER')

draw_image = widget_draw(base,/scroll,x_scroll_size=900,xsize=3000, $
             uvalue='IMG',/button_events,y_scroll_size=128,ysize=129,retain=2)

label2  = widget_label(base,value='Particle Images',/align_left)

base2   = widget_base(base,/row)
;base2   = widget_base(base,/column)
draw_track = widget_draw(base2,xsize=500,ysize=250,/frame,uvalue='TRACK',/button_events,retain=2)
draw_plot  = widget_draw(base2,xsize=350,ysize=250,/frame)

base3          = widget_base(base,/row)
;button_charge  = widget_button(base3,value='Charge Data',uvalue='CHARGE')
button_reduced = widget_button(base3,value='Reduced Data',uvalue='REDUCED')
button_fssp    = widget_button(base3,value='FSSP Spectrum',uvalue='FSSP')
button_hail    = widget_button(base3,value='HAIL Spectrum',uvalue='HAIL')
button_2dc     = widget_button(base3,value='2DC Data',uvalue='2DC')

widget_control,base,/realize

buffer_num = 1   ;3342 Good spot in flt 717

;- Open the HVPS data file for reading
openr,unit,fn_hvps,/get_lun

buf = intarr(buf_size)

;- Get the HVPS buffer image
point_lun,unit,buf_ptr(buffer_num)
buffer_num_str = strtrim(fix(buffer_num),2)

readu,unit,skip_bytes
readu,unit,buf

;- Get the indices of the draw windows
widget_control,draw_image,get_value=index_image
widget_control,draw_plot, get_value=index_plot
widget_control,draw_track,get_value=index_track


;- Resize to fit the window and display
;img_buff = congrid(img_buff,1000,128)

wset,index_image
;tv,img_buff
charge_plates = intarr(1000,8,6)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;- Read the reduced data file to get time,lat,lon,and calc_tas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_rnd,fn_reduced,num_tags,tags,tag_ind,data,num,fltno
times_red = long(reform(data(0,*)))
times_red = times_red    ;+ 60000l
times_red = strtrim(string(times_red),2)
hms2hrs,times_red,time_red
temp_size = size(times_red)
start_time = times_red(0)
number = temp_size(1)
;print,'number: ',number
end_time = times_red(temp_size(1)-1)

;print,'size(times_red): ',size(times_red)
;print,'start_time for this flight: ',start_time
;print,'end_time for this flight:',end_time
;stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;- Get data for tags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_posttel,tag_post,tag_labels, fn_posttel

get_tag,tags,data,num,tag_post,tag_labels,172,lat,lat_lab
get_tag,tags,data,num,tag_post,tag_labels,173,lon,lon_lab
get_tag,tags,data,num,tag_post,tag_labels,211,calc_tas,calc_tas_lab
get_tag,tags,data,num,tag_post,tag_labels,147,shad_or_2dc,shad_or_2dc_lab

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;- Get the FSSP counts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ind_fssp = where(tags eq 140,cnt_fssp)
fssp_cnts = data(ind_fssp(0)+1:ind_fssp(cnt_fssp-1)+1,*)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;plot the track
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wset,index_track
!p.multi = 0
;plot,state.lon,state.lat, $
plot,lon,lat, $
     background = 255, $
     color = 0, $
     /ynozero

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;- Convert lat/lon to device coordinates so we can click on the track
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dlatlon = convert_coord(lon,lat,/data,/to_device)
dlon = dlatlon(0,*)
dlat = dlatlon(1,*)

;;particle_number = 2l

state = {BASE:base, $
         INDEX_PLOT:index_plot, $
         INDEX_IMAGE:index_image, $
         INDEX_TRACK:index_track, $
         LABEL_IMAGE:label_image, $
         SLIDER_BUFFER:slider_buffer, $
         TEXT_SLIDER:text_slider, $

         UNIT:unit, $
         SKIP_BYTES:skip_bytes, $
         BUF_SIZE:buf_size, $
         BUF_PTR:buf_ptr, $
         NUM_BUFFERS:num_buffers, $
         TIMES:times, $
         TIME:time, $
         BUFFER_NUM:buffer_num, $
         PAN_X:pan_x, $
         PAN_Y:pan_y, $
         TOTAL_BUFFER_SIZE: total_buffer_size, $
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
         FSSP_CNTS:fssp_cnts, $
         CALC_TAS:calc_tas, $
         SHAD_OR_2DC:shad_or_2dc, $
         FSSP_CHN:fssp_chn, $
         FN_2DC: fn_2dc, $
        FN_REDUCED: fn_reduced, $
        FN_POSTTEL: fn_posttel, $
         CHARGE_PLATES:charge_plates }

widget_control,base,set_uvalue=state

;widget_control,label_image,timer = 1.

xmanager,'disp_buffs_hvps_only',base

end

