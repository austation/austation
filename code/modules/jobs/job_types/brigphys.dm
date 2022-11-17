/datum/job/brig_phys
	title = "Brig Physician"
	flag = BRIG_PHYS
<<<<<<< HEAD:code/modules/jobs/job_types/brigphys.dm
	department_head = list("Chief Medical Officer")
	department_flag = ENGSEC
=======
	department_head = list(JOB_NAME_CHIEFMEDICALOFFICER)
	supervisors = "chief medical officer"
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559)):code/modules/jobs/job_types/brig_physician.dm
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#ffeeee"
	chat_color = "#b16789"
	minimal_player_age = 7
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
<<<<<<< HEAD:code/modules/jobs/job_types/brigphys.dm

	outfit = /datum/outfit/job/brig_phys

	access = list(ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_MEDICAL, ACCESS_BRIGPHYS)
	minimal_access = list(ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_MEDICAL, ACCESS_BRIGPHYS)
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	display_order = JOB_DISPLAY_ORDER_BRIG_PHYS
	departments = DEPARTMENT_MEDICAL | DEPARTMENT_SECURITY
=======
	outfit = /datum/outfit/job/brig_physician

	access = list(ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_MEDICAL, ACCESS_BRIGPHYS)
	minimal_access = list(ACCESS_SEC_DOORS, ACCESS_COURT, ACCESS_MAINT_TUNNELS, ACCESS_MORGUE, ACCESS_MEDICAL, ACCESS_BRIGPHYS)

	department_flag = ENGSEC
	departments = DEPT_BITFLAG_MED | DEPT_BITFLAG_SEC
	bank_account_department = ACCOUNT_MED_BITFLAG
	payment_per_department = list(ACCOUNT_MED_ID = PAYCHECK_MEDIUM)
	mind_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_BRIG_PHYS
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559)):code/modules/jobs/job_types/brig_physician.dm
	rpg_title = "Battle Cleric"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/secmed
	)
	biohazard = 15 //still deals with the sick and injured, just less than a medical doctor

/datum/outfit/job/brig_phys
	name = "Brig Physician"
	jobtype = /datum/job/brig_phys

	id = /obj/item/card/id/job/brigphys
	belt = /obj/item/pda/brigphys
	ears = /obj/item/radio/headset/headset_medsec
	uniform = /obj/item/clothing/under/rank/brig_phys
	shoes = /obj/item/clothing/shoes/sneakers/white
	glasses = /obj/item/clothing/glasses/hud/health/sunglasses
	suit = /obj/item/clothing/suit/hazardvest/brig_phys
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	suit_store = /obj/item/flashlight/seclite
	l_hand = /obj/item/storage/firstaid/medical
	head = /obj/item/clothing/head/soft/sec/brig_phys

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	box = /obj/item/storage/box/security

	chameleon_extras = /obj/item/gun/syringe
