/mob/living/carbon/human/verb/toggle_rings()
	set name = "Toggle Ring"
	set category = "IC"
	var/datum/preferences/prefs = client.prefs

	if(ismecha(loc))
		return

	if(incapacitated())
		return

	if(prefs.ring_type != RING_DISABLED)
		if(src.ringsoff == FALSE)
			ringsoff = TRUE
			to_chat(src, "<span class='notice'>You take off your ring.</span>")
		else
			ringsoff = FALSE
			to_chat(src, "<span class='notice'>You put your ring back on.</span>")
	else
		to_chat(src, "<span class='warning'>You don't have any rings.</span>")
