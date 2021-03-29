/obj/machinery/pipedispenser/disposal/coilgun
	name = "coilgun pipe dispenser"
	desc = "Dispenses the parts needed to construct a functional coilgun. Warrenty void if exposed to magnetic fields"

/obj/machinery/pipedispenser/disposal/coilgun/interact(mob/user)

	var/dat = ""
	var/recipes = GLOB.coilgun_pipe_recipes
	for(var/category in recipes)
		var/list/cat_recipes = recipes[category]
		dat += "<b>[category]:</b><ul>"

		for(var/datum/pipe_info/I in cat_recipes)
			dat += I.Render(src)

		dat += "</ul>"

	user << browse("<HEAD><TITLE>[src]</TITLE></HEAD><TT>[dat]</TT>", "window=pipedispenser")
