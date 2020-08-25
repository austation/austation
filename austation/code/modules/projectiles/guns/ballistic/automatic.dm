/obj/item/gun/ballistic/automatic/huot //pretty good, tho good luck spraying this without jamming
	name = "Huot-Ross Conversion Rifle"
	desc = "Converted from the poor-quality Ross rifle, this automatic rifle fires .303 bullets in a very innacurate manner. Prone to jamming,"
	icon = 'austation/icons/obj/guns.dmi'
	icon_state = "huot"
	slot_flags = 0
	mag_type = /obj/item/ammo_box/magazine/huot
	fire_sound = 'sound/weapons/rifleshot.ogg'
	rack_sound = 'sound/weapons/chunkyrack.ogg'
	can_suppress = FALSE
	fire_rate = 2
	spread = 7
	w_class = WEIGHT_CLASS_HUGE
	bolt_type = BOLT_TYPE_STANDARD

/obj/item/gun/ballistic/automatic/huot/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "") //creds to thelaughingbomb, very nice way to make jams
	if(prob(5)) 
		playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
		to_chat(user, "<span class='userdanger'>The [src] has misfired and requires to be rechambered!</span>")
		qdel(chambered)
		chambered = null 
		return
	..()

