/datum/species/human/felinid
	// memed
	say_mod = "meows"

/datum/species/human/felinid/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	. = ..()
	H.grant_language(/datum/language/cattongue)
	