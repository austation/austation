/obj/machinery/door/poddoor/shutters
	gender = PLURAL
	name = "shutters"
	desc = "Heavy duty metal shutters that open mechanically."
	icon = 'icons/obj/doors/shutters.dmi'
	layer = SHUTTER_LAYER
	closingLayer = SHUTTER_LAYER
	damage_deflection = 20

/obj/machinery/door/poddoor/shutters/preopen
	icon_state = "open"
	density = FALSE
	obj_flags = CAN_BE_HIT // reset zblock
	opacity = 0

/obj/machinery/door/poddoor/shutters/indestructible
	name = "hardened shutters"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
<<<<<<< HEAD
=======

/obj/machinery/door/poddoor/shutters/bumpopen()
	return

/obj/machinery/door/poddoor/shutters/radiation
	name = "radiation shutters"
	desc = "Depleted uranium-lined shutters with a radiation hazard symbol. Whilst this won't stop you getting irradiated, especially by a supermatter crystal, it will stop the majority of radiation."
	base_state = "rad"
	icon_state = "rad_closed"
	rad_insulation = RAD_EXTREME_INSULATION
	recipe_type = /datum/crafting_recipe/radshutters

/obj/machinery/door/poddoor/shutters/radiation/preopen
	icon_state = "rad_open"
	density = FALSE
	opacity = FALSE
	rad_insulation = RAD_NO_INSULATION
	obj_flags = CAN_BE_HIT // reset zblock

/obj/machinery/door/poddoor/shutters/radiation/open()
	. = ..()
	rad_insulation = RAD_NO_INSULATION

/obj/machinery/door/poddoor/shutters/radiation/close()
	. = ..()
	rad_insulation = RAD_EXTREME_INSULATION

/obj/machinery/door/poddoor/shutters/window
	name = "windowed shutters"
	desc = "A shutter with a thick see-through polycarbonate window."
	base_state = "win"
	icon_state = "win_closed"
	opacity = FALSE
	glass = TRUE
	recipe_type = /datum/crafting_recipe/glassshutters

/obj/machinery/door/poddoor/shutters/window/preopen
	icon_state = "win_open"
	density = FALSE
	obj_flags = CAN_BE_HIT // reset zblock
>>>>>>> e100ff7a7f (MultiZ and Shuttle fixes and improvements (#8594))
