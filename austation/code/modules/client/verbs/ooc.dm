//Returns true if the string is only composed with spaces or unicode characters
/proc/is_blank_string(t_in)
	if(!t_in)
		return TRUE

	var/number_of_alphanumeric = 0
	var/t_len = length(t_in)
	var/char = ""


	for(var/i = 1, i <= t_len, i += length(char))
		char = t_in[i]

		switch(text2ascii(char))
			if(32) //spaces
				continue
			if(33 to 126) //everything else
				number_of_alphanumeric++
			if(127 to INFINITY) //obviously false
				continue

	if(number_of_alphanumeric < 1)
		return TRUE
	else
		return FALSE

/client/ooc(msg as text)
	. = ..()
	if(is_blank_string(msg))
		return
	if(holder?.fakekey)
		send2chat("**[holder.fakekey]:** [msg2discord(msg)]", "ooc")
	else
		send2chat("**[key]:** [msg2discord(msg)]", "ooc")
