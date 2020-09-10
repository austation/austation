/obj/item/clothing/neck/stethoscope/attack(mob/living/carbon/human/M, mob/living/user)
	if(ishuman(M) && isliving(user))
		if(user.a_intent == INTENT_HELP)
			var/obj/item/organ/heart/heart = M.getorganslot(ORGAN_SLOT_HEART)
			if(heart && istype(heart,/obj/item/organ/heart/vampheart/))
				var/obj/item/organ/heart/vampheart/vampheart = heart
				if (vampheart.fakingit)
					vampheart.beating = 1
					..()
					vampheart.beating = 0
					return
	return ..()
