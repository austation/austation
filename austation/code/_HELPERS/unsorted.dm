/proc/js_keycode_to_byond(key_in)
	key_in = text2num(key_in)
	switch(key_in)
		if(65 to 90, 48 to 57) // letters and numbers
			return ascii2text(key_in)
		if(17)
			return "Ctrl"
		if(18)
			return "Alt"
		if(16)
			return "Shift"
		if(37)
			return "West"
		if(38)
			return "North"
		if(39)
			return "East"
		if(40)
			return "South"
		if(45)
			return "Insert"
		if(46)
			return "Delete"
		if(36)
			return "Northwest"
		if(35)
			return "Southwest"
		if(33)
			return "Northeast"
		if(34)
			return "Southeast"
		if(112 to 123)
			return "F[key_in-111]"
		if(96 to 105)
			return "Numpad[key_in-96]"
		if(188)
			return ","
		if(190)
			return "."
		if(189)
			return "-"
