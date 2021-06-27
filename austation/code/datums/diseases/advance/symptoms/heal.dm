/datum/symptom/heal/surface
	threshhold = 25

/datum/symptom/heal/surface/Start(datum/disease/advance/A)
	AU_Start(A)

/datum/symptom/heal/surface/AU_Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage_rate >= 8)
		power = 2
	if(A.resistance >= 10)
		threshhold = 50

/datum/symptom/heal/surface/Heal(mob/living/carbon/M, datum/disease/advance/A, actual_power)
	var/healed = FALSE

	if(M.getBruteLoss() && M.getBruteLoss() <= threshhold)
		M.adjustBruteLoss(-power)
		healed = TRUE

	if(M.getFireLoss() && M.getFireLoss() <= threshhold)
		M.adjustFireLoss(-power)
		healed = TRUE

	if(M.getToxLoss() && M.getToxLoss() <= threshhold)
		M.adjustToxLoss(-power)
	return healed

/datum/symptom/growth
	threshold_desc = "<b>Stage Speed 6:</b> The disease heals brute damage at a fast rate.<br>\
					<b>Stage Speed 12:</b> The disease heals brute damage incredibly fast, but deteriorates cell health. The disease will also regenerate lost limbs"


/datum/symptom/growth/Start(datum/disease/advance/A)
	AU_Start(A)

/datum/symptom/growth/AU_Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage_rate >= 6)
		bruteheal = TRUE
	if(A.stage_rate >= 12)
		tetsuo = TRUE
	var/mob/living/carbon/M = A.affected_mob
	ownermind = M.mind
	sizemult = CLAMP((A.stage_rate / 10), 1, 2.5)

/datum/symptom/growth/Activate(datum/disease/advance/A)
	AU_Activate(A)

/datum/symptom/growth/AU_Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/M = A.affected_mob
	switch(A.stage)
		if(4, 5)
			if(tetsuo)
				M.adjustBruteLoss(-4)
				if(prob(5))
					regenerate_limb(M)

				if(prob(20))
					M.adjustCloneLoss(1)
			else if(bruteheal)
				M.adjustBruteLoss(-1)
		else
			if(prob(5))
				to_chat(M, "<span class='notice'>[pick("You feel bloated.", "You are the strongest")]</span>")
	return

/datum/symptom/growth/proc/regenerate_limb(var/mob/living/carbon/M)
	var/list/missing = M.get_missing_limbs()
	for(var/Z in missing) //uses the same text and sound a ling's regen does. This can false-flag the host as a changeling.
		if(M.regenerate_limb(Z, TRUE))
			playsound(M, 'sound/magic/demon_consume.ogg', 50, 1)
			M.visible_message("<span class='warning'>[M]'s missing limbs \
				reform, making a loud, grotesque sound!</span>",
				"<span class='userdanger'>Your limbs regrow, making a \
				loud, crunchy sound and giving you great pain!</span>",
				"<span class='italics'>You hear organic matter ripping \
				and tearing!</span>")
			M.emote("scream")

			if(Z == BODY_ZONE_HEAD) //if we regenerate the head, make sure the mob still owns us
				if(isliving(ownermind.current))
					var/mob/living/owner = ownermind.current
					if(owner.stat && owner != M && !istype(owner, /mob/living/brain))//if they have a new mob, forget they exist
						ownermind = null
						break
					if(owner == M) //they're already in control of this body, probably because their brain isn't in the head!
						break
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					H.dna.species.regenerate_organs(H, replace_current = FALSE) //get head organs, including the brain, back
				ownermind.transfer_to(M)
				M.grab_ghost()
			break
