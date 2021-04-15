#define MBU_MED /obj/item/minebot_upgrade/
#define MBU_SIGHT /obj/item/minebot_upgrade/
#define MBU_LAMP /obj/item/minebot_upgrade/
#define MBU_NAME /obj/item/minebot_upgrade/
#define MBU_APC /obj/item/minebot_upgrade/
#define GUN_UPGRADES list(/obj/item/minebot_upgrade/gun_a, /obj/item/minebot_upgrade/gun_b)
#define GUNTYPES list(/obj/item/minebot_upgrade/gun_c, /obj/item/minebot_upgrade/gun_d)


/////////////////////////  PROCS  /////////////////////////


/obj/item/minebot_upgrade  //  Can't use mine_bot_upgrade because existing definitions conflict with what we want to do
	name = "minebot upgrade"
	icon = 'icons/obj/module.dmi'
	icon_state = "door_electronics"
	var/weight = 1  //  How many mod slots the upgrade takes up.  Each minebot can only install mods until the total weight is 3
	var/upgrade_id = null  //  Populate with a pointer to the class of the upgrade; used for identifying the contents of a minebot's upgrades_list, and for calling new MBU() constructors
	var/list/incompatible = list()  //  This list blacklists later mods from being added (such as gun upgrades for weapons you do not have equipped)

/obj/item/minebot_upgrade/proc/is_minebotgun()  //  Mostly used when trying to uninstall a gun
	return upgrade_id in GUNTYPES

/obj/item/minebot_upgrade/proc/is_minebotgun_upg()  //  Used to uninstall all the mods, before we uninstall a gun
	return upgrade_id in GUN_UPGRADES

/obj/item/minebot_upgrade/afterattack(mob/living/simple_animal/hostile/mining_drone/M, mob/user, proximity)
	. = ..()
	if(!istype(M) || !proximity || !upgrade_id)  //  Something has gone very wrong.  the user probably wouldn't understand a warning for these
		return
	if(upgrade_id in M.upgrades_list)  //  Can't install the same upgrade twice
		to_chat(user, "<span class='warning'[M] already has a [src] installed!</span>")
		return
	if((M.mod_total + weight) > 3  && !(upgrade_id in GUNTYPES))  //  We allow GUNTYPES because they replace an existing upgrade, instead of adding another.
		to_chat(user, "<span class='warning'[M] has no more room to install a [src]!</span>")
		return
	for(var/obj/item/minebot_upgrade/U in M.upgrades_list)  //  Check to see if we're trying to install a blacklisted upgrade
		if(upgrade_id in U.incompatible)
			to_chat(user, "<span class='warning'There are conflicting mods already installed to \the [M]!  You may remove them with a crowbar.</span>")
			return
	src.upgrade_bot(M, user)

/obj/item/minebot_upgrade/proc/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	to_chat(user, "<span class='notice'>You install \the [src] upgrade into \the [M]</span>")
	M.upgrades_list += upgrade_id  //  This is how to add upgrades to the list, so we can check for them and uninstall them later
	M.mod_total += src.weight  //  Usually +1.  Builds toward a maximum of 3
	qdel(src)

/obj/item/minebot_upgrade/proc/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(!get_turf(M))  //  Must have space to put the item down
		if(is_minebotgun())  //  This will probably never get called, but referring to guns differently just seems like the right thing to do
			to_chat(user, "<span class='warning'>There is no room to uninstall \the [M]'s previous gun.</span>")
		else
			to_chat(user, "<span class='warning'>There is no room to uninstall \the [src]</span>")
		return
	var/turf/T = get_turf(M)  //  Where we will place the item onto the floor
	var/obj/item/gun/energy/E  //  The minebot's current gun.  Changes how we talk about a few things
	if(M.minebot_gun)  //  Always possible that maybe it disappeared?  We'll still run the proc even if it has, because we're more interested in the MBUs than the gun
		E = M.minebot_gun

	if(is_minebotgun())
		for(var/obj/item/minebot_upgrade/gunmod in M.upgrades_list)  //  Before uninstalling a gun, we must first uninstall all of its mods
			if(gunmod.is_minebotgun_upg())
				gunmod.uninstall(M,user)
		if(E)  //  We've uninstalled all the gun mods, but if there is somehow no gun, we don't need to claim we uninstalled one
			to_chat(user, "<span class='notice'You uninstall [M]'s previous weapon kit, the [src].</span>")
			qdel(E)

	if(is_minebotgun_upg())
		if(E)  //  Just in case they somehow don't have a gun - we wouldn't want to say we removed something from the gun
			to_chat(user, "<span class='notice'You uninstall the [src] from \the [M]'s [E]'.</span>")
		else
			to_chat(user, "<span class='notice'You removed pieces of a [src] from \the [M].</span>")

	if(!is_minebotgun() && !is_minebotgun_upg())  //  Upgrades that are neither guns nor gun mods, such as a structure upgrade
		to_chat(user, "<span class='notice'You removed the [src] upgrade from \the [M].</span>")

	M.upgrades_list -= src.upgrade_id  //  Remove the upgrade from the minebot's list
	var/obj/item/minebot_upgrade/U = new src.upgrade_id(T)  //  Build a copy of it, for reinstalling
	visible_message("<span class='notice'\A [U] was placed on the ground</span>")  //  Unless you're blind, we'll all see this happen
	return TRUE  //  When installing new weapons, we want to know that the minebot doesn't have an old gun still inside.  This only returns false when there is no room on the floor

/obj/item/minebot_upgrade/melee  //  An imitation of /obj/item/mine_bot_upgrade.  It has the same values
	name = "gORE"
	desc = "A drill that may help you face tomorrow; Increases a minebot's drill damage by 50%."
	upgrade_id = /obj/item/minebot_upgrade/melee

/obj/item/minebot_upgrade/melee/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	M.melee_damage = 22  //  Up from 15
	. = ..()  //  ALWAYS call parent at the end of .minebot_upgrade because the MBU is deleted at the end of parent.minebot_upgrade()

/obj/item/minebot_upgrade/melee/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	M.melee_damage = /mob/living/simple_animal/hostile/mining_drone.melee_damage  //  Who knows what the default will be in the future?

/obj/item/minebot_upgrade/health_a  //  An imitation of /obj/item/mine_bot_upgrade/health.  It increases max_health by the same amount, but doubling the cell is new.
	name = "Structure+"
	desc = "A general utility increase to the minebot frame; Increases a minebot's health by 45% and fuel capacity by 100%.\
	Incompatible with:\
	B4D-A$$"
	upgrade_id = /obj/item/minebot_upgrade/health_a
	incompatible = list(/obj/item/minebot_upgrade/health_b)  //  Don't stack both health upgrades

/obj/item/minebot_upgrade/health_a/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	M.maxHealth = 170  //  Up from 125
	M.health += 45
	M.cell.maxcharge = M.cell_type.maxcharge * 2  //  Currently minebots may not install new cells, but this is for just in case
	. = ..()

/obj/item/minebot_upgrade/health_a/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	if(M.health < 45)  //  Don't reduce their health below 1, if they're low on hp
		M.health = 1
	else
		M.health -= 45
	M.maxHealth = /mob/living/simple_animal/hostile/mining_drone.maxHealth
	M.cell.maxcharge = M.cell_type.maxcharge

/obj/item/minebot_upgrade/health_b
	name = "B4D-A$$"
	desc = "An armored hull for the minebot that means business; Increases a minebot's health by 200%.\
	Incompatible with:\
	Structure+\
	Boat Boots"
	upgrade_id = /obj/item/minebot_upgrade/health_b
	incompatible = list(/obj/item/minebot_upgrade/health_a, /obj/item/minebot_upgrade/tracks_b)  //  In addition to not stacking with health_a, the Badass upgrade makes you too heavy to float on lava

/obj/item/minebot_upgrade/health_b/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	M.maxHealth = 300
	M.health += 175
	. = ..()

/obj/item/minebot_upgrade/health_b/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	if(M.health <= 175)  //  Again, don't reduce them to below 1
		M.health = 1
	else
		M.health -= 175
	M.maxHealth = /mob/living/simple_animal/hostile/mining_drone.maxHealth

/obj/item/minebot_upgrade/tracks_a
	name = "BIGGA TRUKKZ"
	desc = "MAKZ YA FOR HUNDRID PICENT FASTA; RED PAINT NOT INKLUDID!\
	Incompatible with:\
	Boat Boots"
	upgrade_id = /obj/item/minebot_upgrade/tracks_a
	incompatible = list(/obj/item/minebot_upgrade/tracks_b)  //  Don't stack both Tracks upgrades

/obj/item/minebot_upgrade/tracks_a/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	M.move_to_delay = 2  //  I believe this is 5 steps per second
	. = ..()

/obj/item/minebot_upgrade/tracks_a/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	M.move_to_delay = /mob/living/simple_animal/hostile/mining_drone.move_to_delay  //  I believe this is 1 step per second

/obj/item/minebot_upgrade/tracks_b
	name = "Boat Boots"
	desc = "A near-submersible lava-floatation boot for minebots; the rear is modified to include a saddle for riding.\
	Incompatible with:\
	BIGGA TRUKKS\
	B4D-A$$"
	upgrade_id = /obj/item/minebot_upgrade/tracks_b
	incompatible = list(/obj/item/minebot_upgrade/tracks_a, /obj/item/minebot_upgrade/health_b)  //  Don't stack Tracks and Badass makes you too heavy

/obj/item/minebot_upgrade/tracks_b/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	M.weather_immunities += "lava"

/obj/item/minebot_upgrade/tracks_b/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	M.weather_immunities -= "lava"

/obj/item/minebot_upgrade/gun_a  //  An imitation of /obj/item/mine_bot_upgrade/cooldown. Makes your cooldown go down to 0.5s, the same as a miner's fully upgraded PKA  (but your damage is only half)
	name = "Auto-LODEr"
	desc = "Recalibrates the internal PKA faster; reload time is reduced to 2x per second.\
	Incompatible with:\
	Barometric Field Generator"
	upgrade_id = /obj/item/minebot_upgrade/gun_a
	incompatible = list(GUN_UPGRADES)  //  Don't stack gun upgrades

/obj/item/minebot_upgrade/gun_a/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(!istype(M.minebot_gun, /obj/item/gun/energy/kinetic_accelerator))
		return
	var/obj/item/gun/energy/kinetic_accelerator/K = M.minebot_gun
	K.overheat_time = 5
	. = ..()

/obj/item/minebot_upgrade/gun_a/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	var/obj/item/gun/energy/kinetic_accelerator/K = M.minebot_gun
	K.overheat_time = /obj/item/gun/energy/kinetic_accelerator/minebot.overheat_time

/obj/item/minebot_upgrade/gun_b  //  THE DPS is better than auto-loder, but the lowered fire rate makes it poorer for mining
	name = "Barometric Field Generator"
	desc = "Maybe it would be useful for slaying demons? Damage is quadrupled in exchange for a lowered firing rate.\
	Incompatible with:\
	Auto-LODEr"
	upgrade_id = /obj/item/minebot_upgrade/gun_b
	incompatible = list(GUN_UPGRADES)  //  Again

/obj/item/minebot_upgrade/gun_b/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(!istype(M.minebot_gun, /obj/item/gun/energy/kinetic_accelerator))
		return
	var/obj/item/gun/energy/kinetic_accelerator/K = M.minebot_gun
	K.ammo_type = /obj/item/ammo_casing/kinetic/heavy  //  4x as powerful as Kinetic/light
	K.overheat_time = 15  //  50% slower than base cooldown
	. = ..()

/obj/item/minebot_upgrade/gun_b/uninstall(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	. = ..()
	if(!istype(M.minebot_gun, /obj/item/gun/energy/kinetic_accelerator))
		return
	var/obj/item/gun/energy/kinetic_accelerator/K = M.minebot_gun
	K.ammo_type = /obj/item/gun/energy/kinetic_accelerator/minebot.ammo_type
	K.overheat_time = /obj/item/gun/energy/kinetic_accelerator/minebot.overheat_time

/obj/item/minebot_upgrade/gun_c  //  Plasmacutter refit.  Obviously doesn't accept PKA upgrades
	name = "Plasma tool conversion"
	desc = "Plasmacutters are the real miner's choice of tool; replaces that shoddy PKA.\
	Incompatible with:\
	Auto-LODEr\
	Barometric Field Generator"
	upgrade_id = /obj/item/minebot_upgrade/gun_c
	incompatible = list(/obj/item/minebot_upgrade/gun_a, /obj/item/minebot_upgrade/gun_b)

/obj/item/minebot_upgrade/gun_c/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(istype(M.minebot_gun, /obj/item/gun/energy/plasmacutter))  //  Can't install a gun we already have, should be caught earlier, but CONSISTENCY and VIGILANCE
		to_chat(user, "<span class='notice'>The [M] already has a plasma gun.</span>")
		return
	for(var/obj/item/minebot_upgrade/U in M.upgrades_list)  //  We have to remove the old gun (and its mods) before we can install a plasmacutter.  Don't move all this to parent.Install because we need to know that we managed to install the new gun before we can give it a new cell.
		if(U.is_minebotgun())
			if(U.uninstall(M, user))
				var/obj/item/gun/energy/plasmacutter/P = new /obj/item/gun/energy/plasmacutter(src)
				M.minebot_gun = P
				P.cell = M.cell
			else
				to_chat(user, "<span class='warning'>The previous weapon was not uninstalled.</span>")
	. = ..()

/obj/item/minebot_upgrade/gun_d  //  Minebots equip one of these during initialisation
	name = "Kinetic tool conversion"
	desc = "Reverts the minebot's armament to its original PKA."
	upgrade_id = /obj/item/minebot_upgrade/gun_d

/obj/item/minebot_upgrade/gun_d/upgrade_bot(mob/living/simple_animal/hostile/mining_drone/M, mob/user)
	if(istype(M.minebot_gun, /obj/item/gun/energy/kinetic_accelerator))
		to_chat(user, "<span class='warning'>\The [M] already has a kinetic gun.</span>")
		return
	for(var/obj/item/minebot_upgrade/U in M.upgrades_list)
		if(U.is_minebotgun())
			if(U.uninstall(M, user))
				var/obj/item/gun/energy/plasmacutter/K = new /obj/item/gun/energy/kinetic_accelerator(src)
				M.minebot_gun = K
			else
				to_chat(user, "<span class='warning'>The previous weapon was not uninstalled.</span>")
	. = ..()


#undef GUN_UPGRADES
#undef GUNTYPES
