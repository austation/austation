///////////////////////
//     ROSS RIFLE    //
///////////////////////

/obj/item/gun/ballistic/rifle/ross //dont craft this unless you want sec to laugh at you
	name = "Improvised Ross Rifle"
	desc = "A bolt-action rifle based on the antiquated and outdated Ross design. It's barely being held together by wrapping tape. Fires .303 rounds."
	icon = 'austation/icons/obj/guns.dmi'
	icon_state = "ross"
	mag_type = /obj/item/ammo_box/magazine/internal/ross
	slot_flags = 0

/obj/item/gun/ballistic/rifle/ross/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "") //creds to thelaughingbomb, very nice way to make jams
	if(prob(10)) 
		playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
		to_chat(user, "<span class='userdanger'>The [src] has misfired and requires to be rechambered!</span>")
		qdel(chambered)
		chambered = null 
		return
	..()

