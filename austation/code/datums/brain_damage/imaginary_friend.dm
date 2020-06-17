// Haha
/mob/camera/imaginary_friend/proc/custom_icon(datum/preferences/prefs, datum/job/J)
	name = prefs.real_name
	real_name = prefs.real_name
	human_image = get_flat_human_icon(null, J, prefs)
