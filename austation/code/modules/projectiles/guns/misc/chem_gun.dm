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
	allowedchems = typesof(/datum/reagent/medicine) + typesof(/datum/reagent/vaccine) + typesof(/datum/reagent/water) //easier to define allowed chems then to blacklist them
	allowedchems.Remove(/datum/reagent/medicine/morphine, /datum/reagent/medicine/silver_sulfadiazine, /datum/reagent/medicine/styptic_powder) //these are considered medicine but arent beneficial
	create_reagents(120, OPENCONTAINER)

// chem check

/obj/item/gun/chem/medical/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/reagent_containers))
		for(var/datum/reagent/R in I.reagents.reagent_list)
			if(R.type in allowedchems)

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
