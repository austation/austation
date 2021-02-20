/// Similar to vis_contents but is purely cosmetic and does not effect the arg atom
/atom/proc/overlay_atom(atom/A, random_pos = TRUE, rotation = FALSE, checks)
	if(!isnull(checks) && !checks) // todo: make this less bad or remove entirely
		return
	var/AX = 0
	var/AY = 0
	var/icon/Oicon = A.icon
	if(random_pos)
		AX = rand(-3, 3)
		AY = rand(-3, 3)
	var/image/O = image(Oicon, A.icon_state, layer = layer + 1)
	O.overlays += A.overlays
//	O.icon_state = A.icon_state
	if(rotation)
		O.transform = turn(O.transform, rand(1, 360))
	O.pixel_x = AX
	O.pixel_y = AY
//	O.layer = layer + 1
	add_overlay(O)
