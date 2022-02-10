#define CLAW_DAMAGE_MULT 2.5

/datum/mutation/human/claws
	name = "Claws"
	desc = "Causes nails to grow to be sharper and thinner."
	quality = POSITIVE
	difficulty = 16
	instability = 5
	conflicts = list(HULK)
	locked = TRUE    // Only found in felinids

/datum/mutation/human/claws/on_acquiring(mob/living/carbon/human/owner)
	if(..())
		return
	owner.dna.species.punchdamage *= CLAW_DAMAGE_MULT
	owner.dna.species.attack_verb = "slash"
	owner.dna.species.attack_sound = 'sound/weapons/slash.ogg'
	owner.dna.species.miss_sound = 'sound/weapons/slashmiss.ogg'
	passtable_on(owner, GENETIC_MUTATION)
	owner.visible_message("<span class='danger'>[owner] sprouts claws from their hands!</span>", "<span class='notice'>Your nails feel sharp!</span>")

/datum/mutation/human/claws/on_losing(mob/living/carbon/human/owner)
	if(..())
		return
	owner.dna.species.punchdamage /= CLAW_DAMAGE_MULT
	owner.dna.species.attack_verb = initial(owner.dna.species.attack_verb)
	owner.dna.species.attack_sound = initial(owner.dna.species.attack_sound)
	owner.dna.species.miss_sound = initial(owner.dna.species.miss_sound)
	passtable_off(owner, GENETIC_MUTATION)
	owner.visible_message("<span class='danger'>[owner]'s claws form back to regular nails.</span>", "<span class='notice'>Your nails become blunt.</span>")

/datum/mutation/human/claws/get_visual_indicator()
	return("Their nails are pointy!")
#undef CLAW_DAMAGE_MULT
