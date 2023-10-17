//////////////// Lets humans self-apply bruise packs and burn ointment again by removing the pain block ////////////////
/obj/item/stack/medical/attack(mob/living/M, mob/user)
	if(!M || !user || (isliving(M) && !M.can_inject(user, TRUE))) //If no mob, user and if we can't inject the mob just return
		return

	if(M.stat == DEAD && !stop_bleeding)
		to_chat(user, "<span class='danger'>\The [M] is dead, you cannot help [M.p_them()]!</span>")
		return

	if(!iscarbon(M) && !isanimal(M))
		to_chat(user, "<span class='danger'>You don't know how to apply \the [src] to [M]!</span>")
		return

	if(isanimal(M))
		var/mob/living/simple_animal/critter = M
		if(!(critter.healable))
			to_chat(user, "<span class='notice'>You cannot use [src] on [M]!</span>")
			return
		if(critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'>[M] is at full health.</span>")
			return
		if(!heal_brute) //simplemobs can only take brute damage, and can only benefit from items intended to heal it
			to_chat(user, "<span class='notice'>[src] won't help [M] at all.</span>")
			return
		M.heal_bodypart_damage(REAGENT_AMOUNT_PER_ITEM)
		user.visible_message("<span class='green'>[user] applies [src] on [M].</span>", "<span class='green'>You apply [src] on [M].</span>")
		use(1)
		return

	var/obj/item/bodypart/affecting
	var/mob/living/carbon/C = M
	affecting = C.get_bodypart(check_zone(user.zone_selected))

	if(M in user.do_afters) //One at a time, please.
		return

	if(!affecting) //Missing limb?
		to_chat(user, "<span class='warning'>[C] doesn't have \a [parse_zone(user.zone_selected)]!</span>")
		return

	if(ishuman(C)) //apparently only humans bleed? funky.
		var/mob/living/carbon/human/H = C
		if(stop_bleeding)
			if(!H.bleed_rate)
				to_chat(user, "<span class='warning'>[H] isn't bleeding!</span>")
				return
			if(H.bleedsuppress) //so you can't stack bleed suppression
				to_chat(user, "<span class='warning'>[H]'s bleeding is already bandaged!</span>")
				return
			H.suppress_bloodloss(stop_bleeding)

	if(!IS_ORGANIC_LIMB(affecting))
		to_chat(user, "<span class='warning'>Medicine won't work on a robotic limb!</span>")
		return

	if(!(affecting.brute_dam || affecting.burn_dam))
		to_chat(user, "<span class='warning'>[M]'s [parse_zone(user.zone_selected)] isn't hurt!</span>")
		return

	if((affecting.brute_dam && !affecting.burn_dam && !heal_brute) || (affecting.burn_dam && !affecting.brute_dam && !heal_burn)) //suffer
		to_chat(user, "<span class='warning'>This type of medicine isn't appropriate for this type of wound.</span>")
		return

	if(C == user)
		user.visible_message("<span class='notice'>[user] starts to apply [src] on [user.p_them()]self...</span>", "<span class='notice'>You begin applying [src] on yourself...</span>")
		if(!do_after(user, self_delay, M))
			return
		//After the do_mob to ensure metabolites have had time to process at least one tick.
		if(reagent && (C.reagents.get_reagent_amount(/datum/reagent/metabolite/medicine/styptic_powder) || C.reagents.get_reagent_amount(/datum/reagent/metabolite/medicine/silver_sulfadiazine)))
			to_chat(user, "<span class='warning'>That stuff really hurt! Maybe someone else can help put it on for you?</span>")
			C.emote("scream")
			C.adjustStaminaLoss(20)
			return

	user.visible_message("<span class='green'>[user] applies [src] on [M].</span>", "<span class='green'>You apply [src] on [M].</span>")
	if(reagent)
		reagents.reaction(M, PATCH, affecting = affecting)
		M.reagents.add_reagent_list(reagent) //Stack size is reduced by one instead of actually removing reagents from the stack.
		C.update_damage_overlays()
	use(1)
