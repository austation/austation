GLOBAL_DATUM_INIT(ahelp_tickets, /datum/help_tickets/admin, new)

/// Client Stuff

/client
	var/adminhelptimerid = 0	//a timer id for returning the ahelp verb
	var/datum/help_ticket/current_adminhelp_ticket	//the current ticket the (usually) not-admin client is dealing with

/client/proc/openTicketManager()
	set name = "Ticket Manager"
	set desc = "Opens the ticket manager"
	set category = "Admin"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	GLOB.ahelp_tickets.BrowseTickets(usr)

/datum/help_tickets/admin/BrowseTickets(mob/user)
	var/client/C = user.client
	if(!C)
		return
	var/datum/admins/admin_datum = GLOB.admin_datums[C.ckey]
	if(!admin_datum)
		message_admins("[C.ckey] attempted to browse tickets, but had no admin datum")
		return
	if(!admin_datum.admin_interface)
		admin_datum.admin_interface = new(user)
	admin_datum.admin_interface.ui_interact(user)

<<<<<<< HEAD
//TGUI TICKET THINGS

/datum/admin_help_ui/ui_state(mob/user)
	return GLOB.admin_state

/datum/admin_help_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		log_admin_private("[user.ckey] opened the ticket panel.")
		ui = new(user, src, "TicketBrowser", "Ticket Browser")
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/admin_help_ui/ui_data(mob/user)
	var/datum/admins/admin_datum = GLOB.admin_datums[user.ckey]
	if(!admin_datum)
		log_admin_private("[user] sent a request to interact with the ticket browser without sufficient rights.")
		message_admins("[user] sent a request to interact with the ticket browser without sufficient rights.")
		return
	var/list/data = list()
	data["admin_ckey"] = user.ckey
	data["unclaimed_tickets"] = GLOB.ahelp_tickets.get_ui_ticket_data(AHELP_UNCLAIMED)
	data["open_tickets"] = GLOB.ahelp_tickets.get_ui_ticket_data(AHELP_ACTIVE)
	data["closed_tickets"] = GLOB.ahelp_tickets.get_ui_ticket_data(AHELP_CLOSED)
	data["resolved_tickets"] = GLOB.ahelp_tickets.get_ui_ticket_data(AHELP_RESOLVED)
	return data

/datum/admin_help_ui/ui_act(action, params)
	var/datum/admins/admin_datum = GLOB.admin_datums[usr.ckey]
	if(!admin_datum)
		message_admins("[usr] sent a request to interact with the ticket browser without sufficient rights.")
		log_admin_private("[usr] sent a request to interact with the ticket browser without sufficient rights.")
		return
	var/ticket_id = text2num(params["id"])
	var/datum/admin_help/ticket = GLOB.ahelp_tickets.TicketByID(ticket_id)
	//Doing action on a ticket claims it
	var/claim_ticket = CLAIM_DONTCLAIM
	switch(action)
		if("claim")
			if(ticket.claimed_admin)
				var/confirm = alert("This ticket is already claimed, override claim?",,"Yes", "No")
				if(confirm == "No")
					return
			claim_ticket = CLAIM_OVERRIDE
		if("reject")
			claim_ticket = CLAIM_OVERRIDE
			ticket.Reject()
		if("ic")
			claim_ticket = CLAIM_OVERRIDE
			ticket.ICIssue()
		if("mhelp")
			claim_ticket = CLAIM_OVERRIDE
			ticket.MHelpThis()
		if("resolve")
			claim_ticket = CLAIM_OVERRIDE
			ticket.Resolve()
		if("reopen")
			claim_ticket = CLAIM_OVERRIDE
			ticket.Reopen()
		if("close")
			claim_ticket = CLAIM_OVERRIDE
			ticket.Close()
		if("view")
			ticket.TicketPanel()
		if("flw")
			admin_datum.admin_follow(get_mob_by_ckey(ticket.initiator.ckey))
		if("pm")
			usr.client.cmd_ahelp_reply(ticket.initiator)
			claim_ticket = CLAIM_CLAIMIFNONE
	if(claim_ticket == CLAIM_OVERRIDE || (claim_ticket == CLAIM_CLAIMIFNONE && !ticket.claimed_admin))
		ticket.Claim()

/datum/admin_help_tickets/proc/get_ui_ticket_data(state)
	var/list/l2b
	switch(state)
		if(AHELP_UNCLAIMED)
			l2b = unclaimed_tickets
		if(AHELP_ACTIVE)
			l2b = active_tickets
		if(AHELP_CLOSED)
			l2b = closed_tickets
		if(AHELP_RESOLVED)
			l2b = resolved_tickets
	if(!l2b)
		return
	var/list/dat = list()
	for(var/I in l2b)
		var/datum/admin_help/AH = I
		var/list/ticket = list(
			"id" = AH.id,
			"initiator_key_name" = AH.initiator_key_name,
			"name" = AH.name,
			"claimed_key_name" = AH.claimed_admin_key_name,
			"disconnected" = AH.initiator ? FALSE : TRUE,
			"state" = AH.state
		)
		dat += list(ticket)
	return dat

//End

//Tickets statpanel
/datum/admin_help_tickets/proc/stat_entry()
	var/list/tab_data = list()
	tab_data["Tickets"] = list(
		text = "Open Ticket Browser",
		type = STAT_BUTTON,
		action = "browsetickets",
	)
	tab_data["Active Tickets"] = list(
		text = "[active_tickets.len]",
		type = STAT_BUTTON,
		action = "browsetickets",
	)
	var/num_disconnected = 0
	for(var/l in list(active_tickets, unclaimed_tickets))
		for(var/I in l)
			var/datum/admin_help/AH = I
			if(AH.initiator)
				tab_data["#[AH.id]. [AH.initiator_key_name]"] = list(
					text = AH.name,
					type = STAT_BUTTON,
					action = "open_ticket",
					params = list("id" = AH.id),
				)
			else
				++num_disconnected
	if(num_disconnected)
		tab_data["Disconnected"] = list(
			text = "[num_disconnected]",
			type = STAT_BUTTON,
			action = "browsetickets",
		)
	tab_data["Closed Tickets"] = list(
		text = "[closed_tickets.len]",
		type = STAT_BUTTON,
		action = "browsetickets",
	)
	tab_data["Resolved Tickets"] = list(
		text = "[resolved_tickets.len]",
		type = STAT_BUTTON,
		action = "browsetickets",
	)
	return tab_data

//Reassociate still open ticket if one exists
/datum/admin_help_tickets/proc/ClientLogin(client/C)
	C.current_ticket = CKey2ActiveTicket(C.ckey)
	if(C.current_ticket)
		C.current_ticket.initiator = C
		C.current_ticket.AddInteraction("green", "Client reconnected.")
		SSblackbox.LogAhelp(C.current_ticket.id, "Reconnected", "Client reconnected", C.ckey) // austation -- ticket db storage

//Dissasociate ticket
/datum/admin_help_tickets/proc/ClientLogout(client/C)
	if(C.current_ticket)
		C.current_ticket.AddInteraction("red", "Client disconnected.")
		SSblackbox.LogAhelp(C.current_ticket.id, "Disconnected", "Client disconnected", C.ckey) // austation -- ticket db storage
		C.current_ticket.initiator = null
		C.current_ticket = null

//Get a ticket given a ckey
/datum/admin_help_tickets/proc/CKey2ActiveTicket(ckey)
	for(var/l in list(unclaimed_tickets, active_tickets))
		for(var/I in l)
			var/datum/admin_help/AH = I
			if(AH.initiator_ckey == ckey)
				return AH

//
// Ticket interaction
//

/datum/ticket_interaction
	var/time_stamp
	var/message_color = "default"
	var/from_user = ""
	var/to_user = ""
	var/message = ""
	var/from_user_safe
	var/to_user_safe

/datum/ticket_interaction/New()
	. = ..()
	time_stamp = time_stamp()

//
// Ticket datum
//

/datum/admin_help
	var/id
	var/name
	var/state = AHELP_UNCLAIMED

	var/opened_at
	var/closed_at

	var/client/initiator	//semi-misnomer, it's the person who ahelped/was bwoinked
	var/initiator_ckey
	var/initiator_key_name
	var/heard_by_no_admins = FALSE

	var/client/claimed_admin	//The admin that has claimed this ticket
	var/claimed_admin_key_name

	var/list/_interactions	//use AddInteraction() or, preferably, admin_ticket_log()

	var/static/ticket_counter = 0

	var/bwoink // is the ahelp player to admin (not bwoink) or admin to player (bwoink)

//call this on its own to create a ticket, don't manually assign current_ticket
//msg is the title of the ticket: usually the ahelp text
//is_bwoink is TRUE if this ticket was started by an admin PM
/datum/admin_help/New(msg, client/C, is_bwoink)
	//Clean the input message
	msg = sanitize(copytext_char(msg, 1, MAX_MESSAGE_LEN))
	if(!msg || !C || !C.mob)
		qdel(src)
		return

	id = ++ticket_counter
	opened_at = world.time

	name = copytext_char(msg, 1, 100)

	initiator = C
	initiator_ckey = initiator.ckey
	initiator_key_name = key_name(initiator, FALSE, TRUE)
	if(initiator.current_ticket)	//This is a bug
		stack_trace("Multiple ahelp current_tickets")
		initiator.current_ticket.AddInteraction("red", "Ticket erroneously left open by code")
		initiator.current_ticket.Close()
	initiator.current_ticket = src

	TimeoutVerb()

	_interactions = list()

	GLOB.ahelp_tickets.unclaimed_tickets += src

	if(is_bwoink)
		AddInteraction("blue", name, usr.ckey, initiator_key_name, "Administrator", "You")
		message_admins("<font color='blue'>Ticket [TicketHref("#[id]")] created</font>")
		Claim()	//Auto claim bwoinks
	else
		MessageNoRecipient(msg, TRUE) // austation -- ticket db storage, set new ticket flag

		//send it to tgs if nobody is on and tell us how many were on
		var/admin_number_present = send2tgs_adminless_only(initiator_ckey, "Ticket #[id]: [msg]")
		log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
		if(admin_number_present <= 0)
			to_chat(C, "<span class='notice'>No active admins are online, your adminhelp was sent through TGS to admins who are available. This may use IRC or Discord.</span>")
			heard_by_no_admins = TRUE

	bwoink = is_bwoink
	if(!bwoink)
		discordsendmsg("ahelp", "**ADMINHELP: (#[id]) [C.key]: ** \"[msg]\" [heard_by_no_admins ? "**(NO ADMINS)**" : "" ]")

/datum/admin_help/Destroy()
	RemoveActive()
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	return ..()

/datum/admin_help/proc/AddInteraction(msg_color, message, name_from, name_to, safe_from, safe_to)
	if(heard_by_no_admins && usr && usr.ckey != initiator_ckey)
		heard_by_no_admins = FALSE
		send2tgs(initiator_ckey, "Ticket #[id]: Answered by [key_name(usr)]")
	var/datum/ticket_interaction/interaction_message = new /datum/ticket_interaction
	interaction_message.message_color = msg_color
	interaction_message.message = message
	interaction_message.from_user = name_from
	interaction_message.to_user = name_to
	interaction_message.from_user_safe = safe_from
	interaction_message.to_user_safe = safe_to
	_interactions += interaction_message
	SStgui.update_uis(src)

/datum/admin_help/proc/TimeoutVerb()
	initiator.remove_verb(/client/verb/adminhelp)
	initiator.adminhelptimerid = addtimer(CALLBACK(initiator, /client/proc/giveadminhelpverb), 1200, TIMER_STOPPABLE)

//private
/datum/admin_help/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	if(state <= AHELP_ACTIVE)
		. += ClosureLinks(ref_src)

//private
/datum/admin_help/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reject'>REJT</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=icissue'>IC</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=close'>CLOSE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=resolve'>RSLVE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=mhelp'>MHELP</A>)"

//private
/datum/admin_help/proc/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reply'>[initiator_key_name]</A>"

//private
/datum/admin_help/proc/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=[action]'>[msg]</A>"

/datum/admin_help/proc/TicketPanel()
	ui_interact(usr)

/datum/admin_help/ui_interact(mob/user, datum/tgui/ui = null)
	//Support multiple tickets open at once
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		log_admin_private("[user.ckey] opened the ticket panel.")
		ui = new(user, src, "TicketMessenger", "Ticket Messenger")
		ui.set_autoupdate(TRUE)
		ui.open()

/datum/admin_help/ui_state(mob/user)
	return GLOB.admin_state

/datum/admin_help/ui_data(mob/user)
	var/datum/admins/admin_datum = GLOB.admin_datums[user.ckey]
	if(!admin_datum)
		message_admins("[user] sent a request to interact with the ticket window without sufficient rights.")
		log_admin_private("[user] sent a request to interact with the ticket window without sufficient rights.")
		return
	var/list/data = list()
	//Messages
	data["disconected"] = initiator
	data["time_opened"] = opened_at
	data["time_closed"] = closed_at
	data["ticket_state"] = state
	data["claimee"] = claimed_admin
	data["claimee_key"] = claimed_admin_key_name
	data["id"] = id
	data["sender"] = initiator_key_name
	data["world_time"] = world.time
	data["antag_status"] = "None"
	if(initiator)
		var/mob/living/M = initiator.mob
		if(M?.mind?.antag_datums)
			var/datum/antagonist/AD = M.mind.antag_datums[1]
			data["antag_status"] = AD.name
	data["messages"] = list()
	for(var/datum/ticket_interaction/message in _interactions)
		var/list/msg = list(
			"time" = message.time_stamp,
			"color" = message.message_color,
			"from" = message.from_user,
			"to" = message.to_user,
			"message" = message.message
		)
		data["messages"] += list(msg)
	return data

/datum/admin_help/ui_act(action, params)
	var/datum/admins/admin_datum = GLOB.admin_datums[usr.ckey]
	if(!admin_datum)
		message_admins("[usr] sent a request to interact with the ticket window without sufficient rights.")
		log_admin_private("[usr] sent a request to interact with the ticket window without sufficient rights.")
		return
	if(!check_rights(R_ADMIN))
		message_admins("[usr] sent a request to interact with the ticket window without sufficient rights. (Requires: R_ADMIN)")
		log_admin_private("[usr] sent a request to interact with the ticket window without sufficient rights.")
		return
	//Doing action on a ticket claims it
	var/claim_ticket = CLAIM_DONTCLAIM
	switch(action)
		if("sendpm")
			usr.client.cmd_ahelp_reply_instant(initiator, params["text"])
			claim_ticket = CLAIM_CLAIMIFNONE
		if("reject")
			Reject()
			claim_ticket = CLAIM_OVERRIDE
		if("mentorhelp")
			MHelpThis()
			claim_ticket = CLAIM_OVERRIDE
		if("close")
			Close()
			claim_ticket = CLAIM_OVERRIDE
		if("resolve")
			Resolve()
			claim_ticket = CLAIM_OVERRIDE
		if("markic")
			ICIssue()
			claim_ticket = CLAIM_OVERRIDE
		if("retitle")
			Retitle()
		if("reopen")
			Reopen()
			claim_ticket = CLAIM_OVERRIDE
		if("moreinfo")
			admin_datum.admin_more_info(get_mob_by_ckey(initiator.ckey))
		if("playerpanel")
			admin_datum.show_player_panel(get_mob_by_ckey(initiator.ckey))
		if("viewvars")
			usr.client.debug_variables(get_mob_by_ckey(initiator.ckey))
		if("subtlemsg")
			usr.client.cmd_admin_subtle_message(get_mob_by_ckey(initiator.ckey))
		if("flw")
			admin_datum.admin_follow(get_mob_by_ckey(initiator.ckey))
		if("traitorpanel")
			admin_datum.show_traitor_panel(get_mob_by_ckey(initiator.ckey))
		if("viewlogs")
			show_individual_logging_panel(get_mob_by_ckey(initiator.ckey))
		if("smite")
			usr.client.smite(get_mob_by_ckey(initiator.ckey))
	if(claim_ticket == CLAIM_OVERRIDE || (claim_ticket == CLAIM_CLAIMIFNONE && !claimed_admin))
		Claim()

/datum/admin_help/proc/MessageNoRecipient(msg, is_new = FALSE) // austation -- ticket db storage, better formatting
	var/ref_src = "[REF(src)]"

	//Message to be sent to all admins
	var/admin_msg = "<span class='adminnotice'><span class='adminhelp'>Ticket [TicketHref("#[id]", ref_src)]</span><b>: [LinkedReplyName(ref_src)] [FullMonty(ref_src)]:</b> <span class='linkify'>[keywords_lookup(msg)]</span></span>"

	AddInteraction("red", msg, initiator_key_name, claimed_admin_key_name, "You", "Administrator")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [msg]")

	//send this msg to all admins
	for(var/client/X in GLOB.admins)
		if(X.prefs.toggles & SOUND_ADMINHELP)
			SEND_SOUND(X, sound('sound/effects/adminhelp.ogg'))
		window_flash(X, ignorepref = TRUE)
		to_chat(X,
			type = MESSAGE_TYPE_ADMINPM,
			html = admin_msg)

	//show it to the person adminhelping too
	to_chat(initiator,
		type = MESSAGE_TYPE_ADMINPM,
		html = "<span class='adminnotice'>PM to-<b>Admins</b>: <span class='linkify'>[msg]</span></span>")
	if(is_new) // austation begin -- ticket db storage
		SSblackbox.LogAhelp(id, "Ticket Opened", msg, null, initiator.ckey)
	else
		SSblackbox.LogAhelp(id, "Reply", msg, null, initiator.ckey) // austation end

//Reopen a closed ticket
/datum/admin_help/proc/Reopen()
	if(state <= AHELP_ACTIVE)
		to_chat(usr, "<span class='warning'>This ticket is already open.</span>")
		return

	if(GLOB.ahelp_tickets.CKey2ActiveTicket(initiator_ckey))
		to_chat(usr, "<span class='warning'>This user already has an active ticket, cannot reopen this one.</span>")
		return

	GLOB.ahelp_tickets.active_tickets += src
	GLOB.ahelp_tickets.closed_tickets -= src
	GLOB.ahelp_tickets.resolved_tickets -= src
	switch(state)
		if(AHELP_CLOSED)
			SSblackbox.record_feedback("tally", "ahelp_stats", -1, "closed")
		if(AHELP_RESOLVED)
			SSblackbox.record_feedback("tally", "ahelp_stats", -1, "resolved")
	state = AHELP_ACTIVE
	closed_at = null
	if(initiator)
		initiator.current_ticket = src

	AddInteraction("purple", "Reopened by [key_name_admin(usr)]")
	var/msg = "<span class='adminhelp'>Ticket [TicketHref("#[id]")] reopened by [key_name_admin(usr)].</span>"
	message_admins(msg)
	log_admin_private(msg)
	SSblackbox.LogAhelp(id, "Reopened", "Reopened by [usr.ckey]", usr.ckey) // austation -- ticket db storage
	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "reopened")
	TicketPanel()	//can only be done from here, so refresh it

//private
/datum/admin_help/proc/RemoveActive()
	if(state > AHELP_ACTIVE)
		return
	closed_at = world.time
	if(state == AHELP_ACTIVE)
		GLOB.ahelp_tickets.active_tickets -= src
	else
		GLOB.ahelp_tickets.unclaimed_tickets -= src
	if(initiator && initiator.current_ticket == src)
		initiator.current_ticket = null

/datum/admin_help/proc/Claim(key_name = key_name_admin(usr), silent = FALSE)
	if(claimed_admin == usr)
		return
	if(initiator && !claimed_admin)
		to_chat(initiator, "<font color='red'>Your issue is being investigated by an administrator, please stand by.</span>")
	if(state == AHELP_UNCLAIMED)
		GLOB.ahelp_tickets.unclaimed_tickets -= src
		state = AHELP_ACTIVE
		GLOB.ahelp_tickets.ListInsert(src)
	var/updated = claimed_admin
	if(updated)
		AddInteraction("blue", "Claimed by [key_name] (Overwritten from [updated])")
	else
		AddInteraction("blue", "Claimed by [key_name]")
	claimed_admin = usr
	claimed_admin_key_name = usr.ckey
	if(!silent && !updated)
		SSblackbox.record_feedback("tally", "ahelp_stats", 1, "claimed")
		var/msg = "Ticket [TicketHref("#[id]")] claimed by [key_name]."
		message_admins(msg)
		SSblackbox.LogAhelp(id, "Claimed", "Claimed by [usr.key]", null,  usr.ckey) // austation -- ticket db storage
		log_admin_private(msg)

	if(!bwoink && !silent && !updated)
		discordsendmsg("ahelp", "Ticket #[id] is being investigated by [key_name(usr, include_link=0)]")

//Mark open ticket as closed/meme
/datum/admin_help/proc/Close(key_name = key_name_admin(usr), silent = FALSE)
	if(state > AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_CLOSED
	GLOB.ahelp_tickets.ListInsert(src)
	AddInteraction("red", "Closed by [key_name].")
	if(!silent)
		SSblackbox.record_feedback("tally", "ahelp_stats", 1, "closed")
		var/msg = "Ticket [TicketHref("#[id]")] closed by [key_name]."
		message_admins(msg)
		SSblackbox.LogAhelp(id, "Closed", "Closed by [usr.key]", null, usr.ckey) // austation -- ticket db storage
		log_admin_private(msg)

	if(!bwoink && !silent)
		discordsendmsg("ahelp", "Ticket #[id] closed by [key_name(usr, include_link=0)]")

//Mark open ticket as resolved/legitimate, returns ahelp verb
/datum/admin_help/proc/Resolve(key_name = key_name_admin(usr), silent = FALSE)
	if(state > AHELP_ACTIVE)
		return
	RemoveActive()
	state = AHELP_RESOLVED
	GLOB.ahelp_tickets.ListInsert(src)

	addtimer(CALLBACK(initiator, /client/proc/giveadminhelpverb), 50)

	AddInteraction("green", "Resolved by [key_name].")
	to_chat(initiator, "<span class='adminhelp'>Your ticket has been resolved by an admin. The Adminhelp verb will be returned to you shortly.</span>")
	if(!silent)
		SSblackbox.record_feedback("tally", "ahelp_stats", 1, "resolved")
		var/msg = "Ticket [TicketHref("#[id]")] resolved by [key_name]"
		message_admins(msg)
		SSblackbox.LogAhelp(id, "Resolved", "Resolved by [usr.key]", null, usr.ckey) // austation -- ticket db storage
		log_admin_private(msg)

	if(!bwoink)
		discordsendmsg("ahelp", "Ticket #[id] resolved by [key_name(usr, include_link=0)]")

//Close and return ahelp verb, use if ticket is incoherent
/datum/admin_help/proc/Reject(key_name = key_name_admin(usr))
	if(state > AHELP_ACTIVE)
		return

	if(initiator)
		initiator.giveadminhelpverb()

		SEND_SOUND(initiator, sound('sound/effects/adminhelp.ogg'))

		to_chat(initiator, "<font color='red' size='4'><b>- AdminHelp Rejected! -</b></font>")
		to_chat(initiator, "<font color='red'><b>The administrators could not resolve your ticket.</b> The adminhelp verb has been returned to you so that you may try again.</font>")
		to_chat(initiator, "Please try to be calm, clear, and descriptive in admin helps, do not assume the admin has seen any related events, and clearly state the names of anybody you are reporting.")

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "rejected")
	var/msg = "Ticket [TicketHref("#[id]")] rejected by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("red", "Rejected by [key_name].")
	SSblackbox.LogAhelp(id, "Rejected", "Rejected by [usr.key]", null, usr.ckey) // austation -- ticket db storage
	Close(silent = TRUE)

	if(!bwoink)
		discordsendmsg("ahelp", "Ticket #[id] rejected by [key_name(usr, include_link=0)]")

//Resolve ticket with IC Issue message
/datum/admin_help/proc/ICIssue(key_name = key_name_admin(usr))
	if(state > AHELP_ACTIVE)
		return

	var/msg = "<font color='red' size='4'><b>- AdminHelp marked as IC issue! -</b></font><br>"
	msg += "<font color='red'>Your issue has been determined by an administrator to be an in character issue and does NOT require administrator intervention at this time. For further resolution you should pursue options that are in character.</font><br>"

	if(initiator)
		to_chat(initiator, msg)

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "IC")
	msg = "Ticket [TicketHref("#[id]")] marked as IC by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("red", "Marked as IC issue by [key_name]")
	SSblackbox.LogAhelp(id, "IC Issue", "Marked as IC issue by [usr.key]", null,  usr.ckey) // austation -- ticket db storage
	Resolve(silent = TRUE)

	if(!bwoink)
		discordsendmsg("ahelp", "Ticket #[id] marked as IC by [key_name(usr, include_link=0)]")

/datum/admin_help/proc/MHelpThis(key_name = key_name_admin(usr))
	if(state > AHELP_ACTIVE)
		return

	if(initiator)
		initiator.giveadminhelpverb()

		SEND_SOUND(initiator, sound('sound/effects/adminhelp.ogg'))

		to_chat(initiator, "<font color='red' size='4'><b>- AdminHelp Rejected! -</b></font>")
		to_chat(initiator, "<font color='red'>This question may regard <b>game mechanics or how-tos</b>. Such questions should be asked with <b>Mentorhelp</b>.</font>")

	SSblackbox.record_feedback("tally", "ahelp_stats", 1, "mhelp this")
	var/msg = "Ticket [TicketHref("#[id]")] told to mentorhelp by [key_name]"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("red", "Told to mentorhelp by [key_name].")
	if(!bwoink)
		discordsendmsg("ahelp", "Ticket #[id] told to mentorhelp by [key_name(usr, include_link=0)]")
	Close(silent = TRUE)

/datum/admin_help/proc/Retitle()
	var/new_title = capped_input(usr, "Enter a title for the ticket", "Rename Ticket", name)
	if(new_title)
		name = new_title
		//not saying the original name cause it could be a long ass message
		var/msg = "Ticket [TicketHref("#[id]")] titled [name] by [key_name_admin(usr)]"
		message_admins(msg)
		log_admin_private(msg)
	TicketPanel()	//we have to be here to do this

//Forwarded action from admin/Topic
/datum/admin_help/proc/Action(action)
	testing("Ahelp action: [action]")
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_ahelp_reply(initiator)
		if("icissue")
			ICIssue()
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("reopen")
			Reopen()
		if("mhelp")
			MHelpThis()

//
//CLIENT PROCS
//

=======
>>>>>>> 6218431bc4 (Refactor mentors to use admin ticketing system (#7430))
/client/proc/giveadminhelpverb()
	if(!src)
		return
	src.add_verb(/client/verb/adminhelp)
	deltimer(adminhelptimerid)
	adminhelptimerid = 0

// Used for methods where input via arg doesn't work
/client/proc/get_adminhelp()
	var/msg = capped_multiline_input(src, "Please describe your problem concisely and an admin will help as soon as they're able. Include the names of the people you are ahelping against if applicable.", "Adminhelp contents")
	adminhelp(msg)

/client/verb/adminhelp(msg as message)
	set category = "Admin"
	set name = "Adminhelp"

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<span class='danger'>Error: Admin-PM: You cannot send adminhelps (Muted).</span>")
		return
	if(handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	msg = trim(msg)

	if(!msg)
		return

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Adminhelp") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	if(current_adminhelp_ticket)
		if(alert(usr, "You already have a ticket open. Is this for the same issue?",,"Yes","No") != "No")
			if(current_adminhelp_ticket)
				current_adminhelp_ticket.MessageNoRecipient(msg)
				current_adminhelp_ticket.TimeoutVerb()
				return
			else
				to_chat(usr, "<span class='warning'>Ticket not found, creating new one...</span>")
		else
			current_adminhelp_ticket.AddInteraction("yellow", "[usr] opened a new ticket.")
			current_adminhelp_ticket.Close()

	var/datum/help_ticket/admin/ticket = new(src)
	ticket.Create(msg, FALSE)

/// Ticket List UI

/datum/help_ui/admin/ui_state(mob/user)
	return GLOB.admin_state

/datum/help_ui/admin/get_data_glob()
	return GLOB.ahelp_tickets

/datum/help_ui/admin/add_additional_ticket_data(data)
	// Add mentorhelp tickets to admin panel
	var/datum/help_tickets/data_glob = GLOB.mhelp_tickets
	data["unclaimed_tickets_mentor"] = data_glob.get_ui_ticket_data(TICKET_UNCLAIMED)
	data["open_tickets_mentor"] = data_glob.get_ui_ticket_data(TICKET_ACTIVE)
	data["closed_tickets_mentor"] = data_glob.get_ui_ticket_data(TICKET_CLOSED)
	data["resolved_tickets_mentor"] = data_glob.get_ui_ticket_data(TICKET_RESOLVED)
	return data

/datum/help_ui/admin/get_additional_ticket_data(ticket_id)
	return GLOB.mhelp_tickets.TicketByID(ticket_id) // make sure mhelp tickets can be retrieved for actions

/datum/help_ui/admin/check_permission(mob/user)
	return !!GLOB.admin_datums[user.ckey]

/datum/help_ui/admin/reply(whom)
	usr.client.cmd_ahelp_reply(whom)

/// Tickets Holder

/datum/help_tickets/admin

/datum/help_tickets/admin/get_active_ticket(client/C)
	return C.current_adminhelp_ticket

/datum/help_tickets/admin/set_active_ticket(client/C, datum/help_ticket/ticket)
	C.current_adminhelp_ticket = ticket

/// Ticket Datum

/datum/help_ticket/admin
	var/heard_by_no_admins = FALSE
	/// is the ahelp player to admin (not bwoink) or admin to player (bwoink)
	var/bwoink

/datum/help_ticket/admin/get_data_glob()
	return GLOB.ahelp_tickets

/datum/help_ticket/admin/check_permission(mob/user)
	return !!GLOB.admin_datums[user.ckey]

/datum/help_ticket/admin/check_permission_act(mob/user)
	return !!GLOB.admin_datums[user.ckey] && check_rights(R_ADMIN)

/datum/help_ticket/admin/ui_state(mob/user)
	return GLOB.admin_state

/datum/help_ticket/admin/reply(whom, msg)
	usr.client.cmd_ahelp_reply_instant(whom, msg)

/datum/help_ticket/admin/Create(msg, is_bwoink)
	if(!..())
		return FALSE
	if(is_bwoink)
		AddInteraction("blue", name, usr.ckey, initiator_key_name, "Administrator", "You")
		message_admins("<font color='blue'>Ticket [TicketHref("#[id]")] created</font>")
		Claim()	//Auto claim bwoinks
	else
		MessageNoRecipient(msg)

		//send it to tgs if nobody is on and tell us how many were on
		var/admin_number_present = send2tgs_adminless_only(initiator_ckey, "Ticket #[id]: [msg]")
		log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
		if(admin_number_present <= 0)
			to_chat(initiator, "<span class='notice'>No active admins are online, your adminhelp was sent through TGS to admins who are available. This may use IRC or Discord.</span>", type = message_type)
			heard_by_no_admins = TRUE

	bwoink = is_bwoink
	if(!bwoink)
		discordsendmsg("ahelp", "**ADMINHELP: (#[id]) [initiator.key]: ** \"[msg]\" [heard_by_no_admins ? "**(NO ADMINS)**" : "" ]")
	return TRUE

/datum/help_ticket/admin/NewFrom(datum/help_ticket/old_ticket)
	if(!..())
		return FALSE
	MessageNoRecipient(initial_msg, FALSE)
	//send it to tgs if nobody is on and tell us how many were on
	var/admin_number_present = send2tgs_adminless_only(initiator_ckey, "Ticket #[id]: [initial_msg]")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [name] - heard by [admin_number_present] non-AFK admins who have +BAN.")
	if(admin_number_present <= 0)
		to_chat(initiator, "<span class='notice'>No active admins are online, your adminhelp was sent through TGS to admins who are available. This may use IRC or Discord.</span>")
		heard_by_no_admins = TRUE
	discordsendmsg("ahelp", "**ADMINHELP: (#[id]) [initiator.key]: ** \"[initial_msg]\" [heard_by_no_admins ? "**(NO ADMINS)**" : "" ]")
	return TRUE

/datum/help_ticket/admin/AddInteraction(msg_color, message, name_from, name_to, safe_from, safe_to)
	if(heard_by_no_admins && usr && usr.ckey != initiator_ckey)
		heard_by_no_admins = FALSE
		send2tgs(initiator_ckey, "Ticket #[id]: Answered by [key_name(usr)]")
	..()

/datum/help_ticket/admin/TimeoutVerb()
	initiator.remove_verb(/client/verb/adminhelp)
	initiator.adminhelptimerid = addtimer(CALLBACK(initiator, /client/proc/giveadminhelpverb), 1200, TIMER_STOPPABLE)

/datum/help_ticket/admin/get_ticket_additional_data(mob/user, list/data)
	data["antag_status"] = "None"
	if(initiator)
		var/mob/living/M = initiator.mob
		if(M?.mind?.antag_datums)
			var/datum/antagonist/AD = M.mind.antag_datums[1]
			data["antag_status"] = AD.name
	return data

/datum/help_ticket/admin/key_name_ticket(mob/user)
	return key_name_admin(user)

/datum/help_ticket/admin/message_ticket_managers(msg)
	message_admins(msg)

/datum/help_ticket/admin/MessageNoRecipient(msg, add_to_ticket = TRUE)
	var/ref_src = "[REF(src)]"

	//Message to be sent to all admins
	var/admin_msg = "<span class='adminnotice'><span class='adminhelp'>Ticket [TicketHref("#[id]", ref_src)]</span><b>: [LinkedReplyName(ref_src)] [FullMonty(ref_src)]:</b> <span class='linkify'>[keywords_lookup(msg)]</span></span>"

	if(add_to_ticket)
		AddInteraction("red", msg, initiator_key_name, claimee_key_name, "You", "Administrator")
	log_admin_private("Ticket #[id]: [key_name(initiator)]: [msg]")

	//send this msg to all admins
	for(var/client/X in GLOB.admins)
		if(X.prefs.toggles & PREFTOGGLE_SOUND_ADMINHELP)
			SEND_SOUND(X, sound(reply_sound))
		window_flash(X, ignorepref = TRUE)
		to_chat(X,
			type = message_type,
			html = admin_msg)

	//show it to the person adminhelping too
	if(add_to_ticket)
		to_chat(initiator,
			type = message_type,
			html = "<span class='adminnotice'>PM to-<b>Admins</b>: <span class='linkify'>[msg]</span></span>")


/datum/help_ticket/admin/proc/FullMonty(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = ADMIN_FULLMONTY_NONAME(initiator.mob)
	if(state <= TICKET_ACTIVE)
		. += ClosureLinks(ref_src)

/datum/help_ticket/admin/proc/ClosureLinks(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	. = " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reject'>REJT</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=icissue'>IC</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=close'>CLOSE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=resolve'>RSLVE</A>)"
	. += " (<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=mhelp'>MHELP</A>)"

/datum/help_ticket/admin/LinkedReplyName(ref_src)
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=reply'>[initiator_key_name]</A>"

/datum/help_ticket/admin/TicketHref(msg, ref_src, action = "ticket")
	if(!ref_src)
		ref_src = "[REF(src)]"
	return "<A HREF='?_src_=holder;[HrefToken(TRUE)];ahelp=[ref_src];ahelp_action=[action]'>[msg]</A>"

/datum/help_ticket/admin/blackbox_feedback(increment, data)
	SSblackbox.record_feedback("tally", "ahelp_stats", increment, data)

/// Resolve ticket with IC Issue message
/datum/help_ticket/admin/proc/ICIssue(key_name = key_name_ticket(usr))
	if(state > TICKET_ACTIVE)
		return

	if(!claimee)
		Claim(silent = TRUE)

	if(initiator)
		addtimer(CALLBACK(initiator, /client/proc/giveadminhelpverb), 5 SECONDS)
		SEND_SOUND(initiator, sound(reply_sound))
		resolve_message(status = "marked as IC Issue!", message = "\A [handling_name] has handled your ticket and has determined that the issue you are facing is an in-character issue and does not require [handling_name] intervention at this time.<br />\
		For further resolution, you should pursue options that are in character, such as filing a report with security or a head of staff.<br />\
		Thank you for creating a ticket, the adminhelp verb will be returned to you shortly.")

	blackbox_feedback(1, "IC")
	var/msg = "<span class='[span_class]'>Ticket [TicketHref("#[id]")] marked as IC by [key_name]</span>"
	message_admins(msg)
	log_admin_private(msg)
	AddInteraction("red", "Marked as IC issue by [key_name]")
	Resolve(silent = TRUE)

	if(!bwoink)
		discordsendmsg("ahelp", "Ticket #[id] marked as IC by [key_name(usr, include_link = FALSE)]")

/datum/help_ticket/admin/proc/MHelpThis(key_name = key_name_ticket(usr))
	if(state > TICKET_ACTIVE)
		return

	if(!claimee)
		Claim(silent = TRUE)

	if(initiator)
		initiator.giveadminhelpverb()
		SEND_SOUND(initiator, sound(reply_sound))
		resolve_message(status = "De-Escalated to Mentorhelp!", message = "This question may regard <b>game mechanics or how-tos</b>. Such questions should be asked with <b>Mentorhelp</b>.")

	blackbox_feedback(1, "mhelp this")
	var/msg = "<span class='[span_class]'>Ticket [TicketHref("#[id]")] transferred to mentorhelp by [key_name]</span>"
	AddInteraction("red", "Transferred to mentorhelp by [key_name].")
	if(!bwoink)
		discordsendmsg("ahelp", "Ticket #[id] transferred to mentorhelp by [key_name(usr, include_link = FALSE)]")
	Close(silent = TRUE, hide_interaction = TRUE)
	if(initiator.prefs.muted & MUTE_MHELP)
		message_admins(src, "<span class='danger'>Attempted de-escalation to mentorhelp failed because [initiator_key_name] is mhelp muted.</span>")
		return
	message_admins(msg)
	log_admin_private(msg)
	var/datum/help_ticket/mentor/ticket = new(initiator)
	ticket.NewFrom(src)

/// Forwarded action from admin/Topic
/datum/help_ticket/admin/proc/Action(action)
	testing("Ahelp action: [action]")
	switch(action)
		if("ticket")
			TicketPanel()
		if("retitle")
			Retitle()
		if("reject")
			Reject()
		if("reply")
			usr.client.cmd_ahelp_reply(initiator)
		if("icissue")
			ICIssue()
		if("close")
			Close()
		if("resolve")
			Resolve()
		if("reopen")
			Reopen()
		if("mhelp")
			MHelpThis()

/datum/help_ticket/admin/Claim(key_name = key_name_ticket(usr), silent = FALSE)
	..()
	if(!bwoink && !silent && !claimee)
		discordsendmsg("ahelp", "Ticket #[id] is being investigated by [key_name(usr, include_link = FALSE)]")

/datum/help_ticket/admin/Close(key_name = key_name_ticket(usr), silent = FALSE, hide_interaction = FALSE)
	..()
	if(!bwoink && !silent)
		discordsendmsg("ahelp", "Ticket #[id] closed by [key_name(usr, include_link = FALSE)]")

/datum/help_ticket/admin/Resolve(key_name = key_name_ticket(usr), silent = FALSE)
	..()
	addtimer(CALLBACK(initiator, /client/proc/giveadminhelpverb), 5 SECONDS)
	if(!bwoink)
		discordsendmsg("ahelp", "Ticket #[id] resolved by [key_name(usr, include_link = FALSE)]")

/datum/help_ticket/admin/Reject(key_name = key_name_ticket(usr), extra_text = ", and clearly state the names of anybody you are reporting")
	..()
	if(initiator)
		initiator.giveadminhelpverb()
	if(!bwoink)
		discordsendmsg("ahelp", "Ticket #[id] rejected by [key_name(usr, include_link = FALSE)]")

/datum/help_ticket/admin/resolve_message(status = "Resolved", message = null, extratext = " If your ticket was a report, then the appropriate action has been taken where necessary.")
	..()
