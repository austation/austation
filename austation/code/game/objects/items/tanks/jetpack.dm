/obj/item/tank/jetpack
  name = "jetpack (empty)"
  desc = "A tank of compressed gas for use as propulsion in zero-gravity areas. Use with caution."
  icon_state = "jetpack"
  item_state = "jetpack"
  lefthand_file = 'icons/mob/inhands/equipment/jetpacks_lefthand.dmi'
  righthand_file = 'icons/mob/inhands/equipment/jetpacks_righthand.dmi'
  w_class = WEIGHT_CLASS_BULKY
  distribute_pressure = ONE_ATMOSPHERE * O2STANDARD
  actions_types = list(/datum/action/item_action/set_internals, /datum/action/item_action/toggle_jetpack, /datum/action/item_action/jetpack_stabilization)
  no_rupture = TRUE
  var/gas_type = /datum/gas/oxygen
  var/on = FALSE
  var/stabilizers = FALSE
  var/full_speed = TRUE // If the jetpack will have a speedboost in space/nograv or not
  var/datum/effect_system/trail_follow/ion/ion_trail
