/datum/emote/living/carbon/human
	mob_type_allowed_typecache = list(/mob/living/carbon/human)

/datum/emote/living/carbon/human/bruh
	key = "bruh"
	key_third_person = "bruhs"
	message = "thinks this is a bruh moment."
	emote_type = EMOTE_AUDIBLE
	sound = 'austation/sound/misc/bruh.ogg'
	cooldown = (5 SECONDS)

/datum/emote/living/carbon/human/cheese
	key = "cheese"
	key_third_person = "cheeses"
	message = "thinks this is cheese"
	emote_type = EMOTE_AUDIBLE
	sound = 'austation/sound/misc/cheese.ogg' //CHEESE
	cooldown = (5 SECONDS)

/datum/emote/living/carbon/human/beans
	key = "beans"
	key_third_person = "beanss"
	message = "thinks this is beans"
	emote_type = EMOTE_AUDIBLE
	sound = 'austation/sound/misc/beans.ogg'
	cooldown = (5 SECONDS)

/datum/emote/living/carbon/human/enthusiastic
	key = "yes"
	key_third_person = "yess"
	message = "enthusiastically agrees!"
	emote_type = EMOTE_AUDIBLE
	sound = 'austation/sound/misc/yesYES.ogg'
	cooldown = (5 SECONDS)

/datum/emote/living/carbon/human/unenthusiastic
	key = "no"
	key_third_person = "nos"
	message = "enthusiastically disagrees!"
	emote_type = EMOTE_AUDIBLE
	sound = 'austation/sound/misc/nono.ogg'
	cooldown = (5 SECONDS)

/datum/emote/living/carbon/human/goddamn
	key = "goddamn"
	key_third_person = "goddamns"
	message = "is impressed with your flex!"
	emote_type = EMOTE_AUDIBLE
	sound = 'austation/sound/misc/goughdemn.ogg'
	cooldown = (5 SECONDS)

/datum/emote/living/carbon/human/scream
	cooldown = (5 SECONDS)

/datum/emote/living/carbon/human/fart
	cooldown = (5 SECONDS)

/datum/emote/living/carbon/human/dab
	key = "dab"
	key_third_person = "dabs"
	message = "hits a nasty dab!"

/datum/emote/living/carbon/circle
	key = "circle"
	key_third_person = "circles"
	restraint_check = TRUE

/datum/emote/living/carbon/circle/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!length(user.get_empty_held_indexes()))
		to_chat(user, "<span class='warning'>You don't have any free hands to make a circle with.</span>")
		return
	var/obj/item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, "<span class='notice'>You make a circle with your hand.</span>")

/datum/emote/living/carbon/human/impressive
	key = "impressive"
	key_third_person = "impressives"
	message = "is impressed!"
	emote_type = EMOTE_AUDIBLE
	sound = 'austation/sound/misc/impressiveverynice.ogg'
	cooldown = (5 SECONDS)

/datum/emote/living/carbon/human/surprise
	key = "surprised"
	key_third_person = "surpriseds"
	message = "is surprised!"
	emote_type = EMOTE_AUDIBLE
	sound = 'austation/sound/misc/whatinthegoddamn.ogg'
	cooldown = (5 SECONDS)
