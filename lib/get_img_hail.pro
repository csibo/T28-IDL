
;- get_img_hail.pro
;- Decode a set of ND HVPS buffers to an image

function get_img_hail,data,buff_time,specs, $
                      p_info_arr

@part_struct

;period     = 0.000008D		;currently an approximation

max_num_particles = 1000
max_num_occluded = 100000l

num_buffs = (n_elements(data) / 2048) - 1
max_num_particles = max_num_particles * num_buffs
tot_np = specs.np * num_buffs
tot_num_slices = specs.buf_size * num_buffs
tot_num_slices = 512

;print,'num_buffs,tot_num_slices: ',num_buffs,tot_num_slices

p_info_arr = replicate(p_info,max_num_particles)

time_between_particles = fltarr(max_num_particles)

;- Initialize
ix = 10l			;1st column number in decoded image (a little padding)
i = 0				;slice number
k = 0				;particle number (not to be confused with frame number)
blob_num = 1
num_frames  = 0		;frame number
frame_start = ix

img      = intarr(tot_np,specs.nl)
blob_img = intarr(tot_np,specs.nl)

inter_part_cycles = 0l
iy = 0

while i le (tot_num_slices - 1) do begin

	particle_area = 0l

	while i le (tot_num_slices-1) do begin

		if(ishft(data(i),-14) and '01'X gt 0) then begin
			;print,'i,ix: ',i,ix
			ix = ix + 1l
			iy = 0l
		endif
		num_clear = data(i) and '003F'X
		num_occluded = ishft(data(i),-7) and '007F'X
		if num_occluded gt 1 then num_occluded = num_occluded - 1
		;print,'ix,num_clear,num_occluded: ',ix,num_clear,num_occluded

		iy = iy + num_clear
		;print,'ix,num_clear,num_occluded,iy: ',ix,num_clear,num_occluded,iy

		;iy2 = iy < specs.mask2
		;iy1 = ((iy - num_occluded + 1) > specs.mask1) < specs.mask2
		;if (iy2 ge iy1 and ix lt tot_np) then img(ix,iy1:iy2) = 1
		if ((iy-num_occluded+1) ge specs.mask1 and iy le specs.mask2 and ix lt tot_np and num_occluded ne 0) then begin
			img(ix,iy-num_occluded+1:iy) = 1
			particle_area = particle_area + num_occluded
		endif

		i = i + 1

	endwhile				;end of a particle

	frame_end = ix > frame_start
	fw = long(frame_end) - long(frame_start) + 1l
	print,'i,frame_start,frame_end: ',i,frame_start,frame_end
	img_in = img(frame_start:frame_end,*)

	indt = where(img_in eq 1,cntt)
	if cntt eq 0 then img_in(0,64) = 1

	img_out = get_blobs2(img_in,blob_num,1,num_blobs)

	;mb = max(img_out)
	;print,'mb: ',mb
	;for l=1,mb do begin
		;indt = where(img_out eq l,cntt)
		;print,'l,cntt: ',l,cntt
	;endfor

	blob_img(frame_start:frame_end,*) = img_out(*,*)

	for kk=0,num_blobs-1 do begin
		;print,'k: ',k
		p_info_arr(k).frame_num       = num_frames
		p_info_arr(k).start_frame     = frame_start
		p_info_arr(k).end_frame       = frame_end
		p_info_arr(k).num_in_frame    = num_blobs
		p_info_arr(k).seq_num         = kk + 1
		p_info_arr(k).blob_num        = k
		k = k + 1
	endfor

	num_frames = num_frames + 1
	ix = ix + 1

	frame_start = ix

endwhile			;i < 2047, end of buffer

if num_frames eq 0 then num_frames = 1

num_blobs  = k>1
print,'num_frames,num_blobs: ',num_frames,num_blobs

p_info_arr = p_info_arr(0:num_blobs-1)

;mb = max(blob_img)
;print,'mb: ',mb
;for l=1,mb do begin
	;indt = where(blob_img eq l,cntt)
	;print,'l,cntt: ',l,cntt
;endfor

return, blob_img

end
