// Builds a cosmetic overlay chain from a specified parent object. Similar to beam code but designed to be permanent.
/datum/barrel_builder
	var/atom/parent // The object we're going to build the barrel from
	var/angle = 0
	var/length
	var/increment = 32
	var/po_x
	var/po_y // pixel offsets applied after the barrel is built
	var/num_barrels = 0
	var/max_barrels = 1 // for multi barrel building
	var/list/parts = list()

/datum/barrel_builder/New(_parent, _angle, _length, _pox, _poy)
	parent = _parent
	angle = _angle
	length = _length
	po_x = _pox
	po_y= _poy

/datum/barrel_builder/proc/build()
	num_barrels++
	if(!parent || !length)
		return FALSE
	if(num_barrels > max_barrels)
		parent.cut_overlays()
		num_barrels--
		parts.len = 0

	for(var/L in 0 to length)
		var/place_distance = (L+1) * increment
		// TODO: check for Z level borders
		var/mutable_appearance/bpart = mutable_appearance(parent.icon, parent.icon_state, MOB_LAYER + 1)
		bpart.appearance_flags = KEEP_TOGETHER
		var/matrix/M = matrix()
		switch(parent.dir)
			if(NORTH)
				bpart.pixel_y -= place_distance
			if(SOUTH)
				bpart.pixel_y += place_distance
				M.Turn(180)
			if(EAST)
				bpart.pixel_x += place_distance
				M.Turn(90)
			if(WEST)
				bpart.pixel_x -= place_distance
				M.Turn(270)
		bpart.transform = M
		parent.add_overlay(bpart, TRUE)
	parent.transform.Translate(po_x, po_y)
	if(angle)
		rotate(angle, 0, TRUE)

// null or 0 anim_time will just apply the transform
/datum/barrel_builder/proc/rotate(_angle, anim_time, initial = FALSE)
	if(!initial && _angle == angle)
		return
	if(parent)
		var/diff = closer_angle_difference(angle, _angle)
		var/matrix/M = turn(parent.transform, diff)
		if(anim_time)
			animate(parent, transform = M, time = anim_time)
		else
			parent.transform = M
		angle = _angle
		return TRUE

/datum/barrel_builder/proc/get_end_piece()
	return parts[parts.len]

/datum/barrel_builder/proc/reset()
	parent.cut_overlays()
	num_barrels--
	parts.len = 0

/datum/barrel_builder/Destroy()
	reset()
	return ..()
