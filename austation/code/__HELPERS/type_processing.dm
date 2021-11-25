/// Generates a list full of atoms paths associated with their names.
/proc/generate_name_list(list/namelist = typesof(/atom))
	. = list()
	for(var/atom/A as() in namelist)
		var/name =  initial(A.name)
		if(!name)
			continue
		var/index = lowertext(name)
		if(.[index]) // if there's already something here we'll make an embedded list
			if(islist(.[index]))
				.[index] += A
			else
				.[index] = list(A, .[index])
		else
			.[index] = A
