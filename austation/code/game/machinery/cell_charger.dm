/obj/machinery/cell_charger
	icon = 'austation/icons/obj/power.dmi'

/obj/machinery/cell_charger/update_icon()
	cut_overlays()
	if(charging)
		add_overlay(image(charging.icon, charging.icon_state))
		add_overlay("ccharger-on")
		if(!(stat & (BROKEN|NOPOWER)))
			var/newlevel = 	round(charging.percent() * 4 / 100)
			chargelevel = newlevel
			add_overlay("ccharger-o[newlevel]")
