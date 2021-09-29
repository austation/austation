/datum/reagent/australium
	name = "Australium"
	color = "#F2BE11"
	description = "A mysterious metal element that can adapt and transform itself into different states and forms, can make subjects appear down-under."
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "australia"
	var/static/list/whitelist = typesof(/obj/item/gun) + typesof(/obj/item/melee) + typesof(/obj/item/kitchen) + typesof(/obj/item/crowbar) + typesof(/obj/item/screwdriver) + typesof(/obj/item/wrench) + typesof(/obj/item/wirecutters) + typesof(/obj/item/weldingtool) + typesof(/obj/item/retractor) + typesof(/obj/item/hemostat) + typesof(/obj/item/cautery) + typesof(/obj/item/surgicaldrill) + typesof(/obj/item/scalpel) + typesof(/obj/item/circular_saw) + typesof(/obj/item/nullrod) + typesof(/obj/item/storage/toolbox)

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

/datum/reagent/australium/reaction_obj(obj/O, reac_volume)
	var/obj/item/M = O
	if(HAS_TRAIT(M, TRAIT_AUSTRALIUM))
		return ..()
	else if(M.type in whitelist)
		M.add_atom_colour(rgb(242,190,17), FIXED_COLOUR_PRIORITY)
		M.name = "australium [M.name]"
		M.desc = "[M.desc] It's plated in Australium!"
		ADD_TRAIT(M, TRAIT_AUSTRALIUM, "australium")

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

/datum/reagent/consumable/synthetic_cake_batter
	name = "Synthetic cake batter"
	description = "An organic compound used for printing cakes and pretty much nothing else, highly concentrated in nutriments."
	reagent_state = SOLID
	color = "#ddaf4c"
	nutriment_factor = 30 * REAGENTS_METABOLISM
	metabolization_rate = 2 * REAGENTS_METABOLISM
	taste_description = "sweetness"

/datum/reagent/neutron_fluid
	name = "Neutron Fluid"
	description = "A dense fluid like substance composed of pure neutrons, extremely dense"
	taste_description = "nothing" // neutrons, get it?
	color = "#97FFFF"
	metabolization_rate = 4 // same as clf3
	can_synth = FALSE

/datum/reagent/neutron_fluid/on_mob_life(mob/living/carbon/M)
	M.adjustBruteLoss(3)
	M.adjustOrganLoss(ORGAN_SLOT_STOMACH, 1)

/datum/reagent/strange_matter
	name = "Strange matter"
	description = "An unusual form of matter consisting of an incredibly dense arrangement of strange quarks. EXTREMELY DEADLY, keep away from children"
	taste_description = "quarks"
	color = "#99ff87"
	metabolization_rate = 4
	can_synth = FALSE

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
	can_synth = FALSE

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

/datum/reagent/plasma_oxide
	name = "Hyper-Plasmium Oxide"
	description = "Compound created deep in the cores of demon-class planets. Commonly found through deep geysers."
	color = "#470750" // rgb: 255, 255, 255
	taste_description = "hell"

/datum/reagent/exotic_stabilizer
	name = "Exotic Stabilizer"
	description = "Advanced compound created by mixing stabilizing agent and hyper-plasmium oxide."
	color = "#180000" // rgb: 255, 255, 255
	taste_description = "blood"

/datum/reagent/acetone_oxide
	name = "Acetone oxide"
	description = "Enslaved oxygen"
	reagent_state = LIQUID
	color = "#C8A5DC"
	taste_description = "acid"

/datum/reagent/acetone_oxide/reaction_mob(mob/living/M, methods=TOUCH, reac_volume)//Splashing people kills people!
	if(!istype(M))
		return
	if(methods & TOUCH)
		M.adjustFireLoss(2, FALSE) // burns,
		M.adjust_fire_stacks((reac_volume / 10))
	..()

/datum/reagent/pentaerythritol
	name = "Pentaerythritol"
	description = "Slow down, it ain't no spelling bee!"
	reagent_state = SOLID
	color = "#E66FFF"
	taste_description = "acid"

/datum/reagent/acetaldehyde
	name = "Acetaldehyde"
	description = "Similar to plastic. Tastes like dead people."
	reagent_state = SOLID
	color = "#EEEEEF"
	taste_description = "dead people" //made from formaldehyde, ya get da joke ?

/datum/reagent/hydrogen_peroxide
	name = "Hydrogen peroxide"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen and oxygen." //intended intended
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha)
	taste_description = "burning water"
	var/cooling_temperature = 2
	glass_icon_state = "glass_clear"
	glass_name = "glass of oxygenated water"
	glass_desc = "The father of all refreshments. Surely it tastes great, right?"
	shot_glass_icon_state = "shotglassclear"

/*
 *	Water reaction to turf
 */

/datum/reagent/hydrogen_peroxide/reaction_turf(turf/open/T, reac_volume)
	if(!istype(T))
		return
	if(reac_volume >= 5)
		T.MakeSlippery(TURF_WET_WATER, 10 SECONDS, min(reac_volume*1.5 SECONDS, 60 SECONDS))
/*
 *	Water reaction to a mob
 */

/datum/reagent/hydrogen_peroxide/reaction_mob(mob/living/M, methods=TOUCH, reac_volume)//Splashing people with h2o2 can burn them !
	if(!istype(M))
		return
	if(methods & TOUCH)
		M.adjustFireLoss(2, 0) // burns
	..()

/datum/reagent/colorful_reagent/powder/on_mob_life(mob/living/carbon/M)
	if((ishuman(M) && M.job == "Clown"))
		M.heal_bodypart_damage(1,1, 0)
		. = 1
	..()
