/obj/item/gun/ballistic/automatic/pistol/aumakeshift

	name = "Makeshift Pistol"
	desc = "A makeshift pistol, its crude structure makes it unable to fit magazines in, only accepts individual 9mm casings."
	icon = 'austation/icons/obj/guns.dmi'
	icon_state = "makeshift"
	internal_magazine = TRUE
	w_class = WEIGHT_CLASS_NORMAL //sorry, no loading boxes upon boxes of these guns
	mag_type = /obj/item/ammo_box/magazine/internal/makeshift_mag
	can_suppress = FALSE
	fire_rate = 1 //one third of a stechkin
	automatic = 0
	weapon_weight = WEAPON_LIGHT


/obj/item/gun/ballistic/automatic/pistol/aumakeshift/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "")
	if(prob(5)) //I can hear zesko reeeeeing all ready
		playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
		user.visible_message("<span class='userdanger'>The [src] misfires and needs to be rechambered!</span>")
		qdel(chambered)
		chambered = null //Basically it misfires and you gotta rechamber it
		return
	..()
