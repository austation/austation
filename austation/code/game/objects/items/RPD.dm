
GLOBAL_LIST_INIT(coilgun_recipes, list(
	"Coilgun Pipes" = list(
		new /datum/pipe_info/coilgun("Pipe",			/obj/structure/disposalpipe/segment/coilgun, PIPE_BENDABLE),
//		new /datum/pipe_info/coilgun("Junction",		/obj/structure/disposalpipe/junction/coilgun, PIPE_TRIN_M),
		new /datum/pipe_info/coilgun("Magnetizer",		/obj/structure/disposalpipe/coilgun/magnetizer),
		new /datum/pipe_info/coilgun("Cooler",			/obj/structure/disposalpipe/coilgun/cooler),
		new /datum/pipe_info/coilgun("Active Cooler",	/obj/structure/disposalpipe/coilgun/cooler/active),
	)
))

/datum/pipe_info/coilgun/New(label, obj/path, dt=PIPE_UNARY)
	name = label
	id = path

	icon_state = initial(path.icon_state)
	if(ispath(path, /obj/structure/disposalpipe))
		icon_state = "con[icon_state]"

	dirtype = dt

/datum/pipe_info/coilgun/Params()
	return "dmake=[id]&type=[dirtype]"

/obj/item/pipe_dispenser
	var/static/datum/pipe_info/first_coilgun

/*

The following has been moved into the main file due to proc specific variable.

/obj/item/pipe_dispenser/ui_data(mob/user)
	var/au_recipes
	. = ..()
	if(category == COILGUN_CATEGORY)
		recipes = GLOB.coilgun_recipes
*/
/obj/item/pipe_dispenser/ui_act(mob/user)
	. = ..()
	if(category == COILGUN_CATEGORY)
		recipe = first_coilgun

/obj/item/pipe_dispenser/coilgun
	name = "Coilgun dispenser"
	desc = "An advanced device used to construct small to large coilguns. Warrenty void if exposed to magnetic fields."
	category = COILGUN_CATEGORY
	locked = TRUE

/obj/item/pipe_dispenser/plumbing/Initialize()
	. = ..()
	if(!first_coilgun)
		first_plumbing = GLOB.coilgun_recipes[GLOB.coilgun_recipes[1]][1]
	recipe = first_coilgun

/// coilgun dispensing works the same way as disposals, this saves us the trouble of touching main code.
/obj/item/pipe_dispenser/coilgun/pre_attack(atom/A, mob/user)
	category = DISPOSALS_CATEGORY
	..()
	category = COILGUN_CATEGORY

#undef DISPOSALS_CATEGORY
