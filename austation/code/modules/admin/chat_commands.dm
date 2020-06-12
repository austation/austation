/datum/tgs_chat_command/reboot
	name = "reboot"
	help_text = "<normal|hard|hardest|tgs> <time (only applies to normal reboots)>"
	admin_only = TRUE

/datum/tgs_chat_command/reboot/Run(datum/tgs_chat_user/sender, params)
	if(!params)
		return "Insufficient parameters"
	var/list/all_params = splittext(params, " ")
	if(all_params.len != 1 && all_params.len != 2)
		return "Invalid amount of parameters"
	SSblackbox.record_feedback("tally", "admin_tgs", 1, "Reboot World")
	var/delay = (all_params.len == 2) ? text2num(all_params[2]) : 1
	var/mode = all_params[1]
	var/init_by = "Initiated by an Admin remotely through the TGS Relay."
	switch(mode)
		if("normal")
			SSticker.Reboot(init_by, "admin reboot - by TGS Relay", 10 * delay)
		if("hard")
			to_chat(world, "World reboot - [init_by]")
			world.Reboot()
		if("hardest")
			to_chat(world, "Hard world reboot - [init_by]")
			world.Reboot(fast_track = TRUE)
		if("tgs")
			to_chat(world, "Server restart - [init_by]")
			world.TgsEndProcess()
		else
			return "Invalid reboot mode"
