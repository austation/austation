/datum/job/hydro
	title = "Botanist"
	flag = BOTANIST
<<<<<<< HEAD
	department_head = list("Head of Personnel")
	department_flag = CIVILIAN
=======
	department_head = list(JOB_NAME_HEADOFPERSONNEL)
	supervisors = "the head of personnel"
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	selection_color = "#bbe291"
	chat_color = "#95DE85"

	outfit = /datum/outfit/job/botanist

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_MINERAL_STOREROOM)
	minimal_access = list(ACCESS_HYDROPONICS, ACCESS_MORGUE, ACCESS_MINERAL_STOREROOM)

	department_flag = CIVILIAN
	departments = DEPT_BITFLAG_SRV
	bank_account_department = ACCOUNT_SRV_BITFLAG
	payment_per_department = list(ACCOUNT_SRV_ID = PAYCHECK_EASY)

	display_order = JOB_DISPLAY_ORDER_BOTANIST
<<<<<<< HEAD
	departments = DEPARTMENT_SERVICE
=======
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "Gardener"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman/botany
	)
/datum/outfit/job/botanist
	name = "Botanist"
	jobtype = /datum/job/hydro

	id = /obj/item/card/id/job/serv
	belt = /obj/item/pda/service
	ears = /obj/item/radio/headset/headset_srv
	uniform = /obj/item/clothing/under/rank/civilian/hydroponics
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/botanic_leather
	suit_store = /obj/item/plant_analyzer

	backpack = /obj/item/storage/backpack/botany
	satchel = /obj/item/storage/backpack/satchel/hyd


