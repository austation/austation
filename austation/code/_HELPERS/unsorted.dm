/// returns a list of typepaths in a file, each typepath is seperated by a newline by defau/lt
/world/proc/file2pathlist(path, splitter = "\n")
	var/list/L = world.file2list(path, splitter)
	var/NL = list()
	for(var/i in L)
		NL += text2path(L)
	return NL
