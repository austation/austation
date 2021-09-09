/// Generates a list full of atoms paths associated with their names
/proc/generate_name_list(list/namelist = typesof(/atom))
	. = list()
	for(var/atom/A as() in namelist)
		var/index = lowertext(A.name)
		if(.[index]) // if there's already something here we'll make an embedded list
			.[index] = list(A, .[index])
		else
			.[index] = A
