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
