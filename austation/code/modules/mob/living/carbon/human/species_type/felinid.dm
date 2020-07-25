/datum/species/human/felinid
	// memed
	say_mod = "meows"
	cattongue = /obj/item/organ/tongue/felinid

/datum/species/human/felinid/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	. = ..()
	H.grant_language(/datum/language/cattongue)
	