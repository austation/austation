/obj/item/gun/chem/medical
	name = "medical darter"
	desc = "A specialised dart gun that synthesizes its own darts, must be loaded directly with chemicals, the gun will refuse any potentially harmful chemicals, holds 120 units"
	icon_state = "chemgun"
	item_state = "chemgun"
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 3
	throw_range = 7
	color = rgb(0,255,255) //cyan
	force = 4
	materials = list(/datum/material/iron=2000)
	clumsy_check = FALSE
	fire_sound = 'sound/items/syringeproj.ogg'
	fire_rate = 1
	time_per_syringe = 200
	syringes_left = 6
	max_syringes = 6
	last_synth = 0
	casing = /obj/item/ammo_casing/chemgun/medical
	var/list/allowedchems

/obj/item/gun/chem/medical/Initialize()
	. = ..()

	allowedchems = typesof(/datum/reagent/medicine) + typesof(/datum/reagent/vaccine) + typesof(/datum/reagent/water) + typesof(/datum/reagent/pax) //easier to define allowed chems then to blacklist them


	chambered = new casing(src)
	START_PROCESSING(SSobj, src)
	create_reagents(120, OPENCONTAINER)

/obj/item/gun/chem/medical/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/gun/chem/medical/can_shoot()
	return syringes_left

/obj/item/gun/chem/medical/process_chamber()
	if(chambered && !chambered.BB && syringes_left)
		chambered.newshot()

/obj/item/gun/chem/medical/process()
	if(syringes_left >= max_syringes)
		return
	if(world.time < last_synth+time_per_syringe)
		return
	to_chat(loc, "<span class='warning'>You hear a click as the [src] synthesizes a new dart.</span>")
	syringes_left++
	if(chambered && !chambered.BB)
		chambered.newshot()
	last_synth = world.time

// chem check

/obj/item/gun/chem/medical/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/reagent_containers))
		for(var/datum/reagent/R in I.reagents.reagent_list)
			if(R.type in allowedchems)
				return FALSE
			else
				to_chat(user, "<span class='notice'>The dart gun refuses as [I] has harmful chemicals.</span>")
				return TRUE

// ammo stuff
/obj/item/projectile/bullet/dart/medical
	name = "medicated dart"
	icon_state = "cbbolt"
	damage = 1

/obj/item/ammo_casing/chemgun/medical
	name = "dart synthesiser"
	desc = "A high-power spring, linked to an energy-based dart synthesiser."
	projectile_type = /obj/item/projectile/bullet/dart/medical
	firing_effect_type = null
