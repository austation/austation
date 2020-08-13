/datum/gear/uniform/skirt/maid
	display_name = "Maid Costume"
	description = "Wearing this may be considered a war crime in your area. Contact your local HoS or captain for more information."
	path = /obj/item/clothing/under/costume/maid
	cost = 10000 // It ain't special if everyone's wearing it.

/datum/gear/uniform/rank/janitor
	subtype_path = /datum/gear/uniform/rank/janitor
	allowed_roles = list("Janitor")

/datum/gear/uniform/rank/janitor/maid
	display_name = "Janitor's maid uniform"
	description = "Wearing this may be considered a war crime in your area. Contact your local HoS or captain for more information."
	path = /obj/item/clothing/under/rank/civilian/janitor/maid