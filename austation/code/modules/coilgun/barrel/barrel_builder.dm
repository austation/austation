// Builds a cosmetic overlay chain from a specified parent object. Similar to beam code but designed to be permanent.
/datum/barrel_builder
	var/atom/parent // The object we're going to build the barrel from
	var/angle = 0
	var/length = 0
	var/px_increment = 32
	var/po_x
	var/po_y // pixel offsets applied after the barrel is built

	// from a gameplay perspective. The actual total amount of parts is typically parts.len + 1; as to include the master barrel piece
	var/list/parts = list()

	var/place_distance = 0

/datum/barrel_builder/New(_parent, _angle, _pox, _poy)
	parent = _parent
	angle = _angle
	po_x = _pox
	po_y= _poy

/datum/barrel_builder/proc/build(_length)
	if(!parent || !length)
		return FALSE
	if(length(parts))
		parent.cut_overlays()
		parts.len = 0

	for(var/L in 0 to _length)
		append_barrel()
		/*
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
		*/
	parent.transform.Translate(po_x, po_y)
	if(angle)
		rotate(angle, 0, TRUE)

/datum/barrel_builder/proc/append_barrel()
	// TODO: check for Z level borders
	length++
	place_distance = length * px_increment
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
	parts += bpart
	parent.add_overlay(bpart, TRUE)

/datum/barrel_builder/proc/decrement_barrel()
	length--
	place_distance = length * px_increment
	qdel(get_endpiece)

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
