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

/datum/reagent/nitryloxide
	name = "Nitryl Oxide"
	description = "A highly reactive stimulant and anaesthetic."
	reagent_state = GAS
	metabolization_rate = REAGENTS_METABOLISM * 0.5 // Because stimulum/nitryl are handled through gas breathing, metabolism must be lower for breathcode to keep up
	color = "90560B"
	taste_description = "fruity"

/datum/reagent/stimulum/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier(type, update=TRUE, priority=100, multiplicative_slowdown=-1, blacklisted_movetypes=(FLYING|FLOATING))
	ADD_TRAIT(L, TRAIT_STUNIMMUNE, type)
	ADD_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	ADD_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	ADD_TRAIT(L, TRAIT_NOSTAMCRIT, type)
	ADD_TRAIT(L, TRAIT_NOLIMBDISABLE, type)
	ADD_TRAIT(L, TRAIT_NOBLOCK, type)

/datum/reagent/stimulum/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier(type)
	REMOVE_TRAIT(L, TRAIT_STUNIMMUNE, type)
	REMOVE_TRAIT(L, TRAIT_SLEEPIMMUNE, type)
	REMOVE_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	REMOVE_TRAIT(L, TRAIT_NOSTAMCRIT, type)
	REMOVE_TRAIT(L, TRAIT_NOLIMBDISABLE, type)
	REMOVE_TRAIT(L, TRAIT_NOBLOCK, type)
	..()

/datum/reagent/nitryloxide/on_mob_metabolize(mob/living/L)
	..()
	ADD_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	ADD_TRAIT(L, TRAIT_IGNORESLOWDOWN, type)

/datum/reagent/nitryloxide/on_mob_end_metabolize(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_IGNOREDAMAGESLOWDOWN, type)
	REMOVE_TRAIT(L, TRAIT_IGNORESLOWDOWN, type)
	L.unignore_slowdown(type)
	..()
