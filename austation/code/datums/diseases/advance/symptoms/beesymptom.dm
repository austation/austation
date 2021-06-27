/datum/symptom/beesease
	transmission = 2
	level = 9
	severity = 3
	threshold_desc = "<b>Resistance 6:</b> The bees become symbiotic with the host and no longer attack the host.<br>\
			<b>Resistance 8:</b> Hive synthesizes honey. Bees will also contain honey, unless transmission exceeds 10.<br>\
			<b>Resistance 14:</b> The hive becomes dormant significantly reducing healing.<br>\
			<b>Transmission 10:</b> Bees now contain a completely random toxin.<br>\
			<b>Stage Speed:</b> Effects bee spawn chance"
	var/no_bee = FALSE
	var/bee_friend = FALSE
	var/last_proc = 0
	symptom_delay_min = 2
	symptom_delay_max = 2

/datum/symptom/beesease/severityset(datum/disease/advance/A)
	AU_Severity_Set(A)

/datum/symptom/beesease/AU_Severity_Set(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 8)
		severity -= 2
	if(A.resistance >= 14)
		severity -= 2
	if(A.transmission >= 10)
		severity += 2

/datum/symptom/beesease/Start(datum/disease/advance/A)
	AU_Start(A)

/datum/symptom/beesease/AU_Start(datum/disease/advance/A)
	if(!..())
		return
	if(resistance >= 6)
		bee_friend = TRUE
	if(A.resistance >= 8)
		honey = TRUE
	if(A.resistance >= 14)
		no_bee = TRUE
	if(A.transmission >= 10)
		toxic_bees = TRUE

/datum/symptom/beesease/Activate(datum/disease/advance/A)
	AU_Activate(A)

/datum/symptom/beesease/AU_Activate(datum/disease/advance/A)
	if(!..())
		return

	var/mob/living/M = A.affected_mob
	var/existing_honey = M.reagents.get_reagent_amount(/datum/reagent/consumable/honey)
	var/existing_royaljelly = M.reagents.get_reagent_amount(/datum/reagent/consumable/honey/special)
	var/existing_insulin = M.reagents.get_reagent_amount(/datum/reagent/medicine/insulin)

	switch(A.stage)
		if(2)
			if(prob(2) && !no_bee)
				to_chat(M, "<span class='notice'>You taste honey in your mouth.</span>")

		if(3)
			if(prob(2) && !no_bee)
				to_chat(M, "<span class='notice'>Your stomach tingles.</span>")

			if(prob(5) && honey)
				to_chat(M, "<span class='notice'>You can't get the taste of honey out of your mouth!.</span>")
				M.reagents.add_reagent(/datum/reagent/consumable/honey,max(0, 2 - existing_honey))
				M.reagents.add_reagent(/datum/reagent/medicine/insulin,max(0, 1 - existing_insulin))
		if(4, 5)
			if(prob(2) && !no_bee)
				M.visible_message("<span class='danger'>[M] buzzes.</span>", \
									"<span class='userdanger'>Your stomach buzzes violently!</span>")

			if(bee_friend && !HAS_TRAIT(M, TRAIT_BEEFRIEND))
				ADD_TRAIT(M, TRAIT_BEEFRIEND, DISEASE_TRAIT)

			if(prob(10) && honey)
				to_chat(M, "<span class='notice'>You can't get the taste of honey out of your mouth!.</span>")
				if(no_bee)
					M.reagents.add_reagent(/datum/reagent/consumable/honey,max(0, 5 - existing_honey))
					M.reagents.add_reagent(/datum/reagent/medicine/insulin,max(0, 2.5 - existing_insulin))
				else
					M.reagents.add_reagent(/datum/reagent/consumable/honey,max(0, 10 - existing_honey))
					M.reagents.add_reagent(/datum/reagent/consumable/honey/special,max(0, 5 - existing_royaljelly))
					M.reagents.add_reagent(/datum/reagent/medicine/insulin,max(0, 5 - existing_insulin))

			if(prob(25 + clamp(A.stage_rate * 5, -25, 70)) && !no_bee)
				M.visible_message("<span class='danger'>[M] coughs up a bee!</span>", \
				"<span class='userdanger'>You cough up a bee!</span>")

				var/mob/living/simple_animal/hostile/poison/bees/viro/newbee = new /mob/living/simple_animal/hostile/poison/bees/viro(M.loc)
				if(toxic_bees)
					var/datum/reagent/R = pick(typesof(/datum/reagent/toxin))
					newbee.assign_reagent(GLOB.chemical_reagents_list[R])
				else if(honey)
					newbee.assign_reagent(GLOB.chemical_reagents_list[/datum/reagent/consumable/honey])

/mob/living/simple_animal/hostile/poison/bees/viro
	desc = "These bees seem unstable and won't survive for long."

/mob/living/simple_animal/hostile/poison/bees/viro/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/death), 5 SECONDS)
