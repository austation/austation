obj/item/organ/lungs/cybernetic/eso_lungs
	name = "upgraded cybernetic lungs"
	desc = "A pair of lungs created with such advanced technologies that it is capable of filtering great amounts of Co2 and toxin from the air aswell as being far more efficent with Oxygen consumption, due to its use of bluespace technology these lungs hold complete immunity to electromagnets"
	icon = 'austation/icons/obj/ausurgery.dmi'
	icon_state = "eso_lungs"
	safe_toxins_max = 20
	safe_co2_max = 20
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	safe_oxygen_min = 10
	emp_vulnerability = 0

	cold_level_1_threshold = 200
	cold_level_2_threshold = 140
	cold_level_3_threshold = 100
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC

