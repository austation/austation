
// very hacky but this means we don't need to override every disposalpipe segment, even if we have to use fucky typepaths
/obj/structure/disposalpipe/segment/coilgun
	coilgun = TRUE
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'

/obj/structure/disposalpipe/broken/coilgun
	coilgun = TRUE
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'

/obj/structure/disposalpipe/trunk/coilgun
	coilgun = TRUE
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'

/obj/structure/disposalpipe/junction/coilgun
	coilgun = TRUE
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'

/obj/structure/disposalpipe/junction/flip/coilgun
	coilgun = TRUE
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
/*
/obj/structure/disposalpipe/junction/yjunction/coilgun
	coilgun = TRUE
	icon = 'austation/icons/obj/atmospherics/pipes/disposal.dmi'
*/
/obj/structure/disposalpipe/coilgun/bypass
	name = "projectile velocity bypass"
	initialize_dirs = DISP_DIR_LEFT | DISP_DIR_RIGHT

	var/speed_limit = 0

/obj/structure/disposalpipe/coilgun/bypass/nextdir(obj/structure/disposalholder/H)
	if(!LAZYLEN(H.contents))
		return dir
	var/flipdir = turn(H.dir, 180)
	if(dir == flipdir)
		return pick(turn(flipdir, 90), turn(flipdir, -90))
	for(var/atom/movable/AM in H)
		var/obj/item/projectile/hvp/PJ = AM
		if(!istype(PJ))
			continue
		if(speed_limit > PJ.velocity)
			break
		var/mask = dpdir & (~dir)	// get a mask of secondary dirs
		for(var/D in GLOB.cardinals) // see disposal junctions for documentation
			if(D & mask)
				return D
	return dir
