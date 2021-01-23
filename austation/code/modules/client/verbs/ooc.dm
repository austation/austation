var/global/regex/is_blank_string_regex = new(@{"^(\s|[\u00A0\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u2028\u205F\u3000])*$"})
/proc/is_blank_string(var/txt)
	if (is_blank_string_regex.Find(txt))
		return 1
	return 0 //not blank

/client/ooc(msg as text)
	. = ..()
	if((length(msg) < 1) || is_blank_string(msg))
		return
	if(holder?.fakekey)
		send2chat("**[holder.fakekey]:** [msg2discord(msg)]", "ooc")
	else
		send2chat("**[key]:** [msg2discord(msg)]", "ooc")
