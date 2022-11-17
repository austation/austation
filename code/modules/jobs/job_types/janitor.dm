/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
<<<<<<< HEAD
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
=======
	department_head = list(JOB_NAME_HEADOFPERSONNEL)
	supervisors = "the head of personnel"
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	selection_color = "#bbe291"
	chat_color = "#97FBEA"

	outfit = /datum/outfit/job/janitor

	access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_JANITOR, ACCESS_MAINT_TUNNELS, ACCESS_MINERAL_STOREROOM)

	department_flag = CIVILIAN
	departments = DEPT_BITFLAG_SRV
	bank_account_department = ACCOUNT_SRV_BITFLAG
	payment_per_department = list(ACCOUNT_SRV_ID = PAYCHECK_EASY)

	display_order = JOB_DISPLAY_ORDER_JANITOR
<<<<<<< HEAD
	departments = DEPARTMENT_SERVICE
=======
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "Groundskeeper"
	biohazard = 20//cleaning up hazardous messes puts janitors at extra risk

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/janitor
	)

/datum/outfit/job/janitor
	name = "Janitor"
	jobtype = /datum/job/janitor

	id = /obj/item/card/id/job/janitor
	belt = /obj/item/pda/janitor
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/janitor
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced=1)

/datum/outfit/job/janitor/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(GARBAGEDAY in SSevents.holidays)
		l_pocket = /obj/item/gun/ballistic/revolver
		r_pocket = /obj/item/ammo_box/a357
