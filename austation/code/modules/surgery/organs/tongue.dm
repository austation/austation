/obj/item/organ/tongue
	var/static/list/austation_languages_possible_base = typecacheof(list(
		/datum/language/buzzwords,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/cattongue,
	))

/obj/item/organ/tongue/fly
	var/static/list/languages_possible_fly = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/buzzwords
	))

/obj/item/organ/tongue/fly/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_fly

/obj/item/organ/tongue/bone
	var/static/list/languages_possible_skeleton = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/calcic
	))

/obj/item/organ/tongue/bone/Initialize()
	. = ..()
	languages_possible = languages_possible_skeleton

/obj/item/organ/tongue/ethereal
	name = "electric discharger"
	desc = "A sophisticated ethereal organ, capable of synthesising speech via electrical discharge."
	icon = 'austation/icons/obj/austation_surgery.dmi'
	icon_state = "electrotongue"
	say_mod = "crackles"
	attack_verb = list("shocked", "jolted", "zapped")
	taste_sensitivity = 101 // Not a tongue, they can't taste shit
	var/static/list/languages_possible_ethereal = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/voltaic
	))

/obj/item/organ/tongue/ethereal/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_ethereal

/obj/item/organ/tongue/felinid
	name = "cat-tongue"
	desc = "A fleshy muscle mostly used for lying. This tongue has a sandpaper-like texture"
	icon_state = "tonguenormal"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb = list("licked", "slobbered", "slapped", "frenched", "tongued")
	var/list/languages_possible
	var/say_mod = meows
	var/taste_sensitivity = 15 // lower is more sensitive.
	var/modifies_speech = FALSE
	var/static/list/languages_possible_base = typecacheof(list(
		/datum/language/common,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/ratvar,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/rlyehian,
		/datum/language/apidite,
		/datum/language/cattongue,
	))

/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	languages_possible_base += austation_languages_possible_base // austation -- species languages from /tg/
	languages_possible = languages_possible_cattongue