/mob/living/carbon/human/proc/austation_wear_examine(mob/user)
	var/t_He = p_they(TRUE)
	var/t_is = p_are()


	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .) // circle game

