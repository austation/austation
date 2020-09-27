/obj/item/clothing/head/foilhat/equipped(mob/living/carbon/human/user, slot)
	..()
	if(slot == SLOT_HEAD)
		user.sec_hud_set_implants()
		if(paranoia)
			QDEL_NULL(paranoia)
		paranoia = new()
		paranoia.clonable = FALSE

		user.gain_trauma(paranoia, TRAUMA_RESILIENCE_MAGIC)
		to_chat(user, "<span class='warning'>As you don the foiled hat, an entire world of conspiracy theories and seemingly insane ideas suddenly rush into your mind. What you once thought unbelievable suddenly seems.. undeniable. Everything is connected and nothing happens just by accident. You know too much and now they're out to get you. </span>")
		if(!user.mind)  // austation removes gangs
			return TRUE
		if(user.mind.has_antag_datum(/datum/antagonist/gang/boss))
			if(!silent)
				user.visible_message("<span class='warning'>[user] seems to resist the implant!</span>", "<span class='warning'>You feel something interfering with your mental conditioning, but you resist it!</span>")
			removed(user, 1)
			qdel(src)
			return FALSE
		user.mind.remove_antag_datum(/datum/antagonist/gang)
		if(!silent)
			to_chat(user, "<span class='notice'>You feel a sense of peace and security. You are now protected from brainwashing.</span>")
		return TRUE
