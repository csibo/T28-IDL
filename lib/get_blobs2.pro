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

;- get_blobs2.pro

;- Uniquely number each group of continguous pixels in the input image (img).

;- Input
;-	img - The input image (binary) to process.
;-	blob_num - On input, the next available blob number to use for labeling pixels.
;-             On output, the next available number to use for labeling pixels after labeling
;-             the pixels in img.
;-	occ_num - The number used in img to indicate an occluded pixel.

;- Ouput
;-	num_blobs - The number of particles (blobs) detected in img.
;----------------------------------------------------------------------------

function get_blobs2,img,blob_num,occ_num,num_blobs

start_num = blob_num

;- Get the indices of the occluded pixels.
img_ind = where(img eq occ_num,num_occluded)
;print,'num_occluded(get_blobs2): ',num_occluded


;- Get the 2D size of img.
dim = size(img)
np = dim(1)
nl = dim(2)

;stop


; Convert the 1D indices of the occluded pixels to 2D coordinates.
xcoord = img_ind mod np
ycoord = fix(img_ind / np)

;stop

;- Initialize all the occluded pixels to the starting blob number
blob_img = img
blob_img(img_ind) = blob_num

;- Check for a one pixel image or one that is too big
if num_occluded gt 1l and num_occluded lt 200000l then begin

	for i=1l,num_occluded-1l do begin

		;- If the pixel to the left of the cuurent one is occluded then mark it. Only
		;- check it if the current pixel is not on the starting edge
		if xcoord(i) ne 0 then begin
			if img(xcoord(i)-1,ycoord(i)) eq occ_num then xl = 1 else xl = 0
		endif else xl = 0

		;- If the pixel below (or above depending on your reference) of the cuurent one
		;- is occluded then mark it. Only check it if the current pixel is not on the bottom/top edge
		if ycoord(i) ne 0 then begin
			if img(xcoord(i),ycoord(i)-1) eq occ_num then xu = 1 else xu = 0
		endif else xu = 0

		;- If the pixel above/below is marked then set the current pixel to its blob number
		if xu eq 1 then begin
			blob_img(xcoord(i),ycoord(i)) = blob_img(xcoord(i),ycoord(i)-1)
			;- If the pixel to the left is marked then set it, plus all the pixels with the same
			;- blob number, to the blob number of the current pixel.
			if xl eq 1 then begin
				if blob_img(xcoord(i)-1,ycoord(i)) ne blob_img(xcoord(i),ycoord(i)) then begin
					indp = where(blob_img eq blob_img(xcoord(i)-1,ycoord(i)),cntp)
					blob_img(indp) = blob_img(xcoord(i),ycoord(i))
				endif
			endif
		;- If the pixel above/below is not marked then set the current pixel to the blob
		;- number of the pixel to the left if it is marked; otherwise, increment the blob
		;- number and set the current pixel to that number
		endif else begin
			if xl eq 1 then begin
				blob_img(xcoord(i),ycoord(i)) = blob_img(xcoord(i)-1,ycoord(i))
			endif else begin
				blob_num = blob_num + 1
				blob_img(xcoord(i),ycoord(i)) = blob_num
			endelse
		endelse

	endfor

endif

;- Get rid of unused blob numbers
j = start_num
for i=start_num,blob_num do begin
	ind = where(blob_img eq i,cnt)
	if cnt ne 0 then begin
		blob_img(ind) = j
		j = j + 1
	endif
endfor

blob_num = j
num_blobs = j - start_num
;print,'start_num,j,num_blobs: ',start_num,j,num_blobs

return, blob_img

end

