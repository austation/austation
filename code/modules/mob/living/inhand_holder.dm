//Generic system for picking up mobs.
//Currently works for head and hands.
/obj/item/clothing/head/mob_holder
	name = "bugged mob"
	desc = "Yell at coderbrush."
	icon = null
	icon_state = ""
	slot_flags = NONE
	clothing_flags = NOTCONSUMABLE
	var/mob/living/held_mob
	var/can_head = TRUE
	var/destroying = FALSE

/obj/item/clothing/head/mob_holder/Initialize(mapload, mob/living/M, worn_state, head_icon, lh_icon, rh_icon, worn_slot_flags = NONE)
	. = ..()
	if(head_icon)
		worn_icon = head_icon
	if(worn_state)
		item_state = worn_state
	if(lh_icon)
		lefthand_file = lh_icon
	if(rh_icon)
		righthand_file = rh_icon
	if(worn_slot_flags)
		slot_flags = worn_slot_flags
	deposit(M)

/obj/item/clothing/head/mob_holder/Destroy()
	destroying = TRUE
	if(held_mob)
		release(FALSE)
	return ..()

/obj/item/clothing/head/mob_holder/proc/deposit(mob/living/L)
	if(!istype(L))
		return FALSE
	L.setDir(SOUTH)
	update_visuals(L)
	held_mob = L
	L.forceMove(src)
	name = L.name
	desc = L.desc
	return TRUE

/obj/item/clothing/head/mob_holder/proc/update_visuals(mob/living/L)
	appearance = L.appearance

/obj/item/clothing/head/mob_holder/dropped(mob/user, thrown = FALSE)
	..()
	if(held_mob && isturf(loc) && !thrown)
		release()

/obj/item/clothing/head/mob_holder/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	. = ..()
	release()

/obj/item/clothing/head/mob_holder/proc/release(del_on_release = TRUE)
	if(!held_mob)
		if(del_on_release && !destroying)
			qdel(src)
		return FALSE
	if(isliving(loc))
		var/mob/living/L = loc
		to_chat(L, "<span class='warning'>[held_mob] wriggles free!</span>")
		L.dropItemToGround(src)
	held_mob.forceMove(get_turf(held_mob))
	held_mob.reset_perspective()
	held_mob.setDir(SOUTH)
	held_mob.visible_message("<span class='warning'>[held_mob] uncurls!</span>")
	held_mob = null
	if(del_on_release && !destroying)
		qdel(src)
	return TRUE

/obj/item/clothing/head/mob_holder/relaymove(mob/user)
	release()

/obj/item/clothing/head/mob_holder/container_resist()
	release()

/obj/item/clothing/head/mob_holder/drone/deposit(mob/living/L)
	. = ..()
	if(!isdrone(L))
		qdel(src)
	name = "drone (hiding)"
	desc = "This drone is scared and has curled up into a ball!"

/obj/item/clothing/head/mob_holder/drone/update_visuals(mob/living/L)
	var/mob/living/simple_animal/drone/D = L
	if(!D)
		return ..()
	icon = 'icons/mob/drone.dmi'
	icon_state = "[D.visualAppearance]_hat"
