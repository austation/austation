<<<<<<< HEAD:code/modules/jobs/job_types/emt.dm
/datum/job/emt
	title = "Paramedic"
	flag = EMT
	department_head = list("Chief Medical Officer")
	department_flag = MEDSCI
=======
/datum/job/paramedic
	title = JOB_NAME_PARAMEDIC
	flag = PARAMEDIC
	department_head = list(JOB_NAME_CHIEFMEDICALOFFICER)
	supervisors = "the chief medical officer"
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559)):code/modules/jobs/job_types/paramedic.dm
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	selection_color = "#d4ebf2"
	chat_color = "#8FBEB4"
	exp_requirements = 120
	exp_type = EXP_TYPE_CREW
<<<<<<< HEAD:code/modules/jobs/job_types/emt.dm

	outfit = /datum/outfit/job/emt

=======
	outfit = /datum/outfit/job/paramedic
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559)):code/modules/jobs/job_types/paramedic.dm
	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CLONING, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM,
					ACCESS_MAINT_TUNNELS, ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_AUX_BASE)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_CLONING, ACCESS_MECH_MEDICAL, ACCESS_MAINT_TUNNELS,
					ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_AUX_BASE)
<<<<<<< HEAD:code/modules/jobs/job_types/emt.dm
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	display_order = JOB_DISPLAY_ORDER_MEDICAL_DOCTOR
	departments = DEPARTMENT_MEDICAL
=======

	department_flag = MEDSCI
	departments = DEPT_BITFLAG_MED
	bank_account_department = ACCOUNT_MED_BITFLAG
	payment_per_department = list(ACCOUNT_MED_ID = PAYCHECK_MEDIUM)
	mind_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_MEDICAL_DOCTOR
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559)):code/modules/jobs/job_types/paramedic.dm
	rpg_title = "Corpse Runner"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/emt
	)
	biohazard = 25//deal with sick like MDS, but also muck around in maint and get into the thick of it

/datum/outfit/job/emt
	name = "Paramedic"
	jobtype = /datum/job/emt

	id = /obj/item/card/id/job/paramed
	belt = /obj/item/pda/paramedic
	ears = /obj/item/radio/headset/headset_med
	gloves = /obj/item/clothing/gloves/color/latex/nitrile
	uniform = /obj/item/clothing/under/rank/medical/emt
	shoes = /obj/item/clothing/shoes/sneakers/white
	head = /obj/item/clothing/head/soft/emt
	suit =  /obj/item/clothing/suit/toggle/labcoat/emt
	l_hand = /obj/item/storage/firstaid/medical
	l_pocket = /obj/item/pinpointer/crew
	suit_store = /obj/item/sensor_device

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	chameleon_extras = /obj/item/gun/syringe
