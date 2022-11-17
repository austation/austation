/*
Assistant
*/
/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	supervisors = "absolutely everyone"
	faction = "Station"
	total_positions = 5
	spawn_positions = 5
	selection_color = "#dddddd"
<<<<<<< HEAD
	chat_color = "#bdbdbd"
=======
	antag_rep = 7

	outfit = /datum/outfit/job/assistant

>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()

	department_flag = CIVILIAN
	departments = DEPT_BITFLAG_CIV
	bank_account_department = NONE // nothing is free for them
	payment_per_department = list(ACCOUNT_CIV_ID = PAYCHECK_ASSISTANT) // Get a job. Job reassignment changes your paycheck now. Get over it.

	display_order = JOB_DISPLAY_ORDER_ASSISTANT
<<<<<<< HEAD
	departments = DEPARTMENT_SERVICE
=======
>>>>>>> a596a80feb (Major bank system refactoring +New negative station trait: united budget (#7559))
	rpg_title = "Lout"

	species_outfits = list(
		SPECIES_PLASMAMAN = /datum/outfit/plasmaman
	)
/datum/job/assistant/get_access()
	if(CONFIG_GET(flag/assistants_have_maint_access) || !CONFIG_GET(flag/jobs_have_minimal_access)) //Config has assistant maint access set
		. = ..()
		. |= list(ACCESS_MAINT_TUNNELS)
	else
		return ..()

/datum/outfit/job/assistant
	name = "Assistant"
	jobtype = /datum/job/assistant
	belt = /obj/item/pda/assistant

/datum/outfit/job/assistant/pre_equip(mob/living/carbon/human/H)
	..()
	if (CONFIG_GET(flag/grey_assistants))
		if(H.jumpsuit_style == PREF_SUIT)
			uniform = /obj/item/clothing/under/color/grey
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/grey
	else
		if(H.jumpsuit_style == PREF_SUIT)
			uniform = /obj/item/clothing/under/color/random
		else
			uniform = /obj/item/clothing/under/color/jumpskirt/random
