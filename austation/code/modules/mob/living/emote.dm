/datum/emote/living/deathgasp
	cooldown = (5 SECONDS)

/datum/emote/living/laugh
	cooldown = (5 SECONDS)

/datum/emote/beep
	cooldown = (5 SECONDS)

/datum/emote/living/snap
	cooldown = (5 SECONDS)

/datum/emote/living/surrender/run_emote(mob/user, params, type_override, intentional)
	..()
	var/mob/living/L = user
	var/atom/A = L
	var/image/I
	if(L.surrendered)
		I = image('austation/icons/mob/actions/actions.dmi', A, "surrender", A.layer+1)
		L.apply_status_effect(STATUS_EFFECT_PARALYZED)
		L.audible_message("[L.get_examine_name()] puts their hands on their head and falls to the ground, surrendering.")
	else
		I = image('icons/obj/closet.dmi', A, "cardboard_special", A.layer+1)
		addtimer(CALLBACK(src, L.remove_status_effect(STATUS_EFFECT_PARALYZED)), 50)
		L.audible_message("[L.get_examine_name()] suddenly removes their hands from their head and attempts to launch to their feet.")
	flick_overlay_view(I, A, 8)
	I.alpha = 0
	animate(I, pixel_z = 32, alpha = 255, time = 5, easing = ELASTIC_EASING)
