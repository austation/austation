// -- austation manuals - 28 5 22 --
/obj/item/book/manual/wiki/xenoarchaeology
	name = "Archaeology - Xenoartifacts"
	icon_state ="bookEngineeringSingularitySafety"
	author = "Dr. Fry"
	title = "Archaeology - Xenoartifacts"
	page_link = "Guide_to_xenoarchaeology"

/obj/item/book/manual/wiki/xenoarchaeology/attack_self(mob/user)
	var/wikiurl = "https://wiki.austation.net/wiki" //overwrite url to point to AuStation Wiki
	if(!wikiurl)
		return
	if(alert(user, "This will open the wiki page in your browser. Are you sure?", null, "Yes", "No") != "Yes")
		return
	DIRECT_OUTPUT(user, link("[wikiurl]/[page_link]"))
