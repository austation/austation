/turf/open/floor/plating/attackby(obj/item/C, mob/user, params)
	if(..())
		return
	if(istype(C, /obj/item/stack/rods) && attachment_holes)
		if(broken || burnt)
			to_chat(user, "<span class='warning'>Repair the plating first!</span>")
			return
		if(locate(/obj/structure/lattice/catwalk/over, src))
			return
		if (istype(C, /obj/item/stack/rods))
			var/obj/item/stack/rods/R = C
			if (R.use(2))
				to_chat(user, "<span class='notice'>You lay down the catwalk.</span>")
				playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
				new /obj/structure/lattice/catwalk/over(src)
				return
	if(istype(C, /obj/item/stack/sheet/iron) && attachment_holes)
		if(broken || burnt)
			to_chat(user, "<span class='warning'>Repair the plating first!</span>")
			return
		var/obj/item/stack/sheet/iron/R = C
		if (R.get_amount() < 1)
			to_chat(user, "<span class='warning'>You need one sheet to make a reinforced floor!</span>")
			return
		else
			to_chat(user, "<span class='notice'>You begin reinforcing the floor...</span>")
			if(do_after(user, 30, target = src))
				if (R.get_amount() >= 1 && !istype(src, /turf/open/floor/engine))
					PlaceOnTop(/turf/open/floor/engine, flags = CHANGETURF_INHERIT_AIR)
					playsound(src, 'sound/items/deconstruct.ogg', 80, 1)
					R.use(1)
					to_chat(user, "<span class='notice'>You reinforce the floor.</span>")
				return
	else if(istype(C, /obj/item/stack/tile) && !locate(/obj/structure/lattice/catwalk, src))
		if(!broken && !burnt)
			for(var/obj/O in src)
				if(O.level == 1) //ex. pipes laid underneath a tile
					for(var/M in O.buckled_mobs)
						to_chat(user, "<span class='warning'>Someone is buckled to \the [O]! Unbuckle [M] to move \him out of the way.</span>")
						return
			var/obj/item/stack/tile/W = C
			if(!W.use(1))
				return
			if(!istype(src, /turf/open/floor/plating/asteroid))
				var/turf/open/floor/T = PlaceOnTop(W.turf_type, flags = CHANGETURF_INHERIT_AIR)
				if(istype(W, /obj/item/stack/tile/light)) //TODO: get rid of this ugly check somehow
					var/obj/item/stack/tile/light/L = W
					var/turf/open/floor/light/F = T
					F.state = L.state
			else
				var/turf/open/floor/plating/asteroid/T = src
				if(T.dug)
					PlaceOnTop(/turf/open/floor/plating, flags = CHANGETURF_INHERIT_AIR)
				else
					to_chat(user, "<span class='warning'>You need to dig below the foundations first!</span>")
			playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
		else
			to_chat(user, "<span class='warning'>This section is too damaged to support a tile! Use a welder to fix the damage.</span>")
