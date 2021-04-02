/// Similar to vis_contents but is purely cosmetic, used to copy paste object icons onto another object
/atom/proc/overlay_atom(atom/A, random_pos = TRUE, rotation, checks)
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
	if(isnull(rotation))
		O.transform = turn(O.transform, rand(1, 360))
	else
		O.transform = turn(O.transform, rotation)
	O.pixel_x = AX
	O.pixel_y = AY
//	O.layer = layer + 1
	add_overlay(O)

/*
	* Called when a coilgun projectile collides with a non-living atom.
	* Parent overrides should return TRUE if they were affected.
	* If they weren't affected (i.e immunity override), returning FALSE will make projectiles bounce off it
*/
/atom/proc/hvp_act(obj/item/projectile/hvp/PJ, severe = FALSE)
	if(PJ.momentum > 1000 || severe)
		ex_act(EXPLODE_DEVASTATE)
		return TRUE
	if(PJ.momentum > 100)
		ex_act(EXPLODE_HEAVY)
		return TRUE
	return FALSE
