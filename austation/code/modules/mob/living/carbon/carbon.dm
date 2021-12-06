/mob/living/carbon/update_handcuffed()
	remove_status_effect(STATUS_EFFECT_SURRENDERED)
	remove_status_effect(STATUS_EFFECT_PARALYZED)
	..()
