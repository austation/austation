GLOBAL_LIST_INIT(coilgun_pipe_recipes, list(
	"Coilgun Pipes" = list(
		new /datum/pipe_info/coilgun("Pipe",			/obj/structure/disposalpipe/segment/coilgun, PIPE_BENDABLE),
		new /datum/pipe_info/coilgun("Junction",		/obj/structure/disposalpipe/junction/coilgun, PIPE_TRIN_M),
		new /datum/pipe_info/coilgun("Y-Junction",		/obj/structure/disposalpipe/junction/yjunction/coilgun),
	),
	"Coilgun Devices" = list(
		new /datum/pipe_info/coilgun("Charger",			/obj/structure/disposalpipe/coilgun/charger),
		new /datum/pipe_info/coilgun("Super-Charger",	/obj/structure/disposalpipe/coilgun/super_charger),
		new /datum/pipe_info/coilgun("Magnetizer",		/obj/structure/disposalpipe/coilgun/magnetizer),
		new /datum/pipe_info/coilgun("Passive Cooler",	/obj/structure/disposalpipe/coilgun/cooler),
		new /datum/pipe_info/coilgun("Active Cooler",	/obj/structure/disposalpipe/coilgun/cooler/active),
		new /datum/pipe_info/coilgun("Barrel",			/obj/structure/disposalpipe/coilgun/barrel),

	)
))
