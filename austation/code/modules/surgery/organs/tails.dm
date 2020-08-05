/obj/item/organ/tail/cat/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		if(!("tail_human" in H.dna.species.mutant_bodyparts))
			H.dna.species.mutant_bodyparts |= "tail_human"
			H.dna.features["tail_human"] = tail_type
			H.update_body()
		ADD_TRAIT(H, TRAIT_GRABWEAKNESS, "cat tail grab weakness")
		H.physiology.stun_mod *= 0.8

/obj/item/organ/tail/cat/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		H.dna.features["tail_human"] = "None"
		H.dna.species.mutant_bodyparts -= "tail_human"
		color = H.hair_color
		H.update_body()
		REMOVE_TRAIT(H, TRAIT_GRABWEAKNESS, "cat tail grab weakness")
		H.physiology.stun_mod /= 0.8