/// returns a list of typepaths in a file, each typepath is seperated by a newline by default
/proc/get_typepath_list(path, splitter = "\n")
	var/L = splittext(file2text(file(path)), splitter)
	var/NL = list()
	for(var/i in L)
		NL += text2path(L)
	return NL
