/obj/item/gun/shoot_live_shot(mob/living/user, pointblank = 0, atom/pbtarget = null, message = 1)
	if(suppressed)
		playsound(user, suppressed_sound, suppressed_volume, vary_fire_sound)
	else
		playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
		if(message)
			if(pointblank)
				user.visible_message("<span class='danger'>[user] fires [src] point blank at [pbtarget]!</span>", \
								"<span class='danger'>You fire [src] point blank at [pbtarget]!</span>", \
								"<span class='hear'>You hear a gunshot!</span>", COMBAT_MESSAGE_RANGE, pbtarget)
				to_chat(pbtarget, "<span class='userdanger'>[user] fires [src] point blank at you!</span>")
				if(pb_knockback > 0 && ismob(pbtarget))
					var/mob/PBT= pbtarget
					var/atom/throw_target = get_edge_target_turf(PBT, user.dir)
					PBT.throw_at(throw_target, pb_knockback, 2)
			else
				user.visible_message("<span class='danger'>[user] fires [src]!</span>", \
								"<span class='danger'>You fire [src]!</span>", \
								"<span class='hear'>You hear a gunshot!</span>", COMBAT_MESSAGE_RANGE)
