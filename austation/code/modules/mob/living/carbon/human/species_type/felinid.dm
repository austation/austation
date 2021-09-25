/datum/species/human/felinid
	inert_mutation = /datum/mutation/human/claws // Claws

/datum/species/human/felinid/New()
	. = ..()
	inherent_traits.Add(TRAIT_STRONG_STOMACH)
