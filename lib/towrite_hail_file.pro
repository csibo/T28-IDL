;-
;- towrite_hail_file.pro
;-
;- This routine is called when hail counts need to be
; written in an output text file.
;
;  Author: Dr. Donna Kliche
;
;- Last modified: 09/15/2008 -
;
;-------------------------------------------------------------

pro towrite_hail_file, switcht, start_time, end_time, num_buffers, start_buffer, end_buffer, b_info_arr, GROUP = base_leader


tvlct,255,0,0,1
tvlct,0,255,0,2
tvlct,0,0,255,3

device,decomposed=0

;read the needed fn from flightselected.txt
dir2 = ''
idl_file = file_which('t28idl.txt')
openr, 1, idl_file
readf,1,dir2
close,1

fn_out = ''
title_flt = ''
fltno = 0
flt_num = ''
fn_hvps = ''
fn_reduced =''
fn_2dc = ''
fssp_chn = ''
fn_posttel = ''
yr = ''
fn_hail = ''
fn_raw = ''

out_file = dir2 + 'lib' + path_sep() + 'flightselected.txt'
openr,1,out_file
readf,1,fn_out
readf,1,title_flt
readf,1,fltno
flt_num = strtrim(fltno,2)
readf,1,fn_hvps
readf,1,fn_reduced
readf,1,fn_2dc
readf,1,fssp_chn
readf,1,fn_posttel
readf,1,yr
readf,1,fn_hail
readf,1,fn_raw
close,1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;- Read the reduced data file to get time,lat,lon,and calc_tas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
read_rnd,fn_reduced,num_tags,tags,tag_ind,data,num,fltno
times_red = long(reform(data(0,*)))
times_red = times_red    ;+ 60000l
times_red = strtrim(string(times_red),2)
hms2hrs,times_red,time_red
stop

ind_hail = where(tags eq 150,ni)
;use the reduced data to extract the channel info for the hail counts
hail_counts = intarr(14,num)

for i = 0, num-1 do begin
   hail_counts(*,i) = data(ind_hail+1,i)
endfor


;read HAIL counts
;------------------------------------------------------------
;- Get the reduced TAS for the time closest to the 2DC buffer_num
 tem = min(abs(state2dc.time_red - state2dc.time(state2dc.buffer_num)),ind_red)
 reduced_time = state2dc.time_red(ind_red)
 calc_tas = state2dc.calc_tas(ind_red)
;- Extract the hail data for the 5 seconds following the current HVPS buffer time
 hail5 = hail_counts(*,ind_red:ind_red + 4)
 hail_total = total(hail5,2)
 hail_mean = float(hail_total) / 5.
;- Read the hail channel data
 read_hail_chn,hail_chn,vol,bin_width,bins,bine
stop
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
;print,'Hail-mean = ',hail_mean
;print,'bin_width = ',bin_width
;print,'hail_conc = ',hail_conc
;stop
 window,xs=400,ys=250,10,title='HAIL Conc'
 plot_io,tem,hail_conc, $
 ;plot,tem,hail_conc, $
     charsize = 0.8, $
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






case switcht of


0:begin

   values = [ 'Yes' , 'No' ]
   if keyword_set(GROUP) then basea = widget_base(group_leader = base_leader, /modal) $
                         else basea = widget_base()
   bgroup = cw_bgroup(basea, values, label_top = 'Create Output Text File For Hail?', /column)
   widget_control,basea, /realize, tlb_set_xoffset = 300, tlb_set_yoffset = 300
   ev = widget_event(basea)
   widget_control,/destroy,basea
   ;print,'ev: ',ev
   ;print,'ev.value: ',ev.value

   case ev.value of

    1:begin			;TEXT file not requested, continue w/o creating text file
      switcht=4
      return
      end

    0:begin			;TEXT file requested

      out_file = 'output_' + flt_num +'.txt'   ; default output name
      ; determine output directory
      fn = idl_file
      dir1 = ''
      openr,1,fn
      readf,1,dir1
      close,1
	  out_file_dir = dir1 + 'output\'

      if keyword_set(GROUP) then basea = widget_base(group_leader = base_leader, /modal, /column) else $
                                 basea = widget_base(/column)
      field1  = cw_field(basea, value = out_file, title = 'Filename?', /column)
      bgroup3 = cw_bgroup(basea, 'OK', /column, /frame)
      widget_control, basea, /realize, tlb_set_xoffset = 300, tlb_set_yoffset = 300
      ev = widget_event(basea)
      while ev.id ne bgroup3 do begin
        ev = widget_event(basea)
      endwhile

      widget_control, field1, get_value = out_file
      out_file = out_file_dir + out_file(0)
      widget_control, /destroy, basea

      tvg = tvrd(true=3)
      siz = size(tvg)
      if(siz(0) eq 3) then begin

     openw,1,out_file
     printf,1,'Output data for Flight ' + flt_num
     printf,1,fn_hail

     printf,1,'Probe type = hail
     printf,1,'Size Range = 4.5 mm - 4.5 cm, with 14 size classes'
     printf,1,'Probe Sampling Rate = 100 m3/km'

     printf,1,'=================================================='

     printf,1,''
     printf,1, 'Image Buffer times (HHMMSS): ',b_info.time_hms
     printf,1,'Calculated True Air Speed (m/s): ',b_info.calc_tas_buff
     printf,1,'Rosemount Temperature (C): ',b_info.rose_buff
     printf,1,'Pressure (mb): ',b_info.press1_buff
     printf,1,'FSSP LW (g/m3): ',b_info.fssp_lw_buff
     printf,1,'Calculated Sample Volume (m3): ',sample_volume
     printf,1,'Calculated Particle Concentration (#/m3): ',sample_concentration
     printf,1,''
     printf,1,'Number of particles in each image buffer: ',b_info.num_blobs
     printf,1,''
num_particles = total(b_info.num_blobs)
     printf,1,' xsize (um)         ysize(um)
     printf,1,'--------------------------------------------------------'
     for i = 0, num_particles -1 do begin
       printf,1,xsizes(i), ysizes(i)
     endfor
     close,1

      endif
      GOTO, JUMP1
      end

   endcase

   end

endcase
JUMP1: switcht = 4
return
end


