// Mutable appearances are an inbuilt byond datastructure. Read the documentation on them by hitting F1 in DM.
// Basically use them instead of images for overlays/underlays and when changing an object's appearance if you're doing so with any regularity.
// Unless you need the overlay/underlay to have a different direction than the base object. Then you have to use an image due to a bug.

// Mutable appearances are children of images, just so you know.

/mutable_appearance/New()
	..()
	plane = FLOAT_PLANE // No clue why this is 0 by default yet images are on FLOAT_PLANE
						// And yes this does have to be in the constructor, BYOND ignores it if you set it as a normal var

// Helper similar to image()
<<<<<<< HEAD
/proc/mutable_appearance(icon, icon_state = "", layer = FLOAT_LAYER, plane = FLOAT_PLANE)
=======
/proc/mutable_appearance(icon, icon_state = "", layer = FLOAT_LAYER, plane = FLOAT_PLANE, alpha = 255, appearance_flags = NONE, color)
>>>>>>> 257d064f2e (Fixes Emissives, aswell as adds an atomized version of update_appearance  (#8063))
	var/mutable_appearance/MA = new()
	MA.icon = icon
	MA.icon_state = icon_state
	MA.layer = layer
	MA.plane = plane
<<<<<<< HEAD
=======
	MA.alpha = alpha
	MA.appearance_flags |= appearance_flags
	if(color)
		MA.color = color
>>>>>>> 257d064f2e (Fixes Emissives, aswell as adds an atomized version of update_appearance  (#8063))
	return MA

/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EMISSIVE_COLOR].
/proc/emissive_appearance(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = NONE)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, EMISSIVE_PLANE, alpha, appearance_flags | EMISSIVE_APPEARANCE_FLAGS)
	appearance.color = GLOB.emissive_color
	return appearance

/// Produces a mutable appearance glued to the [EMISSIVE_PLANE] dyed to be the [EM_BLOCK_COLOR].
/proc/emissive_blocker(icon, icon_state = "", layer = FLOAT_LAYER, alpha = 255, appearance_flags = NONE)
	var/mutable_appearance/appearance = mutable_appearance(icon, icon_state, layer, EMISSIVE_PLANE, alpha, appearance_flags | EMISSIVE_APPEARANCE_FLAGS)
	appearance.color = GLOB.em_block_color
	return appearance
