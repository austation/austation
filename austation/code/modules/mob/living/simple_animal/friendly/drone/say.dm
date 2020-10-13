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
	spoken_languages = list(/datum/language/drone = list(LANGUAGE_ATOM),
							/datum/language/machine = list(LANGUAGE_ATOM))
	blocked_languages = list()

// Derelict drones don't speak machine, as its too modern for them.
/datum/language_holder/drone/derelict
	understood_languages = list(/datum/language/drone = list(LANGUAGE_ATOM),
								/datum/language/machine = list(LANGUAGE_ATOM),
								/datum/language/common = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/drone = list(LANGUAGE_ATOM))

// Overwrites but references the upstream handle_message proc for binary. This allows drones to speak on binary, but
/datum/saymode/binary/handle_message(mob/living/user, message, datum/language/language)
	if(istype(user, /mob/living/simple_animal/drone/derelict)) // Derelict drones can only use drone chat (as per upstream)
		return ..()
	if(isdrone(user) && user.binarycheck()) // All other drones that use binary
		user.robot_talk(message)
		return FALSE
	return ..() // Anything that isn't a drone is handled normally.

/datum/saymode/drone // Handles the drone exclusive chat
	key = "d"
	mode = "drone"

/datum/saymode/drone/handle_message(mob/living/user, message, datum/language/language)
	if(isdrone(user))
		var/mob/living/simple_animal/drone/D = user
		D.drone_chat(message)
		return FALSE
	return FALSE // If your not a drone, no drone chat for you
