/*
	* Most of coilgun RPD construction code is unmodularized due to proc complexity
	* Everything else can be found in code/game/objects/items/RPD.dm in the main directory
*/
/obj/item/pipe_dispenser/coilgun
	name = "\improper Rapid Magnetic Pipe Dispenser (RMPD)"
	desc = "A device used to rapidly pipe things to rapidly accelerate things."
	w_class = WEIGHT_CLASS_BULKY
	materials = list(/datum/material/iron=75000, /datum/material/glass=37500, /datum/material/copper=100000)
	category = COILGUN_CATEGORY
	locked = TRUE

/obj/item/pipe_dispenser/coilgun/Initialize()
	. = ..()
	if(!first_coilgun)
		first_coilgun = GLOB.coilgun_pipe_recipes[GLOB.coilgun_pipe_recipes[1]][1]
	recipe = first_coilgun

/datum/pipe_info/coilgun/New(label, obj/path, dt=PIPE_UNARY)
	name = label
	id = path
	icon_state = initial(path.icon_state)
	dirtype = dt

/datum/pipe_info/coilgun/Params()
	return "dmake=[id]&type=[dirtype]"
