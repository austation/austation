/obj/machinery/nuclearbomb/Bumped(atom/A)
	if(istype(A, /obj/item/projectile/hvp))
		var/obj/item/projectile/hvp/hvp = A
		if(locate(/obj/item/disk/nuclear) in hvp.contents)
			if(hvp.momentum >= 10000) // come on and slam, and welcome to the jam
				safety = FALSE
				timer_set = 360
				set_active()
				hvp.momentum -= 10000
			else
				var/obj/item/reagent_containers/food/snacks/cookie/sad = new(get_turf(src))
				sad.name = "consolation cookie"
				sad.desc = "You tried.."
				playsound(src, 'sound/misc/sadtrombone.ogg', 50) // :(
