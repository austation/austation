///////////////////////
//     ROSS RIFLE    //
///////////////////////

/obj/item/gun/ballistic/rifle/ross //dont craft this unless you want sec to laugh at you
	name = "Improvised Ross Rifle"
	desc = "Already a terrible rifle, this improvised Ross rifle should be able to take care of security officers, maybe."
	icon = 'austation/icons/obj/guns.dmi'
	icon_state = "ross"
	mag_type = /obj/item/ammo_box/magazine/internal/ross
	slot_flags = 0

/obj/item/gun/ballistic/rifle/ross/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "") //creds to thelaughingbomb, very nice way to make jams
	if(prob(10)) 
		playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
		user.visible_message("<span class='userdanger'>The [src] has misfired and requires to be rechambered!</span>")
		qdel(chambered)
		chambered = null 
		return
	..()

