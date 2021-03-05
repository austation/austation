/datum/controller/subsystem/ticker/sendtodiscord(survivors, escapees, integrity)
	var/discordmsg = ""
	discordmsg += "--------------ROUND END--------------\n"
	discordmsg += "Round Number: [GLOB.round_id]\n"
	discordmsg += "Duration: [DisplayTimeText(world.time - SSticker.round_start_time)]\n"
	discordmsg += "Players: [GLOB.player_list.len]\n"
	discordmsg += "Survivors: [survivors]\n"
	discordmsg += "Escapees: [escapees]\n"
	discordmsg += "Integrity: [integrity]\n"
	discordmsg += "Gamemode: [SSticker.mode.name]\n"
	discordmsg = msg2discord(discordmsg)
	send2chat(discordmsg, "ooc")
	discordmsg = ""
	var/list/ded = SSblackbox.first_death
	if(ded)
		discordmsg += "First Death: [ded["name"]], [ded["role"]], at [ded["area"]]\n"
		var/last_words = ded["last_words"] ? "Their last words were: \"[ded["last_words"]]\"\n" : "They had no last words.\n"
		discordmsg += "[last_words]\n"
	else
		discordmsg += "Nobody died!\n"
	/*if(GLOB.antagonists.len)
		discordmsg += "Antagonists at round end were...\n"
	else
		discordmsg += "There were no antagonists!\n"*/
	discordmsg = msg2discord(discordmsg)
	send2chat(discordmsg, "ooc")
	/*if(GLOB.antagonists.len)
		for(var/datum/antagonist/A in GLOB.antagonists)
			if(!A.owner)
				continue
			discordmsg = ""
			var/list/antag_info = list()
			antag_info["key"] = A.owner.key
			antag_info["name"] = A.owner.name
			antag_info["antagonist_name"] = A.name

			discordmsg += "[antag_info["key"]] was [antag_info["name"]] the [antag_info["antagonist_name"]]\n"

			var/list/objective_info = list()
			var/greentexted = TRUE
			var/num = 0

			if(A.objectives.len)
				for(var/datum/objective/O in A.objectives)
					var/result = O.check_completion() ? "SUCCESS" : "FAIL"
					num++
					if (result == "FAIL")
						greentexted = FALSE

					objective_info["result"] = result
					objective_info["text"] = O.explanation_text
					discordmsg += "Objective #[num]: [objective_info["text"]] **[objective_info["result"]]**\n"

			if(greentexted == FALSE)
				discordmsg += "The [antag_info["antagonist_name"]] has failed!\n"
			else
				discordmsg += "The [antag_info["antagonist_name"]] has succeded!\n"

			msg2discord(discordmsg)
			send2chat(discordmsg, "ooc")*/
	discordmsg = ""
	discordmsg += "-------------------------------------\n"
	send2chat(discordmsg, "ooc")

proc/msg2discord(var/msg as text)
    var/list/conversions = list(
    	"@" = "\[at]", // no @ abuse
		"#" = "\[hash]"
    )
    for(var/c in conversions)
        msg = replacetext(msg, c, conversions[c])
    return msg
