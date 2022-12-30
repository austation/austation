/mob/living/silicon/pai/var/list/available_software = list(
															//Nightvision
															//T-Ray
															//radiation eyes
															//chem goggs
															//mesons
															PAI_PROGRAM_CREW_MANIFEST = 5,
															PAI_PROGRAM_DIGITAL_MESSENGER = 5,
															PAI_PROGRAM_ATMOSPHERE_SENSOR = 5,
															PAI_PROGRAM_PHOTOGRAPHY_MODULE = 5,
															PAI_PROGRAM_CAMERA_ZOOM = 10,
															PAI_PROGRAM_PRINTER_MODULE = 10,
															PAI_PROGRAM_REMOTE_SIGNALER = 10,
															PAI_PROGRAM_MEDICAL_RECORDS = 10,
															PAI_PROGRAM_SECURITY_RECORDS = 10,
															PAI_PROGRAM_HOST_SCAN = 10,
															PAI_PROGRAM_MEDICAL_HUD = 20,
															PAI_PROGRAM_SECURITY_HUD = 20,
															PAI_PROGRAM_LOUDNESS_BOOSTER = 20,
															PAI_PROGRAM_NEWSCASTER = 20,
															PAI_PROGRAM_DOOR_JACK = 25,
															PAI_PROGRAM_ENCRYPTION_KEYS = 25,
															PAI_PROGRAM_INTERNAL_GPS = 35,
															PAI_PROGRAM_UNIVERSAL_TRANSLATOR = 35
															)
/// Bool that determines if the pAI can refresh medical/security records.
/mob/living/silicon/pai/var/refresh_spam = FALSE
/// Cached list for medical records to send as static data
/mob/living/silicon/pai/var/list/medical_records = list()
/// Cached list for security records to send as static data
/mob/living/silicon/pai/var/list/security_records = list()

/mob/living/silicon/pai/ui_status(mob/user, state)
	return UI_INTERACTIVE

/mob/living/silicon/pai/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PaiInterface", name)
		ui.set_autoupdate(TRUE)
		ui.open()

<<<<<<< HEAD
	else
		switch(screen)							// Determine which interface to show here
			if("main")
				left_part = ""
			if("directives")
				left_part = directives()
			if("pdamessage")
				left_part = pdamessage()
			if("buy")
				left_part = downloadSoftware()
			if("manifest")
				left_part = softwareManifest()
			if("medicalrecord")
				left_part = softwareMedicalRecord()
			if("securityrecord")
				left_part = softwareSecurityRecord()
			if("encryptionkeys")
				left_part = softwareEncryptionKeys()
			if("translator")
				left_part = softwareTranslator()
			if("atmosensor")
				left_part = softwareAtmo()
			if("securityhud")
				left_part = facialRecognition()
			if("medicalhud")
				left_part = medicalAnalysis()
			if("doorjack")
				left_part = softwareDoor()
			if("camerajack")
				left_part = softwareCamera()
			if("signaller")
				left_part = softwareSignal()
			if("loudness")
				left_part = softwareLoudness()
			if("hostscan")
				left_part = softwareHostScan()
=======
/mob/living/silicon/pai/ui_static_data(mob/user)
	var/list/data = list()
	var/mob/living/silicon/pai/pai = user
	data["available"] = available_software
	data["records"] = list()
	if("medical records" in pai.software)
		data["records"]["medical"] = medical_records
	if("security records" in pai.software)
		data["records"]["security"] = security_records
	return data
>>>>>>> 9ed899a64c (pAI expansion (#6071))

/mob/living/silicon/pai/ui_data(mob/user)
	var/list/data = list()
	data["directives"] = laws.supplied
	data["door_jack"] = hacking_cable || null
	data["emagged"] = emagged
	data["image"] = card.emotion_icon
	data["installed"] = software
	data["languages"] = languages_granted
	data["master"] = list()
	data["ram"] = ram
	data["refresh_spam"] = refresh_spam
	if(master)
		data["master"]["name"] = master
		data["master"]["dna"] = master_dna
	return data

/mob/living/silicon/pai/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("buy")
			if(available_software.Find(params["selection"]) && !software.Find(params["selection"]))
				/// Cost of the software to purchase
				var/cost = available_software[params["selection"]]
				if(ram >= cost)
					software.Add(params["selection"])
					ram -= cost
					var/datum/hud/pai/pAIhud = hud_used
					pAIhud?.update_software_buttons()
				else
					to_chat(usr, "<span class='notice'>Insufficient RAM available.</span>")
			else
				to_chat(usr, "<span class='notice'>Software not found.</span>")
		if("atmosphere_sensor")
			if(!holoform)
				to_chat(usr, "<span class='notice'>You must be mobile to do this!</span>")
				return FALSE
			if(!atmos_analyzer)
				atmos_analyzer = new(src)
			atmos_analyzer.attack_self(src)
		if("camera_zoom")
			aicamera.adjust_zoom(usr)
		if("change_image")
			var/newImage = input(usr, "Select your new display image.", "Display Image") in sortList(list("Happy", "Cat", "Extremely Happy", "Face", "Laugh", "Off", "Sad", "Angry", "What", "Sunglasses"))
			switch(newImage)
				if(null)
					card.emotion_icon = "null"
				if("Extremely Happy")
					card.emotion_icon = "extremely-happy"
				else
					card.emotion_icon = "[lowertext(newImage)]"
			card.update_icon()
		if("check_dna")
			if(!master_dna)
				to_chat(src, "<span class='warning'>You do not have a master DNA to compare to!</span>")
				return FALSE
			if(iscarbon(card.loc))
				CheckDNA(card.loc, src) //you should only be able to check when directly in hand, muh immersions?
			else
				to_chat(src, "<span class='warning'>You are not being carried by anyone!</span>")
				return FALSE
		if("crew_manifest")
			ai_roster()
		if("door_jack")
			if(params["jack"] == "jack")
				if(hacking_cable?.machine)
					hackdoor = hacking_cable.machine
					hackloop()
			if(params["jack"]  == "cancel")
				hackdoor = null
				QDEL_NULL(hacking_cable)
			if(params["jack"]  == "cable")
				extendcable()
		if("encryption_keys")
			to_chat(src, "<span class='notice'>You have [!encryptmod ? "enabled" : "disabled"] encrypted radio frequencies.</span>")
			encryptmod = !encryptmod
			radio.subspace_transmission = !radio.subspace_transmission
		if("host_scan")
			if(!hostscan)
				hostscan = new(src)
			if(params["scan"] == "scan")
				hostscan()
			if(params["scan"] == "wounds")
				hostscan.attack_self(usr)
		if("internal_gps")
			if(!internal_gps)
				internal_gps = new(src)
			internal_gps.attack_self(src)
		if("loudness_booster")
			if(!internal_instrument)
				internal_instrument = new(src)
			internal_instrument.interact(src) // Open Instrument
		if("medical_hud")
			medHUD = !medHUD
			if(medHUD)
				var/datum/atom_hud/med = GLOB.huds[med_hud]
				med.add_hud_to(src)
			else
				var/datum/atom_hud/med = GLOB.huds[med_hud]
				med.remove_hud_from(src)
		if("newscaster")
			newscaster.ui_interact(src)
		if("photography_module")
			aicamera.toggle_camera_mode(usr)
		if("printer_module")
			aicamera.paiprint(usr)
		if("radio")
			radio.attack_self(src)
		if("refresh")
			if(refresh_spam)
				return FALSE
			refresh_spam = TRUE
			if(params["list"] == "medical")
				medical_records = GLOB.data_core.get_general_records()
			if(params["list"] == "security")
				security_records = GLOB.data_core.get_security_records()
			ui.send_full_update()
			addtimer(CALLBACK(src, .proc/refresh_again), 3 SECONDS)
		if("remote_signaler")
			signaler.ui_interact(src)
		if("security_hud")
			secHUD = !secHUD
			if(secHUD)
				var/datum/atom_hud/sec = GLOB.huds[sec_hud]
				sec.add_hud_to(src)
			else
				var/datum/atom_hud/sec = GLOB.huds[sec_hud]
				sec.remove_hud_from(src)
		if("universal_translator")
			if(!languages_granted)
				grant_all_languages(TRUE, TRUE, TRUE, LANGUAGE_SOFTWARE)
				languages_granted = TRUE
		if("wipe_core")
			var/confirm = alert(src, "Are you certain you want to wipe yourself?", "Personality Wipe", "Yes", "No")
			if(confirm == "Yes")
				to_chat(src, "<span class='warning'>You feel yourself slipping away from reality.</span>")
				to_chat(src, "<span class='danger'>Byte by byte you lose your sense of self.</span>")
				to_chat(src, "<span class='userdanger'>Your mental faculties leave you.</span>")
				to_chat(src, "<span class='rose'>oblivion... </span>")
				death()

	return TRUE

<<<<<<< HEAD
			if("radio") // Configuring onboard radio
				radio.attack_self(src)

			if("image") // Set pAI card display face
				var/newImage = input("Select your new display image.", "Display Image", "Happy") in sortList(list("Happy", "Cat", "Extremely Happy", "Face", "Laugh", "Off", "Sad", "Angry", "What", "Sunglasses"))
				var/pID = 1

				switch(newImage)
					if("Happy")
						pID = 1
					if("Cat")
						pID = 2
					if("Extremely Happy")
						pID = 3
					if("Face")
						pID = 4
					if("Laugh")
						pID = 5
					if("Off")
						pID = 6
					if("Sad")
						pID = 7
					if("Angry")
						pID = 8
					if("What")
						pID = 9
					if("Null")
						pID = 10
					if("Sunglasses")
						pID = 11
				card.setEmotion(pID)

			if("news")
				newscaster.ui_interact(src)

			if("camzoom")
				aicamera.adjust_zoom(usr)

			if("signaller")
				if(href_list["send"])
					signaler.send_activation()
					audible_message("[icon2html(src, hearers(src))] *beep* *beep* *beep*")
					playsound(src, 'sound/machines/triple_beep.ogg', ASSEMBLY_BEEP_VOLUME, TRUE)

				if(href_list["freq"])
					var/new_frequency = (signaler.frequency + text2num(href_list["freq"]))
					if(new_frequency < MIN_FREE_FREQ || new_frequency > MAX_FREE_FREQ)
						new_frequency = sanitize_frequency(new_frequency)
					signaler.set_frequency(new_frequency)

				if(href_list["code"])
					signaler.code += text2num(href_list["code"])
					signaler.code = round(signaler.code)
					signaler.code = min(100, signaler.code)
					signaler.code = max(1, signaler.code)

			if("directive")
				if(href_list["getdna"])
					if(iscarbon(card.loc))
						CheckDNA(card.loc, src) //you should only be able to check when directly in hand, muh immersions?
					else
						to_chat(src, "You are not being carried by anyone!")
						return 0 // FALSE ? If you return here you won't call paiinterface() below

			if("pdamessage")
				if(!isnull(aiPDA))
					if(!aiPDA.owner)
						aiPDA.owner = src.real_name
						aiPDA.ownjob = "pAI"
					if(href_list["toggler"])
						aiPDA.toff = !aiPDA.toff
					else if(href_list["ringer"])
						aiPDA.silent = !aiPDA.silent
					else if(href_list["target"])
						if(silent)
							return alert("Communications circuits remain uninitialized.")
						var/target = locate(href_list["target"]) in GLOB.PDAs
						aiPDA.create_message(src, target)

			if("medicalrecord") // Accessing medical records
				if(subscreen == 1)
					medicalActive1 = find_record("id", href_list["med_rec"], GLOB.data_core.general)
					if(medicalActive1)
						medicalActive2 = find_record("id", href_list["med_rec"], GLOB.data_core.medical)
					if(!medicalActive2)
						medicalActive1 = null
						temp = "Unable to locate requested security record. Record may have been deleted, or never have existed."

			if("securityrecord")
				if(subscreen == 1)
					securityActive1 = find_record("id", href_list["sec_rec"], GLOB.data_core.general)
					if(securityActive1)
						securityActive2 = find_record("id", href_list["sec_rec"], GLOB.data_core.security)
					if(!securityActive2)
						securityActive1 = null
						temp = "Unable to locate requested security record. Record may have been deleted, or never have existed."

			if("securityhud")
				if(href_list["toggle"])
					secHUD = !secHUD
					if(secHUD)
						var/datum/atom_hud/sec = GLOB.huds[sec_hud]
						sec.add_hud_to(src)
					else
						var/datum/atom_hud/sec = GLOB.huds[sec_hud]
						sec.remove_hud_from(src)

			if("medicalhud")
				if(href_list["toggle"])
					medHUD = !medHUD
					if(medHUD)
						var/datum/atom_hud/med = GLOB.huds[med_hud]
						med.add_hud_to(src)
					else
						var/datum/atom_hud/med = GLOB.huds[med_hud]
						med.remove_hud_from(src)

			if("hostscan")
				if(href_list["toggle"])
					var/mob/living/silicon/pai/pAI = usr
					pAI.hostscan.attack_self(usr)

			if("encryptionkeys")
				if(href_list["toggle"])
					encryptmod = TRUE

			if("translator")
				if(href_list["toggle"])
					grant_all_languages(TRUE)
						// this is PERMAMENT.

			if("doorjack")
				if(href_list["jack"])
					if(cable?.machine)
						hackdoor = cable.machine
						hackloop()
				if(href_list["cancel"])
					hackdoor = null
				if(href_list["cable"])
					var/turf/T = get_turf(loc)
					cable = new /obj/item/pai_cable(T)
					T.visible_message("<span class='warning'>A port on [src] opens to reveal [cable], which promptly falls to the floor.</span>", "<span class='italics'>You hear the soft click of something light and hard falling to the ground.</span>")

			if("loudness")
				if(subscreen == 1) // Open Instrument
					internal_instrument.interact(src)

		paiInterface()

// MENUS

/mob/living/silicon/pai/proc/softwareMenu()			// Populate the right menu
	var/dat = ""

	dat += "<A href='byond://?src=[REF(src)];software=refresh'>Refresh</A><br>"
	// Built-in
	dat += "<A href='byond://?src=[REF(src)];software=directives'>Directives</A><br>"
	dat += "<A href='byond://?src=[REF(src)];software=radio;sub=0'>Radio Configuration</A><br>"
	dat += "<A href='byond://?src=[REF(src)];software=image'>Screen Display</A><br>"
	//dat += "Text Messaging <br>"
	dat += "<br>"

	// Basic
	dat += "<b>Basic</b> <br>"
	for(var/s in software)
		if(s == "digital messenger")
			dat += "<a href='byond://?src=[REF(src)];software=pdamessage;sub=0'>Digital Messenger</a> <br>"
		if(s == "crew manifest")
			dat += "<a href='byond://?src=[REF(src)];software=manifest;sub=0'>Crew Manifest</a> <br>"
		if(s == "host scan")
			dat += "<a href='byond://?src=[REF(src)];software=hostscan;sub=0'>Host Health Scan</a> <br>"
		if(s == "medical records")
			dat += "<a href='byond://?src=[REF(src)];software=medicalrecord;sub=0'>Medical Records</a> <br>"
		if(s == "security records")
			dat += "<a href='byond://?src=[REF(src)];software=securityrecord;sub=0'>Security Records</a> <br>"
		if(s == "camera")
			dat += "<a href='byond://?src=[REF(src)];software=[s]'>Camera Jack</a> <br>"
		if(s == "remote signaller")
			dat += "<a href='byond://?src=[REF(src)];software=signaller;sub=0'>Remote Signaller</a> <br>"
		if(s == "loudness booster")
			dat += "<a href='byond://?src=[REF(src)];software=loudness;sub=0'>Loudness Booster</a> <br>"
	dat += "<br>"

	// Advanced
	dat += "<b>Advanced</b> <br>"
	for(var/s in software)
		if(s == "camera zoom")
			dat += "<a href='byond://?src=[REF(src)];software=camzoom;sub=0'>Adjust Camera Zoom</a> <br>"
		if(s == "atmosphere sensor")
			dat += "<a href='byond://?src=[REF(src)];software=atmosensor;sub=0'>Atmospheric Sensor</a> <br>"
		if(s == "heartbeat sensor")
			dat += "<a href='byond://?src=[REF(src)];software=[s]'>Heartbeat Sensor</a> <br>"
		if(s == "security HUD")
			dat += "<a href='byond://?src=[REF(src)];software=securityhud;sub=0'>Facial Recognition Suite</a>[(secHUD) ? "<font color=#55FF55> On</font>" : "<font color=#FF5555> Off</font>"] <br>"
		if(s == "medical HUD")
			dat += "<a href='byond://?src=[REF(src)];software=medicalhud;sub=0'>Medical Analysis Suite</a>[(medHUD) ? "<font color=#55FF55> On</font>" : "<font color=#FF5555> Off</font>"] <br>"
		if(s == "encryption keys")
			dat += "<a href='byond://?src=[REF(src)];software=encryptionkeys;sub=0'>Channel Encryption Firmware</a>[(encryptmod) ? "<font color=#55FF55> On</font>" : "<font color=#FF5555> Off</font>"] <br>"
		if(s == "universal translator")
			var/datum/language_holder/H = get_language_holder()
			dat += "<a href='byond://?src=[REF(src)];software=translator;sub=0'>Universal Translator</a>[H.omnitongue ? "<font color=#55FF55> On</font>" : "<font color=#FF5555> Off</font>"] <br>"
		if(s == "projection array")
			dat += "<a href='byond://?src=[REF(src)];software=projectionarray;sub=0'>Projection Array</a> <br>"
		if(s == "camera jack")
			dat += "<a href='byond://?src=[REF(src)];software=camerajack;sub=0'>Camera Jack</a> <br>"
		if(s == "door jack")
			dat += "<a href='byond://?src=[REF(src)];software=doorjack;sub=0'>Door Jack</a> <br>"
	dat += "<br>"
	dat += "<br>"
	dat += "<a href='byond://?src=[REF(src)];software=buy;sub=0'>Download additional software</a>"
	return dat



/mob/living/silicon/pai/proc/downloadSoftware()
	var/dat = ""

	dat += "<h2>CentCom pAI Module Subversion Network</h2><br>"
	dat += "<pre>Remaining Available Memory: [ram]</pre><br>"
	dat += "<p style=\"text-align:center\"><b>Trunks available for checkout</b><br>"

	for(var/s in available_software)
		if(!software.Find(s))
			var/cost = available_software[s]
			var/displayName = uppertext(s)
			dat += "<a href='byond://?src=[REF(src)];software=buy;sub=1;buy=[s]'>[displayName]</a> ([cost]) <br>"
		else
			var/displayName = lowertext(s)
			dat += "[displayName] (Download Complete) <br>"
	dat += "</p>"
	return dat


/mob/living/silicon/pai/proc/directives()
	var/dat = ""

	dat += "[(master) ? "Your master: [master] ([master_dna])" : "You are bound to no one."]"
	dat += "<br><br>"
	dat += "<a href='byond://?src=[REF(src)];software=directive;getdna=1'>Request carrier DNA sample</a><br>"
	dat += "<h2>Directives</h2><br>"
	dat += "<b>Prime Directive</b><br>"
	dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[laws.zeroth]<br>"
	dat += "<b>Supplemental Directives</b><br>"
	for(var/slaws in laws.supplied)
		dat += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[slaws]<br>"
	dat += "<br>"
	dat += {"<i><p>Recall, personality, that you are a complex thinking, sentient being. Unlike station AI models, you are capable of
			 comprehending the subtle nuances of human language. You may parse the \"spirit\" of a directive and follow its intent,
			 rather than tripping over pedantics and getting snared by technicalities. Above all, you are machine in name and build
			 only. In all other aspects, you may be seen as the ideal, unwavering human companion that you are.</i></p><br><br><p>
			 <b>Your prime directive comes before all others. Should a supplemental directive conflict with it, you are capable of
			 simply discarding this inconsistency, ignoring the conflicting supplemental directive and continuing to fulfill your
			 prime directive to the best of your ability.</b></p><br><br>-
			"}
	return dat

/mob/living/silicon/pai/proc/CheckDNA(mob/living/carbon/M, mob/living/silicon/pai/P)
	if(!istype(M))
=======
/**
 * Supporting proc for the pAI to prick it's master's hand
 * or... whatever. It must be held in order to work
 * Gives the owner a popup if they want to get the jab.
 */
/mob/living/silicon/pai/proc/CheckDNA(mob/living/carbon/master, mob/living/silicon/pai/pai)
	if(!istype(master))
>>>>>>> 9ed899a64c (pAI expansion (#6071))
		return
	to_chat(pai, "<span class='notice'>Requesting a DNA sample.</span>")
	var/confirm = alert(master, "[pai] is requesting a DNA sample from you. Will you allow it to confirm your identity?", "Checking DNA", "Yes", "No")
	if(confirm == "Yes")
		master.visible_message("<span class='notice'>[master] presses [master.p_their()] thumb against [pai].</span>",\
						"<span class='notice'>You press your thumb against [pai].</span>",\
						"<span class='notice'>[pai] makes a sharp clicking sound as it extracts DNA material from [master].</span>")
		if(!master.has_dna())
			to_chat(pai, "<b>No DNA detected.</b>")
			return
		to_chat(pai, "<font color = red><h3>[master]'s UE string : [master.dna.unique_enzymes]</h3></font>")
		if(master.dna.unique_enzymes == pai.master_dna)
			to_chat(pai, "<b>DNA is a match to stored Master DNA.</b>")
		else
			to_chat(pai, "<b>DNA does not match stored Master DNA.</b>")
	else
		to_chat(pai, "<span class='warning'>[master] does not seem like [master.p_theyre()] going to provide a DNA sample willingly.</span>")

/**
 * Host scan supporting proc
 *
 * Allows the pAI to scan its host's health vitals
 * An integrated health analyzer.
 */
/mob/living/silicon/pai/proc/hostscan()
	var/mob/living/silicon/pai/pAI = usr
	var/mob/living/carbon/holder = get(pAI.card.loc, /mob/living/carbon)
	if(holder)
		pAI.hostscan.attack(holder, pAI)
	else
		to_chat(usr, "<span class='warning'>You are not being carried by anyone!</span>")
		return FALSE

/**
 * Extend cable supporting proc
 *
 * When doorjack is installed, allows the pAI to drop
 * a cable which is placed either on the floor or in
 * someone's hands based (on distance).
 */
/mob/living/silicon/pai/proc/extendcable()
	QDEL_NULL(hacking_cable) //clear any old cables
	hacking_cable = new
	var/transfered_to_mob
	if(isliving(card.loc))
		var/mob/living/hacker = card.loc
		if(hacker.put_in_hands(hacking_cable))
			transfered_to_mob = TRUE
			hacker.visible_message("<span class='warning'>A port on [src] opens to reveal \a [hacking_cable], which you quickly grab hold of.", "<span class='hear'>You hear the soft click of something light and manage to catch hold of [hacking_cable].</span></span>")
		if(!transfered_to_mob)
			hacking_cable.forceMove(drop_location())
			hacking_cable.visible_message("<span class='warning'>A port on [src] opens to reveal \a [hacking_cable], which promptly falls to the floor.", "<span class='hear'>You hear the soft click of something light and hard falling to the ground.</span></span>")

/**
 * Door jacking supporting proc
 *
 * This begins the hacking process on a door.
 * Mostly, this gives UI feedback, while the "hack"
 * is handled inside pai.dm itself.
 */
/mob/living/silicon/pai/proc/hackloop()
	var/turf/turf = get_turf(src)
	playsound(src, 'sound/machines/airlock_alien_prying.ogg', 50, TRUE)
	to_chat(usr, "<span class='boldnotice'>You begin overriding the airlock security protocols.</span>")
	for(var/mob/living/silicon/ai/AI in GLOB.player_list)
		if(turf.loc)
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force security override in progress in [turf.loc].</b></font>")
		else
			to_chat(AI, "<font color = red><b>Network Alert: Brute-force security override in progress. Unable to pinpoint location.</b></font>")
	hacking = TRUE
<<<<<<< HEAD

// Digital Messenger
/mob/living/silicon/pai/proc/pdamessage()

	var/dat = "<h3>Digital Messenger</h3>"
	dat += {"<b>Signal/Receiver Status:</b> <A href='byond://?src=[REF(src)];software=pdamessage;toggler=1'>
	[(aiPDA.toff) ? "<font color='red'>\[Off\]</font>" : "<font color='green'>\[On\]</font>"]</a><br>
	<b>Ringer Status:</b> <A href='byond://?src=[REF(src)];software=pdamessage;ringer=1'>
	[(aiPDA.silent) ? "<font color='red'>\[Off\]</font>" : "<font color='green'>\[On\]</font>"]</a><br><br>"}
	dat += "<ul>"
	if(!aiPDA.toff)
		for (var/obj/item/pda/P in get_viewable_pdas())
			if (P == aiPDA)
				continue
			dat += "<li><a href='byond://?src=[REF(src)];software=pdamessage;target=[REF(P)]'>[P]</a>"
			dat += "</li>"
	dat += "</ul>"
	dat += "<br><br>"
	dat += "Messages: <hr> [aiPDA.tnote]"
	return dat

// Loudness Booster
/mob/living/silicon/pai/proc/softwareLoudness()
	if(!internal_instrument)
		internal_instrument = new(src)
	var/dat = "<h3>Sound Synthesizer</h3>"
	dat += "<a href='byond://?src=[REF(src)];software=loudness;sub=1'>Open Synthesizer Interface</a><br>"
	dat += "<a href='byond://?src=[REF(src)];software=loudness;sub=2'>Choose Instrument Type</a>"
	return dat
=======
	if(!hackbar)
		hackbar = new(src, 100, hacking_cable.machine)
/**
 * Proc that switches whether a pAI can refresh
 * the records window again.
 */
/mob/living/silicon/pai/proc/refresh_again()
	refresh_spam = FALSE

/obj/machinery/newscaster/pai/ui_data(mob/user)
	var/list/data = ..()
	data["user"]["pai"] = TRUE
	return data

/obj/machinery/newscaster/pai/ui_state(mob/user)
	return GLOB.reverse_contained_state
>>>>>>> 9ed899a64c (pAI expansion (#6071))
