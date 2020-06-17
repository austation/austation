/datum/species/golem/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	C.grant_language(/datum/language/terrum)

/datum/species/golem/runic/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	C.grant_language(/datum/language/narsie)

/datum/species/golem/bone/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	C.grant_language(/datum/language/calcic)
