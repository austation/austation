/datum/job/cmo
	title = "Chief Medical Officer"
	flag = CMO_JF
<<<<<<< HEAD
	department_head = list("Captain")
	department_flag = MEDSCI
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
=======
	department_head = list(JOB_NAME_CAPTAIN)
	supervisors = "the captain"
	auto_deadmin_role_flags = PREFTOGGLE_DEADMIN_POSITION_HEAD
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	head_announce = list(RADIO_CHANNEL_MEDICAL)
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	selection_color = "#c1e1ec"
	chat_color = "#7A97DA"
	req_admin_notify = 1
	minimal_player_age = 7
	exp_requirements = 1200
	exp_type = EXP_TYPE_MEDICAL
	exp_type_department = EXP_TYPE_MEDICAL

	outfit = /datum/outfit/job/cmo

	access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_HEADS, ACCESS_MINERAL_STOREROOM,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE, ACCESS_MECH_MEDICAL,
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS, ACCESS_BRIGPHYS, ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS)
	minimal_access = list(ACCESS_MEDICAL, ACCESS_MORGUE, ACCESS_GENETICS, ACCESS_CLONING, ACCESS_HEADS, ACCESS_MINERAL_STOREROOM,
			ACCESS_CHEMISTRY, ACCESS_VIROLOGY, ACCESS_CMO, ACCESS_SURGERY, ACCESS_RC_ANNOUNCE, ACCESS_MECH_MEDICAL,
<<<<<<< HEAD
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS, ACCESS_BRIGPHYS, ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS)
	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_MED

	display_order = JOB_DISPLAY_ORDER_CHIEF_MEDICAL_OFFICER
	departments = DEPARTMENT_MEDICAL | DEPARTMENT_COMMAND
=======
			ACCESS_KEYCARD_AUTH, ACCESS_SEC_DOORS, ACCESS_MAINT_TUNNELS, ACCESS_BRIGPHYS, ACCESS_EVA, ACCESS_EXTERNAL_AIRLOCKS, ACCESS_WEAPONS)

	department_flag = MEDSCI
	departments = DEPT_BITFLAG_MED | DEPT_BITFLAG_COM
	bank_account_department = ACCOUNT_MED_BITFLAG | ACCOUNT_COM_BITFLAG
	payment_per_department = list(
		ACCOUNT_COM_ID = PAYCHECK_COMMAND_NT,
		ACCOUNT_MED_ID = PAYCHECK_COMMAND_DEPT)
	mind_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CHIEF_MEDICAL_OFFICER
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "High Cleric"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/cmo
	)
	biohazard = 20

/datum/outfit/job/cmo
	name = "Chief Medical Officer"
	jobtype = /datum/job/cmo

	id = /obj/item/card/id/job/cmo
	belt = /obj/item/pda/heads/cmo
	l_pocket = /obj/item/pinpointer/crew
	ears = /obj/item/radio/headset/heads/cmo
	uniform = /obj/item/clothing/under/rank/medical/chief_medical_officer
	shoes = /obj/item/clothing/shoes/sneakers/brown
	suit = /obj/item/clothing/suit/toggle/labcoat/cmo
	l_hand = /obj/item/storage/firstaid/medical
	suit_store = /obj/item/flashlight/pen
	backpack_contents = list(/obj/item/melee/classic_baton/police/telescopic=1,
		/obj/item/modular_computer/tablet/preset/advanced/command=1)

	backpack = /obj/item/storage/backpack/medic
	satchel = /obj/item/storage/backpack/satchel/med
	duffelbag = /obj/item/storage/backpack/duffelbag/med

	chameleon_extras = list(/obj/item/gun/syringe, /obj/item/stamp/cmo)

/datum/outfit/job/cmo/hardsuit
	name = "Chief Medical Officer (Hardsuit)"

	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/hardsuit/medical/cmo
	suit_store = /obj/item/tank/internals/oxygen
	r_pocket = /obj/item/flashlight/pen
