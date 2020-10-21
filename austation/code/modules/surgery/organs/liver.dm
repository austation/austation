/obj/item/organ/liver/cybernetic/eso_liver
	name = "esoteric liver"
	icon = 'austation/icons/obj/ausurgery.dmi'
	icon_state = "eso_liver"
	desc = "An artificial liver that uses bluespace technology to automatically filter out excess alcohol aswell as toxins, this liver is built from such advanced technology that it is impervious to electromagnetic pulses"
	alcohol_tolerance = 0.001
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 10 //can shrug off up to 10u of toxins
	toxLethality = 0.008 //20% less damage than a normal liver
	emp_vulnerability = 0
	status = ORGAN_ROBOTIC
	organ_flags = ORGAN_SYNTHETIC
