/mob/living/carbon/examine(mob/user)
	. = ..()
	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .) // circle game
