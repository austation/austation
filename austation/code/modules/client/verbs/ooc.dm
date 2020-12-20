/client/ooc(msg)
	. = ..()
	if(holder?.fakekey)
		send2chat("**[holder.fakekey]:** [msg2url(msg)]", "ooc")
	else
		send2chat("**[key]:** [msg2url(msg)]", "ooc")
