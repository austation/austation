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
	var/list/build_cost

/datum/pipe_info/coilgun/New(label, obj/path, build_cost, dt=PIPE_UNARY)
	name = label
	id = path
	icon_state = initial(path.icon_state)
	dirtype = dt
	for(var/m_path in build_cost) // looks confusing but all this does is convert (material_path = amount) to (material_datum = amount)
		var/datum/material/M = getmaterialref(m_path) || m_path // with a failsafe in case we somehow were already assigned the datum
		src.build_cost[M] = build_cost[m_path]

/datum/pipe_info/coilgun/Params()
	return "cgmake=[id]&type=[dirtype]"

/datum/pipe_info/coilgun/Render(dispenser)
	var/dat = "<li><a href='?src=[REF(dispenser)]&[Params()]'>[name]</a></li>"

	// Stationary pipe dispensers don't allow you to pre-select pipe directions.
	// This makes it impossble to spawn bent versions of bendable pipes.
	// We add a "Bent" pipe type with a preset diagonal direction to work around it.
	// Stationary pipe dispensers also have a build cost for their pipes
	if(istype(dispenser, /obj/machinery/pipedispenser) && (dirtype == PIPE_BENDABLE || dirtype == /obj/item/pipe/binary/bendable))
		var/cost_data
		for(var/datum/material/M in build_cost)
			if(cost_data)
				cost_data += ", "
			cost_data += "[M.name] - [build_cost[M] / MINERAL_MATERIAL_AMOUNT]"
		dat = "<li><a href='?src=[REF(dispenser)]&[Params()]'>[name]</a>[cost_data ? " | [cost_data]" : ""]</li>"
		dat += "<li><a href='?src=[REF(dispenser)]&[Params()]&dir=[NORTHEAST]'>Bent [name]</a>[cost_data ? " | [cost_data]" : ""]</li>"

	return dat
