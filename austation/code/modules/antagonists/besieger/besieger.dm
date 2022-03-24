/datum/antagonist/siege
	name = "Besieger"
	antagpanel_category = "Besieger"
	job_rank = ROLE_BESIEGER
	antag_moodlet = /datum/mood_event/focused
	var/datum/team/siege/team

/datum/antagonist/siege/create_team(datum/team/siege/new_team)
	team = new_team

/datum/antagonist/siege/get_team()
	return team

/datum/antagonist/siege/on_gain()
	SSticker.mode.brothers += owner
	objectives += team.objectives
	for(var/datum/objective/O in team.objectives)
		log_objective(owner, O.explanation_text)
	owner.special_role = job_rank
	finalize()
	return ..()

/datum/antagonist/siege/on_removal()
	SSticker.mode.brothers -= owner
	if(owner.current)
		to_chat(owner.current,"<span class='userdanger'>You are no longer the besieger!</span>")
	owner.special_role = null
	return ..()

/datum/antagonist/siege/antag_panel_data()
	return "Conspirators : [get_conspirators()]"

/datum/antagonist/siege/proc/get_conspirators()
	var/list/brothers = team.members - owner
	var/brother_text = ""
	for(var/i = 1 to brothers.len)
		var/datum/mind/M = brothers[i]
		brother_text += M.name
		if(i == brothers.len - 1)
			brother_text += " and "
		else if(i != brothers.len)
			brother_text += ", "
	return brother_text

/datum/antagonist/siege/greet()
	to_chat(owner.current, "<span class='alertsyndie'>You are the a saboteur.</span>")
	to_chat(owner.current, "You have been activated. Sow chaos and degrade the station's defensive capabilities in preparation for invasion. You and your team are outfitted with communication implants allowing for direct, encrypted communication. You are not expected to survive. Glory to the Syndicate.")
	owner.announce_objectives()
	to_chat(owner.current, "<B>Your designated meeting area:</B> [team.meeting_area]")
	antag_memory += "<b>Meeting Area</b>: [team.meeting_area]<br>"
	owner.current.client?.tgui_panel?.give_antagonist_popup("Besieger",
		"You have been activated. Sow chaos and degrade the station's defensive capabilities in preparation for invasion. You and your team are outfitted with communication implants allowing for direct, encrypted communication. You are not expected to survive. Glory to the Syndicate.")

/datum/antagonist/siege/proc/finalize()
	var/obj/item/implant/bloodbrother/I = new /obj/item/implant/bloodbrother()
	I.implant(owner.current, null, TRUE, TRUE)
	I.implant_colour = "#ff0000"
	for(var/datum/mind/M in team.members) // Link the implants of all team members
		var/obj/item/implant/bloodbrother/T = locate() in M.current.implants
		I.link_implant(T)
	SSticker.mode.update_brother_icons_added(owner)
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/tatoralert.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/brother/admin_add(datum/mind/new_owner,mob/admin)
	new_owner.add_antag_datum(/datum/antagonist/siege, SSsiege.team)
	message_admins("[key_name_admin(admin)] made [key_name_admin(new_owner)] into a besieger.")
	log_admin("[key_name(admin)] made [key_name(new_owner)] into a besieger.")

/datum/team/siege
	name = "besiegers"
	member_name = "besieger"
	objectives = list(/datum/objective/siege, FALSE)
	var/static/meeting_area = pick("The Bar", "Dorms", "Escape Dock", "Arrivals", "Holodeck", "Primary Tool Storage", "Recreation Area", "Chapel", "Library")

/datum/team/siege/roundend_report()
	var/list/parts = list()
	parts += "<span class='header'>The Besieger Saboteurs [name] were:</span>"
	for(var/datum/mind/M in members)
		parts += printplayer(M)
	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
