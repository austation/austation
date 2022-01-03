#define IMPORTANT_ACTION_COOLDOWN (60 SECONDS)
#define MAX_STATUS_LINE_LENGTH 40

#define STATE_BUYING_SHUTTLE "buying_shuttle"
#define STATE_CHANGING_STATUS "changing_status"
#define STATE_MESSAGES "messages"

// The communications computer
/obj/machinery/computer/communications
	name = "communications console"
	desc = "A console used for high-priority announcements and emergencies."
	icon_screen = "comm"
	icon_keyboard = "tech_key"
	req_access = list(ACCESS_HEADS)
	circuit = /obj/item/circuitboard/computer/communications
	light_color = LIGHT_COLOR_BLUE

	/// Authentication level
	var/authenticated = 0

	/// Cooldown for important actions, such as messaging CentCom or other sectors
	COOLDOWN_DECLARE(static/important_action_cooldown)

	/// The current state of the UI
	var/state = STATE_MESSAGES

	/// The current state of the UI for AIs
	var/cyborg_state = STATE_MESSAGES

	/// The name of the user who logged in
	var/authorize_name

	/// The access that the card had on login
	var/list/authorize_access

	/// The messages this console has been sent
	var/list/datum/comm_message/messages

	/// How many times the alert level has been changed
	/// Used to clear the modal to change alert level
	var/alert_level_tick = 0

	/// The last lines used for changing the status display
	var/static/last_status_display

/obj/machinery/computer/communications/Initialize()
	. = ..()
	GLOB.shuttle_caller_list += src

/// Are we NOT a silicon, AND we're logged in as the captain?
/obj/machinery/computer/communications/proc/authenticated_as_non_silicon_captain(mob/user)
	if (issilicon(user))
		return FALSE
	return ACCESS_CAPTAIN in authorize_access

/// Are we a silicon, OR we're logged in as the captain?
/obj/machinery/computer/communications/proc/authenticated_as_silicon_or_captain(mob/user)
	if (issilicon(user))
		return TRUE
	return ACCESS_CAPTAIN in authorize_access

/// Are we a silicon, OR logged in?
/obj/machinery/computer/communications/proc/authenticated(mob/user)
	if (issilicon(user))
		return TRUE
	return authenticated

/obj/machinery/computer/communications/attackby(obj/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		attack_hand(user)
	else
		return ..()

/obj/machinery/computer/communications/emag_act(mob/user)
	if (obj_flags & EMAGGED)
		return
	obj_flags |= EMAGGED
	if (authenticated)
		authorize_access = get_all_accesses()
	to_chat(user, "<span class='danger'>You scramble the communication routing circuits!</span>")
	playsound(src, 'sound/machines/terminal_alert.ogg', 50, 0)

/obj/machinery/computer/communications/ui_act(action, list/params)
	var/static/list/approved_states = list(STATE_BUYING_SHUTTLE, STATE_CHANGING_STATUS, STATE_MESSAGES)
	var/static/list/approved_status_pictures = list("biohazard", "blank", "default", "lockdown", "redalert", "shuttle")

	. = ..()
	if (.)
		return

	if (!has_communication())
		return

	switch (action)
		if ("answerMessage")
			if (!authenticated(usr))
				return
			var/answer_index = text2num(params["answer"])
			var/message_index = text2num(params["message"])
			if (!answer_index || !message_index || answer_index < 1 || message_index < 1)
				return
			var/datum/comm_message/message = messages[message_index]
			if (message.answered)
				return
			message.answered = answer_index
			message.answer_callback.InvokeAsync()
			. = TRUE
		if ("callShuttle")
			if (!authenticated(usr))
				return
			var/reason = trim(params["reason"], MAX_MESSAGE_LEN)
			if (length(reason) < CALL_SHUTTLE_REASON_LENGTH)
				return
			SSshuttle.requestEvac(usr, reason)
			post_status("shuttle")
			. = TRUE
		if ("changeSecurityLevel")
			if (!authenticated_as_silicon_or_captain(usr))
				return

			// Check if they have
			if (!issilicon(usr))
				var/obj/item/held_item = usr.get_active_held_item()
				var/obj/item/card/id/id_card = held_item?.GetID()
				if (!istype(id_card))
					to_chat(usr, "<span class='warning'>You need to swipe your ID!</span>")
					playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
					return
				if (!(ACCESS_CAPTAIN in id_card.access))
					to_chat(usr, "<span class='warning'>You are not authorized to do this!</span>")
					playsound(src, 'sound/machines/terminal_prompt_deny.ogg', 50, FALSE)
					return

			var/new_sec_level = seclevel2num(params["newSecurityLevel"])
			if (new_sec_level != SEC_LEVEL_GREEN && new_sec_level != SEC_LEVEL_BLUE)
				return
			if (GLOB.security_level == new_sec_level)
				return

			set_security_level(new_sec_level)

			to_chat(usr, "<span class='notice'>Authorization confirmed. Modifying security level.</span>")
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)

			// Only notify people if an actual change happened
			log_game("[key_name(usr)] has changed the security level to [params["newSecurityLevel"]] with [src] at [AREACOORD(usr)].")
			message_admins("[ADMIN_LOOKUPFLW(usr)] has changed the security level to [params["newSecurityLevel"]] with [src] at [AREACOORD(usr)].")
			deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> has changed the security level to [params["newSecurityLevel"]] with [src] at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)

			alert_level_tick += 1
			. = TRUE
		if ("deleteMessage")
			if (!authenticated(usr))
				return
<<<<<<< HEAD
		if(STATE_DELMESSAGE)
			if (currmsg)
				dat += "Are you sure you want to delete this message? \[ <A HREF='?src=[REF(src)];operation=delmessage2'>OK</A> | <A HREF='?src=[REF(src)];operation=viewmessage'>Cancel</A> \]"
			else
				state = STATE_MESSAGELIST
				attack_hand(user)
				return
		if(STATE_STATUSDISPLAY)
			dat += "Set Status Displays<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=blank'>Clear</A> \]<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=shuttle'>Shuttle ETA</A> \]<BR>"
			dat += "\[ <A HREF='?src=[REF(src)];operation=setstat;statdisp=message'>Message</A> \]"
			dat += "<ul><li> Line 1: <A HREF='?src=[REF(src)];operation=setmsg1'>[ stat_msg1 ? stat_msg1 : "(none)"]</A>"
			dat += "<li> Line 2: <A HREF='?src=[REF(src)];operation=setmsg2'>[ stat_msg2 ? stat_msg2 : "(none)"]</A></ul><br>"
			dat += "\[ Alert: <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=default'>None</A> |"
			dat += " <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=redalert'>Red Alert</A> |"
			dat += " <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=lockdown'>Lockdown</A> |"
			dat += " <A HREF='?src=[REF(src)];operation=setstat;statdisp=alert;alert=biohazard'>Biohazard</A> \]<BR><HR>"
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, 0)
		if(STATE_ALERT_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			if(GLOB.security_level == SEC_LEVEL_DELTA)
				dat += "<font color='red'><b>The self-destruct mechanism is active. Find a way to deactivate the mechanism to lower the alert level or evacuate.</b></font>"
			else
				dat += "<A HREF='?src=[REF(src)];operation=securitylevel;newalertlevel=[SEC_LEVEL_BLUE]'>Blue</A><BR>"
				dat += "<A HREF='?src=[REF(src)];operation=securitylevel;newalertlevel=[SEC_LEVEL_GREEN]'>Green</A>"
		if(STATE_CONFIRM_LEVEL)
			dat += "Current alert level: [get_security_level()]<BR>"
			dat += "Confirm the change to: [num2seclevel(tmp_alertlevel)]<BR>"
			dat += "<A HREF='?src=[REF(src)];operation=swipeidseclevel'>Swipe ID</A> to confirm change.<BR>"
		if(STATE_TOGGLE_EMERGENCY)
			playsound(src, 'sound/machines/terminal_prompt.ogg', 50, 0)
			if(GLOB.emergency_access == 1)
				dat += "<b>Emergency Maintenance Access is currently <font color='red'>ENABLED</font></b>"
				dat += "<BR>Restore maintenance access restrictions? <BR>\[ <A HREF='?src=[REF(src)];operation=disableemergency'>OK</A> | <A HREF='?src=[REF(src)];operation=viewmessage'>Cancel</A> \]"
			else
				dat += "<b>Emergency Maintenance Access is currently <font color='green'>DISABLED</font></b>"
				dat += "<BR>Lift access restrictions on maintenance and external airlocks? <BR>\[ <A HREF='?src=[REF(src)];operation=enableemergency'>OK</A> | <A HREF='?src=[REF(src)];operation=viewmessage'>Cancel</A> \]"

		if(STATE_PURCHASE)
			var/datum/bank_account/D = SSeconomy.get_dep_account(ACCOUNT_CAR)
			dat += "Budget: [D.account_balance] Credits.<BR>"
			dat += "<BR>"
			if((obj_flags & EMAGGED)) // austation -- remove screwdrivering
				dat += "<b>WARNING: Safety features disabled. Non-certified shuttles included. Order at your own peril.</b><BR><BR>"
			else
				dat += "<b>Safety protocols in effect: These shuttles all fulfill NT safety standards.</b><BR><BR>" //not that they're very high but these won't kill everyone aboard
			for(var/shuttle_id in SSmapping.shuttle_templates)
				var/datum/map_template/shuttle/S = SSmapping.shuttle_templates[shuttle_id]
				if(S.can_be_bought && S.credit_cost < INFINITY &! S.illegal_shuttle)
					dat += "[S.name] | [S.credit_cost] Credits<BR>"
					dat += "[S.description]<BR>"
					if(S.prerequisites)
						dat += "Prerequisites: [S.prerequisites]<BR>"
					dat += "<A href='?src=[REF(src)];operation=buyshuttle;chosen_shuttle=[REF(S)]'>(<font color=red><i>Purchase</i></font>)</A><BR><BR>"
			if((obj_flags & EMAGGED)) // austation -- remove screwdrivering
				dat += "<b>NON-CERTIFIED SHUTTLES APPENDED BELOW.</b><BR><BR>"
				for(var/shuttle_id in SSmapping.shuttle_templates)
					var/datum/map_template/shuttle/S = SSmapping.shuttle_templates[shuttle_id]
					if(S.illegal_shuttle && S.credit_cost < INFINITY)
						dat += "[S.name] | [S.credit_cost] Credits<BR>"
						dat += "[S.description]<BR>"
						if(S.prerequisites)
							dat += "Prerequisites: [S.prerequisites]<BR>"
						dat += "<A href='?src=[REF(src)];operation=buyshuttle;chosen_shuttle=[REF(S)]'>(<font color=red><i>Purchase</i></font>)</A><BR><BR>"

	dat += "<BR><BR>\[ [(state != STATE_DEFAULT) ? "<A HREF='?src=[REF(src)];operation=main'>Main Menu</A> | " : ""]<A HREF='?src=[REF(user)];mach_close=communications'>Close</A> \]"

	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/communications/proc/get_javascript_header(form_id)
	var/dat = {"<script type="text/javascript">
						function getLength(){
							var reasonField = document.getElementById('reasonfield');
							if(reasonField.value.length >= [CALL_SHUTTLE_REASON_LENGTH]){
								reasonField.style.backgroundColor = "#DDFFDD";
							}
							else {
								reasonField.style.backgroundColor = "#FFDDDD";
							}
						}
						function submit() {
							document.getElementById('[form_id]').submit();
						}
					</script>"}
	return dat

/obj/machinery/computer/communications/proc/get_call_shuttle_form(ai_interface = 0)
	var/form_id = "callshuttle"
	var/dat = get_javascript_header(form_id)
	dat += "<form name='callshuttle' id='[form_id]' action='?src=[REF(src)]' method='get' style='display: inline'>"
	dat += "<input type='hidden' name='src' value='[REF(src)]'>"
	dat += "<input type='hidden' name='operation' value='[ai_interface ? "ai-callshuttle2" : "callshuttle2"]'>"
	dat += "<b>Nature of emergency:</b><BR> <input type='text' id='reasonfield' name='call' style='width:250px; background-color:#FFDDDD; onkeydown='getLength() onkeyup='getLength()' onkeypress='getLength()'>"
	dat += "<BR>Are you sure you want to call the shuttle? \[ <a href='#' onclick='submit()'>Call</a> \]"
	return dat

/obj/machinery/computer/communications/proc/get_cancel_shuttle_form()
	var/form_id = "cancelshuttle"
	var/dat = get_javascript_header(form_id)
	dat += "<form name='cancelshuttle' id='[form_id]' action='?src=[REF(src)]' method='get' style='display: inline'>"
	dat += "<input type='hidden' name='src' value='[REF(src)]'>"
	dat += "<input type='hidden' name='operation' value='cancelshuttle2'>"

	dat += "<BR>Are you sure you want to cancel the shuttle? \[ <a href='#' onclick='submit()'>Cancel</a> \]"
	return dat

/obj/machinery/computer/communications/proc/interact_ai(mob/living/silicon/ai/user)
	var/dat = ""
	switch(aistate)
		if(STATE_DEFAULT)
			if(SSshuttle.emergencyCallAmount)
				if(SSshuttle.emergencyLastCallLoc)
					dat += "Latest emergency signal trace attempt successful.<BR>Last signal origin: <b>[format_text(SSshuttle.emergencyLastCallLoc.name)]</b>.<BR>"
				else
					dat += "Latest emergency signal trace attempt failed.<BR>"
			if(authenticated)
				dat += "Current login: [auth_id]"
			else
				dat += "Current login: None"
			dat += "<BR><BR><B>General Functions</B>"
			dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-messagelist'>Message List</A> \]"
			if(SSshuttle.emergency.mode == SHUTTLE_IDLE)
				dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-callshuttle'>Call Emergency Shuttle</A> \]"
			dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-status'>Set Status Display</A> \]"
			dat += "<BR><BR><B>Special Functions</B>"
			dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-announce'>Make an Announcement</A> \]"
			dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-changeseclevel'>Change Alert Level</A> \]"
			dat += "<BR>\[ <A HREF='?src=[REF(src)];operation=ai-emergencyaccess'>Emergency Maintenance Access</A> \]"
		if(STATE_CALLSHUTTLE)
			dat += get_call_shuttle_form(1)
		if(STATE_MESSAGELIST)
			dat += "Messages:"
			for(var/i in 1 to messages.len)
				var/datum/comm_message/M = messages[i]
				dat += "<BR><A HREF='?src=[REF(src)];operation=ai-viewmessage;message-num=[i]'>[M.title]</A>"
		if(STATE_VIEWMESSAGE)
			if (aicurrmsg)
				dat += "<B>[aicurrmsg.title]</B><BR><BR>[aicurrmsg.content]"
				if(!aicurrmsg.answered && aicurrmsg.possible_answers.len)
					for(var/i in 1 to aicurrmsg.possible_answers.len)
						var/answer = aicurrmsg.possible_answers[i]
						dat += "<br>\[ <A HREF='?src=[REF(src)];operation=ai-respond;answer=[i]'>Answer : [answer]</A> \]"
				else if(aicurrmsg.answered)
					var/answered = aicurrmsg.possible_answers[aicurrmsg.answered]
					dat += "<br> Archived Answer : [answered]"
				dat += "<BR><BR>\[ <A HREF='?src=[REF(src)];operation=ai-delmessage'>Delete</A> \]"
=======
			var/message_index = text2num(params["message"])
			if (!message_index)
				return
			LAZYREMOVE(messages, LAZYACCESS(messages, message_index))
			. = TRUE
		if ("makePriorityAnnouncement")
			if (!authenticated_as_silicon_or_captain(usr))
				return
			make_announcement(usr)
			. = TRUE
		if ("messageAssociates")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!COOLDOWN_FINISHED(src, important_action_cooldown))
				return

			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			var/message = trim(html_encode(params["message"]), MAX_MESSAGE_LEN)

			var/emagged = obj_flags & EMAGGED
			if (emagged)
				message_syndicate(message, usr)
				to_chat(usr, "<span class='danger'>SYSERR @l(19833)of(transmit.dm): !@$ MESSAGE TRANSMITTED TO SYNDICATE COMMAND.</span>")
>>>>>>> b15a903e80... [PORT] tgui: Communications Console (#5445)
			else
				message_centcom(message, usr)
				to_chat(usr, "<span class='notice'>Message transmitted to Central Command.</span>")

			var/associates = emagged ? "the Syndicate": "CentCom"
			usr.log_talk(message, LOG_SAY, tag = "message to [associates]")
			deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> has messaged [associates], \"[message]\" at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
			COOLDOWN_START(src, important_action_cooldown, IMPORTANT_ACTION_COOLDOWN)
			. = TRUE
		if ("purchaseShuttle")
			var/can_buy_shuttles_or_fail_reason = can_buy_shuttles(usr)
			if (can_buy_shuttles_or_fail_reason != TRUE)
				if (can_buy_shuttles_or_fail_reason != FALSE)
					to_chat(usr, "<span class='alert'>[can_buy_shuttles_or_fail_reason]</span>")
				return
			var/list/shuttles = flatten_list(SSmapping.shuttle_templates)
			var/datum/map_template/shuttle/shuttle = locate(params["shuttle"]) in shuttles
			if (!istype(shuttle))
				return
			if (!shuttle.prerequisites_met())
				to_chat(usr, "<span class='alert'>You have not met the requirements for purchasing this shuttle.</span>")
				return
			var/datum/bank_account/bank_account = SSeconomy.get_dep_account(ACCOUNT_CAR)
			if (bank_account.account_balance < shuttle.credit_cost)
				return
			SSshuttle.shuttle_purchased = TRUE
			SSshuttle.unload_preview()
			SSshuttle.existing_shuttle = SSshuttle.emergency
			SSshuttle.action_load(shuttle)
			bank_account.adjust_money(-shuttle.credit_cost)
			minor_announce("[usr.real_name] has purchased [shuttle.name] for [shuttle.credit_cost] credits.[shuttle.extra_desc ? " [shuttle.extra_desc]" : ""]" , "Shuttle Purchase")
			message_admins("[ADMIN_LOOKUPFLW(usr)] purchased [shuttle.name].")
			log_game("[key_name(usr)] has purchased [shuttle.name].")
			SSblackbox.record_feedback("text", "shuttle_purchase", 1, shuttle.name)
			//state = STATE_MAIN
			. = TRUE
		if ("recallShuttle")
			// AIs cannot recall the shuttle
			if (!authenticated(usr) || issilicon(usr))
				return
			. = SSshuttle.cancelEvac(usr)
		if ("requestNukeCodes")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!COOLDOWN_FINISHED(src, important_action_cooldown))
				return
			var/reason = trim(html_encode(params["reason"]), MAX_MESSAGE_LEN)
			nuke_request(reason, usr)
			to_chat(usr, "<span class='notice'>Request sent.</span>")
			usr.log_message("has requested the nuclear codes from CentCom with reason \"[reason]\"", LOG_SAY)
			priority_announce("The codes for the on-station nuclear self-destruct have been requested by [usr]. Confirmation or denial of this request will be sent shortly.", "Nuclear Self-Destruct Codes Requested", SSstation.announcer.get_rand_report_sound())
			playsound(src, 'sound/machines/terminal_prompt.ogg', 50, FALSE)
			COOLDOWN_START(src, important_action_cooldown, IMPORTANT_ACTION_COOLDOWN)
			. = TRUE
		if ("restoreBackupRoutingData")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!(obj_flags & EMAGGED))
				return
			to_chat(usr, "<span class='notice'>Backup routing data restored.</span>")
			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)
			obj_flags &= ~EMAGGED
			. = TRUE
		if ("sendToOtherSector")
			if (!authenticated_as_non_silicon_captain(usr))
				return
			if (!can_send_messages_to_other_sectors(usr))
				return
			if (!COOLDOWN_FINISHED(src, important_action_cooldown))
				return

			var/message = trim(html_encode(params["message"]), MAX_MESSAGE_LEN)
			if (!message)
				return

			playsound(src, 'sound/machines/terminal_prompt_confirm.ogg', 50, FALSE)

			SStopic.crosscomms_send("comms_console", message, station_name())
			minor_announce(message, title = "Outgoing message to allied station", html_encode = FALSE)
			usr.log_talk(message, LOG_SAY, tag="message to the other server")
			message_admins("[ADMIN_LOOKUPFLW(usr)] has sent a message to the other server.")
			deadchat_broadcast("<span class='deadsay bold'>[usr.real_name] has sent an outgoing message to the other station(s).</span>", usr)

			COOLDOWN_START(src, important_action_cooldown, IMPORTANT_ACTION_COOLDOWN)
			. = TRUE
		if ("setState")
			if (!authenticated(usr))
				return
			if (!(params["state"] in approved_states))
				return
			if (state == STATE_BUYING_SHUTTLE && can_buy_shuttles(usr) != TRUE)
				return
			set_state(usr, params["state"])
			playsound(src, "terminal_type", 50, FALSE)
			. = TRUE
		if ("setStatusMessage")
			if (!authenticated(usr))
				return
			var/line_one = reject_bad_text(params["lineOne"] || "", MAX_STATUS_LINE_LENGTH)
			var/line_two = reject_bad_text(params["lineTwo"] || "", MAX_STATUS_LINE_LENGTH)
			post_status("alert", "blank")
			post_status("message", line_one, line_two)
			last_status_display = list(line_one, line_two)
			playsound(src, "terminal_type", 50, FALSE)
			. = TRUE
		if ("setStatusPicture")
			if (!authenticated(usr))
				return
			var/picture = params["picture"]
			if (!(picture in approved_status_pictures))
				return
			post_status("alert", picture)
			playsound(src, "terminal_type", 50, FALSE)
			. = TRUE
		if ("toggleAuthentication")
			// Log out if we're logged in
			if (authorize_name)
				authenticated = FALSE
				authorize_access = null
				authorize_name = null
				playsound(src, 'sound/machines/terminal_off.ogg', 50, FALSE)
				return TRUE

			if (obj_flags & EMAGGED)
				authenticated = TRUE
				authorize_access = get_all_accesses()
				authorize_name = "Unknown"
				to_chat(usr, "<span class='warning'>[src] lets out a quiet alarm as its login is overridden.</span>")
				playsound(src, 'sound/machines/terminal_alert.ogg', 25, FALSE)
			else
				var/obj/item/card/id/id_card = usr.get_idcard(hand_first = TRUE)
				if (check_access(id_card))
					authenticated = TRUE
					authorize_access = id_card.access
					authorize_name = "[id_card.registered_name] - [id_card.assignment]"

			state = STATE_MESSAGES
			playsound(src, 'sound/machines/terminal_on.ogg', 50, FALSE)
			. = TRUE
		if ("toggleEmergencyAccess")
			if (!authenticated_as_silicon_or_captain(usr))
				return
			. = TRUE
			if (GLOB.emergency_access)
				revoke_maint_all_access()
				log_game("[key_name(usr)] disabled emergency maintenance access.")
				message_admins("[ADMIN_LOOKUPFLW(usr)] disabled emergency maintenance access.")
				deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> disabled emergency maintenance access at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)
			else
				make_maint_all_access()
				log_game("[key_name(usr)] enabled emergency maintenance access.")
				message_admins("[ADMIN_LOOKUPFLW(usr)] enabled emergency maintenance access.")
				deadchat_broadcast("<span class='deadsay'><span class='name'>[usr.real_name]</span> enabled emergency maintenance access at <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", usr)

/obj/machinery/computer/communications/ui_data(mob/user)
	var/list/data = list(
		"authenticated" = FALSE,
		"emagged" = FALSE,
		"hasConnection" = has_communication(),
	)

	var/ui_state = issilicon(user) ? cyborg_state : state

	if (authenticated || issilicon(user))
		data["authenticated"] = TRUE
		data["canLogOut"] = !issilicon(user)
		data["page"] = ui_state

		if (obj_flags & EMAGGED)
			data["emagged"] = TRUE

		//Main section is always visible when authenticated
		data["canBuyShuttles"] = can_buy_shuttles(user)
		data["canMakeAnnouncement"] = FALSE
		data["canMessageAssociates"] = FALSE
		data["canRecallShuttles"] = !issilicon(user)
		data["canRequestNuke"] = FALSE
		data["canSendToSectors"] = FALSE
		data["canSetAlertLevel"] = FALSE
		data["canToggleEmergencyAccess"] = FALSE
		data["importantActionReady"] = COOLDOWN_FINISHED(src, important_action_cooldown)
		data["shuttleCalled"] = FALSE
		data["shuttleLastCalled"] = FALSE

		data["alertLevel"] = get_security_level()
		data["authorizeName"] = authorize_name
		data["canLogOut"] = !issilicon(user)
		data["shuttleCanEvacOrFailReason"] = SSshuttle.canEvac(user)

		if (authenticated_as_non_silicon_captain(user))
			data["canMessageAssociates"] = TRUE
			data["canRequestNuke"] = TRUE

		if (can_send_messages_to_other_sectors(user))
			data["canSendToSectors"] = TRUE

		if (authenticated_as_silicon_or_captain(user))
			data["canToggleEmergencyAccess"] = TRUE
			data["emergencyAccess"] = GLOB.emergency_access

			data["alertLevelTick"] = alert_level_tick
			data["canMakeAnnouncement"] = TRUE
			data["canSetAlertLevel"] = issilicon(user) ? "NO_SWIPE_NEEDED" : "SWIPE_NEEDED"

		if (SSshuttle.emergency.mode != SHUTTLE_IDLE && SSshuttle.emergency.mode != SHUTTLE_RECALL)
			data["shuttleCalled"] = TRUE
			data["shuttleRecallable"] = SSshuttle.canRecall()

		if (SSshuttle.emergencyCallAmount)
			data["shuttleCalledPreviously"] = TRUE
			if (SSshuttle.emergencyLastCallLoc)
				data["shuttleLastCalled"] = format_text(SSshuttle.emergencyLastCallLoc.name)

		switch (ui_state)
			if (STATE_MESSAGES)
				data["messages"] = list()

				if (messages)
					for (var/_message in messages)
						var/datum/comm_message/message = _message
						data["messages"] += list(list(
							"answered" = message.answered,
							"content" = message.content,
							"title" = message.title,
							"possibleAnswers" = message.possible_answers,
						))
			if (STATE_BUYING_SHUTTLE)
				var/datum/bank_account/bank_account = SSeconomy.get_dep_account(ACCOUNT_CAR)
				var/list/shuttles = list()

				for (var/shuttle_id in SSmapping.shuttle_templates)
					var/datum/map_template/shuttle/shuttle_template = SSmapping.shuttle_templates[shuttle_id]
					if (!shuttle_template.can_be_bought || shuttle_template.credit_cost == INFINITY)
						continue
					shuttles += list(list(
						"name" = shuttle_template.name,
						"description" = shuttle_template.description,
						"creditCost" = shuttle_template.credit_cost,
						"prerequisites" = shuttle_template.prerequisites,
						"ref" = REF(shuttle_template),
					))

				data["budget"] = bank_account.account_balance
				data["shuttles"] = shuttles
			if (STATE_CHANGING_STATUS)
				data["lineOne"] = last_status_display ? last_status_display[1] : ""
				data["lineTwo"] = last_status_display ? last_status_display[2] : ""

	return data

/obj/machinery/computer/communications/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "CommunicationsConsole")
		ui.open()

/obj/machinery/computer/communications/ui_static_data(mob/user)
	return list(
		"callShuttleReasonMinLength" = CALL_SHUTTLE_REASON_LENGTH,
		"maxStatusLineLength" = MAX_STATUS_LINE_LENGTH,
		"maxMessageLength" = MAX_MESSAGE_LEN,
	)

/// Returns whether or not the communications console can communicate with the station
/obj/machinery/computer/communications/proc/has_communication()
	var/turf/current_turf = get_turf(src)
	var/z_level = current_turf.z
	return is_station_level(z_level) || is_centcom_level(z_level)

/obj/machinery/computer/communications/proc/set_state(mob/user, new_state)
	if (issilicon(user))
		cyborg_state = new_state
	else
		state = new_state

/// Returns TRUE if the user can buy shuttles.
/// If they cannot, returns FALSE or a string detailing why.
/obj/machinery/computer/communications/proc/can_buy_shuttles(mob/user)
	if (!SSmapping.config.allow_custom_shuttles)
		return FALSE
	if (!authenticated_as_non_silicon_captain(user))
		return FALSE
	if (SSshuttle.emergency.mode != SHUTTLE_RECALL && SSshuttle.emergency.mode != SHUTTLE_IDLE)
		return "The shuttle is already in transit."
	if (SSshuttle.shuttle_purchased)
		return "A replacement shuttle has already been purchased."
	return TRUE

/obj/machinery/computer/communications/proc/can_send_messages_to_other_sectors(mob/user)
	if (!authenticated_as_non_silicon_captain(user))
		return

	return length(CONFIG_GET(keyed_list/cross_server)) > 0

/obj/machinery/computer/communications/proc/make_announcement(mob/living/user)
	var/is_ai = issilicon(user)
	if(!SScommunications.can_announce(user, is_ai))
		to_chat(user, "<span class='alert'>Intercomms recharging. Please stand by.</span>")
		return
	var/input = stripped_input(user, "Please choose a message to announce to the station crew.", "What?")
	if(!input || !user.canUseTopic(src, !issilicon(usr)))
		return
	if(CHAT_FILTER_CHECK(input))
		to_chat(user, "<span class='warning'>You cannot send an announcement that contains prohibited words.</span>")
		return
	SScommunications.make_announcement(user, is_ai, input)
	deadchat_broadcast("<span class='deadsay'><span class='name'>[user.real_name]</span> made a priority announcement from <span class='name'>[get_area_name(usr, TRUE)]</span>.</span>", user)

/obj/machinery/computer/communications/proc/post_status(command, data1, data2)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = new(list("command" = command))
	switch(command)
		if("message")
			status_signal.data["msg1"] = data1
			status_signal.data["msg2"] = data2
		if("alert")
			status_signal.data["picture_state"] = data1

	frequency.post_signal(src, status_signal)

/obj/machinery/computer/communications/Destroy()
	GLOB.shuttle_caller_list -= src
	SSshuttle.autoEvac()
	return ..()

/// Override the cooldown for special actions
/// Used in places such as CentCom messaging back so that the crew can answer right away
/obj/machinery/computer/communications/proc/override_cooldown()
	COOLDOWN_RESET(src, important_action_cooldown)

/obj/machinery/computer/communications/proc/add_message(datum/comm_message/new_message)
	LAZYADD(messages, new_message)
	ui_update()

/datum/comm_message
	var/title
	var/content
	var/list/possible_answers = list()
	var/answered
	var/datum/callback/answer_callback

/datum/comm_message/New(new_title,new_content,new_possible_answers)
	..()
	if(new_title)
		title = new_title
	if(new_content)
		content = new_content
	if(new_possible_answers)
		possible_answers = new_possible_answers

#undef IMPORTANT_ACTION_COOLDOWN
#undef MAX_STATUS_LINE_LENGTH
#undef STATE_BUYING_SHUTTLE
#undef STATE_CHANGING_STATUS
#undef STATE_MESSAGES
