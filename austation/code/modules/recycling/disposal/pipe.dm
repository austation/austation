/obj/structure/disposalpipe
	var/coilgun = FALSE // is this pipe part of a coilgun? Used for determining if a coilgun projectile is allowed inside it.

/obj/structure/disposalpipe/deconstruct(disassembled = TRUE)
	if(coilgun && !(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			new /obj/structure/disposalconstruct/coilgun(loc, null , SOUTH , FALSE , src)
		else
			var/turf/T = get_turf(src)
			for(var/D in GLOB.cardinals)
				if(D & dpdir)
					var/obj/structure/disposalpipe/broken/P = new(T)
					P.setDir(D)
		SEND_SIGNAL(src, COMSIG_OBJ_DECONSTRUCT, disassembled)
		qdel(src)
	else
		..()
