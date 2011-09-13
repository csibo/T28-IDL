;- get_specs_hvps.pro

;- Returns a set of constants within a structure based on the probe_type

;- Input
;-	probe_type - A unique identifier for each 2D data type. It seems that from one year to the
;-               next, although the probe may be the same one or more of the following quantities
;-               changes. Therefore, a set is specified for each probe type and each field season.

;- Outputs
;-	probe_name - A string used in creating filenames
;-	xscale - 1.0 indicates that no horizontal scaling is needed for square images
;-           2.0 indicates that horizontal scaling is required to obtain square images
;-	buf_size - Number of values in an image buffer
;-	x_resolution - The nominal horizontal resolution of the probe after scaling in um
;-	y_resolution - The nominal vertical resolution of the probe in um
;-	clock factor - Only used in the SEA format. Constant prescribed by SEA for calculating TAS Clock
;-                 from the multiply and divide factors.
;-	np - Width of an array in pixels needed to display a raw, unscaled image buffer. This value is
;-       sufficiently large to accommodate all buffer images.
;-	nl - Height of an array in pixels needed to display a raw image buffer.
;-	nps - Width of an array in pixels needed to display a raw, scaled image buffer. This value is
;-        sufficiently large to accommodate all buffer images and determines the size of the scaled
;-        buffer images. This is the one quantity that is needed to convert the indices in the .ind
;-        file to an image.
;-	fresnel_dcl - Size of a particle below which a diffraction correction must be made for sample
;-                area
;-	arm_width - Distance between the probe arms in cm
;-	mask1 - Pixel number below which the detector array in not sensitive or is occluded
;-	mask2 - Pixel number above which the detector array is not sensitive or is occluded
;-	pan_x - The width of the display area for a buffer when creating panels of buffer images.
;-          Can be less than the actual width of the image and, if so, will be truncated.
;-	pan_y - The height of the display area for a buffer when creating panels of buffer
;-          buffer images. A value larger than the number of diodes in the probe will provide
;-          a white space above the buffer image for the buffer time.
;-	num_diodes - Number of diodes/detectors in the probe.
;-	time_thresh - A time threshold (sec) used to distinguish between buffers that are filling
;-                at less or more than the system data rate.
;-	der_thresh - A delta time threshold used in filtering TAC (sum of interparticle times
;				for a buffer) values. If the difference in TAC
;-               between 2 successive buffers is less than this threshold the TAC value is
;-               considered valid otherwise it is replaced by the nearest TAC value.
;-	system_type - ???
;-	data_path - Directory path to the .src files (the input file).
;-	buf_path - Directory path to the .buf,.par,.ind,...files (output files).
;-	img_sea_tag - SEA tag number for the image data
;-	mdf_sea_tag - SEA tag number for the multiply/divide factors
;-	et_sea_tag - SEA tag number for the elapsed time (if available)
;-	elapsed_factor - Conversion factor for elapsed time counts to seconds (i.e., s/count)

function get_specs_hvps,probe_type

dir1 = ''
dir2 = ''
data_file = FILE_WHICH('t28data.txt')
openr, 1, data_file
readf,1, dir1
close,1

idl_file = FILE_WHICH('t28idl.txt')
openr, 1, idl_file
readf,1, dir2
close,1
dir2 = dir2 + 'output' + path_sep()

spec_hvps = {	probe_type : [ 1 , 2 , 3 , 4 , 5, 6 ]								, $
			probe_name : [ 'HVPS' , 'HVPS' , 'HVPS' , 'HVPS' , 'HVPS', 'HVPS']		, $
	   		xscale : [ 2.0 , 2.0 , 2.0 , 2.0 , 2.0, 2.0  ] 						, $
	   		buf_size : [ 2048 , 2048 , 2048 , 2048 , 2048, 2048 ]					, $
	   		x_resolution : [ 400. , 400. , 400. , 400. , 400., 400.] 				, $
	   		y_resolution : [ 200. , 200. , 200. , 200. , 200., 200. ]				, $
	   		clock_factor : [ 25000. , 25000. , 25000. , 25000. , 25000. , 25000.]	, $
	   		np : [ 2000 ,2000 , 2000 , 2000 , 2000, 2000 ]						, $
	   		nl : [ 256 , 256 , 256 , 256 , 256 , 256]								, $
	   		nps : [ 6000 , 6000 , 5000 , 5000 , 5000, 5000]						, $
	   		fresnel_dcl : [ 293.0 , 293.0 , 293.0 , 293.0 , 293.0 , 293.0 ]			, $		;um 2DC
	   		arm_width : [ 20.3 , 20.3 , 20.3 , 20.3 , 20.3, 20.3 ]	 				, $		;cm 2DC
	   		mask1 : [ 28, 26 , 26 , 26 , 26, 26]								, $
	   		mask2 : [ 224 , 234 , 234 , 234 , 234, 234 ]							, $
	   		pan_x : [ 1000 , 1400 , 500 , 500 , 500, 500 ]					, $
	   		pan_y : [ 256 , 256 , 256 , 256 , 256, 256 ]	  						, $
	   		num_diodes : [ 256 , 256 , 256 , 256 , 256, 256]						, $
	   		time_thresh : [ 0.11 , 0.11 , 0.11 , 0.11 , 0.11, 0.11 ]				, $
	   		der_thresh : [ 0.7 , 0.7 , 0.7 , 0.7 , 0.7, 0.7 ]					, $
	   		system_type : [ 1 , 1 , 1 , 1 , 1, 1 ]								, $
	   		data_path : [ dir1, $
	   					  dir1, $
	   					  dir1, $
	   					  dir1, $
	   					  dir1, $
	   					  dir1],$
	  		buf_path : [dir2, $
	  					dir2, $
	  					dir2, $
	  					dir2, $
	  					dir2 , $
	  					dir2], $
	  		img_sea_tag : [ 66 , 6000 , 6000 , 6000 , 6000, 6000 ], $	; 66 = 0x4242 for images for 1995 data				, $
	  		mdf_sea_tag : [ 65 , 6001 , 6001 , 6001 , 6001, 6001 ], $	; 65 = 0x4141 for TAScnts for the 1995 data				, $
	  		et_sea_tag : [ 69 , 6002 , 6002 , 6002 , 6002, 6002 ], $	; 69 = no meaning for the 1995 data				, $
	  		elapsed_factor : [ 0.000025 , 0.000025 , 0.000025 , 0.000025 , 0.000025 , $
	  		                   0.000025 ] }

specs_hvps = {	probe_type : spec_hvps.probe_type(probe_type)		, $
			probe_name : spec_hvps.probe_name(probe_type)		, $
	   		xscale : spec_hvps.xscale(probe_type) 				, $
	   		buf_size : spec_hvps.buf_size(probe_type)			, $
	   		x_resolution : spec_hvps.x_resolution(probe_type)	, $
	   		y_resolution : spec_hvps.y_resolution(probe_type)	, $
	   		clock_factor : spec_hvps.clock_factor(probe_type) 	, $
	   		np : spec_hvps.np(probe_type)						, $
	   		nl : spec_hvps.nl(probe_type)						, $
	   		nps : spec_hvps.nps(probe_type)						, $
	   		fresnel_dcl : spec_hvps.fresnel_dcl(probe_type)		, $		;um 2DC
	   		arm_width : spec_hvps.arm_width(probe_type)	 		, $		;cm 2DC
	   		mask1 : spec_hvps.mask1(probe_type)					, $
	   		mask2 : spec_hvps.mask2(probe_type)					, $
	   		pan_x : spec_hvps.pan_x(probe_type)					, $
	   		pan_y : spec_hvps.pan_y(probe_type)	  				, $
	   		num_diodes : spec_hvps.num_diodes(probe_type)		, $
	   		time_thresh : spec_hvps.time_thresh(probe_type)		, $
	   		der_thresh : spec_hvps.der_thresh(probe_type)		, $
	   		system_type : spec_hvps.system_type(probe_type)		, $
	   		data_path : spec_hvps.data_path(probe_type)			, $
	   		buf_path : spec_hvps.buf_path(probe_type)			, $
	   		img_sea_tag : spec_hvps.img_sea_tag(probe_type)		, $
	   		mdf_sea_tag : spec_hvps.mdf_sea_tag(probe_type)		, $
	   		et_sea_tag : spec_hvps.et_sea_tag(probe_type)		, $
	   		elapsed_factor : spec_hvps.elapsed_factor(probe_type)}

return, specs_hvps

end
