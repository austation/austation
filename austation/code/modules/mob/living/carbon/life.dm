/mob/living/carbon/natural_bodytemperature_stabilization()
	if (HAS_TRAIT(src,TRAIT_COLDBLOODED))
		return 0
	else
		return ..()
