/obj/machinery/vending
	var/aus_products = list()
	var/aus_contraband = list()
	var/aus_premium = list()

/obj/machinery/vending/Initialize(mapload)
	// Add our items to the list
	// If the item is already a product then add items to it
	if (LAZYLEN(products) && LAZYLEN(aus_products))
		for (var/i in aus_products)
			if (products[i])
				if (products[i] + aus_products[i] <= 0)
					LAZYREMOVE(products, i)
				else
					products[i] = products[i] + aus_products[i]
			else
				products[i] = aus_products[i]

	if (LAZYLEN(contraband) && LAZYLEN(aus_contraband))
		for (var/i in aus_contraband)
			if (contraband[i])
				if (contraband[i] + aus_contraband[i] <= 0)
					LAZYREMOVE(contraband, i)
				else
					contraband[i] = contraband[i] + aus_contraband[i]
			else
				contraband[i] = aus_contraband[i]

	if (LAZYLEN(premium) && LAZYLEN(aus_premium))
		for (var/i in aus_premium)
			if (premium[i])
				if (premium[i] + aus_premium[i] <= 0)
					LAZYREMOVE(premium, i)
				else
					premium[i] = premium[i] + aus_premium[i]
			else
				premium[i] = aus_premium[i]

	return ..()
