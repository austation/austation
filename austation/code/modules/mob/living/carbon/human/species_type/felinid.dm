/datum/species/human/felinid
	say_mod = "meows" // memed
	inherent_traits = list(TRAIT_FRIENDLY)
	mutanteyes = /obj/item/organ/eyes/cat
	inert_mutation = /datum/mutation/human/claws // Claws

/datum/species/human/felinid/on_species_gain(mob/living/carbon/human/H)
	..()
	if(istype(H))
		H.physiology.bleed_mod *= 1.5 //austation -- felinid rework (Compilatron's revision)

/datum/species/human/felinid/on_species_loss(mob/living/carbon/human/H)
	..()
	if(istype(H))
		H.physiology.bleed_mod /= 1.5