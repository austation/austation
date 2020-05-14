mob/proc/emote(act, m_type = null, message = null, intentional = FALSE)
	var/silenced = FALSE
	for(var/datum/emote/P in key_emotes)
		if(!P.check_cooldown(src, intentional))
			silenced = TRUE
			continue
		if(P.run_emote(src, param, m_type, intentional))
			return TRUE
	if(intentional && !silenced)
		to_chat(src, "<span class='notice'>Unusable emote '[act]'. Say *help for a list.</span>")
	return FALSE
