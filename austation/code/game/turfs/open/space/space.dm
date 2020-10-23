/turf/open/space/proc/glass_attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/stack/tile/plasmarglass))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/plasmarglass/PG = C
			if(PG.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You build a glass floor.</span>")
				PlaceOnTop(/turf/open/floor/glass/plasma, flags = CHANGETURF_INHERIT_AIR)
			else
				to_chat(user, "<span class='warning'>You need one floor tile to build a floor!</span>")
		else
			to_chat(user, "<span class='warning'>The glass is going to need some support! Place iron rods first.</span>")
	if(istype(C, /obj/item/stack/tile/rglass))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/rglass/RG = C
			if(RG.use(1))
				qdel(L)
				playsound(src, 'sound/weapons/genhit.ogg', 50, 1)
				to_chat(user, "<span class='notice'>You build a glass floor.</span>")
				PlaceOnTop(/turf/open/floor/glass, flags = CHANGETURF_INHERIT_AIR)
			else
				to_chat(user, "<span class='warning'>You need one floor tile to build a floor!</span>")
		else
			to_chat(user, "<span class='warning'>The glass is going to need some support! Place iron rods first.</span>")
