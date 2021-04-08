/*
	* Most of coilgun RPD construction code is unmodularized due to proc complexity
	* Everything else can be found in code/game/objects/items/RPD.dm in the main directory
*/
/obj/item/pipe_dispenser/coilgun
	name = "Rapid Magnetic Pipe Dispenser (RMPD)"
	desc = "A device used to rapidly pipe things to rapidly accelerate things."
	w_class = WEIGHT_CLASS_BULKY
	materials = list(/datum/material/iron=75000, /datum/material/glass=37500, /datum/material/copper=100000)
	category = COILGUN_CATEGORY
	locked = TRUE

/obj/item/pipe_dispenser/coilgun/Initialize()
	. = ..()
	spark_system = new
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	if(!first_coilgun)
		first_coilgun = GLOB.coilgun_pipe_recipes[GLOB.coilgun_pipe_recipes[1]][1]
	recipe = first_coilgun
