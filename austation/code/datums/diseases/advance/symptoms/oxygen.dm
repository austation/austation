/datum/symptom/oxygen/Activate(datum/disease/advance/A)
  AU_Activate(A)
  return

/datum/symptom/oxygen/AU_Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	switch(A.stage)
		if(4, 5)
			ADD_TRAIT(M, TRAIT_NOBREATH, DISEASE_TRAIT)
			M.adjustOxyLoss(-7, 0)
			M.losebreath = max(0, M.losebreath - 4)
			if(regenerate_blood && M.blood_volume < BLOOD_VOLUME_NORMAL)
				M.blood_volume += 1
		else if(prob(base_message_chance))
			to_chat(M, "<span class='notice'>[pick("Your lungs feel great.", "You realize you haven't been breathing.", "You don't feel the need to breathe.", "Something smells rotten", "You feel peckish")]</span>")
	return
