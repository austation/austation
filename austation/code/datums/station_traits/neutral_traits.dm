/datum/station_trait/announcement_ancestor
	name = "Announcer: Ancestor"
	trait_type = STATION_TRAIT_NEUTRAL
	weight = 2
	show_in_report = TRUE
	report_message = "Wayne June has generously donated his time to provide some spooky announcement lines for the season"
	blacklist = list( /datum/station_trait/announcement_medbot,
                    /datum/station_trait/announcement_baystation,
                    /datum/station_trait/announcement_intern)

/datum/station_trait/announcement_ancestor/New()
	. = ..()
	SSstation.announcer = /datum/centcom_announcer/ancestor
