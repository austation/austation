/mob/living/carbon/adjustBruteLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	if (!forced && amount < 0 && HAS_TRAIT(src,TRAIT_NONATURALHEAL))	// austation -- Bloodsucker integration
		return FALSE
	..()

/mob/living/carbon/adjustFireLoss(amount, updating_health = TRUE, forced = FALSE, required_status)
	if (!forced && amount < 0 && HAS_TRAIT(src,TRAIT_NONATURALHEAL))	// austation -- Bloodsucker integration
		return FALSE
	..()
