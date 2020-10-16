/mob/living/carbon/human/proc/austation_wear_examine(mob/user)
	var/t_He = p_they(TRUE)
	var/t_is = p_are()

	if(!ringsoff) // rings
		if(ring_type != RING_DISABLED)
			switch(ring_type)
				if(RING_CASUAL)
					. += "<span class='info'>[t_He] [t_is] wearing a casual ring[ring_engraved ? " with <i>" + ring_engraved + "</i> etched into it" : ""]~</span>"
				if(RING_ENGAGEMENT)
					. += "<span class='info'>[t_He] [t_is] wearing an engagement ring[ring_engraved ? " with <i>" + ring_engraved + "</i> etched into it" : ""]~</span>"
				if(RING_WEDDING)
					. += "<span class='info'>[t_He] [t_is] wearing a wedding ring[ring_engraved ? " with <i>" + ring_engraved + "</i> etched into it" : ""]~</span>"
				if(RING_AUSTRALIUM)
					. += "<span class='info'>[t_He] [t_is] wearing a shiny australium ring[ring_engraved ? " with <i>" + ring_engraved + "</i> etched into it" : ""]~</span>"
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .) // circle game
