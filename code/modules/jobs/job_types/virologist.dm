/datum/job/virologist
	title = "Virologist"
	flag = VIROLOGIST
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
	chat_color = "#75AEA3"
	exp_requirements = 180
	exp_type = EXP_TYPE_MEDICAL
	exp_type_department = EXP_TYPE_MEDICAL
	outfit = /datum/outfit/job/virologist

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_SURGERY, ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_MINERAL_STOREROOM, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_VIROLOGY, ACCESS_MECH_MEDICAL, ACCESS_MINERAL_STOREROOM, ACCESS_MAINT_TUNNELS)
<<<<<<< HEAD
	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_MED

	display_order = JOB_DISPLAY_ORDER_VIROLOGIST
	departments = DEPARTMENT_MEDICAL
=======

	department_flag = MEDSCI
	departments = DEPT_BITFLAG_MED
	bank_account_department = ACCOUNT_MED_BITFLAG
	payment_per_department = list(ACCOUNT_MED_ID = PAYCHECK_MEDIUM)
	mind_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_VIROLOGIST
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "Plague Doctor"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/viro
	)
	biohazard = 50 //duh

/datum/outfit/job/virologist
	name = "Virologist"
	jobtype = /datum/job/virologist

	id = /obj/item/card/id/job/viro
	belt = /obj/item/extrapolator
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/rank/medical/virologist
	mask = /obj/item/clothing/mask/surgical
	shoes = /obj/item/clothing/shoes/sneakers/white
	suit =  /obj/item/clothing/suit/toggle/labcoat/virologist
	suit_store =  /obj/item/flashlight/pen
	r_pocket = /obj/item/pda/viro

	backpack = /obj/item/storage/backpack/virology
	satchel = /obj/item/storage/backpack/satchel/vir
	duffelbag = /obj/item/storage/backpack/duffelbag/med
	pda_slot = ITEM_SLOT_RPOCKET
