/datum/reagent/australium
	name = "Australium"
	color = "#F2BE11"
	description = "Pure distilled essence of Australia. Can cause subjects to suddenly appear down-under."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "australia"

/datum/reagent/australium/on_mob_life(mob/living/carbon/M)
	if(prob(10))
		M.say(pick("Cunt!", "Fuck off cunt!", "Tell him he's dreaming!", "Have a go, ya mug!", "Put a sock in it!", "She'll be right!", "I know a pretender when I see one!", "Wrap ya laughing gear 'round that!", "Throw another shrimp on the barbie!"), forced = /datum/reagent/australium)
	..()

/datum/reagent/australium/on_mob_add(mob/living/L)
	. = ..()
	var/matrix/M = L.transform
	L.transform = M.Scale(1,-1)

/datum/reagent/australium/on_mob_delete(mob/living/L)
	. = ..()
	L.transform = matrix()

/datum/reagent/luminol
	name = "Luminol"
	color = "#93EF61"
	description = "A strange reagent with luminescent properties. Induces glowing in subjects which scales with the amount."
	taste_description = "bitterness"
	var/obj/effect/dummy/luminescent_glow/glowth // Shamelessly copied from glowy mutation which shamelessly copied from luminescents
	var/power_coefficient = 10 // 40 units to reach max brightness
	var/max_brightness = 4
	var/power = 1.5

/datum/reagent/luminol/on_mob_life(mob/living/carbon/M)
	var/intensity = round(min(M.reagents.get_reagent_amount(type)/power_coefficient, max_brightness), 0.5)
	if(glowth)
		glowth.set_light(min(intensity, max_brightness), power, color)
	..()

/datum/reagent/luminol/on_mob_add(mob/living/L)
	. = ..()
	glowth = new(L)
	glowth.set_light(0) // stop it showing up white before being on_mob_life gets called

/datum/reagent/luminol/on_mob_delete(mob/living/L)
	. = ..()
	qdel(glowth)

/datum/reagent/luminol/energized
	name = "Energized Luminol"
	color = "#97FFFF"
	description = "The more powerful version of Luminol, it has been energized to increase its brightness and range."
	taste_description = "electrical bitterness"
	power_coefficient = 5 // 30 units to reach max brightness
	max_brightness = 6
	power = 1.8

/datum/reagent/stimulum/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-1, blacklisted_movetypes=(FLYING|FLOATING))
	ADD_TRAIT(L, TRAIT_IGNORESLOWDOWN, type)

/datum/reagent/stimulum/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(type)
	REMOVE_TRAIT(L, TRAIT_IGNORESLOWDOWN, type)
	..()

/datum/reagent/nitryl/on_mob_metabolize(mob/living/L)
	ADD_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	ADD_TRAIT(L, TRAIT_IGNORESLOWDOWN, type)

/datum/reagent/nitryl/on_mob_life(mob/living/L)
	if(L.reagents.get_reagent_amount(/datum/reagent/nitryl) > 1)
		L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-1, blacklisted_movetypes=(FLYING|FLOATING))
	else if(L.remove_movespeed_modifier(type))
		L.remove_movespeed_modifier(type)
	..()

/datum/reagent/nitryl/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	REMOVE_TRAIT(L, TRAIT_IGNORESLOWDOWN, type)

	if(L.remove_movespeed_modifier(type))
		L.remove_movespeed_modifier(type)

/datum/reagent/neutron_fluid
	name = "Neutron Fluid"
	description = "A dense fluid like substance composed of pure neutrons, extremely dense"
	taste_description = "nothing" // neutrons, get it?
	color = "#97FFFF"
	metabolization_rate = 4 // same as clf3

/datum/reagent/neutron_fluid/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(3)
	M.adjustOrganLoss(ORGAN_SLOT_STOMACH, 1)

/datum/reagent/strange_matter
	name = "Strange matter"
	description = "An unusual form of matter consisting of an incredibly dense arrangement of strange quarks. EXTREMELY DEADLY, keep away from children"
	taste_description = "quarks"
	color = "#99ff87"
	metabolization_rate = 4

/datum/reagent/strange_matter/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(2)
	M.adjustFireLoss(2)
	M.adjustToxLoss(2)
	M.adjustOrganLoss(ORGAN_SLOT_STOMACH, 2)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1)
	if(prob(20))
		if(prob(50))
			to_chat(M, "<span class='userdanger'>The strange matter consumes part of your flesh!</span>")
			M.adjustBruteLoss(10)
		M.emote("scream")
		M.Jitter(3)
	else if(prob(2))
		M.visible_message("<span class='danger'>The strange matters consumes \the [M]'s body, turning them into a pile of goo!</span>", "<span class='userdanger'>The strange matters consumes your body, turning you into a pile of goo!</span>")
		var/obj/effect/decal/cleanable/greenglow/gloo = new(get_turf(M))
		gloo.reagents.add_reagent(/datum/reagent/strange_matter, volume)
		M.death()
		qdel(M)

/datum/reagent/antimatter
	name = "Antimatter"
	description = "Incredibly dangerous substance whose particles have an exactly opposite charge to those of normal matter, annihilating on contact. How it stays in the beaker is anyone's guess."
	taste_description = "your mouth vaporizing"
	color = "#858585"
	metabolization_rate = 2

/datum/reagent/antimatter/on_mob_add(mob/living/L)
	to_chat(L, "<span class='userdanger'>You feel the antimatter vaporizing your body!</span>")
	L.adjustFireLoss(50)
	addtimer(CALLBACK(src, .proc/vaporize, L), 50)

/datum/reagent/antimatter/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(20)

/datum/reagent/antimatter/reaction_turf(turf/T, volume)
	if(volume < 5)
		return
	T.ChangeTurf(path = /turf/open/space)
	T.visible_message("<span class='danger'>The antimatter melts through the floor in a brilliant flash of light!")

/datum/reagent/antimatter/proc/vaporize(mob/living/L)
	if(QDELETED(src))
		to_chat(L, "<span class='danger'>The antimatter dissipates, leaving you with only severe burns.</span>")
		return
	L.visible_message("<span class='danger'>The antimatter vaporizes \the [L]'s body in a brilliant flash of pure energy!</span>", "<span class='userdanger'>The antimatter vaporizes your body in a brilliant flash of pure energy!</span>")
	L.dust(drop_items = FALSE, force = TRUE)
