

/datum/reagent/toxin/sarin
	name = "Sarin"
	description = "An extremely deadly neurotoxin, keep away from children"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	color = "#00FF32"
	toxpwr = 1.75
	taste_description = "nothing"

/datum/reagent/toxin/sarin/on_mob_life(mob/living/carbon/C)
	. = TRUE

	if(HAS_TRAIT(C, TRAIT_NOBREATH))
		. = FALSE

	if(.)
		to_chat(M, "<span class='danger'>You can barely see!</span>")
		M.blur_eyes(3)
		C.adjustOxyLoss(5, 0)
		C.losebreath += 11
		if(prob(20))
			C.emote("gasp")
		if(prob(10))
			M.Paralyze(20, 0)
		if(M.toxloss <= 60)
			M.adjustToxLoss(1*REM, 0)
		if(current_cycle >=11 && prob(min(50,current_cycle)))
			C.vomit(10, prob(10), prob(50), rand(0,4), TRUE, prob(30))
	..()
