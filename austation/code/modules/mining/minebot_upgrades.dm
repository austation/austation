#define MBU_MELEE /obj/item/minebot_upgrade/melee
#define MBU_HEALTH_A /obj/item/minebot_upgrade/health_a
#define MBU_HEALTH_B /obj/item/minebot_upgrade/health_b
#define MBU_TRACKS_A /obj/item/minebot_upgrade/tracks_a
#define MBU_TRACKS_B /obj/item/minebot_upgrade/tracks_b
#define MBU_GUN_A /obj/item/minebot_upgrade/gun_a
#define MBU_GUN_B /obj/item/minebot_upgrade/gun_b
#define MBU_GUN_C /obj/item/minebot_upgrade/gun_c
#define MBU_GUN_D /obj/item/minebot_upgrade/gun_d
#define MBU_MED /obj/item/minebot_upgrade/
#define MBU_SIGHT /obj/item/minebot_upgrade/
#define MBU_LAMP /obj/item/minebot_upgrade/
#define MBU_NAME /obj/item/minebot_upgrade/
#define MBU_APC /obj/item/minebot_upgrade/
#define GUN_UPGRADES list(MBU_GUN_A, MBU_GUN_B)
#define GUNTYPES list(MBU_GUN_C, MBU_GUN_D)


/////////////////////////  PROCS  /////////////////////////


/obj/item/minebot_upgrade  //  can't use mine_bot_upgrade because existing definitions conflict with what we want to do
	name = "minebot upgrade"
	icon_state = "door_electronics"
	icon = 'icons/obj/module.dmi'
	var/weight = 0  //  how many mod slots the upgrade takes up.  each minebot can only install mods until the total weight is 3
	var/upgrade_id = null  //  populate with the DEFINES above, they point to the class of the upgrade
	var/list/incompatible = list()  //  this list blacklists new mods from being added (such as gun upgrades for weapons you do not have equipped)

/obj/item/minebot_upgrade/proc/is_minebotgun()
	return upgrade_id in GUNTYPES

/obj/item/minebot_upgrade/proc/is_minebotgun_upg()
	return upgrade_id in GUN_UPGRADES

/obj/item/minebot_upgrade/afterattack(mob/living/simple_animal/hostile/mining_drone/M, mob/user, proximity)
	. = ..()
	if(!istype(M) || !proximity || !upgrade_id)  //  something has gone very wrong.  the user probably wouldn't understand a warning for these
		return
	if(upgrade_id in M.upgrades_list)  //  can't install the same mod twice
		to_chat(user, "<span class='warning'[M] already has a [src] installed!</span>")
		return
	if(M.mod_total >= 3  && !(upgrade_id in GUNTYPES))  //  we allow GUNTYPES because they replace an existing mod, instead of adding another.
		to_chat(user, "<span class='warning'[M] has no more room to install a [src]!</span>")
		return
	for(var/obj/item/minebot_upgrade/U in M.upgrades_list)
		if(upgrade_id in U.incompatible)
			to_chat(user, "<span class='warning'there are conflicting mods already installed to \the [M]!  You may remove them with a crowbar.</span>")
			return
	src.upgrade_bot(M, user)

/obj/item/minebot_upgrade/proc/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	to_chat(user, "<span class='notice'> you install \the [src] upgrade into \the [M]</span>")
	M.upgrades_list += upgrade_id
	M.mod_total += src.weight
	qdel(src)

/obj/item/minebot_upgrade/proc/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(!get_turf(M))
		if(is_minebotgun())
			to_chat(user, "<span class='warning'there is no room to uninstall the [M]'s previous gun.</span>")
		else
			to_chat(user, "<span class='warning'there is no room to uninstall the [src].</span>")
		return
	var/turf/T = get_turf(M)
	var/obj/item/gun/energy/E
	if(M.minebot_gun)
		E = M.minebot_gun

	if(is_minebotgun())
		for(var/obj/item/minebot_upgrade/gunmod in M.upgrades_list)
			if(gunmod.is_minebotgun_upg())
				gunmod.uninstall(M,user)
		if(E)
			to_chat(user, "<span class='notice'you uninstall [M]'s previous weapon kit, the [src].</span>")
			qdel(E)

	if(is_minebotgun_upg())
		if(E)
			to_chat(user, "<span class='notice'you uninstall the [src] from \the [M]'s [E]'.</span>")
		else
			to_chat(user, "<span class='notice'you removed pieces of a [src] from \the [M].</span>")

	if(!is_minebotgun() && !is_minebotgun_upg())
		to_chat(user, "<span class='notice'you removed the [src] upgrade from \the [M].</span>")

	M.upgrades_list -= src.upgrade_id
	var/obj/item/minebot_upgrade/U = new src.upgrade_id(T)
	visible_message("<span class='notice'A [U] was placed on the ground</span>")
	return TRUE

/obj/item/minebot_upgrade/melee
	name = "gORE"
	desc = "a drill that will help you face tomorrow; Increases a minebot's drill damage by 50%."
	upgrade_id = MBU_MELEE

/obj/item/minebot_upgrade/melee/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	M.melee_damage += 7

/obj/item/minebot_upgrade/melee/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	M.melee_damage -= 7

/obj/item/minebot_upgrade/health_a
	name = "Structure+"
	desc = "a general utility increase to the minebot frame; Increases a minebot's health by 45% and fuel capacity by 100%.\
	incompatible with:\
	B4D-A$$"
	upgrade_id = MBU_HEALTH_A
	incompatible = list(MBU_HEALTH_B)

/obj/item/minebot_upgrade/health_a/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	M.health = 145
	M.cell.maxcharge = M.cell_type.maxcharge * 2

/obj/item/minebot_upgrade/health_a/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	M.health -= 45
	M.cell.maxcharge -= M.cell_type.maxcharge

/obj/item/minebot_upgrade/health_b
	name = "B4D-A$$"
	desc = "an armored hull for the minebot that means business; Increases a minebot's health by 200%.\
	incompatible with:\
	Structure+\
	Boat Boots"
	upgrade_id = MBU_HEALTH_B
	incompatible = list(MBU_HEALTH_A, MBU_TRACKS_B)

/obj/item/minebot_upgrade/health_b/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	M.maxHealth = 300
	M.health += 200

/obj/item/minebot_upgrade/health_b/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(M.health <= 200)
		M.health = 1
	else
		M.health = M.health - 200
	M.maxHealth = 100

/obj/item/minebot_upgrade/tracks_a
	name = "BIGGA TRUKKZ"
	desc = "MAKZ YA FOR HUNDRID PICENT FASTA; RED PAINT NOT INKLUDID!\
	incompatible with:\
	Boat Boots"
	upgrade_id = MBU_TRACKS_A
	incompatible = list(MBU_TRACKS_B)

/obj/item/minebot_upgrade/tracks_a/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	M.move_to_delay = 2

/obj/item/minebot_upgrade/tracks_a/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	M.move_to_delay = 10

/obj/item/minebot_upgrade/tracks_b
	name = "Boat Boots"
	desc = "a near-submersible lava-floatation boot for minebots; the rear is modified to include a saddle for riding.\
	incompatible with:\
	BIGGA TRUKKS\
	B4D-A$$"
	upgrade_id = MBU_TRACKS_B
	incompatible = list(MBU_TRACKS_A, MBU_HEALTH_B)

/obj/item/minebot_upgrade/tracks_b/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	M.weather_immunities += "lava"

/obj/item/minebot_upgrade/tracks_b/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	M.weather_immunities -= "lava"

/obj/item/minebot_upgrade/gun_a
	name = "Auto-LODEr"
	desc = "recalibrates the internal PKA faster; reload time is reduced to 2x per second.\
	incompatible with:\
	Plasma tool conversion\
	Barometric Field Generator"
	upgrade_id = MBU_GUN_A
	incompatible = list(MBU_GUN_B)

/obj/item/minebot_upgrade/gun_a/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	if(!istype(M.minebot_gun, /obj/item/gun/energy/kinetic_accelerator))
		return
	var/obj/item/gun/energy/kinetic_accelerator/K = M.minebot_gun
	K.overheat_time = 5

/obj/item/minebot_upgrade/gun_a/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	var/obj/item/gun/energy/kinetic_accelerator/K = M.minebot_gun
	K.overheat_time = 10

/obj/item/minebot_upgrade/gun_b
	name = "Barometric Field Generator"
	desc = "pressurises the PKA for a meatier attack; damage is increased to triplicate.\
	incompatible with:\
	Plasma tool conversion\
	Barometric Field Generator"
	upgrade_id = MBU_GUN_B
	incompatible = list(MBU_GUN_A)

/obj/item/minebot_upgrade/gun_b/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	if(!istype(M.minebot_gun, /obj/item/gun/energy/kinetic_accelerator))
		return
	var/obj/item/gun/energy/kinetic_accelerator/K = M.minebot_gun
	K.ammo_type = /obj/item/ammo_casing/kinetic/heavy

/obj/item/minebot_upgrade/gun_b/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(!istype(M.minebot_gun, /obj/item/gun/energy/kinetic_accelerator))
		return
	var/obj/item/gun/energy/kinetic_accelerator/K = M.minebot_gun
	K.ammo_type = /obj/item/ammo_casing/kinetic

/obj/item/minebot_upgrade/gun_c
	name = "Plasma tool conversion"
	desc = "plasmacutters are the real miner's choice of tool; replaces that shoddy PKA.\
	incompatible with:\
	Auto-LODEr\
	Barometric Field Generator"
	upgrade_id = MBU_GUN_C
	incompatible = list(MBU_GUN_A, MBU_GUN_B)

/obj/item/minebot_upgrade/gun_c/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	if(istype(M.minebot_gun, /obj/item/gun/energy/plasmacutter))
		to_chat(user, "<span class='notice'>the [M] already has a plasma gun.</span>")
		return
	if(uninstall(M, user))
		var/obj/item/gun/energy/plasmacutter/P = new /obj/item/gun/energy/plasmacutter(src)
		M.minebot_gun = P
		P.cell = M.cell
	else
		to_chat(user, "<span class='notice'the previous weapon was not uninstalled.</span>")

/obj/item/minebot_upgrade/gun_d
	name = "Kinetic tool conversion"
	desc = "reverts the minebot's armament to its original PKA."
	upgrade_id = MBU_GUN_D

/obj/item/minebot_upgrade/gun_d/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	if(istype(M.minebot_gun, /obj/item/gun/energy/kinetic_accelerator))
		to_chat(user, "<span class='notice'>the [M] already has a kinetic gun.</span>")
		return
	if(uninstall(M, user))
		M.minebot_gun = new /obj/item/gun/energy/kinetic_accelerator(src)
	else
		to_chat(user, "<span class='notice'the previous weapon was not uninstalled.</span>")


#undef MBU_MELEE
#undef MBU_HEALTH_A
#undef MBU_HEALTH_B
#undef MBU_TRACKS_A
#undef MBU_TRACKS_B
#undef MBU_GUN_A
#undef MBU_GUN_B
#undef MBU_GUN_C
#undef MBU_GUN_D
#undef MBU_MED
#undef MBU_SIGHT
#undef MBU_LAMP
#undef MBU_NAME
#undef MBU_APC
#undef GUN_UPGRADES
#undef GUNTYPES
