/datum/config_entry/flag/chat_send_use_tgs
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/chat_ooc_channel_tag
	protection = CONFIG_ENTRY_LOCKED

// Overrides the upstream implementation to respect TGS config flags
/sendooc2ext(msg, list/allowed_types = list(), list/allowed_users = list(), list/allowed_roles = list())
	if(CONFIG_GET(flag/chat_send_use_tgs))
		var/ooc_tag = CONFIG_GET(string/chat_ooc_channel_tag)
		if(!length(ooc_tag))
			return
		send2chat(new /datum/tgs_message_content(msg), ooc_tag)
	else
		var/ooc_webhook = CONFIG_GET(string/ooc_webhook)
		if(!length(ooc_webhook))
			return
		send_webhook(ooc_webhook, msg, allowed_types = allowed_types, allowed_users = allowed_users, allowed_roles = allowed_roles)

/sendadminhelp2ext(msg, list/allowed_types = list(), list/allowed_users = list(), list/allowed_roles = list())
	if(CONFIG_GET(flag/chat_send_use_tgs))
		send2chat(new /datum/tgs_message_content(msg), "", TRUE)
	else
		var/adminhelp_webhook = CONFIG_GET(string/adminhelp_webhook)
		if(!length(adminhelp_webhook))
			return
		send_webhook(adminhelp_webhook, msg, allowed_types = allowed_types, allowed_users = allowed_users, allowed_roles = allowed_roles)
