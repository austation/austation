/mob/living/carbon/human/proc/austation_wear_examine(mob/user)
	var/t_He = p_they(TRUE)
	var/t_is = p_are()


	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .) // circle game
	if(client) // rings
		var/datum/preferences/prefs = client.prefs // store datum for faster access
		if(prefs.ring_type != RING_DISABLED)
			switch(prefs.ring_type)
				if(RING_CASUAL)
					. += "<span class='info'>[t_He] [t_is] wearing a casual ring[prefs.ring_engraved ? " with " + prefs.ring_engraved + "'s name etched into it" : ""]~</span>"
				if(RING_ENGAGEMENT)
					. += "<span class='info'>[t_He] [t_is] wearing an engagement ring[prefs.ring_engraved ? " with " + prefs.ring_engraved + "'s name etched into it" : ""]~</span>"
				if(RING_WEDDING)
					. += "<span class='info'>[t_He] [t_is] wearing a wedding ring[prefs.ring_engraved ? " with " + prefs.ring_engraved + "'s name etched into it" : ""]~</span>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .) // circle game
