;-
;- get_tag.pro
;-
pro get_tag,tags,data,num,tag_post,tag_labs,tag_num,tag_data,tag_lab
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

;-
;- Get the label for this tag
;-
ind = where(tag_post eq tag_num,cnt)
tag_lab = tag_labs(ind(0))
;stop
;-
;- Find out if this tag_num is in the file
;-
ind = where(tags eq tag_num,cnt)

;if cnt eq 0 then begin
; ans = wmenu(['Tag number ' + strtrim(string(tag_num),2) + ' not in the file:','Continue','Stop'],title=0,init=1)
; if ans eq 2 then stop else sw = 2
;endif

if cnt gt 1 then begin
 print,'This tag number has multiple entries...'
 stop
endif

tag_data = fltarr(num)
if sw eq 1 then tag_data(*) = data(ind(0)+1,*)

print,'tag_num,tag_lab: ',tag_num,tag_lab


end

