

/datum/reagent/toxin/sarin
	name = "Sarin"
	description = "An extremely deadly neurotoxin, keep away from children"
	metabolization_rate = 0.125 * REAGENTS_METABOLISM
	color = "#00FF32"
	toxpwr = 1.75
	taste_description = "nothing"
	can_synth = FALSE

/datum/reagent/toxin/sarin/on_mob_life(mob/living/carbon/C)
	. = TRUE

	if(HAS_TRAIT(C, TRAIT_NOBREATH))
		. = FALSE

	else
		to_chat(C, "<span class='danger'>You can barely see!</span>")
		C.blur_eyes(3)
		C.adjustOxyLoss(5, 0)
		C.losebreath += 11
		if(prob(20))
			C.emote("gasp")
		if(prob(10))
			C.Paralyze(20, 0)
		if(C.toxloss <= 60)
			C.adjustToxLoss(1*REM, 0)
		if(current_cycle >=11 && prob(min(50,current_cycle)))
			C.vomit(10, prob(10), prob(50), rand(0,4), TRUE, prob(30))
	..()

/datum/reagent/toxin/acid/nitracid
	name = "Nitric acid"
	description = "Nitric acid is an extremely corrosive chemical substance that violently reacts with living organic tissue."
	color = "#5050FF"
	toxpwr = 3
	acidpwr = 5.0

/datum/reagent/toxin/acid/nitracid/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(volume/10, FALSE) //here you go nervar
	. = TRUE
	..()

