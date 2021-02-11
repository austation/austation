/atom/rad_act(strength)
	if(istype(get_turf(src), /turf/open/pool))
		var/turf/open/pool/PL = get_turf(src)
		if(PL.filled == TRUE)
			strength *= 0.15
	..()

/atom/proc/overlay_atom(atom/A, random_pos = TRUE, rotation = FALSE, checks)
	if(!isnull(checks) && !checks)
		return
	var/AX = 0
	var/AY = 0
	var/icon/Oicon = A.icon
	if(random_pos)
		AX = rand(-3, 3)
		AY = rand(-3, 3)
	var/image/O = image(Oicon, A.icon_state, layer = layer + 1)
	O.icon_state = A.icon_state
	if(rotation)
		O.transform = turn(O.transform, rand(1, 360))
	O.pixel_x = AX
	O.pixel_y = AY
//	O.layer = layer + 1
	add_overlay(O)
