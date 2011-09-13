;- get_specs.pro

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

function get_specs,probe_type

spec = {	probe_type : [ 1 , 2 , 3 , 4 , 5, 6 , 7, 8, 9, 10]								, $
			probe_name : [ '_2DC' , 'HVPS' , 'HVPS' , 'HVPS' , 'Hail', 'HVPS', '_2DC', 'HVPS', '_2DC', 'HVPS']		, $
	   		xscale : [ 1.0 , 2.0 , 2.0 , 2.0 , 1.0, 2.0, 1.0 , 2.0, 1.0 , 2.0  ] 						, $
	   		buf_size : [ 1024 , 2048 , 2048 , 2048 , 2048, 2048, 1024 , 2048, 1024 , 2048 ]					, $
	   		x_resolution : [ 25. , 800. , 400. , 400. , 1800., 400., 25., 400., 25., 400.] 				, $
	   		y_resolution : [ 25. , 200. , 200. , 200. , 1800., 200., 25., 200., 25., 200. ]				, $
	   		clock_factor : [ 50000. , 25000. , 25000. , 25000. , 50000. , 25000., 50000, 25000, 50000, 25000]	, $
	   		np : [ 1024 , 1000 , 1500 , 2000 , 1000, 2000, 1024, 2000, 1024, 2000 ]						, $
	   		nl : [ 32 , 256 , 256 , 256 , 64 , 256, 32, 256, 32, 256]								, $
	   		nps : [ 1024 , 5000 , 5000 , 6000 , 1000, 6000, 1024, 6000, 1024, 6000]						, $
	   		fresnel_dcl : [ 160.0 , 293.0 , 293.0 , 293.0 , 99.0 , 293.0,160.0 , 293.0,160.0 , 293.0 ]			, $		;um 2DC
	   		arm_width : [ 6.1 , 20.3 , 20.3 , 20.3 , 99.0, 20.3,6.1 , 20.3,6.1 , 20.3 ]	 				, $		;cm 2DC
	   		mask1 : [ 0	, 26 , 26 , 26 , 0, 28,0, 26,0, 26]								, $
	   		mask2 : [ 31 , 234 , 234 , 234 , 63, 224,31 , 234,31 , 234 ]							, $
	   		pan_x : [ 1024 , 500 , 2500 , 1400 , 600, 1000,1024 , 500,1024 , 500 ]					, $
	   		pan_y : [ 55 , 256 , 256 , 256 , 64, 256,55 , 256,55 , 256 ]	  						, $
	   		num_diodes : [ 32 , 256 , 256 , 256 , 64, 256 ,32 , 256,32 , 256]						, $
	   		time_thresh : [ 1.1 , 0.11 , 0.26 , 0.11 , 0.0, 0.11,1.1 , 0.11,1.1 , 0.11 ]				, $
	   		der_thresh : [ 2.0 , 0.7 , 0.7 , 0.7 , 0.0, 0.7, 2.0 , 0.7, 2.0 , 0.7 ]					, $
	   		system_type : [ 1 , 1 , 2 , 1 , 1, 1, 1, 1, 1, 1 ]								, $
	   		data_path : [ 'c:\T28\data\', $
	   					  'c:\T28\data\', $
	   					  'c:\T28\ND\', $
	   					  'c:\T28\data\', $
	   					  'c:\T28\data\' , $
	   					  'c:\t28\data\' ,$
	   					  'c:\T28\data\' , $
	   					  'c:\t28\data\' ,$
	   					  'c:\T28\data\' , $
	   					  'c:\t28\data\'], $
	  		buf_path : [ 'c:\T28\t28display3.0\output\', $
	  					 'c:\T28\t28display3.0\output\', $
	  					 'c:\T28\ND\', $
	  					 'c:\T28\t28display3.0\output\', $
	  					 'c:\T28\t28display3.0\output\' , $
	  					 'c:\t28\t28display3.0\output\', $
	  					 'c:\T28\t28display3.0\output\', $
	  					 'c:\T28\t28display3.0\output\', $
	  					 'c:\T28\t28display3.0\output\', $
	  					 'c:\T28\t28display3.0\output\' ]						, $
	  		img_sea_tag : [ 300 , 6000 , 999 , 6000 , 320, 66, 300, 66, 300, 66 ], $	; 66 = 0x4242 for images for 1995 data				, $
	  		mdf_sea_tag : [ 301 , 6001 , 999 , 6001 , 999, 65, 301, 66, 301, 66 ], $	; 65 = 0x4141 for TAScnts for the 1995 data				, $
	  		et_sea_tag : [ 302 , 6002 , 999 , 6002 , 999, 69,  302, 69, 302, 69 ], $	; 69 = no meaning for the 1995 data				, $
	  		elapsed_factor : [ 0.000025 , 0.000025 , 0.000025 , 0.000025 , 0.000025 , $
	  		                   0.000025, 0.000025 , 0.000025 , 0.000025 , 0.000025 ] }

specs = {	probe_type : spec.probe_type(probe_type)		, $
			probe_name : spec.probe_name(probe_type)		, $
	   		xscale : spec.xscale(probe_type) 				, $
	   		buf_size : spec.buf_size(probe_type)			, $
	   		x_resolution : spec.x_resolution(probe_type)	, $
	   		y_resolution : spec.y_resolution(probe_type)	, $
	   		clock_factor : spec.clock_factor(probe_type) 	, $
	   		np : spec.np(probe_type)						, $
	   		nl : spec.nl(probe_type)						, $
	   		nps : spec.nps(probe_type)						, $
	   		fresnel_dcl : spec.fresnel_dcl(probe_type)		, $		;um 2DC
	   		arm_width : spec.arm_width(probe_type)	 		, $		;cm 2DC
	   		mask1 : spec.mask1(probe_type)					, $
	   		mask2 : spec.mask2(probe_type)					, $
	   		pan_x : spec.pan_x(probe_type)					, $
	   		pan_y : spec.pan_y(probe_type)	  				, $
	   		num_diodes : spec.num_diodes(probe_type)		, $
	   		time_thresh : spec.time_thresh(probe_type)		, $
	   		der_thresh : spec.der_thresh(probe_type)		, $
	   		system_type : spec.system_type(probe_type)		, $
	   		data_path : spec.data_path(probe_type)			, $
	   		buf_path : spec.buf_path(probe_type)			, $
	   		img_sea_tag : spec.img_sea_tag(probe_type)		, $
	   		mdf_sea_tag : spec.mdf_sea_tag(probe_type)		, $
	   		et_sea_tag : spec.et_sea_tag(probe_type)		, $
	   		elapsed_factor : spec.elapsed_factor(probe_type)}

return, specs

end
