/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
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
	selection_color = "#bbe291"
	chat_color = "#B2CEB3"
	exp_type_department = EXP_TYPE_SERVICE // This is so the jobs menu can work properly

	outfit = /datum/outfit/job/bartender

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)

	department_flag = CIVILIAN
	departments = DEPT_BITFLAG_SRV
	bank_account_department = ACCOUNT_SRV_BITFLAG
	payment_per_department = list(ACCOUNT_SRV_ID = PAYCHECK_EASY)

	display_order = JOB_DISPLAY_ORDER_BARTENDER
<<<<<<< HEAD
	departments = DEPARTMENT_SERVICE
=======
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "Tavernkeeper"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/bar
	)
/datum/outfit/job/bartender
	name = "Bartender"
	jobtype = /datum/job/bartender

	id = /obj/item/card/id/job/serv
	glasses = /obj/item/clothing/glasses/sunglasses/advanced/reagent
	belt = /obj/item/pda/bar
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/bartender
	suit = /obj/item/clothing/suit/armor/vest
	backpack_contents = list(/obj/item/storage/box/beanbag=1)
	shoes = /obj/item/clothing/shoes/laceup

