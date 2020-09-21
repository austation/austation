/obj/item/gun/ballistic/automatic/pistol/aumakeshift

	name = "makeshift pistol"
	desc = "A makeshift pistol, its crude structure makes it unable to fit magazines in, only accepts individual 9mm casings."
	icon = 'austation/icons/obj/guns.dmi'
	icon_state = "makeshift"
	internal_magazine = TRUE
	w_class = WEIGHT_CLASS_NORMAL //sorry, no loading boxes upon boxes of these guns
	mag_type = /obj/item/ammo_box/magazine/internal/makeshift_mag
	can_suppress = FALSE
	fire_rate = 1.5 //Half the fire rate of a stechkin
	automatic = 0
	weapon_weight = WEAPON_LIGHT
	
/obj/item/gun/ballistic/automatic/pistol/aumakeshift/attackby(obj/item/I, mob/user, params)
	if (istype(I, /obj/item/ammo_box/c9mm))
		to_chat(user, "<span class='notice'>The [src] cannot be loaded by the ammo box, eject a bullet out first!</span>")
	if (istype(I, /obj/item/ammo_casing/c9mm))
		return ..()

/obj/item/gun/ballistic/automatic/pistol/aumakeshift/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "")
	if(prob(5)) //I can hear zesko reeeeeing all ready
		playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
		to_chat(user, "<span class='userdanger'>The [src] misfires and needs to be rechambered!</span>")
		qdel(chambered)
		chambered = null //Basically it misfires and you gotta rechamber it
		return
	..()
