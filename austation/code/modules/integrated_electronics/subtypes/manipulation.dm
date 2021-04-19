/obj/item/integrated_circuit/manipulation/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades and prime them at will."
	extended_desc = "The time between priming and detonation is limited to between 1 to 12 seconds, but is optional. \
					If the input is not set, not a number, or a number less than 1, the grenade's built-in timing will be used. \
					Beware: Once primed, there is no aborting the process!"
	icon_state = "grenade"
	complexity = 30
	max_allowed = 1
	cooldown_per_use = 10
	inputs = list("detonation time" = IC_PINTYPE_NUMBER)
	outputs = list("reference to grenade" = IC_PINTYPE_REF)
	activators = list("prime grenade" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	var/obj/item/grenade/attached_grenade
	var/pre_attached_grenade_type
	demands_object_input = TRUE	// You can put stuff in once the circuit is in assembly,passed down from additem and handled by attackby()

/obj/item/integrated_circuit/manipulation/grenade/Initialize()
	. = ..()
	if(pre_attached_grenade_type)
		var/grenade = new pre_attached_grenade_type(src)
		attach_grenade(grenade)

/obj/item/integrated_circuit/manipulation/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.forceMove(loc)
	detach_grenade()
	return ..()

/obj/item/integrated_circuit/manipulation/grenade/attackby(var/obj/item/grenade/G, var/mob/user)
	if(istype(G))
		if(attached_grenade)
			to_chat(user, "<span class='warning'>There is already a grenade attached!</span>")
		else if(user.transferItemToLoc(G,src))
			user.visible_message("<span class='warning'>\The [user] attaches \a [G] to \the [src]!</span>", "<span class='notice'>You attach \the [G] to \the [src].</span>")
			attach_grenade(G)
			G.forceMove(src)
	else
		return ..()

/obj/item/integrated_circuit/manipulation/grenade/attack_self(var/mob/user)
	if(attached_grenade)
		user.visible_message("<span class='warning'>\The [user] removes \an [attached_grenade] from \the [src]!</span>", "<span class='notice'>You remove \the [attached_grenade] from \the [src].</span>")
		user.put_in_hands(attached_grenade)
		detach_grenade()
	else
		return ..()

/obj/item/integrated_circuit/manipulation/grenade/do_work()
	if(attached_grenade && !attached_grenade.active)
		var/datum/integrated_io/detonation_time = inputs[1]
		var/dt
		if(isnum_safe(detonation_time.data) && detonation_time.data > 0)
			dt = CLAMP(detonation_time.data, 1, 12)*10
		else
			dt = 15
		addtimer(CALLBACK(attached_grenade, /obj/item/grenade.proc/prime), dt)
		var/atom/holder = loc
		message_admins("activated a grenade assembly. Last touches: Assembly: [holder.fingerprintslast] Circuit: [fingerprintslast] Grenade: [attached_grenade.fingerprintslast]")

// These procs do not relocate the grenade, that's the callers responsibility
/obj/item/integrated_circuit/manipulation/grenade/proc/attach_grenade(var/obj/item/grenade/G)
	attached_grenade = G
	G.forceMove(src)
	desc += " \An [attached_grenade] is attached to it!"
	set_pin_data(IC_OUTPUT, 1, WEAKREF(G))

/obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade()
	if(!attached_grenade)
		return
	attached_grenade.forceMove(drop_location())
	set_pin_data(IC_OUTPUT, 1, WEAKREF(null))
	attached_grenade = null
	desc = initial(desc)
