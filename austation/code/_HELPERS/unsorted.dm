/// returns a list of typepaths in a file, each typepath is seperated by a newline by default
/proc/file2pathlist(path, splitter = "\n")
	var/list/L = file2list(path, splitter)
	var/NL = list()
	for(var/i in L)
		NL += text2path(L)
	return NL
