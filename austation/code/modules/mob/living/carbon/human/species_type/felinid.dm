/datum/species/human/felinid //Only god can redeem my sins
	// memed
	say_mod = "meows"
	
/datum/species/human/felinid/after_equip_job(datum/job/J, mob/living/carbon/human/E)
	E.mob_trait = TRAIT_FREERUNNING
	E.mob_trait = TRAIT_FRIENDLY