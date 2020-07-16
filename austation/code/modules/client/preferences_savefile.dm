// Oh god I am going to regret messing with saves
/datum/preferences/update_character(current_version, savefile/S)
	. = ..()
	if(current_version < 31) // jumpskirts
		jumpsuit_style = PREF_SUIT
