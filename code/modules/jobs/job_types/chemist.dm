/datum/job/chemist
	title = "Chemist"
	flag = CHEMIST
<<<<<<< HEAD
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
=======
	department_head = list(JOB_NAME_CHIEFMEDICALOFFICER)
	supervisors = "the chief medical officer"
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	selection_color = "#d4ebf2"
	chat_color = "#82BDCE"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
	outfit = /datum/outfit/job/chemist

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_CHEMISTRY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM)
<<<<<<< HEAD
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	display_order = JOB_DISPLAY_ORDER_CHEMIST
	departments = DEPARTMENT_MEDICAL
=======

	department_flag = MEDSCI
	departments = DEPT_BITFLAG_MED
	bank_account_department = ACCOUNT_MED_BITFLAG
	payment_per_department = list(ACCOUNT_MED_ID = PAYCHECK_MEDIUM)
	mind_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CHEMIST
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "Alchemist"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/chemist
	)
	biohazard = 15

/datum/outfit/job/chemist
	name = "Chemist"
	jobtype = /datum/job/chemist

	id = /obj/item/card/id/job/chemist
	glasses = /obj/item/clothing/glasses/science
	belt = /obj/item/pda/chemist
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical/chemist
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/chemist
	backpack = /obj/item/storage/backpack/chemistry
	satchel = /obj/item/storage/backpack/satchel/chem
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	chameleon_extras = /obj/item/gun/syringe

