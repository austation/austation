/*
	The monitoring computer for the messaging server.
	Lets you read PDA and request console messages.
*/
<<<<<<< HEAD

#define LINKED_SERVER_NONRESPONSIVE  (!linkedServer || (linkedServer.stat & (NOPOWER|BROKEN)))

#define MSG_MON_SCREEN_MAIN 		0
#define MSG_MON_SCREEN_LOGS 		1
#define MSG_MON_SCREEN_HACKED 		2
#define MSG_MON_SCREEN_CUSTOM_MSG 	3
#define MSG_MON_SCREEN_REQUEST_LOGS 4

// The monitor itself.
=======
>>>>>>> 87b842ca4d (TGUI Message Monitor + PDA Admin Verb (#8094))
/obj/machinery/computer/message_monitor
	name = "message monitor console"
	desc = "Used to monitor the crew's PDA messages, as well as request console messages."
	icon_screen = "comm_logs"
	circuit = /obj/item/circuitboard/computer/message_monitor
<<<<<<< HEAD
	//Server linked to.
	var/obj/machinery/telecomms/message_server/linkedServer = null
	//Sparks effect - For emag
	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
	//Messages - Saves me time if I want to change something.
	var/noserver = "<span class='alert'>ALERT: No server detected.</span>"
	var/incorrectkey = "<span class='warning'>ALERT: Incorrect decryption key!</span>"
	var/defaultmsg = "<span class='notice'>Welcome. Please select an option.</span>"
	var/rebootmsg = "<span class='warning'>%$&(£: Critical %$$@ Error // !RestArting! <lOadiNg backUp iNput ouTput> - ?pLeaSe wAit!</span>"
	//Computer properties
	var/screen = MSG_MON_SCREEN_MAIN 		// 0 = Main menu, 1 = Message Logs, 2 = Hacked screen, 3 = Custom Message
	var/hacking = FALSE		// Is it being hacked into by the AI/Cyborg
	var/message = "<span class='notice'>System bootup complete. Please select an option.</span>"	// The message that shows on the main menu.
	var/auth = FALSE // Are they authenticated?
	var/optioncount = 7
	// Custom Message Properties
	var/customsender = "System Administrator"
	var/obj/item/pda/customrecepient = null
	var/customjob		= "Admin"
	var/custommessage 	= "This is a test, please ignore."

=======
>>>>>>> 87b842ca4d (TGUI Message Monitor + PDA Admin Verb (#8094))
	light_color = LIGHT_COLOR_GREEN
	/// Message server selected to receive data from
	var/obj/machinery/telecomms/message_server/linked_server
	/// If the console is currently being hacked by a silicon
	var/hacking = FALSE

/obj/machinery/computer/message_monitor/attackby(obj/item/O, mob/living/user, params)
	if(O.tool_behaviour == TOOL_SCREWDRIVER && (obj_flags & EMAGGED))
		//Stops people from just unscrewing the monitor and putting it back to get the console working again.
		to_chat(user, "<span class='warning'>It is too hot to mess with!</span>")
	else
		return ..()

<<<<<<< HEAD
/obj/machinery/computer/message_monitor/emag_act(mob/user)
	if(obj_flags & EMAGGED)
		return
	if(!isnull(linkedServer))
		obj_flags |= EMAGGED
		screen = MSG_MON_SCREEN_HACKED
		spark_system.set_up(5, 0, src)
		spark_system.start()
		var/obj/item/paper/monitorkey/MK = new(loc, linkedServer)
		// Will help make emagging the console not so easy to get away with.
		MK.info += "<br><br><font color='red'>£%@%(*$%&(£&?*(%&£/{}</font>"
		var/time = 100 * length(linkedServer.decryptkey)
		addtimer(CALLBACK(src, .proc/UnmagConsole), time)
		message = rebootmsg
	else
		to_chat(user, "<span class='notice'>A no server error appears on the screen.</span>")
=======
/obj/machinery/computer/message_monitor/should_emag(mob/user)
	if(!..())
		return FALSE
	if(!linked_server)
		to_chat(user, "<span class='notice'>A 'no server detected' error appears on the screen.</span>")
		return FALSE
	return TRUE

/obj/machinery/computer/message_monitor/on_emag(mob/user)
	..()
	ui_update()
	do_sparks(5, FALSE, src)
	addtimer(CALLBACK(src, .proc/after_emag), 10 * length(linked_server.decryptkey) SECONDS)

/obj/machinery/computer/message_monitor/proc/after_emag()
	// Print an "error" decryption key, leaving physical evidence of the hack.
	if(linked_server)
		var/obj/item/paper/monitorkey/MK = new(loc, linked_server)
		MK.info += "<br><br><font color='red'>£%@%(*$%&(£&?*(%&£/{}</font>"
	else
		say("Error: Server link lost!")
	obj_flags &= ~EMAGGED
	ui_update()

/obj/machinery/computer/message_monitor/proc/finish_hack(mob/living/silicon/user)
	hacking = FALSE
	ui_update()
	if(!linked_server)
		to_chat(user, "<span class='warning'>Could not complete brute-force: Linked Server Disconnected!</span>")
		return
	to_chat(user, "<span class='warning'>Brute-force completed! The decryption key is '[linked_server.decryptkey]'.</span>")
>>>>>>> 87b842ca4d (TGUI Message Monitor + PDA Admin Verb (#8094))

/obj/machinery/computer/message_monitor/New()
	..()
	GLOB.telecomms_list += src

/obj/machinery/computer/message_monitor/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/message_monitor/LateInitialize()
	//If the server isn't linked to a server, and there's a server available, default it to the first one in the list.
	if(!linked_server)
		for(var/obj/machinery/telecomms/message_server/S in GLOB.telecomms_list)
			set_linked_server(S)
			break

/obj/machinery/computer/message_monitor/proc/set_linked_server(var/obj/machinery/telecomms/message_server/server)
	if(linked_server)
		UnregisterSignal(linked_server, COMSIG_PARENT_QDELETING)
	if(server != linked_server)
		authenticated = FALSE
	linked_server = server
	if(server)
		RegisterSignal(server, COMSIG_PARENT_QDELETING, .proc/server_deleting)
	ui_update()

/obj/machinery/computer/message_monitor/proc/server_deleting()
	set_linked_server(null)

/obj/machinery/computer/message_monitor/Destroy()
	GLOB.telecomms_list -= src
	set_linked_server(null)
	return ..()

/obj/machinery/computer/message_monitor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/chat),
	)

/obj/machinery/computer/message_monitor/ui_static_data(mob/user)
	var/list/data = list()
	data["emoji_names"] = icon_states('icons/emoji.dmi')
	return data

/obj/machinery/computer/message_monitor/ui_data(mob/user)
	var/list/data = ..()
	data["server_on"] = linked_server?.on
	data["authenticated"] = authenticated
	data["hacking"] = hacking || (obj_flags & EMAGGED)
	var/mob/living/silicon/S = user
	data["can_hack"] = istype(S) && S.hack_software
	var/no_server = !linked_server || (linked_server.machine_stat & (NOPOWER|BROKEN))
	data["no_server"] = no_server
	if(no_server || !authenticated)
		return data
	var/list/pda_messages = list()
	for(var/datum/data_tablet_msg/message in linked_server.modular_msgs)
		var/list/message_data = list()
		var/datum/picture/pic = message.picture
		if(istype(pic))
			message_data["photo"] = pda_rsc_image(pic, "[REF(message)]", user)
			message_data["photo_width"] = pic.psize_x
			message_data["photo_height"] = pic.psize_y
		message_data["sender"] = message.sender
		message_data["recipient"] = message.recipient
		message_data["contents"] = message.message
		message_data["emojis"] = message.emojis
		message_data["ref"] = REF(message)
		pda_messages += list(message_data)
	data["pda_messages"] = pda_messages
	var/list/request_messages = list()
	for(var/datum/data_rc_msg/req in linked_server.rc_msgs)
		request_messages += list(list(
			"sending_department" = req.send_dpt,
			"receiving_department" = req.rec_dpt,
			"stamp" = req.stamp,
			"id_auth" = req.id_auth,
			"priority" = req.priority,
			"message" = req.message,
			"ref" = REF(req),
		))
	data["request_messages"] = request_messages
	return data

/obj/machinery/computer/message_monitor/ui_act(action, params)
	. = ..()
	if(.)
		return TRUE
	switch(action)
		if("login")
			if(!usr || authenticated)
				return TRUE
			if(!linked_server)
				to_chat(usr, "<span class='warning'>The console flashes a message: 'ERROR: Server connection lost.'</span>")
				return TRUE
			var/dkey = capped_input(usr, "Please enter the decryption key.")
			if(dkey && linked_server.decryptkey == dkey)
				authenticated = TRUE
			else
				to_chat(usr, "<span class='warning'>The console flashes a message: 'ALERT: Incorrect decryption key!'</span>")
			return TRUE
		if("logout")
			authenticated = FALSE
			return TRUE
		if("hack")
			var/mob/living/silicon/S = usr
<<<<<<< HEAD
			if(istype(S) && S.hack_software)
				//Malf/Traitor AIs can bruteforce into the system to gain the Key.
				dat += "<dd><A href='?src=[REF(src)];hack=1'><i><font color='Red'>*&@#. Bruteforce Key</font></i></font></a><br></dd>"
			else
				dat += "<br>"

			//Bottom message
			if(!auth)
				dat += "<br><hr><dd><span class='notice'>Please authenticate with the server in order to show additional options.</span>"
			else
				dat += "<br><hr><dd><span class='warning'>Reg, #514 forbids sending messages to a Head of Staff containing Erotic Rendering Properties.</span>"

		//Message Logs
		if(MSG_MON_SCREEN_LOGS)
			var/index = 0
			dat += "<center><A href='?src=[REF(src)];back=1'>Back</a> - <A href='?src=[REF(src)];refresh=1'>Refresh</a></center><hr>"
			dat += "<table border='1' width='100%'><tr><th width = '5%'>X</th><th width='15%'>Sender</th><th width='15%'>Recipient</th><th width='300px' word-wrap: break-word>Message</th></tr>"
			for(var/datum/data_pda_msg/pda in linkedServer.pda_msgs)
				index++
				if(index > 3000)
					break
				// Del - Sender   - Recepient - Message
				// X   - Al Green - Your Mom  - WHAT UP!?
				dat += "<tr><td width = '5%'><center><A href='?src=[REF(src)];delete_logs=[REF(pda)]' style='color: rgb(255,0,0)'>X</a></center></td><td width='15%'>[pda.sender]</td><td width='15%'>[pda.recipient]</td><td width='300px'>[pda.message][pda.picture ? " <a href='byond://?src=[REF(pda)];photo=1'>(Photo)</a>":""]</td></tr>"
			dat += "</table>"
		//Hacking screen.
		if(MSG_MON_SCREEN_HACKED)
			if(isAI(user) || iscyborg(user))
				dat += "Brute-forcing for server key.<br> It will take 20 seconds for every character that the password has."
				dat += "In the meantime, this console can reveal your true intentions if you let someone access it. Make sure no humans enter the room during that time."
			else
				//It's the same message as the one above but in binary. Because robots understand binary and humans don't... well I thought it was clever.
				dat += {"01000010011100100111010101110100011001010010110<br>
				10110011001101111011100100110001101101001011011100110011<br>
				10010000001100110011011110111001000100000011100110110010<br>
				10111001001110110011001010111001000100000011010110110010<br>
				10111100100101110001000000100100101110100001000000111011<br>
				10110100101101100011011000010000001110100011000010110101<br>
				10110010100100000001100100011000000100000011100110110010<br>
				10110001101101111011011100110010001110011001000000110011<br>
				00110111101110010001000000110010101110110011001010111001<br>
				00111100100100000011000110110100001100001011100100110000<br>
				10110001101110100011001010111001000100000011101000110100<br>
				00110000101110100001000000111010001101000011001010010000<br>
				00111000001100001011100110111001101110111011011110111001<br>
				00110010000100000011010000110000101110011001011100010000<br>
				00100100101101110001000000111010001101000011001010010000<br>
				00110110101100101011000010110111001110100011010010110110<br>
				10110010100101100001000000111010001101000011010010111001<br>
				10010000001100011011011110110111001110011011011110110110<br>
				00110010100100000011000110110000101101110001000000111001<br>
				00110010101110110011001010110000101101100001000000111100<br>
				10110111101110101011100100010000001110100011100100111010<br>
				10110010100100000011010010110111001110100011001010110111<br>
				00111010001101001011011110110111001110011001000000110100<br>
				10110011000100000011110010110111101110101001000000110110<br>
				00110010101110100001000000111001101101111011011010110010<br>
				10110111101101110011001010010000001100001011000110110001<br>
				10110010101110011011100110010000001101001011101000010111<br>
				00010000001001101011000010110101101100101001000000111001<br>
				10111010101110010011001010010000001101110011011110010000<br>
				00110100001110101011011010110000101101110011100110010000<br>
				00110010101101110011101000110010101110010001000000111010<br>
				00110100001100101001000000111001001101111011011110110110<br>
				10010000001100100011101010111001001101001011011100110011<br>
				10010000001110100011010000110000101110100001000000111010<br>
				001101001011011010110010100101110"}

		//Fake messages
		if(MSG_MON_SCREEN_CUSTOM_MSG)
			dat += "<center><A href='?src=[REF(src)];back=1'>Back</a> - <A href='?src=[REF(src)];Reset=1'>Reset</a></center><hr>"

			dat += {"<table border='1' width='100%'>
					<tr><td width='20%'><A href='?src=[REF(src)];select=Sender'>Sender</a></td>
					<td width='20%'><A href='?src=[REF(src)];select=RecJob'>Sender's Job</a></td>
					<td width='20%'><A href='?src=[REF(src)];select=Recepient'>Recipient</a></td>
					<td width='300px' word-wrap: break-word><A href='?src=[REF(src)];select=Message'>Message</a></td></tr>"}
				//Sender  - Sender's Job  - Recepient - Message
				//Al Green- Your Dad	  - Your Mom  - WHAT UP!?

			dat += {"<tr><td width='20%'>[customsender]</td>
			<td width='20%'>[customjob]</td>
			<td width='20%'>[customrecepient ? customrecepient.owner : "NONE"]</td>
			<td width='300px'>[custommessage]</td></tr>"}
			dat += "</table><br><center><A href='?src=[REF(src)];select=Send'>Send</a>"

		//Request Console Logs
		if(MSG_MON_SCREEN_REQUEST_LOGS)

			var/index = 0
			/* 	data_rc_msg
				X												 - 5%
				var/rec_dpt = "Unspecified" //name of the person - 15%
				var/send_dpt = "Unspecified" //name of the sender- 15%
				var/message = "Blank" //transferred message		 - 300px
				var/stamp = "Unstamped"							 - 15%
				var/id_auth = "Unauthenticated"					 - 15%
				var/priority = "Normal"							 - 10%
			*/
			dat += "<center><A href='?src=[REF(src)];back=1'>Back</a> - <A href='?src=[REF(src)];refresh=1'>Refresh</a></center><hr>"
			dat += {"<table border='1' width='100%'><tr><th width = '5%'>X</th><th width='15%'>Sending Dep.</th><th width='15%'>Receiving Dep.</th>
			<th width='300px' word-wrap: break-word>Message</th><th width='15%'>Stamp</th><th width='15%'>ID Auth.</th><th width='15%'>Priority.</th></tr>"}
			for(var/datum/data_rc_msg/rc in linkedServer.rc_msgs)
				index++
				if(index > 3000)
					break
				// Del - Sender   - Recepient - Message
				// X   - Al Green - Your Mom  - WHAT UP!?
				dat += {"<tr><td width = '5%'><center><A href='?src=[REF(src)];delete_requests=[REF(rc)]' style='color: rgb(255,0,0)'>X</a></center></td><td width='15%'>[rc.send_dpt]</td>
				<td width='15%'>[rc.rec_dpt]</td><td width='300px'>[rc.message]</td><td width='15%'>[rc.stamp]</td><td width='15%'>[rc.id_auth]</td><td width='15%'>[rc.priority]</td></tr>"}
			dat += "</table>"

	message = defaultmsg
	var/datum/browser/popup = new(user, "hologram_console", name, 700, 700)
	popup.set_content(dat)
	popup.open()

/obj/machinery/computer/message_monitor/proc/BruteForce(mob/user)
	if(isnull(linkedServer))
		to_chat(user, "<span class='warning'>Could not complete brute-force: Linked Server Disconnected!</span>")
	else
		var/currentKey = linkedServer.decryptkey
		to_chat(user, "<span class='warning'>Brute-force completed! The key is '[currentKey]'.</span>")
	hacking = FALSE
	screen = MSG_MON_SCREEN_MAIN // Return the screen back to normal

/obj/machinery/computer/message_monitor/proc/UnmagConsole()
	obj_flags &= ~EMAGGED

/obj/machinery/computer/message_monitor/proc/ResetMessage()
	customsender 	= "System Administrator"
	customrecepient = null
	custommessage 	= "This is a test, please ignore."
	customjob 		= "Admin"

/obj/machinery/computer/message_monitor/Topic(href, href_list)
	if(..())
		return

	if(usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)) || issilicon(usr))
		//Authenticate
		if (href_list["auth"])
			if(LINKED_SERVER_NONRESPONSIVE)
				message = noserver
			else if(auth)
				auth = FALSE
				screen = MSG_MON_SCREEN_MAIN
			else
				var/dkey = capped_input(usr, "Please enter the decryption key.")
				if(dkey && dkey != "")
					if(linkedServer.decryptkey == dkey)
						auth = TRUE
					else
						message = incorrectkey

		//Turn the server on/off.
		if (href_list["active"])
			if(LINKED_SERVER_NONRESPONSIVE)
				message = noserver
			else if(auth)
				linkedServer.toggled = !linkedServer.toggled
		//Find a server
		if (href_list["find"])
=======
			if(!istype(S) || !S.hack_software)
				return TRUE
			if(!linked_server)
				to_chat(S, "<span class='warning'>The console flashes a message: 'ERROR: Server connection lost.'</span>")
				return TRUE
			hacking = TRUE
			var/duration = 10 * length(linked_server.decryptkey) SECONDS
			var/approx_duration = max(duration + rand(-20, 20), 1)
			to_chat(S, "<span class='warning'>Brute-force decryption started. This will take approximately [DisplayTimeText(approx_duration, round_seconds_to = 10)].</span>")
			addtimer(CALLBACK(src, .proc/finish_hack, S), duration)
			return TRUE
		if("link")
>>>>>>> 87b842ca4d (TGUI Message Monitor + PDA Admin Verb (#8094))
			var/list/message_servers = list()
			var/obj/machinery/telecomms/message_server/last
			for (var/obj/machinery/telecomms/message_server/M in GLOB.telecomms_list)
				var/key_base = "[M.network] - [M.name]"
				var/key = key_base
				var/number = 1
				while(key in message_servers)
					key = key_base + " ([number])"
					number++
				message_servers[key] = M
				last = M

			if(length(message_servers) > 1)
				var/choice = input(usr, "Please select a server.", "Select a server.", null) as null|anything in message_servers
				if(choice in message_servers)
					set_linked_server(message_servers[choice])
				else
					set_linked_server(null)
			else if(length(message_servers) == 1)
				set_linked_server(last)
			else
				set_linked_server(null)
			return TRUE
		if("power")
			if(!authenticated)
				return TRUE
			if(!linked_server)
				to_chat(usr, "<span class='warning'>The console flashes a message: 'ERROR: Server connection lost.'</span>")
				return TRUE
			linked_server.toggled = !linked_server.toggled
			// Trigger this immediately or hte UI will not update properly... wow this is a dumb proc
			linked_server.update_power()
			return TRUE
		if("reset_key")
			if(!usr || !authenticated)
				return TRUE
			if(!linked_server)
				to_chat(usr, "<span class='warning'>The console flashes a message: 'ERROR: Server connection lost.'</span>")
				return TRUE
			var/dkey = capped_input(usr, "Please enter the decryption key.")
			if(!dkey)
				return
			if(linked_server.decryptkey == dkey)
				var/newkey = capped_input(usr, "Please enter the new key (4-16 characters):")
				if(length(newkey) < 4)
					to_chat(usr, "<span class='warning'>The console flashes a message: 'NOTICE: Decryption key too short!'</span>")
				else if(length(newkey) > 16)
					to_chat(usr, "<span class='warning'>The console flashes a message: 'NOTICE: Decryption key too long!'</span>")
				else if(newkey && newkey != "")
					linked_server.decryptkey = newkey
					to_chat(usr, "<span class='notice'>The console flashes a message: 'NOTICE: Decryption key set.'</span>")
			else
				to_chat(usr,"<span class='warning'>The console flashes a message: 'ALERT: Incorrect decryption key!'</span>")
		if("clear_logs")
			var/type = params["type"]
			if(!usr || !authenticated || (type != "pda" && type != "request"))
				return TRUE
			if(!linked_server)
				to_chat(usr, "<span class='warning'>The console flashes a message: 'ERROR: Server connection lost.'</span>")
				return TRUE
			if(type == "request")
				linked_server.rc_msgs.Cut()
			else
				linked_server.modular_msgs.Cut()
			to_chat(usr, "<span class='notice'>The console flashes a message: 'NOTICE: Logs cleared.'</span>")
			var/turf/the_turf = get_turf(src)
			usr.log_message("cleared [type] logs using [src] at [AREACOORD(the_turf)]", LOG_GAME)
			message_admins("[ADMIN_FLW(usr)] cleared [type] logs using [src] at [ADMIN_VERBOSEJMP(the_turf)]")
			return TRUE
		if("delete_log")
			var/ref = params["ref"]
			var/type = params["type"]
			if(!usr || !authenticated || (type != "pda" && type != "request") || !ref)
				return TRUE
			if(!linked_server)
				to_chat(usr, "<span class='warning'>The console flashes a message: 'ERROR: Server connection lost.'</span>")
				return TRUE
			var/list/target = type == "request" ? linked_server.rc_msgs : linked_server.modular_msgs
			var/datum/entry = locate(ref) in target
			if(!entry)
				return
			target -= entry
			var/msg = ""
			if(istype(entry, /datum/data_tablet_msg))
				var/datum/data_tablet_msg/pda_entry = entry
				msg = "[pda_entry.sender] to [pda_entry.recipient]: [pda_entry.message]"
			else if(istype(entry, /datum/data_rc_msg))
				var/datum/data_rc_msg/rc_entry = entry
				msg = "[rc_entry.send_dpt] to [rc_entry.rec_dpt] PRIORITY [rc_entry.priority] AUTH [rc_entry.id_auth] STAMP [rc_entry.stamp]: [rc_entry.message]"
			to_chat(usr, "<span class='notice'>The console flashes a message: 'NOTICE: Log entry deleted.'</span>")
			var/turf/the_turf = get_turf(src)
			usr.log_message("cleared [type] log entry \"[msg]\" using [src] at [AREACOORD(the_turf)]", LOG_GAME)
			message_admins("[key_name_admin(usr)][ADMIN_FLW(usr)] deleted [type] log entry \"[msg]\" using [src] at [ADMIN_VERBOSEJMP(the_turf)]")
			return TRUE
		if("admin_message")
			if(!usr || !authenticated)
				return TRUE
			if(!linked_server)
				to_chat(usr, "<span class='warning'>The console flashes a message: 'ERROR: Server connection lost.'</span>")
				return TRUE
			tgui_send_admin_pda(usr, src, linked_server)

<<<<<<< HEAD
		//View the logs - KEY REQUIRED
		if (href_list["view_logs"])
			if(LINKED_SERVER_NONRESPONSIVE)
				message = noserver
			else if(auth)
				screen = MSG_MON_SCREEN_LOGS

		//Clears the logs - KEY REQUIRED
		if (href_list["clear_logs"])
			if(LINKED_SERVER_NONRESPONSIVE)
				message = noserver
			else if(auth)
				linkedServer.pda_msgs = list()
				message = "<span class='notice'>NOTICE: Logs cleared.</span>"
		//Clears the request console logs - KEY REQUIRED
		if (href_list["clear_requests"])
			if(LINKED_SERVER_NONRESPONSIVE)
				message = noserver
			else if(auth)
				linkedServer.rc_msgs = list()
				message = "<span class='notice'>NOTICE: Logs cleared.</span>"
		//Change the password - KEY REQUIRED
		if (href_list["pass"])
			if(LINKED_SERVER_NONRESPONSIVE)
				message = noserver
			else if(auth)
				var/dkey = stripped_input(usr, "Please enter the decryption key.")
				if(dkey && dkey != "")
					if(linkedServer.decryptkey == dkey)
						var/newkey = trim(input(usr,"Please enter the new key (3 - 16 characters max):"))
						if(length(newkey) <= 3)
							message = "<span class='notice'>NOTICE: Decryption key too short!</span>"
						else if(length(newkey) > 16)
							message = "<span class='notice'>NOTICE: Decryption key too long!</span>"
						else if(newkey && newkey != "")
							linkedServer.decryptkey = newkey
						message = "<span class='notice'>NOTICE: Decryption key set.</span>"
					else
						message = incorrectkey

		//Hack the Console to get the password
		if (href_list["hack"])
			var/mob/living/silicon/S = usr
			if(istype(S) && S.hack_software)
				hacking = TRUE
				screen = MSG_MON_SCREEN_HACKED
				//Time it takes to bruteforce is dependant on the password length.
				spawn(100*length(linkedServer.decryptkey))
					if(src && linkedServer && usr)
						BruteForce(usr)
		//Delete the log.
		if (href_list["delete_logs"])
			//Are they on the view logs screen?
			if(screen == MSG_MON_SCREEN_LOGS)
				if(LINKED_SERVER_NONRESPONSIVE)
					message = noserver
				else //if(istype(href_list["delete_logs"], /datum/data_pda_msg))
					linkedServer.pda_msgs -= locate(href_list["delete_logs"]) in linkedServer.pda_msgs
					message = "<span class='notice'>NOTICE: Log Deleted!</span>"
		//Delete the request console log.
		if (href_list["delete_requests"])
			//Are they on the view logs screen?
			if(screen == MSG_MON_SCREEN_REQUEST_LOGS)
				if(LINKED_SERVER_NONRESPONSIVE)
					message = noserver
				else //if(istype(href_list["delete_logs"], /datum/data_pda_msg))
					linkedServer.rc_msgs -= locate(href_list["delete_requests"]) in linkedServer.rc_msgs
					message = "<span class='notice'>NOTICE: Log Deleted!</span>"
		//Create a custom message
		if (href_list["msg"])
			if(LINKED_SERVER_NONRESPONSIVE)
				message = noserver
			else if(auth)
				screen = MSG_MON_SCREEN_CUSTOM_MSG
		//Fake messaging selection - KEY REQUIRED
		if (href_list["select"])
			if(LINKED_SERVER_NONRESPONSIVE)
				message = noserver
				screen = MSG_MON_SCREEN_MAIN
			else
				switch(href_list["select"])

					//Reset
					if("Reset")
						ResetMessage()

					//Select Your Name
					if("Sender")
						customsender = stripped_input(usr, "Please enter the sender's name.") || customsender

					//Select Receiver
					if("Recepient")
						//Get out list of viable PDAs
						var/list/obj/item/pda/sendPDAs = get_viewable_pdas()
						if(GLOB.PDAs && GLOB.PDAs.len > 0)
							customrecepient = input(usr, "Select a PDA from the list.") as null|anything in sendPDAs
						else
							customrecepient = null

					//Enter custom job
					if("RecJob")
						customjob = stripped_input(usr, "Please enter the sender's job.") || customjob

					//Enter message
					if("Message")
						custommessage = stripped_input(usr, "Please enter your message.") || custommessage

					//Send message
					if("Send")
						if(isnull(customsender) || customsender == "")
							customsender = "UNKNOWN"

						if(isnull(customrecepient))
							message = "<span class='notice'>NOTICE: No recepient selected!</span>"
							return attack_hand(usr)

						if(isnull(custommessage) || custommessage == "")
							message = "<span class='notice'>NOTICE: No message entered!</span>"
							return attack_hand(usr)

						var/datum/signal/subspace/messaging/pda/signal = new(src, list(
							"name" = "[customsender]",
							"job" = "[customjob]",
							"message" = custommessage,
							"targets" = list("[customrecepient.owner] ([customrecepient.ownjob])")
						))
						// this will log the signal and transmit it to the target
						linkedServer.receive_information(signal, null)
						usr.log_message("(PDA: [name] | [usr.real_name]) sent \"[custommessage]\" to [signal.format_target()]", LOG_PDA)


		//Request Console Logs - KEY REQUIRED
		if(href_list["view_requests"])
			if(LINKED_SERVER_NONRESPONSIVE)
				message = noserver
			else if(auth)
				screen = MSG_MON_SCREEN_REQUEST_LOGS

		if (href_list["back"])
			screen = MSG_MON_SCREEN_MAIN

	return attack_hand(usr)

#undef MSG_MON_SCREEN_MAIN
#undef MSG_MON_SCREEN_LOGS
#undef MSG_MON_SCREEN_HACKED
#undef MSG_MON_SCREEN_CUSTOM_MSG
#undef MSG_MON_SCREEN_REQUEST_LOGS

#undef LINKED_SERVER_NONRESPONSIVE
=======
/obj/machinery/computer/message_monitor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MessageMonitor")
		ui.open()
		ui.set_autoupdate(TRUE)
>>>>>>> 87b842ca4d (TGUI Message Monitor + PDA Admin Verb (#8094))

/obj/item/paper/monitorkey
	name = "monitor decryption key"

/obj/item/paper/monitorkey/Initialize(mapload, obj/machinery/telecomms/message_server/server)
	..()
	if (server)
		print(server)
		return INITIALIZE_HINT_NORMAL
	else
		return INITIALIZE_HINT_LATELOAD

/obj/item/paper/monitorkey/proc/print(obj/machinery/telecomms/message_server/server)
	info = "<h2>Telecommunications Security Notice</h2><br />\
	<strong><pre>INCOMING TRANSMISSION - KEY RESET REPORT</pre></strong><br />\
	<p>\
	<pre>\
	REPORT: PREVIOUS SHIFT DATA WIPED.<br />\
	KEY UPDATED.<br />\
	</pre>\
	<strong>Monitor Decryption Key: </strong>[server.decryptkey]\
	</p>\
	<p><pre>\
	PLEASE MAXIMIZE KEY SECURITY.<br />\
	UPDATE KEY IF NECESSARY.<br />\
	TRANSMISSION END.<br />\
	SENDER: CentCom Telecommunications Data Retention\
	</pre></p>"
	add_overlay("paper_words")

/obj/item/paper/monitorkey/LateInitialize()
	for (var/obj/machinery/telecomms/message_server/preset/server in GLOB.telecomms_list)
		if (server.decryptkey)
			print(server)
			break
