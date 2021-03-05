//Holds the jumping spell for the roos

/obj/effect/proc_holder/spell/targeted/leap
	name = "Jump"
	desc = "Leap great distances!"
	panel = "Abilities"
	range = -1
	include_user = 1

	charge_type = "recharge"
	charge_max = 60

	clothes_req = 0
	stat_allowed = 0
	invocation_type = "none"

	action_icon = 'austation/icons/mob/actions/actions.dmi'
	action_icon_state = "genetic_jump"

/obj/effect/proc_holder/spell/targeted/leap/cast(list/targets, mob/living/user = usr)
	var/failure = FALSE
	if(istype(user.loc,/mob/living) || user.lying || user.IsStun() || user.buckled || user.stat)
		to_chat(user, "<span class='warning'>You can't jump right now!</span>")
		return

	if(istype(user.loc,/turf/))
		if(user.restrained())//Why being pulled while cuffed prevents you from moving
			for(var/mob/living/M in range(user, 1))
				if(M.pulling == user)
					if(!M.restrained() && M.stat == 0 && M.mobility_flags & MOBILITY_MOVE && user.Adjacent(M))
						failure = TRUE
					else
						M.stop_pulling()

		user.visible_message("<span class='danger'>[user.name]</b> takes a huge leap!</span>")
		playsound(user.loc, 'sound/weapons/thudswoosh.ogg', 50, 1)
		if(failure)
			user.Stun(5)
			user.visible_message("<span class='warning'>[user] attempts to leap away but is slammed back down to the ground!</span>",
								"<span class='warning'>You attempt to leap away but are suddenly slammed back down to the ground!</span>",
								"<span class='notice'>You hear the flexing of powerful muscles and suddenly a crash as a body hits the floor.</span>")
			return FALSE

		var/prevLayer = user.layer
		var/prevmovtype = user.movement_type

		user.layer = 9
		user.movement_type = FLYING
		for(var/i=0, i<10, i++)
			step(user, user.dir)
			if(i < 5) user.pixel_y += 8
			else user.pixel_y -= 8
			sleep(1)

		user.movement_type = prevmovtype
		user.layer = prevLayer

	if(istype(user.loc,/obj/))
		var/obj/container = user.loc
		to_chat(user, "<span class='warning'>You leap and slam your head against the inside of [container]! Ouch!</span>")
		user.Knockdown(3)
		user.adjustStaminaLoss(5)
		container.visible_message("<span class='danger'>[user.loc]</b> emits a loud thump and rattles a bit.</span>")
		playsound(user.loc, 'sound/effects/bang.ogg', 50, 1)
		var/wiggle = 6
		while(wiggle > 0)
			wiggle--
			container.pixel_x = rand(-3,3)
			container.pixel_y = rand(-3,3)
			sleep(1)
		container.pixel_x = 0
		container.pixel_y = 0
