// autism rod launching thingo mibob
/obj/structure/disposalpipe/coilgun
	name = "coilgun tube"
	desc = "A special tube that allows the safe transportation of high speed magnetic projectiles"
	icon = 'austation/icons/obj/railgun.dmi'
	icon_state = "coil"

/obj/structure/disposalpipe/coilgun/magnetizer
	name = "magnetizer"
	desc = "A machine that glazes inserted objects with neodymium, making the object magnetive"
	icon = 'austation/icons/obj/railgun.dmi'
	icon_state = "magnet"


/obj/structure/disposalpipe/coilgun/magnetizer/transfer(obj/structure/disposalholder/H) // what do you mean it looks like loafer code?

	if(H.contents.len) // is there an object in here?

		icon_state = "amagnet"
		update_icon()
		var/obj/item/projectile/coilshot/boolet =  new(H)

		for(var/atom/movable/AM in H.contents)
			if(AM == boolet)
				continue

			if(isliving(AM))
				var/mob/living/L = AM
				L.adjustBruteLoss(30)
				if(ishuman(L) && !isdead(L))
					L.Paralyze(amount = 50, ignore_canstun = TRUE)
					L.emote("scream")
					boolet.mass == 5
					sleep(30)
					continue

			if(isitem(AM))
				var/obj/item/I = AM
				if(I.w_class)
					boolet.mass == I.w_class
					playsound(src.loc, 'sound/machines/ping.ogg', 40, 1)
					continue
				else
					qdel(boolet)
					qdel(I)
					continue

			boolet.name = AM.name
			boolet.desc = AM.desc
			boolet.icon = AM.icon
			boolet.icon_state = AM.icon_state
			AM.loc = boolet //put the original inserted objected inside the coilgun projectile to drop on deletion



	return ..()
