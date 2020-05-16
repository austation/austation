/datum/language_holder
	/// Understood languages.
	var/list/understood_languages = list(/datum/language/common = list(LANGUAGE_MIND))
	/// A list of languages that can be spoken. Tongue organ may also set limits beyond this list.
	var/list/spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM))

/datum/language_holder/synthetic
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/machine = list(LANGUAGE_ATOM),
								/datum/language/draconic = list(LANGUAGE_ATOM),
								/datum/language/moffic = list(LANGUAGE_ATOM),
								/datum/language/calcic = list(LANGUAGE_ATOM),
								/datum/language/voltaic = list(LANGUAGE_ATOM))

	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/machine = list(LANGUAGE_ATOM),
								/datum/language/draconic = list(LANGUAGE_ATOM),
								/datum/language/moffic = list(LANGUAGE_ATOM),
								/datum/language/calcic = list(LANGUAGE_ATOM),
								/datum/language/voltaic = list(LANGUAGE_ATOM))

/datum/language_holder/moth
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/moffic = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/moffic = list(LANGUAGE_ATOM))

/datum/language_holder/skeleton
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/calcic = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/calcic = list(LANGUAGE_ATOM))

/datum/language_holder/ethereal
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/voltaic = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/voltaic = list(LANGUAGE_ATOM))

/datum/language_holder/golem
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/terrum = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/terrum = list(LANGUAGE_ATOM))

/datum/language_holder/golem/bone
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/terrum = list(LANGUAGE_ATOM),
								/datum/language/calcic = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/terrum = list(LANGUAGE_ATOM),
							/datum/language/calcic = list(LANGUAGE_ATOM))

/datum/language_holder/golem/runic
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/terrum = list(LANGUAGE_ATOM),
								/datum/language/narsie = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/terrum = list(LANGUAGE_ATOM),
							/datum/language/narsie = list(LANGUAGE_ATOM))

/datum/language_holder/fly
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/buzzwords = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/buzzwords = list(LANGUAGE_ATOM))

/datum/language_holder/plant
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/sylvan = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/sylvan = list(LANGUAGE_ATOM))

/datum/language_holder/shadowpeople
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/shadowtongue = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/shadowtongue = list(LANGUAGE_ATOM))
