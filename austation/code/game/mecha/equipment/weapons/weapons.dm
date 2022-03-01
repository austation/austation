// Don't yell at me if you think it's unbalanced, just tell me what would be a better option ):<

// (Mecha part) The part that goes on the mech
/obj/item/mecha_parts/mecha_equipment/weapon/energy/kinetic_accelerator
	equip_cooldown = 1 // The internal KA handles all this, so click click click away
	name = "\improper MKA-27 Mech Kinetic Accelerator"
	desc = "The result of many complaints from disgruntled miners and equally as many complaints from disgruntled roboticists of the lack of reliable ways to combat lavaland megaphauna. The MKA-27 was produced by a team of NT scientists and hacked into the protolathe databases. Although never approved by central command, few can argue against the costs the MKA-27 saves compared to constantly rebuilding mechs and hiring new miners."
	icon = 'icons/obj/guns/energy.dmi' // Temporary
	icon_state = "kineticgun" // Temporary
	item_state = "kineticgun" // Temporary
	energy_drain = 30
	var/obj/item/gun/energy/kinetic_accelerator/mecha_internal/internal_accelerator
	harmful = TRUE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/kinetic_accelerator/examine(mob/user) // So it looks like a KA
	. = ..()
	if(internal_accelerator.max_mod_capacity)
		. += "<b>[internal_accelerator.get_remaining_mod_capacity()]%</b> mod capacity remaining."
		for(var/A in internal_accelerator.get_modkits())
			var/obj/item/borg/upgrade/modkit/M = A
			. += "<span class='notice'>There is \a [M] installed, using <b>[M.cost]%</b> capacity.</span>"


/obj/item/mecha_parts/mecha_equipment/weapon/energy/kinetic_accelerator/can_attach(obj/mecha/M)
	if(!istype(M, /obj/mecha/working))
		return FALSE
	else if(M.equipment.len < M.max_equip && istype(M))
		return TRUE
	return FALSE

/obj/item/mecha_parts/mecha_equipment/weapon/energy/kinetic_accelerator/Initialize(mapload)
	internal_accelerator = new /obj/item/gun/energy/kinetic_accelerator/mecha_internal(src)
	..()

/obj/item/mecha_parts/mecha_equipment/weapon/energy/kinetic_accelerator/attackby(obj/item/I, mob/user) // Cheety way to make modkits work but hey, it works
	if(istype(I, /obj/item/borg/upgrade/modkit))
		var/obj/item/borg/upgrade/modkit/MK = I
		MK.install(internal_accelerator, user)
	else
		..()

/obj/item/mecha_parts/mecha_equipment/weapon/energy/kinetic_accelerator/crowbar_act(mob/living/user, obj/item/I) // above
	. = internal_accelerator.crowbar_act(user, I)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/kinetic_accelerator/Destroy() // Clean up dem atmos and shit... bro
	if (internal_accelerator)
		QDEL_NULL(internal_accelerator)
	return ..()

/obj/item/mecha_parts/mecha_equipment/weapon/energy/kinetic_accelerator/action(atom/target, params)
	if(!action_checks(target))
		return 0

	var/turf/curloc = get_turf(chassis)
	var/turf/targloc = get_turf(target)
	if (!targloc || !istype(targloc) || !curloc)
		return 0
	if (targloc == curloc)
		return 0

	equip_cooldown = internal_accelerator.overheat_time
	internal_accelerator.process_fire(target, chassis.occupant) // I swear to fuck people are gonna realise this means you need trigger guards and are gonna be livid.
	set_ready_state(0)

	if(kickback)
		chassis.newtonian_move(turn(chassis.dir,180))
	chassis.log_message("Fired from [src.name], targeting [target].", LOG_MECHA)
	return 1

// (Kinetic accelerator) The part that does the shooting
/obj/item/gun/energy/kinetic_accelerator/mecha_internal // Nooo you can't just make a mecha kinetic accelerator which has an actual KA inside of it! Haha KA go bew.
	overheat_time = 20 // Originally 16. Change as per balance recommendations. See line 1.
	max_mod_capacity = 160 // Originally 100. Change as per balance recommendations. See line 1.
	ammo_type = list(/obj/item/ammo_casing/energy/kinetic/mecha_internal)
	holds_charge = TRUE
	unique_frequency = TRUE

// (Ammo casing) The part that controls what's shooting
/obj/item/ammo_casing/energy/kinetic/mecha_internal // Now I hear you whinning "But it's an ENERGY gun! It doesn't have casing!" Well son, to explain this we must turn to bluespace. And that's all the explanation you'll ever get.
	projectile_type = /obj/item/projectile/kinetic/mecha_internal

// (Projectile) The part that does the hurting
/obj/item/projectile/kinetic/mecha_internal
	damage = 60 // Originally 40. Change as per balance recommendations. See line 1.
	range = 3 // Originally 3. Change as per balance recommendations. See line 1.
	pressure_decrease = 0.10 // Originally 0.25. Change as per balance recommendations. See line 1.
