/mob/living/carbon/human/handle_blood()
	if (HAS_TRAIT(src, TRAIT_NOPULSE)) // Bloodsuckers don't need to be here.
		return
	else
		..()
