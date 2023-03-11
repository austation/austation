/datum/disease/revblight
	name = "Unnatural Wasting"
	max_stages = 5
	stage_prob = 10
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = "Holy water or extensive rest."
	spread_text = "A burst of unholy energy"
	cures = list(/datum/reagent/water/holywater)
	cure_chance = 50 //higher chance to cure, because revenants are assholes
	agent = "Unholy Forces"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CURABLE
	permeability_mod = 1
	danger = DISEASE_HARMFUL
	var/stagedamage = 0 //Highest stage reached.
	var/finalstage = 0 //Because we're spawning off the cure in the final stage, we need to check if we've done the final stage's effects.

/datum/disease/revblight/cure()
	if(affected_mob)
		affected_mob.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#1d2953")
		if(affected_mob.dna && affected_mob.dna.species)
			affected_mob.dna.species.handle_mutant_bodyparts(affected_mob)
			affected_mob.dna.species.handle_hair(affected_mob)
		to_chat(affected_mob, "<span class='notice'>You feel better.</span>")
	..()

/datum/disease/revblight/stage_act()
<<<<<<< HEAD
	if(!finalstage)
		if(!(affected_mob.mobility_flags & MOBILITY_STAND) && prob(stage*6))
=======
	..()
	affected_mob.adjustStaminaLoss(1) //Provides gradual exhaustion, but mostly to prevent regeneration and set an upper limit on disease duration to about five minutes
	if(!(affected_mob.mobility_flags & MOBILITY_STAND))
		if(affected_mob.stam_paralyzed && !finalstage)
			stage = 5
		if(!startresting || restingat != get_turf(affected_mob))
			startresting = world.time
			restingat = get_turf(affected_mob)
		else if(world.time - startresting >= 30 SECONDS) //Ensures nobody is left in permanent stamcrit, and also enables players to rest in a safe location to cure themselves
>>>>>>> 7d11b2f84d (515 Compatibility (#8648))
			cure()
			return
		if(prob(stage*3))
			to_chat(affected_mob, "<span class='revennotice'>You suddenly feel [pick("sick and tired", "disoriented", "tired and confused", "nauseated", "faint", "dizzy")]...</span>")
			affected_mob.confused += 8
			affected_mob.adjustStaminaLoss(20)
			new /obj/effect/temp_visual/revenant(affected_mob.loc)
		if(stagedamage < stage)
			stagedamage++
			affected_mob.adjustToxLoss(stage*2) //should, normally, do about 30 toxin damage.
			new /obj/effect/temp_visual/revenant(affected_mob.loc)
		if(prob(45))
			affected_mob.adjustStaminaLoss(stage)
	..() //So we don't increase a stage before applying the stage damage.
	switch(stage)
		if(2)
			if(prob(5))
				affected_mob.emote("pale")
		if(3)
			if(prob(10))
				affected_mob.emote(pick("pale","shiver"))
		if(4)
			if(prob(15))
				affected_mob.emote(pick("pale","shiver","cries"))
		if(5)
			if(!finalstage)
				finalstage = TRUE
				to_chat(affected_mob, "<span class='revenbignotice'>You feel like [pick("nothing's worth it anymore", "nobody ever needed your help", "nothing you did mattered", "everything you tried to do was worthless")].</span>")
				affected_mob.adjustStaminaLoss(45)
				new /obj/effect/temp_visual/revenant(affected_mob.loc)
				if(affected_mob.dna?.species)
					affected_mob.dna.species.handle_mutant_bodyparts(affected_mob,"#1d2953")
					affected_mob.dna.species.handle_hair(affected_mob,"#1d2953")
				affected_mob.visible_message("<span class='warning'>[affected_mob] looks terrifyingly gaunt...</span>", "<span class='revennotice'>You suddenly feel like your skin is <i>wrong</i>...</span>")
				affected_mob.add_atom_colour("#1d2953", TEMPORARY_COLOUR_PRIORITY)
				addtimer(CALLBACK(src, .proc/cure), 100)
		else
			return
