// Min speed required to merge an object into the projectile
#define MIN_SPEED 1000

/obj/structure/disposalpipe/coilgun/modifier
	name = "kinetic infuser"
	desc = "A heavy duty coilgun component capable of kinetically infusing two different objects together at high speeds"

/obj/structure/disposalpipe/coilgun/modifier/transfer(obj/structure/disposalholder/H)
	if(!length(H.contents))
		qdel(H)
		return
	for(var/atom/movable/AM in H.contents)
		if(istype(AM, /obj/item/projectile/hvp))
			var/obj/item/projectile/hvp/PJ = AM
			combine(PJ)
		else
			visible_message("<span class='warning'>\The [src]'s safety mechanism engages, ejecting [AM] through the maintenance hatch!</span>")
			AM.forceMove(get_turf(src))
	return ..()

/obj/structure/disposalpipe/coilgun/modifier/attackby(obj/item/O, mob/user, params)
	..()
	if(anchored && O.tool_behaviour == TOOL_WELDER || O.tool_behaviour == TOOL_WRENCH)
		return
	if(user.transferItemToLoc(O, src))
		to_chat(user, "<span class='warning'>You insert \the [O] into \the [src]'s object bay")
	else
		to_chat(user, "<span class='warning'>You can't seem to safely insert \the [O]!")

/// Handles item merging inside the modifier
/obj/structure/disposalpipe/coilgun/modifier/proc/combine(obj/item/projectile/hvp/PJ)
	if(!length(contents)) // We have no object to merge
		return
	for(var/obj/O in contents)
		if(length(contents) > 1) // eject objects inside of us until there's only one, if there were somehow multiple
			O.forceMove(get_turf(src))
			continue
		var/req_speed = max(PJ.mass * 150, MIN_SPEED)
		if(PJ.velocity < req_speed)
			continue
		playsound(src, 'sound/effects/bang.ogg', 50, 0, 0)
		PJ.velocity -= req_speed * 0.5
		PJ.add_object(O)
		break


#undef MIN_SPEED
