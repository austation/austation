/obj/item/gun/ballistic/rack(mob/user = null)
	switch(bolt_type)
		if(BOLT_TYPE_NO_BOLT)
			return
		if(BOLT_TYPE_OPEN)
			if(!bolt_locked)	//If it's an open bolt, racking again would do nothing
				if(user)
					to_chat(user, "<span class='notice'>\The [src]'s [bolt_wording] is already cocked!</span>")
				return
			bolt_locked = FALSE
	if(user)
		to_chat(user, "<span class='notice'>You rack the [bolt_wording] of \the [src].</span>")
	process_chamber(!chambered, FALSE)
	if (bolt_type == BOLT_TYPE_LOCKING && !chambered)
		bolt_locked = TRUE
		playsound(src, lock_back_sound, lock_back_sound_volume, lock_back_sound_vary)
	else
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
	update_icon()
