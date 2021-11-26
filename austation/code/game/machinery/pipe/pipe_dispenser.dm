/obj/machinery/pipedispenser/disposal/coilgun
	name = "coilgun pipe dispenser"
	desc = "Dispenses the parts needed to construct a functional coilgun. Warrenty void if exposed to magnetic fields"
	var/maxmats = 500000

/obj/machinery/pipedispenser/disposal/coilgun/Initialize()
	. = ..()
	AddComponent(/datum/component/material_container, list(/datum/material/iron, /datum/material/copper, /datum/material/gold), maxmats, TRUE)

/obj/machinery/pipedispenser/disposal/coilgun/Destroy()
	var/datum/component/material_container/MC = GetComponent(/datum/component/material_container)
	MC.retrieve_all(loc) // drop all mats on the ground
	MC.RemoveComponent()
	return ..()

/obj/machinery/pipedispenser/disposal/coilgun/interact(mob/user)

	var/dat = "Materials:<ul>"
	var/datum/component/material_container/MC = GetComponent(/datum/component/material_container)
	for(var/i in MC.materials)
		var/datum/material/M = i
		dat += "[M.name] - [MC.materials[i]] \[<a href='?src=[REF(src)];mateject=[REF(M)]'>Eject</a>\]"
	dat += "</ul>"
	var/recipes = GLOB.coilgun_pipe_recipes
	for(var/category in recipes)
		dat += "<b>[category]:</b><ul>"
		for(var/datum/pipe_info/I as() in recipes[category])
			dat += I.Render(src)

		dat += "</ul>"

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")

/obj/machinery/pipedispenser/disposal/coilgun/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	add_fingerprint(usr)
	if(href_list["cgmake"])
		if(wait < world.time)
			var/p_type = text2path(href_list["cgmake"])
			if (!verify_recipe(GLOB.coilgun_pipe_recipes, p_type))
				return
			var/datum/component/material_container/MC = GetComponent(/datum/component/material_container)
			var/list/buildcost = href_list["matcost"]
			for(var/datum/material/M in buildcost)
				if(!MC.has_enough_of_material(M, buildcost[M]))
					to_chat(usr, "<span class='warning'>Insufficient resources.</span>")
					return
			var/obj/structure/disposalconstruct/coilgun/C = new (loc, p_type)

			if(!C.can_place())
				to_chat(usr, "<span class='warning'>There's not enough room to build that here!</span>")
				qdel(C)
				return
			if(href_list["dir"])
				C.setDir(text2num(href_list["dir"]))
			C.add_fingerprint(usr)
			C.update_icon()
			wait = world.time + 15
	if(href_list["mateject"])
		var/datum/material/M = href_list["mateject"]
		var/datum/component/material_container/MC = GetComponent(/datum/component/material_container)
		MC.retrieve_sheets(MC.materials[M], M, loc)

