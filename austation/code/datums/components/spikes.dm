/datum/component/spikes/setarmor(datum/source, datum/species/S)
	if(ishuman(parent))
		var/mob/living/carbon/human/H = parent
		finalarmor = armor
		if(H.dna.species.armor + armor > 60)
			finalarmor = max(0, (60 - H.dna.species.armor))
		H.dna.species.armor += finalarmor
