
;- laser_wid_select.pro
;- Send plot to ps file and print, or save as jpg, bmp, etc.

;- switch =0 initial value, query operator
;-        =2 this procedure sets switch to 2 so calling loop will cycle through plotting
;-           routines again while device is set to postscript
;-        =4 this procedure sets switch to 4 as signal for calling loop to exit; that is,
;-           postscript file has been created

;- print_sw - Unix only - If 1, after creating ps file, spawn print cmd
;-            while in current idl program. If 2, do not.

;- base_leader - widget id of calling procedure

pro laser_wid_select, switcht, GROUP = base_leader


case switcht of

;- Query operator

 0:begin

   values = [ 'Yes - PS File' , 'YES - Image File', 'No' ]
   if keyword_set(GROUP) then basea = widget_base(group_leader = base_leader, /modal) $
                         else basea = widget_base()
   bgroup = cw_bgroup(basea, values, label_top = 'Create Output File?', /column)
   widget_control,basea, /realize, tlb_set_xoffset = 300, tlb_set_yoffset = 300
   ev = widget_event(basea)
   widget_control,/destroy,basea

   case ev.value of

    2:begin			;output file not requested, continue w/o creating ps file
      switcht=4
      return
      end

    1:begin			;IMG file requested, continue w/o creating ps file
      select_output, switcht
      switcht=4
      end

    0:begin			;PS file requested, query for printing parameters
      color_sw = 1	;default, no color
      height_sw = 1	;default, portrait, 1/2 page
      psfile = 'idl.ps'

      fn = FILE_WHICH('t28idl.txt')
      dir1 = ''
      openr,1,fn
      readf,1,dir1
      close,1
	  psfile_dir = dir1 + 'PSfiles' + path_sep()

      if keyword_set(GROUP) then basea = widget_base(group_leader = base_leader, /modal, /column) else $
                                 basea = widget_base(/column)
      values1 = [ 'Yes' , 'No' ]
      bgroup1 = cw_bgroup(basea,values1,label_top = 'Color?', /column, /frame, /exclusive, set_value = color_sw)
      values2 = [ 'Landscape' , 'Portrait - 1/2' , 'Portrait - 2/3' , 'Portrait - Full' ]
      bgroup2 = cw_bgroup(basea, values2, label_top = 'Orientation?', /column, /frame, /exclusive,set_value = height_sw)
      field1  = cw_field(basea, value = psfile, title = 'Postscript filename?', /column)
      bgroup3 = cw_bgroup(basea, 'OK', /column, /frame)
      widget_control, basea, /realize, tlb_set_xoffset = 300, tlb_set_yoffset = 300
      ev = widget_event(basea)
      while ev.id ne bgroup3 do begin
        ev = widget_event(basea)
        if ev.id eq bgroup1 then color_sw = ev.value
        if ev.id eq bgroup2 then height_sw = ev.value
      endwhile
      widget_control, field1, get_value = psfile
      psfile = psfile_dir + psfile(0)
      widget_control, /destroy, basea

      set_plot, 'ps'
      device, filename = psfile

      if color_sw eq 0 then device, /color

      case height_sw of

       0:begin
         device, /landscape
         end

       1:begin
         device, /portrait	;-1/2
         end

       2:begin
         device, /portrait	;-2/3
         device, xsize   = 18.95	;17.0
         device, ysize   = 17.0		;17.0
         device, yoffset =  2.0		;4.0
         end

       3:begin
         device, /portrait	;-full
         ;device, xsize = 18.95		;17.0
         device, xsize = 18.0
         ;device, ysize = 23.93
         device, ysize = 23.0		;22.0
         device, yoffset = 1.5
         end

      endcase

      switcht = 2
      print,'Creating ' + psfile + '...'
      end
   endcase
   end

;- Close display device

 2:begin

   xyouts, 10, 10, systime(0), /device, charsize=0.5	;date/time annotation
   device, /close

;- Set device back to display

   set_plot,'x'    ;unix only
   ;set_plot,'win'   ;PC only
   switcht = 4

;- Unix only

   ;values = [ 'Do not print!' , 'hplj0' , 'hp5si' , 'hpcm0' ]
   ;printer_type = 0
   ;basea = widget_base(/row)
   ;bgroup1 = cw_bgroup(basea, values, label_top = 'Printer?', /column, /exclusive, set_value = printer_type)
   ;bgroup2 = cw_bgroup(basea,'OK',/column,/frame)
   ;widget_control,basea,/realize,tlb_set_xoffset = 300,tlb_set_yoffset = 300
   ;widget_control,basea
   ;ev = widget_event(basea)
   ;while ev.id ne bgroup2 do begin
     ;ev = widget_event(basea)
     ;if ev.id eq bgroup1 then printer_type = ev.value
   ;endwhile
   ;widget_control,/destroy,basea
   ;print,'printer_type: ',printer_type

   ;if printer_type ne 0 then begin
     ;print,'Printing ',file_ps
     ;case printer_type of
       ;1:cmd = 'lp -dhplj0 < ' + file_ps
       ;2:cmd = 'lp -dhp5si < ' + file_ps
       ;3:cmd = 'lp -dhpcm0 < ' + file_ps
     ;endcase
     ;spawn,cmd
   ;endif

   end
endcase

end

