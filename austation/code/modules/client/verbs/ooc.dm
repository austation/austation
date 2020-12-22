/client/ooc(msg as text)
	. = ..()
	if(holder?.fakekey)
		send2chat("**[holder.fakekey]:** [msg2discord(msg)]", "ooc")
	else
		send2chat("**[key]:** [msg2discord(msg)]", "ooc")
