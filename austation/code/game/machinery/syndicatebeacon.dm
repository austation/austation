
/obj/item/sbeacondrop/deathsky
	desc = "A label on it reads: <i>Warning: Activating this device will send a rogue murder bot to your location</i>."
	var/used = FALSE
	droptype = /mob/living/simple_animal/bot/secbot/deathsky

/obj/item/sbeacondrop/deathsky/attack_self(mob/user)
	if(user && !used)
		used = TRUE
		to_chat(user, "<span class='warning'>Locked In, Run away while you can!</span>")
		sleep(50)
		new droptype(loc)
		playsound(src, 'sound/effects/pop.ogg', 100, 1, 1)
		to_chat(user, "<span class='warning'>You feel a horrible chill go down your spine.</span>")
		qdel(src)
	return
