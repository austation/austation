/////////////////////
// Tile reskinning //
/////////////////////
// Q: What is this?
// A: A simple function to allow you to change what tiles you place with a stack of tiles.
// Q: Why do it this way?
// A: This allows players more freedom to do beautiful-looking builds. Having five types of titanium tile would be clunky as heck.
// Q: Great! Can I use this for all floors?
// A: Unfortunately, this does not work on subtypes of plasteel and instead we must change the icon_state of these turfs instead, as the icon_regular_floor var that "saves" what type of floor a plasteel subtype turf was so once repaired...
// ... it'll go back to the floor it was instead of grey (medical floors turn white even after crowbaring the tile and putting it back). This stops changing turf_type from working.

/obj/item/stack/tile/plasteel
	desc = "Metal tiles that can be placed on top of plating. Press Z or use these to change tiles."
	var/tile_reskin_mode
	tile_reskin_mode = "plasteel"
	icon = 'austation/icons/obj/tile_paint.dmi'
	icon_state = "tile_plasteel"

/obj/item/stack/tile/plasteel/attack_self(mob/user)
	var/static/list/choices = list(
			"Plasteel" = image(icon = 'austation/icons/obj/tile_paint.dmi', icon_state = "tile_plasteel"),
			"White Plasteel" = image(icon = 'austation/icons/obj/tile_paint.dmi', icon_state = "tile_white"),
			"Dark Plasteel" = image(icon = 'austation/icons/obj/tile_paint.dmi', icon_state = "tile_dark"),
			"Shower" = image(icon = 'austation/icons/obj/tile_paint.dmi', icon_state = "tile_shower"),
			"Freezer" = image(icon = 'austation/icons/obj/tile_paint.dmi', icon_state = "tile_freezer"),
			"Kitchen" = image(icon = 'austation/icons/obj/tile_paint.dmi', icon_state = "tile_kitchen"),
			"Grimy" = image(icon = 'austation/icons/obj/tile_paint.dmi', icon_state = "tile_grimy"),
			"Solar Panel" = image(icon = 'austation/icons/obj/tile_paint.dmi', icon_state = "tile_solar")
		)
	var/choice = show_radial_menu(user, src, choices, radius = 48, require_near = TRUE)
	switch(choice)
		if("Plasteel")
			turf_type = /turf/open/floor/plasteel
			tile_reskin_mode = "plasteel"
			icon_state = "tile_plasteel"
		if("White Plasteel")
			turf_type = /turf/open/floor/plasteel/white
			tile_reskin_mode = "white plasteel"
			icon_state = "tile_white"
		if("Dark Plasteel")
			turf_type = /turf/open/floor/plasteel/dark
			tile_reskin_mode = "dark plasteel"
			icon_state = "tile_dark"
		if("Shower")
			turf_type = /turf/open/floor/plasteel/showroomfloor
			tile_reskin_mode = "shower"
			icon_state = "tile_shower"
		if("Freezer")
			turf_type = /turf/open/floor/plasteel/freezer
			tile_reskin_mode = "freezer"
			icon_state = "tile_freezer"
		if("Kitchen")
			turf_type = /turf/open/floor/plasteel/cafeteria
			tile_reskin_mode = "kitchen"
			icon_state = "tile_kitchen"
		if("Grimy")
			turf_type = /turf/open/floor/plasteel/grimy
			tile_reskin_mode = "grimy"
			icon_state = "tile_grimy"
		if("Solar Panel")
			turf_type = /turf/open/floor/plasteel/airless/solarpanel
			tile_reskin_mode = "solar"
			icon_state = "tile_solar"

/turf/open/floor/plasteel/attackby(obj/item/reskinstack, mob/user, params)
	if(istype(reskinstack, /obj/item/stack/tile/plasteel))
		var/obj/item/stack/tile/plasteel/hitfloor = reskinstack
		switch(hitfloor.tile_reskin_mode)
			if("plasteel")
				icon_state = "floor"
				icon_regular_floor = "floor"
			if("white plasteel")
				icon_state = "white"
				icon_regular_floor = "white"
			if("dark plasteel")
				icon_state = "darkfull"
				icon_regular_floor = "darkfull"
			if("shower")
				icon_state = "showroomfloor"
				icon_regular_floor = "showroomfloor"
			if("freezer")
				icon_state = "freezerfloor"
				icon_regular_floor = "freezerfloor"
			if("kitchen")
				icon_state = "cafeteria"
				icon_regular_floor = "cafeteria"
			if("grimy")
				icon_state = "grimy"
				icon_regular_floor = "grimy"
			if("solar")
				icon_state = "solarpanel"
				icon_regular_floor = "solarpanel"
			else return
