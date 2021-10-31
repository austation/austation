/mob/living/carbon/human/can_inject(mob/user, error_msg, target_zone, var/penetrate_thick = 0, show_alert = TRUE)
	. = 1 // Default to returning true.
	if(user && !target_zone)
		target_zone = user.zone_selected
	if(HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
		. = 0
	// If targeting the head, see if the head item is thin enough.
	// If targeting anything else, see if the wear suit is thin enough.
	if (!penetrate_thick)
		var/alert_msg

		if(above_neck(target_zone))
			if(head && isclothing(head))
				var/obj/item/clothing/head/CH = head
				if(CH.clothing_flags & THICKMATERIAL)
					alert_msg = "There is no exposed flesh on [p_their()] head"
		if(wear_suit && isclothing(wear_suit))
			var/obj/item/clothing/suit/CS = wear_suit
			if(CS.clothing_flags & THICKMATERIAL)
				switch(target_zone)
					if(BODY_ZONE_CHEST)
						if(CS.body_parts_covered & CHEST)
							alert_msg = "There is no exposed flesh on this chest"
					if(BODY_ZONE_PRECISE_GROIN)
						if(CS.body_parts_covered & GROIN)
							alert_msg = "There is no exposed flesh on this groin"
					if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
						if(CS.body_parts_covered & ARMS)
							alert_msg = "There is no exposed flesh on these arms"
					if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
						if(CS.body_parts_covered & LEGS)
							alert_msg = "There is no exposed flesh on these legs"

		if(alert_msg)
			if(show_alert)
				balloon_alert(user, alert_msg)

			return FALSE

