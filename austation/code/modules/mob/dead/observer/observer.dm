/mob/verb/Toggle_clownery()
	set name = "Toggle Clownery"
	set category = "null"
	var/mob/M = src
	if(ishuman(M) && M.job == "Clown")
		if(isliving(M))
			message_admins("Yep")
		else
			to_chat(src, "You are dead, silly.")
	else
		return
