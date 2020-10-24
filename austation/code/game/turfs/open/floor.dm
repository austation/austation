/turf/open/floor
	var/painted = 0
	var/current_overlay = null

/turf/open/floor/update_icon()
	if(painted)
		update_visuals()
		overlays -= current_overlay
		if(current_overlay)
			overlays.Add(current_overlay)
		return
	else
		..()

/turf/open/floor/break_tile()
	if(painted)
		if(broken)
			return
		current_overlay = pick(broken_states)
		broken = 1
		update_icon()
	else
		..()

/turf/open/floor/burn_tile()
	if(painted)
		if(burnt)
			return
		current_overlay = pick(burnt_states)
		burnt = 1
		update_icon()
	else
		..()
