/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
<<<<<<< HEAD
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
=======
	department_head = list(JOB_NAME_HEADOFPERSONNEL)
	supervisors = "the head of personnel"
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#d7b088"
	chat_color = "#C79C52"
	exp_requirements = 600
	exp_type = EXP_TYPE_SUPPLY
	exp_type_department = EXP_TYPE_SUPPLY

	outfit = /datum/outfit/job/quartermaster

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE, ACCESS_EXPLORATION)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MAILSORTING, ACCESS_CARGO, ACCESS_QM, ACCESS_MINING, ACCESS_MECH_MINING, ACCESS_MINING_STATION, ACCESS_MINERAL_STOREROOM, ACCESS_VAULT, ACCESS_AUX_BASE, ACCESS_EXPLORATION)

	department_flag = CIVILIAN
	departments = DEPT_BITFLAG_CAR
	bank_account_department = ACCOUNT_CAR_BITFLAG
	payment_per_department = list(ACCOUNT_CAR_ID = PAYCHECK_MEDIUM)

	display_order = JOB_DISPLAY_ORDER_QUARTERMASTER
<<<<<<< HEAD
	departments = DEPARTMENT_CARGO
=======
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "Steward"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/cargo
	)

/datum/outfit/job/quartermaster
	name = "Quartermaster"
	jobtype = /datum/job/qm

	id = /obj/item/card/id/job/qm
	belt = /obj/item/pda/quartermaster
	ears = /obj/item/radio/headset/headset_quartermaster
	uniform = /obj/item/clothing/under/rank/cargo/qm
	shoes = /obj/item/clothing/shoes/sneakers/brown
	glasses = /obj/item/clothing/glasses/sunglasses/advanced
	l_hand = /obj/item/clipboard

	chameleon_extras = /obj/item/stamp/qm

