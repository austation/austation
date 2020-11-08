/mob/living/simple_animal/drone/radio(message, message_mode, list/spans, language)
	. = ..()
	if(. != 0)
		return .

	if(message_mode == "robot")
		if (radio)
			radio.talk_into(src, message, , spans, language)
		return REDUCE_RANGE

	return 0

// Drones understand common and can speak machine, such as with IPCs and borgs.
/datum/language_holder/drone
	understood_languages = list(/datum/language/drone = list(LANGUAGE_ATOM),
								/datum/language/machine = list(LANGUAGE_ATOM),
								/datum/language/common = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/drone = list(LANGUAGE_ATOM))
	blocked_languages = list()

// Derelict drones don't speak machine, as its too modern for them.
/datum/language_holder/drone/derelict
	understood_languages = list(/datum/language/drone = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/drone = list(LANGUAGE_ATOM))
