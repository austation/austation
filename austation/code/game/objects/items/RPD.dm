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

/datum/pipe_info/coilgun
	var/list/build_cost = list()
	var/material_init = FALSE // Have we fully initialized our material list yet?

/datum/pipe_info/coilgun/New(label, obj/path, build_cost, dt=PIPE_UNARY)
	name = label
	id = path
	icon_state = initial(path.icon_state)
	dirtype = dt
	src.build_cost = build_cost

/datum/pipe_info/coilgun/Params()
	return "cgmake=[id]&type=[dirtype]"

// sufficient_resources set to false will make the resource display text red
/datum/pipe_info/coilgun/Render(dispenser, sufficient_resources = TRUE)
	var/dat = "<li><a href='?src=[REF(dispenser)]&[Params()]'>[name]</a></li>"

	// Stationary pipe dispensers don't allow you to pre-select pipe directions.
	// This makes it impossble to spawn bent versions of bendable pipes.
	// We add a "Bent" pipe type with a preset diagonal direction to work around it.
	// Stationary pipe dispensers also have a build cost for their pipes
	if(istype(dispenser, /obj/machinery/pipedispenser))
		var/cost_data
		for(var/datum/material/M in build_cost)
			if(cost_data)
				cost_data += ", "
			cost_data += "[M.name]-[build_cost[M]]"
		if(!sufficient_resources && cost_data)
			cost_data = "<font color='red>[cost_data]</font>"
		dat = "<li><a href='?src=[REF(dispenser)]&[Params()]'>[name]</a>[cost_data ? " | [cost_data]" : ""]</li>"
		if(dirtype == PIPE_BENDABLE)
			dat += "<li><a href='?src=[REF(dispenser)]&[Params()]&dir=[NORTHEAST]'>Bent [name]</a>[cost_data ? " | [cost_data]" : ""]</li>"

	return dat

// All this does is convert (material_path = amount) to (material_datum = amount). We can't do it on New() because SSmaterials isn't initialized.
/datum/pipe_info/coilgun/proc/initialize_materials()
	if(material_init)
		return
	var/list/NBC = list() // new build cost
	for(var/m_path in build_cost)
		var/datum/material/M = getmaterialref(m_path)
		NBC[M] = build_cost[m_path]
	build_cost = NBC
	material_init = TRUE
