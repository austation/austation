/obj/item/organ/ears/catcybernetic
	name = "cybernetic cat ears"
	icon = 'icons/obj/clothing/hats.dmi'
	desc = "These ears act as cones for sound while an implant filters loud noise, all while covered in synthetic fur"
	icon_state = "kitty"
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC //this makes a "version" of cat ears that are immune to bangs


/obj/item/organ/ears/catcybernetic/Insert(mob/living/carbon/human/H, special = 0, drop_if_replaced = TRUE)
	..()
	if(istype(H))
		color = H.hair_color
		H.dna.species.mutant_bodyparts |= "ears"
		H.dna.features["ears"] = "Cat"
		H.update_body()

/obj/item/organ/ears/catcybernetic/Remove(mob/living/carbon/human/H,  special = 0)
	..()
	if(istype(H))
		color = H.hair_color
		H.dna.features["ears"] = "None"
		H.dna.species.mutant_bodyparts -= "ears"
		H.update_body()

/obj/item/organ/cybernetic_ears
	name = "Robotic ears"
	icon_state = "cyb_ears"
	desc = "There are three parts to the ear. Inner, middle and outer. Only one of these parts should be normally visible."
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC
