;- get_specs_2dc.pro

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

function get_specs_2dc,probe_type

spec_2dc = {	probe_type : [ 1 , 2 , 3 , 4 , 5, 6 ]								, $
			probe_name : [ '_2DC' , '_2DC' , '_2DC' , '_2DC' , '_2DC', '_2DC']	, $
	   		xscale : [ 1.0 , 1.0 , 1.0 , 1.0 , 1.0, 1.0  ] 						, $
	   		buf_size : [ 1024 , 1024 , 1024 , 1024 , 1024, 1024 ]					, $
	   		x_resolution : [ 25. , 25. , 25. , 25. , 25., 25.] 				, $
	   		y_resolution : [ 25. , 25. , 25. , 25. , 25., 25. ]				, $
	   		clock_factor : [ 50000. , 50000. , 50000. , 50000. , 50000. , 50000.]	, $
	   		np : [ 1024 , 1024 , 1024 , 1024 , 1024, 1024 ]						, $
	   		nl : [ 32 , 32 , 32 , 32 , 32 , 32]								, $
	   		nps : [ 1024 , 1024 , 1024 , 1024 , 1024, 1024]						, $
	   		fresnel_dcl : [ 160.0 , 160.0 , 160.0 , 160.0 , 160.0 , 160.0 ]			, $		;um 2DC
	   		arm_width : [ 6.1 , 6.1 , 6.1 , 6.1 , 6.1, 6.1 ]	 				, $		;cm 2DC
	   		mask1 : [ 0	, 0 , 0 , 0 , 0, 0]								, $
	   		mask2 : [ 31 , 31 , 31 , 31 , 31, 31 ]							, $
	   		pan_x : [ 1024 , 1024 , 1024 , 1024 , 1024, 1024 ]					, $
	   		pan_y : [ 55 , 55 , 55 , 55 , 55, 55 ]	  						, $
	   		num_diodes : [ 32 , 32 , 32 , 32 , 32, 32]						, $
	   		time_thresh : [ 1.1 , 1.1 , 1.1 , 1.1 , 1.1, 1.1 ]				, $
	   		der_thresh : [ 2.0 , 2.0 , 2.0 , 2.0 , 2.0, 2.0 ]					, $
	   		system_type : [ 1 , 1 , 1 , 1 , 1, 1 ]								, $
	   		data_path : [ '/net/work/T28/idl/data/', $
	   					  'K:\IAS-Staff\Donna\T28\data\', $
	   					  'K:\IAS-Staff\Donna\T28\data\', $
	   					  'K:\IAS-Staff\Donna\T28\data\', $
	   					  'K:\IAS-Staff\Donna\T28\data\' , $
	   					  'K:\IAS-Staff\Donna\t28\data\'] ,$
	  		buf_path : [ 'K:\IAS-Staff\Donna\T28\t28display4.0\output\', $
	  					 'K:\IAS-Staff\Donna\T28\t28display4.0\output\', $
	  					 'K:\IAS-Staff\Donna\T28\t28display4.0\output\', $
	  					 'K:\IAS-Staff\Donna\T28\t28display4.0\output\', $
	  					 'K:\IAS-Staff\Donna\T28\t28display4.0\output\' , $
	  					 'K:\IAS-Staff\Donna\t28\t28display4.0\output\'] ,$
	  		img_sea_tag : [ 300 , 300 , 300 , 300 , 300, 300 ], $	; 66 = 0x4242 for images for 1995 data				, $
	  		mdf_sea_tag : [ 301 , 301 , 301 , 301 , 301, 301 ], $	; 65 = 0x4141 for TAScnts for the 1995 data				, $
	  		et_sea_tag :  [ 302 , 302 , 302 , 302 , 302, 302 ], $	; 69 = no meaning for the 1995 data				, $
	  		elapsed_factor : [ 0.000025 , 0.000025 , 0.000025 , 0.000025 , 0.000025 , $
	  		                   0.000025 ] }

specs_2dc = {	probe_type : spec_2dc.probe_type(probe_type)		, $
			probe_name : spec_2dc.probe_name(probe_type)		, $
	   		xscale : spec_2dc.xscale(probe_type) 				, $
	   		buf_size : spec_2dc.buf_size(probe_type)			, $
	   		x_resolution : spec_2dc.x_resolution(probe_type)	, $
	   		y_resolution : spec_2dc.y_resolution(probe_type)	, $
	   		clock_factor : spec_2dc.clock_factor(probe_type) 	, $
	   		np : spec_2dc.np(probe_type)						, $
	   		nl : spec_2dc.nl(probe_type)						, $
	   		nps : spec_2dc.nps(probe_type)						, $
	   		fresnel_dcl : spec_2dc.fresnel_dcl(probe_type)		, $		;um 2DC
	   		arm_width : spec_2dc.arm_width(probe_type)	 		, $		;cm 2DC
	   		mask1 : spec_2dc.mask1(probe_type)					, $
	   		mask2 : spec_2dc.mask2(probe_type)					, $
	   		pan_x : spec_2dc.pan_x(probe_type)					, $
	   		pan_y : spec_2dc.pan_y(probe_type)	  				, $
	   		num_diodes : spec_2dc.num_diodes(probe_type)		, $
	   		time_thresh : spec_2dc.time_thresh(probe_type)		, $
	   		der_thresh : spec_2dc.der_thresh(probe_type)		, $
	   		system_type : spec_2dc.system_type(probe_type)		, $
	   		data_path : spec_2dc.data_path(probe_type)			, $
	   		buf_path : spec_2dc.buf_path(probe_type)			, $
	   		img_sea_tag : spec_2dc.img_sea_tag(probe_type)		, $
	   		mdf_sea_tag : spec_2dc.mdf_sea_tag(probe_type)		, $
	   		et_sea_tag : spec_2dc.et_sea_tag(probe_type)		, $
	   		elapsed_factor : spec_2dc.elapsed_factor(probe_type)}

return, specs_2dc

end
