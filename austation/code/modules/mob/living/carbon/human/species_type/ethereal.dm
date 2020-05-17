/datum/species/ethereal
	mutanttongue = /obj/item/organ/tongue/ethereal

/datum/species/ethereal/after_equip_job(datum/job/J, mob/living/carbon/human/H)
	. = ..()
	H.grant_language(/datum/language/voltaic)
