/datum/quirk/sweetaholic
	name = "Sweet-junkie"
	desc = "You find yourself craving sugary treats. Can't get enough of them!"
	value = 0
	gain_text = "<span class='notice'>You feel an intense craving for sweets.</span>"
	lose_text = "<span class='notice'>You feel like sweets are not that delicious anymore.</span>"

/datum/quirk/sweetaholic/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food |= SUGAR
	species.disliked_food &= ~SUGAR

/datum/quirk/sweetaholic/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		if(!initial(species.liked_food) & SUGAR)
			species.liked_food &= ~SUGAR
		if(initial(species.disliked_food) & SUGAR)
			species.disliked_food |= SUGAR

/datum/quirk/meatlover
	name = "Meat-lover"
	desc = "You really like meats of all kinds. Especially steaks!"
	value = 0
	gain_text = "<span class='notice'>You start craving for animal flesh. Preferably cooked.</span>"
	lose_text = "<span class='notice'>You feel like steaks are not that delicious anymore.</span>"

/datum/quirk/meatlover/add()
	var/mob/living/carbon/human/H = quirk_holder
	var/datum/species/species = H.dna.species
	species.liked_food |= MEAT
	species.disliked_food &= ~MEAT

/datum/quirk/meatlover/remove()
	var/mob/living/carbon/human/H = quirk_holder
	if(H)
		var/datum/species/species = H.dna.species
		if(!initial(species.liked_food) & MEAT)
			species.liked_food &= ~MEAT
		if(initial(species.disliked_food) & MEAT)
			species.disliked_food |= MEAT

