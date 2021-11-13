

/obj/machinery/computer/telecomms/server
	name = "telecommunications server monitoring console"
	icon_screen = "comm_logs"
	desc = "Has full access to all details and record of the telecommunications network it's monitoring."

	var/screen = 0				// the screen number:
	var/list/servers = list()	// the servers located by the computer
	var/obj/machinery/telecomms/server/SelectedServer

	var/network = "NULL"		// the network to probe
	var/temp = ""				// temporary feedback messages

	var/universal_translate = 0 // set to 1 if it can translate nonhuman speech

	req_access = list(ACCESS_TCOMSAT)
	circuit = /obj/item/circuitboard/computer/comm_server

/obj/machinery/computer/telecomms/server/ui_interact(mob/user)
	. = ..()
	var/dat = "<TITLE>Telecommunication Server Monitor</TITLE><center><b>Telecommunications Server Monitor</b></center>"

	switch(screen)


	  // --- Main Menu ---

		if(0)
			dat += "<br>[temp]<br>"
			dat += "<br>Current Network: <a href='?src=[REF(src)];network=1'>[network]</a><br>"
			if(servers.len)
				dat += "<br>Detected Telecommunication Servers:<ul>"
				for(var/obj/machinery/telecomms/T in servers)
					dat += "<li><a href='?src=[REF(src)];viewserver=[T.id]'>[REF(T)] [T.name]</a> ([T.id])</li>"
				dat += "</ul>"
				dat += "<br><a href='?src=[REF(src)];operation=release'>\[Flush Buffer\]</a>"

			else
				dat += "<br>No servers detected. Scan for servers: <a href='?src=[REF(src)];operation=scan'>\[Scan\]</a>"


	  // --- Viewing Server ---

		if(1)
			dat += "<br>[temp]<br>"
			// austation -- 'Filters' button -- PR #4379
			dat += "<center><a href='?src=[REF(src)];operation=mainmenu'>\[Main Menu\]</a>     <a href='?src=[REF(src)];operation=filters'>\[Filters\]</a>		<a href='?src=[REF(src)];operation=refresh'>\[Refresh\]</a></center>"
			dat += "<br>Current Network: [network]"
			dat += "<br>Selected Server: [SelectedServer.id]"

			if(SelectedServer.totaltraffic >= 1024)
				dat += "<br>Total recorded traffic: [round(SelectedServer.totaltraffic / 1024)] Terrabytes<br><br>"
			else
				dat += "<br>Total recorded traffic: [SelectedServer.totaltraffic] Gigabytes<br><br>"

			dat += "Stored Logs: <ol>"

			var/i = 0
			for(var/datum/comm_log_entry/C in SelectedServer.log_entries)
				i++


				// If the log is a speech file
				if(C.input_type == "Speech File")
					dat += "<li><font color = #008F00>[C.name]</font>  <font color = #FF0000><a href='?src=[REF(src)];delete=[i]'>\[X\]</a></font><br>"

					// -- Determine race of orator --

					var/mobtype = C.parameters["mobtype"]
					var/race			   // The actual race of the mob

					// austation begin -- switching boys -- PR #4379
					switch(mobtype)
						if(/mob/living/carbon/human || /mob/living/brain)
							race = "Humanoid"
						if(/mob/living/simple_animal/slime)		// NT knows a lot about slimes, but not aliens. Can identify slimes
							race = "Slime"
						if(/mob/living/carbon/monkey)
							race = "Monkey"
						if(/mob/living/silicon)
							race = "Artificial Life"
						if(/mob/living/simple_animal)
							race = "Domestic Animal"
						else
							if(C.parameters["job"] == "AI")		// sometimes M gets deleted prematurely for AIs... just check the job
								race = "Artificial Life"
							else if(isobj(mobtype))
								race = "Machinery"
							else
								race = "<i>Unidentifiable</i>"
					// austation end -- PR #4379

					dat += "<u><font color = #18743E>Data type</font></u>: [C.input_type]<br>"
					dat += "<u><font color = #18743E>Source</font></u>: [C.parameters["name"]] (Job: [C.parameters["job"]])<br>"
					dat += "<u><font color = #18743E>Class</font></u>: [race]<br>"
					var/message = C.parameters["message"]
					var/language = C.parameters["language"]

					// based on [/atom/movable/proc/lang_treat]
					if (universal_translate || user.has_language(language))
						message = "\"[message]\""
					else if (!user.has_language(language))
						var/datum/language/D = GLOB.language_datum_instances[language]
						message = "\"[D.scramble(message)]\""
					else if (language)
						message = "<i>(unintelligible)</i>"

					dat += "<u><font color = #18743E>Contents</font></u>: [message]<br>"
					dat += "</li><br>"

				else if(C.input_type == "Execution Error")
					dat += "<li><font color = #990000>[C.name]</font>  <a href='?src=[REF(src)];delete=[i]'>\[X\]</a><br>"
					dat += "<u><font color = #787700>Error</font></u>: \"[C.parameters["message"]]\"<br>"
					dat += "</li><br>"

				else
					dat += "<li><font color = #000099>[C.name]</font>  <a href='?src=[REF(src)];delete=[i]'>\[X\]</a><br>"
					dat += "<u><font color = #18743E>Data type</font></u>: [C.input_type]<br>"
					dat += "<u><font color = #18743E>Contents</font></u>: <i>(unintelligible)</i><br>"
					dat += "</li><br>"


			dat += "</ol>"

	// austation begin -- filtering menu -- PR #4379
	  // --- Server Filtering Menu ---
		if(2)
			dat += "<br>[temp]<br>"
			dat += "<center><a href='?src=[REF(src)];operation=mainmenu'>\[Main Menu\]</a>		<a href='?src=[REF(src)];operation=back'>\[Back\]</a></center>"
			dat += "<br>Current Network: [network]"
			dat += "<br>Selected Server: [SelectedServer.id]"
			dat += "<br><center><a href='?src=[REF(src)];newfilter=1'>\[New Filter\]</a></center>"
			dat += "<br>Current Filters: <ol>"

			var/i = 0
			for(var/datum/comm_filter_entry/C in SelectedServer.filter_entries)
				i++
				dat += "<li><font color = #000099>[C.filter_text]</font>	<a href='?src=[REF(src)];delete=[i]'>\[X\]</a><br>"
				dat += "<u><font color = #18743E>Trigger</font></u>: [C.trigger]<br>"
				dat += "<u><font color = #18743E>Target</font></u>: [C.target]<br>"
				dat += "<u><font color = #18743E>Output</font></u>: [C.output]<br>"
				dat += "</li><br>"

			dat += "</ol>"
	// austation end -- PR #4379


	user << browse(dat, "window=comm_monitor;size=575x400")
	onclose(user, "server_control")

	temp = ""
	return


/obj/machinery/computer/telecomms/server/Topic(href, href_list)
	if(..())
		return


	add_fingerprint(usr)
	usr.set_machine(src)

	if(href_list["viewserver"])
		screen = 1
		for(var/obj/machinery/telecomms/T in servers)
			if(T.id == href_list["viewserver"])
				SelectedServer = T
				break

	if(href_list["operation"])
		switch(href_list["operation"])

			if("release")
				servers = list()
				screen = 0

			if("mainmenu")
				screen = 0

			if("scan")
				if(servers.len > 0)
					temp = "<font color = #D70B00>- FAILED: CANNOT PROBE WHEN BUFFER FULL -</font color>"

				else
					for(var/obj/machinery/telecomms/server/T in urange(25, src))
						if(T.network == network)
							servers.Add(T)

					if(!servers.len)
						temp = "<font color = #D70B00>- FAILED: UNABLE TO LOCATE SERVERS IN \[[network]\] -</font color>"
					else
						temp = "<font color = #336699>- [servers.len] SERVERS PROBED & BUFFERED -</font color>"

					screen = 0

			// austation begin -- filter menu and back button operations -- PR #4379
			if("filters")
				screen = 2

			if("back")
				screen = 1
			// austation end -- PR #4379

	if(href_list["delete"])

		if(!src.allowed(usr) && !(obj_flags & EMAGGED))
			to_chat(usr, "<span class='danger'>ACCESS DENIED.</span>")
			return

		if(SelectedServer)

			// austation begin -- if on filter screen, delete filter instead of log -- PR #4379
			if(screen == 2)
				var/datum/comm_filter_entry/D = SelectedServer.filter_entries[text2num(href_list["delete"])]

				temp = "<font color = #336699>- DELETED FILTER: \[[D.filter_text]\] -</font color>"

				SelectedServer.filter_entries.Remove(D)
				qdel(D)

			else
			// austation end -- PR #4379
				var/datum/comm_log_entry/D = SelectedServer.log_entries[text2num(href_list["delete"])]

				temp = "<font color = #336699>- DELETED ENTRY: [D.name] -</font color>"

				SelectedServer.log_entries.Remove(D)
				qdel(D)

		else
			temp = "<font color = #D70B00>- FAILED: NO SELECTED MACHINE -</font color>"

	if(href_list["network"])

		var/newnet = stripped_input(usr, "Which network do you want to view?", "Comm Monitor", network)

		if(newnet && (get_dist(usr, src) <= 1 || issilicon(usr)))
			if(length(newnet) > 15)
				temp = "<font color = #D70B00>- FAILED: NETWORK TAG STRING TOO LENGHTLY -</font color>"

			else

				network = newnet
				screen = 0
				servers = list()
				temp = "<font color = #336699>- NEW NETWORK TAG SET IN ADDRESS \[[network]\] -</font color>"

	// austation begin -- add new filter -- PR #4379
	if(href_list["newfilter"])

		if(!src.allowed(usr) && !(obj_flags & EMAGGED))
			to_chat(usr, "<span class='danger'>ACCESS DENIED.</span>")
			return

		var/newfilter = stripped_input(usr, "Please enter a new filter:", "Filter")

		if(newfilter && (get_dist(usr, src) <= 1 || issilicon(usr)))

			var/list/split_list = splittext(newfilter,"&gt;&gt;")

			if(length(split_list) != 2)
				temp = "<font color = #D70B00>- FAILED: Incorrect usuage of seperator \'>>\' -</font color>"

			else
				var/list/S1 = splittext(split_list[1],"((")
				if(length(S1) != 2)
					temp = "<font color = #D70B00>- FAILED: Incorrect targeting using \'((\' -</font color>"
					updateUsrDialog()
					return

				var/list/S2 = splittext(S1[2],"))")
				if(length(S2) != 2)
					temp = "<font color = #D70B00>- FAILED: Incorrect targeting using \'))\' -</font color>"
					updateUsrDialog()
					return

				var/T = S2[1]
				split_list[1] = replacetext(split_list[1],"((","")
				split_list[1] = replacetext(split_list[1],"))","")
				T = replacetext(T,"/s","")
				split_list[1] = replacetext(split_list[1],"/s","")
				split_list[2] = replacetext(split_list[2],"/s","")

				var/datum/comm_filter_entry/filter = new
				filter.filter_text = newfilter
				filter.trigger = split_list[1]
				filter.target = T
				filter.output = split_list[2]
				SelectedServer.filter_entries.Add(filter)
				screen = 2
				temp = "<font color = #336699>- NEW FILTER SET: [filter.filter_text] -</font color>"
	// austation end -- PR #4379

	updateUsrDialog()
	return

/obj/machinery/computer/telecomms/server/attackby()
	. = ..()
	updateUsrDialog()
