/mob/living/carbon/update_handcuffed()
	if(surrendered && handcuffed)
		surrendered = FALSE
		remove_status_effect(STATUS_EFFECT_PARALYZED)
	..()
