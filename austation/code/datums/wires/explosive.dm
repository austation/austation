/datum/wires/explosive/minibomb
	holder_type = /obj/item/grenade/syndieminibomb
	randomize = TRUE	//Same behaviour since no wire actually disarms it

/datum/wires/explosive/minibomb/interactable(mob/user)
	var/obj/item/grenade/syndieminibomb/P = holder
	if(P.open_panel)
		return TRUE

/datum/wires/explosive/minibomb/explode()
	var/obj/item/grenade/syndieminibomb/P = holder
	P.prime()
