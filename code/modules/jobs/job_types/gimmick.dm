/datum/job/gimmick //gimmick var must be set to true for all gimmick jobs BUT the parent
	title = "Gimmick"
	flag = GIMMICK
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	supervisors = "no one"
	selection_color = "#dddddd"
<<<<<<< HEAD
	chat_color = "#FFFFFF"

=======
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	exp_type_department = EXP_TYPE_GIMMICK

	access = list(ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MAINT_TUNNELS)

	department_flag = CIVILIAN
	departments = DEPT_BITFLAG_CIV
	bank_account_department = ACCOUNT_CIV_BITFLAG
	payment_per_department = list(ACCOUNT_CIV_ID = PAYCHECK_ASSISTANT)

	display_order = JOB_DISPLAY_ORDER_ASSISTANT
<<<<<<< HEAD
	departments = DEPARTMENT_SERVICE
=======
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "Peasant"
	allow_bureaucratic_error = FALSE
	outfit = /datum/outfit/job/gimmick
/datum/outfit/job/gimmick
	can_be_admin_equipped = FALSE // we want just the parent outfit to be unequippable since this leads to problems
/datum/job/gimmick/barber
	title = "Barber"
	flag = BARBER
<<<<<<< HEAD
=======
	department_head = list(JOB_NAME_HEADOFPERSONNEL)
	supervisors = "the head of personnel"
	gimmick = TRUE

>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	outfit = /datum/outfit/job/gimmick/barber
	access = list(ACCESS_MORGUE, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_MORGUE, ACCESS_MAINT_TUNNELS)
<<<<<<< HEAD
	gimmick = TRUE
	chat_color = "#bd9e86"

=======

	department_flag = CIVILIAN
	departments = DEPT_BITFLAG_SRV
	bank_account_department = ACCOUNT_SRV_BITFLAG
	payment_per_department = list(ACCOUNT_SRV_ID = PAYCHECK_ASSISTANT)

	rpg_title = "Scissorhands"
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman
	)
/datum/outfit/job/gimmick/barber
	name = "Barber"
	jobtype = /datum/job/gimmick/barber
<<<<<<< HEAD

	id = /obj/item/card/id/job/serv
	belt = /obj/item/pda/unlicensed
=======
	id = /obj/item/card/id/job/barber
	belt = /obj/item/modular_computer/tablet/pda/unlicensed
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	ears = /obj/item/radio/headset
	uniform = /obj/item/clothing/under/suit/sl
	shoes = /obj/item/clothing/shoes/laceup
	l_hand = /obj/item/storage/wallet
	l_pocket = /obj/item/razor/straightrazor
	can_be_admin_equipped = TRUE
<<<<<<< HEAD

/datum/job/gimmick/magician
	title = "Stage Magician"
	flag = MAGICIAN
	outfit = /datum/outfit/job/gimmick/magician
	access = list(ACCESS_THEATRE, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_THEATRE, ACCESS_MAINT_TUNNELS)
	gimmick = TRUE
	chat_color = "#b898b3"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/magic
	)

/datum/outfit/job/gimmick/magician
	name = "Stage Magician"
	jobtype = /datum/job/gimmick/magician

	id = /obj/item/card/id/job/serv
	belt = /obj/item/pda/unlicensed
=======
/datum/job/gimmick/stage_magician
	title = JOB_NAME_STAGEMAGICIAN
	flag = MAGICIAN
	department_head = list(JOB_NAME_HEADOFPERSONNEL)
	supervisors = "the head of personnel"
	gimmick = TRUE

	outfit = /datum/outfit/job/gimmick/stage_magician

	access = list(ACCESS_THEATRE, ACCESS_MAINT_TUNNELS)
	minimal_access = list(ACCESS_THEATRE, ACCESS_MAINT_TUNNELS)

	department_flag = CIVILIAN
	departments = DEPT_BITFLAG_SRV
	bank_account_department = ACCOUNT_SRV_BITFLAG
	payment_per_department = list(ACCOUNT_SRV_ID = PAYCHECK_MINIMAL)

	rpg_title = "Master Illusionist"
	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/magic
	)
/datum/outfit/job/gimmick/stage_magician
	name = JOB_NAME_STAGEMAGICIAN
	jobtype = /datum/job/gimmick/stage_magician
	id = /obj/item/card/id/job/stage_magician
	belt = /obj/item/modular_computer/tablet/pda/unlicensed
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	head = /obj/item/clothing/head/that
	ears = /obj/item/radio/headset
	neck = /obj/item/bedsheet/magician
	uniform = /obj/item/clothing/under/suit/black_really
	shoes = /obj/item/clothing/shoes/laceup
	gloves = /obj/item/clothing/gloves/color/white
	l_hand = /obj/item/cane
	backpack_contents = list(/obj/item/choice_beacon/magic=1)
	can_be_admin_equipped = TRUE
<<<<<<< HEAD

/datum/job/gimmick/shrink
	title = "Psychiatrist"
	flag = SHRINK
	outfit = /datum/outfit/job/gimmick/shrink
	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL)
	paycheck = PAYCHECK_EASY
	gimmick = TRUE
	chat_color = "#a2dfdc"
	departments = DEPARTMENT_MEDICAL
=======
/datum/job/gimmick/psychiatrist
	title = JOB_NAME_PSYCHIATRIST
	flag = PSYCHIATRIST
	department_head = list(JOB_NAME_CHIEFMEDICALOFFICER)
	supervisors = "the chief medical officer"
	gimmick = TRUE

	outfit = /datum/outfit/job/gimmick/psychiatrist

	access = list(ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL)
	minimal_access = list(ACCESS_MAINT_TUNNELS, ACCESS_MEDICAL)

	department_flag = MEDSCI
	departments = DEPT_BITFLAG_MED
	bank_account_department = ACCOUNT_MED_BITFLAG
	payment_per_department = list(ACCOUNT_MED_ID = PAYCHECK_EASY)
	mind_traits = list(TRAIT_MADNESS_IMMUNE, TRAIT_MEDICAL_METABOLISM)

	rpg_title = "Enchanter"

>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman
	)
<<<<<<< HEAD

/datum/outfit/job/gimmick/shrink //psychiatrist doesnt get much shit, but he has more access and a cushier paycheck
	name = "Psychiatrist"
	jobtype = /datum/job/gimmick/shrink

	id = /obj/item/card/id/job/med
	belt = /obj/item/pda/medical
=======
/datum/outfit/job/gimmick/psychiatrist //psychiatrist doesnt get much shit, but he has more access and a cushier paycheck
	name = JOB_NAME_PSYCHIATRIST
	jobtype = /datum/job/gimmick/psychiatrist
	id = /obj/item/card/id/job/psychiatrist
	belt = /obj/item/modular_computer/tablet/pda/medical
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	ears = /obj/item/radio/headset/headset_med
	uniform = /obj/item/clothing/under/suit/black
	shoes = /obj/item/clothing/shoes/laceup
	backpack_contents = list(/obj/item/choice_beacon/pet/ems=1)
	can_be_admin_equipped = TRUE
<<<<<<< HEAD

/datum/job/gimmick/celebrity
	title = "VIP"
	flag = CELEBRITY
	outfit = /datum/outfit/job/gimmick/celebrity
	access = list(ACCESS_MAINT_TUNNELS) //Assistants with shitloads of money, what could go wrong?
	minimal_access = list(ACCESS_MAINT_TUNNELS)
	gimmick = TRUE
	paycheck = PAYCHECK_VIP //our power is being fucking rich
	chat_color = "#ebc96b"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/vip
	)

/datum/outfit/job/gimmick/celebrity
	name = "VIP"
	jobtype = /datum/job/gimmick/celebrity

	id = /obj/item/card/id/gold
	belt = /obj/item/pda/celebrity
=======
/datum/job/gimmick/vip
	title = JOB_NAME_VIP
	flag = CELEBRITY
	gimmick = TRUE

	outfit = /datum/outfit/job/gimmick/vip

	access = list(ACCESS_MAINT_TUNNELS) //Assistants with shitloads of money, what could go wrong?
	minimal_access = list(ACCESS_MAINT_TUNNELS)

	department_flag = CIVILIAN
	departments = DEPT_BITFLAG_VIP
	bank_account_department = ACCOUNT_VIP_BITFLAG
	payment_per_department = list(ACCOUNT_VIP_ID = PAYCHECK_VIP)  //our power is being fucking rich

	rpg_title = "Master of Patronage"
	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/vip
	)
/datum/outfit/job/gimmick/vip
	name = JOB_NAME_VIP
	jobtype = /datum/job/gimmick/vip
	id = /obj/item/card/id/gold/vip
	belt = /obj/item/modular_computer/tablet/pda/vip
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	glasses = /obj/item/clothing/glasses/sunglasses/advanced
	ears = /obj/item/radio/headset/heads //VIP can talk loud for no reason
	uniform = /obj/item/clothing/under/suit/black_really
	shoes = /obj/item/clothing/shoes/laceup
	can_be_admin_equipped = TRUE
