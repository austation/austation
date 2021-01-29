/atom/rad_act(strength)
	if(istype(get_turf(src), /turf/open/pool))
		var/turf/open/pool/PL = get_turf(src)
		if(PL.filled == TRUE)
			strength *= 0.15
	..()

/atom/proc/overlay_sprite(atom/A, random_pos = TRUE, checks)
	if(!isnull(checks) && !checks)
		return
	var/AX
	var/AY
	if(random_pos)
		AX = rand(-3, 3)
		AY = rand(-3, 3)
	var/image/overlay = image(A.icon, A.icon_state)
	overlay.icon_state = A.icon_state
	overlay.pixel_x = AX
	overlay.pixel_y = AY
	overlay.layer = layer + 1
	add_overlay(overlay)
