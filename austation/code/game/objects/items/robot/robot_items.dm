/obj/item/borg/apparatus/food //basically beaker apparatus but for food items its janky but it works
	name = "food manipulator"
	desc = "A repurposed beaker apparatus for food items."
	icon_state = "borg_beaker_apparatus"
	storable = list(/obj/item/reagent_containers/food/snacks,
	/obj/item/reagent_containers/food/condiment/flour,
	/obj/item/reagent_containers/food/condiment/rice,
	/obj/item/reagent_containers/food/condiment/soymilk,
	/obj/item/reagent_containers/food/condiment/milk,
	/obj/item/reagent_containers/food/condiment/mayonnaise,
	/obj/item/reagent_containers/food/condiment/soysauce,
	/obj/item/reagent_containers/food/condiment/sugar,
	/obj/item/reagent_containers/food/condiment/peppermill,
	/obj/item/reagent_containers/food/condiment/saltshaker) //yes this means you can do bread and i had to exempt enzymes so you dont pickup your internal one, which causes problems.

/obj/item/borg/apparatus/food/Initialize()
	. = ..()
	RegisterSignal(stored, COMSIG_ATOM_UPDATE_ICON, /atom/.proc/update_icon)
	update_icon()

/obj/item/borg/apparatus/food/Destroy()
	if(stored)
		var/obj/item/reagent_containers/C = stored
		C.SplashReagents(get_turf(src))
		qdel(stored)
	. = ..()

/obj/item/borg/apparatus/beaker/examine()
	. = ..()
	if(stored)
		var/obj/item/reagent_containers/food/C = stored
		. += "The apparatus currently has [C] secured."
		if(length(C.reagents.reagent_list))
		else
			. += "Nothing."

/obj/item/borg/apparatus/food/update_icon(mob/living/silicon/robot/user)
	cut_overlays()
	if(stored)
		COMPILE_OVERLAYS(stored)
		stored.pixel_x = 0
		stored.pixel_y = 0
		var/image/img = image("icon"=stored, "layer"=FLOAT_LAYER)
		var/image/arm = image("icon"="borg_beaker_apparatus_arm", "layer"=FLOAT_LAYER)
		if(istype(stored, /obj/item/reagent_containers/food))
			arm.pixel_y = arm.pixel_y - 3
		img.plane = FLOAT_PLANE
		add_overlay(img)
		add_overlay(arm)
	else
		var/image/arm = image("icon"="borg_beaker_apparatus_arm", "layer"=FLOAT_LAYER)
		arm.pixel_y = arm.pixel_y - 5
		add_overlay(arm)

/obj/item/borg/apparatus/food/attack_self(mob/living/silicon/robot/user)
	if(stored && !user.client?.keys_held["Alt"] && user.a_intent != "help")
		var/obj/item/reagent_containers/C = stored
		C.SplashReagents(get_turf(user))
		loc.visible_message("<span class='notice'>[user] spills the contents of the [C] all over the floor.</span>")
		return
	. = ..()

/obj/item/gun/energy/plasmacutter/cyborg
	name = "cyborg plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off xenos! Or, you know, mine stuff."
	icon_state = "plasmacutter"
	item_state = "plasmacutter"
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/cyborg)
	flags_1 = CONDUCT_1
	attack_verb = list("attacked", "slashed", "cut", "sliced")
	force = 12
	sharpness = IS_SHARP
	can_charge = FALSE
	use_cyborg_cell = TRUE
	tool_behaviour = null //sorry no infinite welder for you

/obj/item/ammo_casing/energy/plasma/cyborg
	projectile_type = /obj/item/projectile/plasma
	select_name = "plasma burst"
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	delay = 15
	e_cost = 250

/obj/item/borg/cyborghug/attack(mob/living/M, mob/living/silicon/robot/user)
	if(M == user)
		return
	switch(mode)
		if(0)
			if(M.health >= 0)
				if(user.zone_selected == BODY_ZONE_HEAD)
					if(is_species(M, /datum/species/human/felinid))//I feel if i dont include the felinid exclusive content people will get angry.
						SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "friendly_pat", /datum/mood_event/betterheadpat)
					else
						SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "pat", /datum/mood_event/headpat)
						user.visible_message("<span class='notice'>[user] playfully boops [M] on the head!</span>", \
									"<span class='notice'>You playfully boop [M] on the head!</span>")
					user.do_attack_animation(M, ATTACK_EFFECT_BOOP)
					playsound(loc, 'sound/weapons/tap.ogg', 50, 1, -1)
				else if(ishuman(M))
					if(!(user.mobility_flags & MOBILITY_STAND))
						user.visible_message("<span class='notice'>[user] shakes [M] trying to get [M.p_them()] up!</span>", \
										"<span class='notice'>You shake [M] trying to get [M.p_them()] up!</span>")
					else
						SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "hug", /datum/mood_event/hug)
						user.visible_message("<span class='notice'>[user] hugs [M] to make [M.p_them()] feel better!</span>", \
								"<span class='notice'>You hug [M] to make [M.p_them()] feel better!</span>")
					if(M.resting)
						M.set_resting(FALSE, TRUE)
				else
					user.visible_message("<span class='notice'>[user] pets [M]!</span>", \
							"<span class='notice'>You pet [M]!</span>")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		if(1)
			if(M.health >= 0)
				if(ishuman(M))
					if(!(M.mobility_flags & MOBILITY_STAND))
						user.visible_message("<span class='notice'>[user] shakes [M] trying to get [M.p_them()] up!</span>", \
										"<span class='notice'>You shake [M] trying to get [M.p_them()] up!</span>")
					else if(user.zone_selected == BODY_ZONE_HEAD)
						user.visible_message("<span class='warning'>[user] bops [M] on the head!</span>", \
										"<span class='warning'>You bop [M] on the head!</span>")
						user.do_attack_animation(M, ATTACK_EFFECT_PUNCH)
					else
						user.visible_message("<span class='warning'>[user] hugs [M] in a firm bear-hug! [M] looks uncomfortable...</span>", \
								"<span class='warning'>You hug [M] firmly to make [M.p_them()] feel better! [M] looks uncomfortable...</span>")
					if(M.resting)
						M.set_resting(FALSE, TRUE)
				else
					user.visible_message("<span class='warning'>[user] bops [M] on the head!</span>", \
							"<span class='warning'>You bop [M] on the head!</span>")
				playsound(loc, 'sound/weapons/tap.ogg', 50, 1, -1)
		if(2)
			if(scooldown < world.time)
				if(M.health >= 0)
					if(ishuman(M)||ismonkey(M))
						M.electrocute_act(5, "[user]", safety = 1)
						user.visible_message("<span class='userdanger'>[user] electrocutes [M] with [user.p_their()] touch!</span>", \
							"<span class='danger'>You electrocute [M] with your touch!</span>")
						M.update_mobility()
					else
						if(!iscyborg(M))
							M.adjustFireLoss(10)
							user.visible_message("<span class='userdanger'>[user] shocks [M]!</span>", \
								"<span class='danger'>You shock [M]!</span>")
						else
							user.visible_message("<span class='userdanger'>[user] shocks [M]. It does not seem to have an effect</span>", \
								"<span class='danger'>You shock [M] to no effect.</span>")
					playsound(loc, 'sound/effects/sparks2.ogg', 50, 1, -1)
					user.cell.charge -= 500
					scooldown = world.time + 20
		if(3)
			if(ccooldown < world.time)
				if(M.health >= 0)
					if(ishuman(M))
						user.visible_message("<span class='userdanger'>[user] crushes [M] in [user.p_their()] grip!</span>", \
							"<span class='danger'>You crush [M] in your grip!</span>")
					else
						user.visible_message("<span class='userdanger'>[user] crushes [M]!</span>", \
								"<span class='danger'>You crush [M]!</span>")
					playsound(loc, 'sound/weapons/smash.ogg', 50, 1, -1)
					M.adjustBruteLoss(15)
					user.cell.charge -= 300
					ccooldown = world.time + 10
