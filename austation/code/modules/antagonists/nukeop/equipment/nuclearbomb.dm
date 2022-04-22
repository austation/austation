/obj/machinery/nuclearbomb/hvp_act(obj/item/projectile/hvp/PJ, severe = FALSE)
	var/obj/item/disk/nuclear/ND = locate() in PJ.contents
	if(!ND)
		return ..()
	if(PJ.momentum >= 2000) // come on and slam, and welcome to the jam
		safety = FALSE
		timer_set = 360
		set_active()
		PJ.momentum -= 2000
	else
		var/obj/item/reagent_containers/food/snacks/cookie/sad = new(get_turf(src))
		sad.name = "consolation cookie"
		sad.desc = "You tried.."
		playsound(src, 'sound/misc/sadtrombone.ogg', 50) // :(
	return TRUE

/obj/machinery/nuclearbomb/Initialize(mapload)
	..()
	var/turf/current_turf = get_turf(src)
	var/z_level = current_turf.z
	if(GLOB.master_mode == "siege" && z_level == 9)//is_centcom_level doesnt work
		new /obj/machinery/siege_spawner(src)
		qdel(src)

/obj/machinery/nuclearbomb/ui_act(action, params)
	if(..())
		return
	if(GLOB.master_mode == "siege")
		if(ROLE_SYNDICATE in usr.faction)
			if(!timing)
				detonation_timer = 90
				safety = FALSE
				set_active()
		else if(timing)
			set_active()
