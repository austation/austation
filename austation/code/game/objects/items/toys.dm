/obj/item/toy/aucode // CTRL + C, CTRL + V of the "gooncode" toy from, well, goon. Heavily modified for beecode, naturally.
	name = "aucode hard disk drive"
	desc = "The prized, sought after spaghetti code, and the only known manual for glassing people. Conveniently on a fancy hard drive that connects to PDAs. \
	Just swipe your PDA on it and add whatever you want. \n\nHang on a minute... this is just the gooncode hard disk drive with the name sticky taped over."
	icon = 'icons/obj/module.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_state = "card-id"
	lefthand_file = 'icons/mob/inhands/equipment/idcards_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/idcards_righthand.dmi'
	icon_state = "antivirus2"
	var/cooldown = 0


/obj/item/toy/aucode/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/pda))
		if(cooldown > world.time)
			return
		else
			var/stationfirst = pick("tee", "bee", "fart", "yoo", "poo", "gee", "ma", "honk", "badmin", "terry", "rubber", "fruity", "war", "de", "admin", "coder")
			var/stationlast = pick("gee", "bee", "goo", "pee", "se", "cho", "clown", "bus", "bugger", "frugal", "illegal", "crime", "row")

			// Sometimes use an actual station name. Add yours here!
			var/stationreal = pick("beestation", "tgstation", "skyrat station", "citadel station", "vgstation", "furbee station", "paradise station",\
			"fulpstation", "goonstation", "yogstation", "baystation", "burgerstation", "singulostation")

			var/pradjective = pick("horribly", "questionably", "lovingly", "well", "spaghetti")
			var/prverb = pick("coded", "sprited", "made")
			var/prpronoun = pick("cool", "beloved", "worthless", "random", "outdated", "good", "bad", "questionable")
			var/prnoun = pick("functions", "bugfixes", "features", "items", "weapons", "antagonists", "jobs", "sprites", "chemicals", "content", "tools", "clothes", "engines", "nerfs")

			// Sometimes use an actual PR. Add yours here!
			var/prreal = pick("fermichem", "pools", "nuclear reactors", "maid dresses")

			playsound(loc, 'sound/machines/ding.ogg', 75, 1)
			user.visible_message("<span class='alert'><B>[user] uploads something from their PDA to AuStation.</B></span>")

			var/stringbuilder = "<i>New pull request opened on AuStation: <span class='emote'>\"Ports "

			if(prob(15))
				stringbuilder += prreal + " "
			else
				if(prob(50))
					stringbuilder += pradjective + " " + prverb + " "
				if(prob(50))
					stringbuilder += prpronoun + " "
				stringbuilder += prnoun + " "

			stringbuilder += "from "

			if(prob(15))
				stringbuilder += stationreal
			else
				stringbuilder += stationfirst
				stringbuilder += stationlast
				if(prob(50))
					stringbuilder += " station"

			stringbuilder += "\"</span>"


			I.audible_message(stringbuilder)
			cooldown = world.time + 40
			return
	return ..()

/obj/item/toy/aucode/attack()
	return
