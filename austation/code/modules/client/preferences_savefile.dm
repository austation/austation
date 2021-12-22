// Oh god I am going to regret messing with saves
/datum/preferences/update_character(current_version, savefile/S)
	. = ..()
	if(current_version < 32) // rings
		ring_type = RING_DISABLED
		ring_engraved = null
