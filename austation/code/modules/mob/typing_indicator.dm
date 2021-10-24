/mob/start_typing(source as text)
	set name = ".start_typing"
	set hidden = 1

	switch(source)
		if("say")
			create_typing_indicator()
		if("me")
			create_typing_indicator(TRUE)

/mob/living/carbon/human/create_typing_indicator(me = FALSE)
	var/mob/living/carbon/human/H = src
	if((HAS_TRAIT(H, TRAIT_MUTE) || H.silent) && !me)
		remove_overlay(TYPING_LAYER)
		return

	if(client)
		if(stat != CONSCIOUS || is_muzzled() || (client.prefs.toggles & TYPING_INDICATOR_SAY) || (me && (client.prefs.toggles & TYPING_INDICATOR_ME)))
			remove_overlay(TYPING_LAYER)
		else if(!overlays_standing[TYPING_LAYER])
			overlays_standing[TYPING_LAYER] = GLOB.human_typing_indicator
			apply_overlay(TYPING_LAYER)
	else
		remove_overlay(TYPING_LAYER)

/client/verb/typing_indicator()
	set name = "Show/Hide Typing Indicator"
	set category = "Preferences"
	set desc = "Toggles showing an indicator when you are typing a message."
	prefs.toggles ^= TYPING_INDICATOR_SAY
	prefs.save_preferences(src)
	to_chat(src, "You will [(prefs.toggles & TYPING_INDICATOR_SAY) ? "no longer" : "now"] display a typing indicator.")

	// Clear out any existing typing indicator.
	if(prefs.toggles & TYPING_INDICATOR_SAY)
		if(istype(mob))
			mob.create_typing_indicator()

	SSblackbox.record_feedback("tally", "toggle_verbs", 1, list("Toggle Typing Indicator (Speech)", "[usr.client.prefs.toggles & TYPING_INDICATOR_SAY ? "Disabled" : "Enabled"]"))


/client/verb/emote_indicator()
	set name = "Show/Hide Emote Typing Indicator"
	set category = "Preferences"
	set desc = "Toggles showing an indicator when you are typing an emote."
	prefs.toggles ^= TYPING_INDICATOR_ME
	prefs.save_preferences(src)
	to_chat(src, "You will [(prefs.toggles & TYPING_INDICATOR_ME) ? "no longer" : "now"] display a typing indicator for emotes.")

	// Clear out any existing typing indicator.
	if(prefs.toggles & TYPING_INDICATOR_ME)
		if(istype(mob))
			mob.create_typing_indicator(TRUE)

	SSblackbox.record_feedback("tally", "toggle_verbs", 1, list("Toggle Typing Indicator (Emote)", "[usr.client.prefs.toggles & TYPING_INDICATOR_ME ? "Disabled" : "Enabled"]"))
