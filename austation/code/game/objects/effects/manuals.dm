// --austation - manauls -- 27/5/22
/obj/item/book/manual/wiki/xenoarchaeology
	name = "Xenoarchaeology - Artifact Research"
	icon_state ="bookXenoa"
	author = "Dr. P. Fry"
	title = "Xenoarchaeology - Artifact Research"
	page_link = "Guide_to_xenoarchaeology"

/obj/item/book/manual/wiki/xenoarchaeology/attack_self(mob/user)
	var/wikiurl = "https://wiki.austation.net/wiki/" //Other manuals use beewiki, this will temporarily use AU-wiki. Kinda hacky.
	if(!wikiurl)
		return
	if(alert(user, "This will open the wiki page in your browser. Are you sure?", null, "Yes", "No") != "Yes")
		return
	DIRECT_OUTPUT(user, link("[wikiurl]/[page_link]"))
