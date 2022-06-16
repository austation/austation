/obj/item/gun/ballistic/automatic/l1a1
	name = "\improper L1A1 CLR"
	desc = "An antiquated 7.62mm Self-Loading Rifle used by several armies back on Old Earth."
	icon = 'austation/icons/obj/guns/projectile_40x32.dmi'
	icon_state = "l1a1"
	lefthand_file = 'austation/icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'austation/icons/mob/inhands/weapons/guns_righthand.dmi'
	item_state = "l1a1"
	mag_type = /obj/item/ammo_box/magazine/mm762x51
	actions_types = list()
	empty_indicator = TRUE
	fire_delay = 0
	burst_size = 1
	fire_rate = 0.333
	weapon_weight = WEAPON_MEDIUM
	select = 0

/obj/item/gun/ballistic/automatic/l1a1/trueblue
	name = "\improper L1A2 'True Blue' SLR"
	desc = "A modified version of the original L1A1 SLR, the L1A2 saw heavy use during WW2 on Old Earth by the Australian Army. It has a small Australian flag attached to the stock."
	icon_state = "l1a1_trueblue"
	item_state = "l1a1_trueblue"
	mag_type = /obj/item/ammo_box/magazine/mm762x51/large
	full_auto = TRUE
	select = 1 // force burst fire
	burst_size = 3
	fire_rate = 2
