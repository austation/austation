
/mob/living/simple_animal/drone
	see_in_dark = 1
	laws = \
	"1. You may not involve yourself in the matters of carbons, even if such matters conflict with Law Two or Law Three.\n"+\
	"2. You may not harm any carbon, regardless of intent or circumstance.\n"+\
	"3. Your goals are to actively build, maintain, repair, improve, and provide power to the best of your abilities within the facility that housed your activation." //for derelict drones so they don't go to station.
	var/obj/item/radio/radio = null

/mob/living/simple_animal/drone/Initialize()
	. = ..()
	radio = new /obj/item/radio/borg(src) // Grants drones the ability to hear common and engineering radio.
	radio.keyslot = new /obj/item/encryptionkey/headset_eng

/mob/living/simple_animal/drone/derelict
	initial_language_holder = /datum/language_holder/drone/derelict

/mob/living/simple_animal/drone/RangedAttack(atom/A, mouseparams)
	. = ..()

	if(isturf(A) && get_dist(src,A) <= 1)
		src.Move_Pulled(A)
		return

/mob/living/simple_animal/drone/get_jetpack()
	var/obj/item/tank/jetpack/J = internal_storage
	if(istype(J))
		return J

/obj/item/drone_shell
	name = "hand-held drone shell"
	desc = "A drone shell yet to be activated. Use it in your hand to activate the drone shell."
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'icons/mob/drone.dmi'
	icon_state = "drone_maint_grey"

/obj/item/drone_shell/attack_self(mob/user)
	. = ..()
	var/turf/T = get_turf(src)
	if(!T)
		user.show_message("<span class='warning'> There is no room to build \the [src].</span>")
		return

	user.visible_message("<span class='notice'> [user] builds \a [src].</span>", "<span class='notice'> You build \the [src].</span>", "<span class='notice'> You can hear someone building \a [src].</span>", 7)
	var/obj/effect/mob_spawn/drone/new_drone = new(T)
	qdel(src)
