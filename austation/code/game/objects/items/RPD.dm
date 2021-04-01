/obj/item/pipe_dispenser/coilgun
	name = "Rapid Magnetic Pipe Dispenser (RMPD)"
	desc = "A device used to rapidly pipe things to rapidly accelerate things."
	w_class = WEIGHT_CLASS_BULKY
	materials = list(/datum/material/iron=75000, /datum/material/glass=37500, /datum/material/copper=100000)
	category = COILGUN_CATEGORY
//	locked = TRUE
	var/static/datum/pipe_info/first_coilgun

/obj/item/pipe_dispenser/coilgun/Initialize()
	. = ..()
	spark_system = new
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)
	if(!first_coilgun) // austation -- coilguns
		first_coilgun = GLOB.coilgun_pipe_recipes[GLOB.coilgun_pipe_recipes[1]][1]

	recipe = first_coilgun

/obj/item/pipe_dispenser/coilgun/ui_act(action, params)
	if(!..())
		return FALSE
	if(action == "category" && category == COILGUN_CATEGORY)
		recipe = first_coilgun
	return TRUE
