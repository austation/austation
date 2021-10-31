//makes self augmentation possible
/datum/surgery/augmentation
	..()
	self_operable = TRUE

//only if morphine is in your system
/datum/surgery_step/replace_limb/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(user == target)
		chems_needed = list(/datum/reagent/medicine/morphine)
	..()
