;-
;- get_tag.pro
;-
pro get_tag3,tags,data,num,tag_post,tag_labs,tag_num,tag_data,tag_lab
;-
;- Input:
;- tags = array of tag numbers for the current flight
;- data = all the data from the current flight
;- num  = number of time points in the current flight
;- tag_post = all the tag numbers from posttel.tag
;- tag_labs = all the available tag labels from posttel.tag
;- tag_num  = the required tag number
;- Output:
;- tag_data = the array of requested data
;- tag_lab  = the label for the requested data

sw = 1   ;if sw is changed to 2 then requested data NA
cnt = 0  ; initialize

print,'tag_num = ', tag_num
;-
;- Get the label for this tag
;-
count_ind = 0

if tag_num lt 910 then begin
	;ind = where(tag_post eq tag_num,cnt)
	nr = size(tag_post)
	for i=0,nr(1)-1 do begin
	  if (tag_post(i) eq tag_num) then begin
	    count_ind = count_ind + 1
	    ind = i
	  endif
	endfor
	print,'count_ind = ',count_ind

    if count_ind eq 0 then begin
     tag_lab = 0
    endif else begin
	 tag_lab = tag_labs(ind)
	 print,'tag_lab = ',tag_lab
	endelse
;stop
endif

;stop
;-
;- Find out if this tag_num is in the file
;-
if tag_num lt 910 then begin
 ind2 = where(tags eq tag_num,cnt)
 print,'tag_num: ',tag_num
 print,'numarul de entries:',cnt
endif

if count_ind gt 1 then begin
 print,'This tag number has multiple entries...'
; stop
endif
;stop
tag_data = fltarr(num)
if sw eq 1 then begin
 tag_data(*) = data(ind2(0)+1,*)
 ;tag_data(*) = tags(ind + 1,*)
 ;stop
endif

;stop
end

