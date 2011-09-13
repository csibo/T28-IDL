;-
;- get_tag.pro
;-
pro get_tag3_1998,tag_nums, hdata_1998, num, selected_tag, tag_ind, tag_title, tag_unit, tag_data, tag_lab, tag_unt
;-
;- Input:
;- tag_nums = array of tag numbers for the current flight
;- hdata_1995 = all the data from the current flight
;- num  = number of time points in the current flight
;- selected_tag = tag selected for the display
;- tag_ind = index in the array of tags for the selected tag
;- tag_title = all the available tag labels from tag_names1.txt
;- tag_unit  = all the available tag units from tag_units1.txt
;- Output:
;- tag_data = the array of requested data
;- tag_lab  = the label for the requested data
;- tag_unt  = the units for the requested data


;stop
tag_num=tag_nums(tag_ind+3)
print,'tag_ind, tag_num = ', tag_ind, tag_num
;-
;- Get the label for this tag
;-
count_ind = 0
;stop


tag_lab = tag_title(tag_ind+3)
print,'tag_label = ',tag_lab
tag_unt= tag_unit(tag_ind+3)
print,'tag_unit = ',tag_unt

tag_data = fltarr(num)

list_var = tag_names(hdata_1998)

var_name = list_var(tag_ind+3)
print,'var_name=',string(var_name)
a=fltarr(num)
tag_data=fltarr(num)

a=hdata_1998.(tag_ind+3)
tag_data(*)=a(*)

;stop
end

