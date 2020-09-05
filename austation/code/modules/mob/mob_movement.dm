/mob/toggle_move_intent(mob/user)
	AU_toggle_move_intent()

/mob/proc/AU_toggle_move_intent()
	if(m_intent == MOVE_INTENT_RUN)
		m_intent = MOVE_INTENT_WALK
	else
		if (HAS_TRAIT(src,TRAIT_NORUNNING))	// austation begin -- Bloodsucker integration
			to_chat(src, "You find yourself unable to run.")
			return FALSE // austation end
		m_intent = MOVE_INTENT_RUN
	if(hud_used && hud_used.static_inventory)
		for(var/obj/screen/mov_intent/selector in hud_used.static_inventory)
			selector.update_icon()
