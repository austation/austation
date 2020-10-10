/datum/design/custompen
	name = "Disposable Autopen"
	id = "custom_epi"
	build_type = PROTOLATHE
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
	materials = list(/datum/material/glass = 3000, /datum/material/plastic = 3000, /datum/material/gold = 1600, /datum/material/titanium = 1000)
	build_path = /obj/item/reagent_containers/hypospray/medipen/custompen
	category = list("Medical Designs")

/datum/design/custompen/bluespace
	name = "Bluespace Disposable Autopen"
	id = "BScustom_epi"
	build_type = PROTOLATHE
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL | DEPARTMENTAL_FLAG_SCIENCE
	materials = list(/datum/material/glass = 5000,  /datum/material/plastic = 1000, /datum/material/diamond = 800, /datum/material/gold = 2000, /datum/material/titanium = 1000, /datum/material/bluespace = 400)
	build_path = /obj/item/reagent_containers/hypospray/medipen/custompen/bluespace
	category = list("Medical Designs")

/datum/design/surgery/cortex_imprint
	name = "Cortex Imprint"
	desc = "A surgical procedure which modifies the cerebral cortex into a redundant neural pattern, making the brain able to bypass damage caused by minor brain traumas."
	id = "surgery_cortex_imprint"
	surgery = /datum/surgery/advanced/bioware/cortex_imprint
	research_icon_state = "surgery_head"

/datum/design/surgery/cortex_folding
	name = "Cortex Folding"
	desc = "A surgical procedure which modifies the cerebral cortex into a complex fold, giving space to non-standard neural patterns."
	id = "surgery_cortex_folding"
	surgery = /datum/surgery/advanced/bioware/cortex_folding
	research_icon_state = "surgery_head"

/datum/design/catcybernetic
	name = "Cybernetic Cat-ears"
	desc = "A pair of cybernetic Cat-ears, With synthetic skin lining, you cant believe robotic cat ears really do exist."
	id = "catcybernetic"
	build_type = PROTOLATHE | MECHFAB
	construction_time = 50
	materials = list(/datum/material/iron = 500, /datum/material/glass = 500, /datum/material/silver = 500, /datum/material/copper = 300)
	build_path = /obj/item/organ/ears/catcybernetic
	category = list("Misc", "Medical Designs")
	departmental_flags = DEPARTMENTAL_FLAG_MEDICAL
