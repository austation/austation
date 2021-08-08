// Table Banging
/obj/structure/table/AltClick(mob/user)
	// Using click cooldowns for attacks and shit here to prevent spam
	if(user.next_move > world.time)
		return
	user.changeNext_move(CLICK_CD_MELEE)

	if(user && Adjacent(user) && !user.incapacitated())
		if(istype(user) && user.a_intent == INTENT_HARM)
			user.visible_message("<span class='warning'>[user] slams [user.p_their()] palms down on [src].</span>", "<span class='warning'>You slam your palms down on \the [src].</span>")
			playsound(src, 'austation/sound/misc/tableslap.ogg', 50, 1)
			if(prob(5) && istype(src, /obj/structure/table/glass) && isliving(user))
				var/mob/living/L = user
				var/obj/structure/table/glass/G = src
				G.table_shatter(L)
		else
			user.visible_message("<span class='notice'>[user] slaps [user.p_their()] hands on [src].</span>", "<span class='notice'>You slap your hands on \the [src].</span>")
			playsound(src, 'sound/weapons/tap.ogg', 50, 1)
		user.do_attack_animation(src)
		return TRUE
