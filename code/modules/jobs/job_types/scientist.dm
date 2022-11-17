/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
<<<<<<< HEAD
	department_head = list("Research Director")
	department_flag = MEDSCI
=======
	department_head = list(JOB_NAME_RESEARCHDIRECTOR)
	supervisors = "the research director"
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	selection_color = "#ffeeff"
	chat_color = "#C772C7"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/scientist

	access = list(ACCESS_ROBOTICS, ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE,
					ACCESS_MINERAL_STOREROOM, ACCESS_TECH_STORAGE, ACCESS_GENETICS, ACCESS_AUX_BASE, ACCESS_EXPLORATION)
	minimal_access = list(ACCESS_TOX, ACCESS_TOX_STORAGE, ACCESS_RESEARCH, ACCESS_XENOBIOLOGY, ACCESS_MECH_SCIENCE,
					ACCESS_MINERAL_STOREROOM, ACCESS_AUX_BASE, ACCESS_EXPLORATION)

	department_flag = MEDSCI
	departments = DEPT_BITFLAG_SCI
	bank_account_department = ACCOUNT_SCI_BITFLAG
	payment_per_department = list(ACCOUNT_SCI_ID = PAYCHECK_MEDIUM)

	display_order = JOB_DISPLAY_ORDER_SCIENTIST
<<<<<<< HEAD
	departments = DEPARTMENT_SCIENCE
=======
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "Thaumaturgist"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/science
	)
	biohazard = 15

/datum/outfit/job/scientist
	name = "Scientist"
	jobtype = /datum/job/scientist

	id = /obj/item/card/id/job/sci
	belt = /obj/item/pda/toxins
	ears = /obj/item/radio/headset/headset_sci
	uniform = /obj/item/clothing/under/rank/rnd/scientist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit = /obj/item/clothing/suit/toggle/labcoat/science

	r_pocket = /obj/item/discovery_scanner

	backpack = /obj/item/storage/backpack/science
	satchel = /obj/item/storage/backpack/satchel/tox

/datum/outfit/job/scientist/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(0.4))
		neck = /obj/item/clothing/neck/tie/horrible
