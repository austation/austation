// Fuck
/obj/structure/disposalpipe/loafer
	name = "loaf compactor"
	desc = "A special machine that converts inserted matter into gluten"
	icon = 'austation/icons/obj/atmospherics/machines/loafer.dmi'
	icon_state = "loafer"
	var/static/list/blacklist = typecacheof(list(
		/obj/item/stock_parts,
		/obj/item/pipe,
		/obj/structure/disposalconstruct,
		/obj/structure/c_transit_tube,
		/obj/structure/c_transit_tube_pod,
		/obj/item/holochip,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill
	))
	var/emag_bonus = 1
	var/obj/item/reagent_containers/food/snacks/store/bread/recycled/stored_looef

// Shittery to get deconstruction icons working
/obj/structure/disposalpipe/loafer/Initialize(mapload, obj/structure/disposalconstruct/make_from)
	. = ..()

	blacklist = typesof(/obj/item/stock_parts) + typesof(/obj/item/pipe) + typesof(/obj/structure/c_transit_tube) + typesof(/obj/structure/c_transit_tube_pod) + typesof(/obj/item/holochip) + typesof(/obj/item/reagent_containers/glass/bottle) + typesof(/obj/structure/disposalconstruct) + typesof(/obj/item/reagent_containers/pill) + typesof(/obj/item/reagent_containers/pill/patch)

// It's late okay, I don't have time for this
/obj/structure/disposalpipe/loafer/deconstruct(disassembled)
	if(!(flags_1 & NODECONSTRUCT_1))
		if(disassembled)
			var/obj/structure/disposalconstruct/D = new(loc, null , SOUTH , FALSE , src)
			D.icon = 'austation/icons/obj/atmospherics/machines/loafer.dmi'
		else
			var/turf/T = get_turf(src)
			for(var/D in GLOB.cardinals)
				if(D & dpdir)
					var/obj/structure/disposalpipe/broken/P = new(T)
					P.setDir(D)
	SEND_SIGNAL(src, COMSIG_OBJ_DECONSTRUCT, disassembled)
	qdel(src)


/obj/structure/disposalpipe/loafer/Destroy()
	var/obj/structure/disposalholder/H = locate() in src
	if(!QDELETED(H))
		for(var/atom/movable/AM in H.contents)
			if(istype(AM, /obj/item/reagent_containers/food/snacks/store/bread/recycled))
				var/obj/item/reagent_containers/food/snacks/store/bread/recycled/looef = AM
				if(looef.bread_density < 10)
					qdel(AM)
			if(isliving(AM))
				var/mob/living/L = AM
				L.adjustBruteLoss(40) //ouchie
		expel(H, get_turf(src), 0)
	return ..()

/obj/structure/disposalpipe/loafer/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	emag_bonus = 1.5
	playsound(src, "sparks", 75, 1, -1)
	to_chat(user, "<span class='notice'>You use the cryptographic sequencer on [src], allowing it to compress faster and enabling much more dangerous densities!</span>")
	visible_message("<span class='danger'>\The [src] humms ominously!</span>")

// This proc runs when something moves through the pipe
/obj/structure/disposalpipe/loafer/transfer(obj/structure/disposalholder/H)

	if(H.contents.len)

		icon_state = "aloafer"
		update_icon()

		var/obj/item/reagent_containers/food/snacks/store/bread/recycled/looef = new(H)

		var/supermatter_singulo = FALSE

		for(var/atom/movable/AM in H.contents)
			if(AM == looef)
				continue

			if(blacklist[AM.type]) // no matter bin singulo for you
				qdel(AM)
				continue

			if(istype(AM, /obj/item/reagent_containers/food/snacks/store/bread/recycled))
				var/obj/item/reagent_containers/food/snacks/store/bread/recycled/recursive_looef = AM
				looef.bread_density += recursive_looef.bread_density
				qdel(AM)
				continue

			if(istype(AM, /obj/item/reagent_containers/food/snacks/store/bread/supermatter))
				supermatter_singulo = TRUE

			if(isliving(AM)) // uh oh
				var/mob/living/L = AM
				if(obj_flags & EMAGGED || !L.mind)
					L.Paralyze(amount = 50, ignore_canstun = TRUE) // prevents victims from smashing out
					if(iscarbon(L) || issilicon(L))
						looef.bread_density += 50 * emag_bonus
					else
						looef.bread_density += 25 * emag_bonus

					if(ishuman(L) && !isdead(L))
						L.emote("scream")

					playsound(src.loc, 'sound/machines/juicer.ogg', 40, 1)
					sleep(50)

					if(L.loc != H)
						return // don't murder if not in the bread machine. this is a final fallback to stop potential immersion breaking stuff.
					L.death()
					qdel(L)
					playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
					continue
				else // ided
					playsound(src.loc, 'sound/machines/buzz-two.ogg', 40, 1)
					visible_message("<span class='warning'>\The [src]'s safety mechanism engages, stopping the processing blades, but not before seriously injuring [L]!</span>")

					if(ishuman(L) && !isdead(L))
						L.emote("scream")

					L.adjustBruteLoss(70)

					sleep(30)

					visible_message("<span class='notice'>The hatch on the side of \the [src] opens, ejecting [L].")
					playsound(src.loc, 'sound/machines/hiss.ogg', 40, 1)
					L.forceMove(get_turf(src))

					continue

			if(isitem(AM)) // because sheet spamming isn't fun for anyone
				var/obj/item/I = AM
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/stecc = I
					looef.bread_density += stecc.amount * 0.1 * emag_bonus
				else if(I.w_class == WEIGHT_CLASS_TINY)
					looef.bread_density += 0.2 * emag_bonus
				else
					looef.bread_density += I.w_class * 1.5 * emag_bonus
				qdel(AM)
				continue

			looef.bread_density++
			qdel(AM)

		// handle merging loaves
		if(stored_looef)
			looef.bread_density += stored_looef.bread_density // if we have a stored loaf, add its density to the current loaf
			qdel(stored_looef) // and delete it
			stored_looef = null
		stored_looef = looef // after merging any currently stored loaf, store our loaf for 36 deciseconds (3.6 seconds) in case another loaf comes along in that time
		sleep(3)
		playsound(src, pick('sound/machines/blender.ogg', 'sound/machines/juicer.ogg', 'sound/machines/buzz-sigh.ogg', 'sound/machines/warning-buzzer.ogg', 'sound/machines/ping.ogg'), 25, 1)
		sleep(33)
		icon_state = "loafer"
		if(stored_looef == looef)
			stored_looef = null // reset the variable if our loaf is still there after 3.6 seconds. Ignore this if another loaf was stored.
		if(!looef.bread_density)
			qdel(looef)
			if(!LAZYLEN(H.contents)) // no point having an empty disposal object
				qdel(H)
				return
			visible_message("<span class='warning'>\The [src] buzzes grumpily!</span>")
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 40, 1)
		else if(looef.bread_density >= 3400 && obj_flags & EMAGGED || supermatter_singulo)
			var/turf/T = get_turf(src)
			var/area/A = get_area(src)
			var/mob/culprit = get_mob_by_ckey(fingerprintslast)
			var/culprit_message
			priority_announce("We have detected an extremely high concentration of gluten in [A.name], we suggest evacuating the immediate area", sound = SSstation.announcer.get_rand_alert_sound())
			visible_message("<span class='userdanger'>[src] collapses into a singularity under its own weight!</span>")
			var/obj/singularity/oof = new(get_turf(src))
			if(supermatter_singulo)
				oof.consumedSupermatter = supermatter_singulo
				oof.energy = 800
			oof.name = "[supermatter_singulo ? "supercharged" : ""] gravitational breadularity"
			oof.desc = "I have done nothing but compress bread for 3 days."
			qdel(src)
			if(culprit)
				culprit_message = " - Loafer last touched by: [ADMIN_LOOKUPFLW(culprit)]"
			message_admins("Bread singularity released in [ADMIN_VERBOSEJMP(T)][culprit_message]")
		else
			looef.check_evolve()

	return ..()
