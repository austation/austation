/datum/chemical_reaction/New()
	. = ..()
	SSticker.OnRoundstart(CALLBACK(src,.proc/update_info))

/**
  * Updates information during the roundstart
  *
  * This proc is mainly used by explosives but can be used anywhere else
  * You should generally use the special reactions in [/datum/chemical_reaction/randomized]
  * But for simple variable edits, like changing the temperature or adding/subtracting required reagents it is better to use this.
  */

/datum/chemical_reaction/proc/update_info()
	return

