// Fuck
/obj/structure/disposalpipe/loafer
	name = "loaf compactor"
	desc = "A special machine that converts inserted matter into gluten"
	icon = 'austation/icons/obj/atmospherics/machines/loafer.dmi'
	icon_state = "loafer"
	var/list/blacklist

// Shittery to get deconstruction icons working
/obj/structure/disposalpipe/loafer/Initialize(mapload, obj/structure/disposalconstruct/make_from)
	. = ..()

	blacklist = typesof(/obj/item/stock_parts) + typesof(/obj/item/pipe)

	if(!QDELETED(make_from))
		setDir(make_from.dir)
		make_from.forceMove(src)
		stored = make_from
	else
		stored = new /obj/structure/disposalconstruct/au(src, null , SOUTH , FALSE , src)

// This proc runs when something moves through the pipe
/obj/structure/disposalpipe/loafer/transfer(obj/structure/disposalholder/H)

	if(H.contents.len)

		icon_state = "aloafer"
		update_icon()

		var/obj/item/reagent_containers/food/snacks/store/bread/recycled/looef = new(src)

		for(var/atom/movable/AM in H.contents)
			if(AM.type in blacklist) // no matter bin singulo for you
				qdel(AM)
				continue

			if(istype(AM, /obj/item/reagent_containers/food/snacks/store/bread/recycled))
				var/obj/item/reagent_containers/food/snacks/store/bread/recycled/recursive_looef = AM
				looef.bread_density += recursive_looef.bread_density * 1.2
				qdel(AM)
				continue

			if(isliving(AM)) // uh oh
				var/mob/living/L = AM
				if(iscarbon(L) || issilicon(L))
					looef.bread_density += 50
				else
					looef.bread_density += 25

				if(ishuman(L) && !isdead(L))
					L.emote("scream")

				playsound(src.loc, 'sound/machines/juicer.ogg', 40, 1)
				sleep(50)

				L.death()
				qdel(L)
				playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
				continue

			if(isitem(AM))
				var/obj/item/I = AM
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/stecc = I
					looef.bread_density += 0.1 * stecc.amount
				else
					looef.bread_density += I.w_class * 5
				qdel(AM)
				continue

			looef.bread_density++
			qdel(AM)

		looef.check_evolve()
		looef.forceMove(H)

		sleep(3)
		playsound(src.loc, pick("sounds/machines/blender.ogg", "sounds/machines/juicer.ogg", "sounds/machines/buzz-sigh.ogg", "sounds/machines/warning-buzzer.ogg", "sounds/machines/ping.ogg"), 50, 1)
		sleep(33)
		icon_state = "loafer"

	return ..()
