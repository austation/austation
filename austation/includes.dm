// AuStation includes file. Add all modularized code files here.

// Global Variables Section
#include "code\_GLOBALS\misc.dm"
#include "code\_GLOBALS\pool_globals.dm"

// Main Includes Section
#include "code\controllers\configuration\entries\game_options.dm"
#include "code\controllers\configuration\entries\general.dm"
#include "code\controllers\subsystem\autosandbox.dm"
#include "code\controllers\subsystem\job.dm"
#include "code\datums\ai_laws.dm"
#include "code\datums\emotes.dm"
#include "code\datums\brain_damage\imaginary_friend.dm"
#include "code\datums\status_effects\buffs.dm"
#include "code\datums\elements\swimming.dm"
#include "code\datums\mood_event\generic_positive_events.dm"
#include "code\game\sound.dm"
#include "code\game\area\Space_Station_13_areas.dm"
#include "code\game\machinery\syndicatebeacon.dm"
#include "code\game\mecha\equipment\tools\other_tools.dm"
#include "code\game\mecha\equipment\tools\work_tools.dm"
#include "code\game\mecha\equipment\weapons\weapons.dm"
#include "code\game\objects\effects\decals\turfdecal\markings.dm"
#include "code\game\objects\items\AI_modules.dm"
#include "code\game\objects\items\robot\robot_upgrades.dm"
#include "code\game\objects\items\storage\belt.dm"
#include "code\game\objects\items\storage\firstaid.dm"
#include "code\game\objects\items\storage\uplink_kits.dm"
#include "code\game\objects\items\twohanded.dm"
#include "code\game\objects\items\weaponry.dm"
#include "code\game\objects\structures\humanfurniture.dm"
#include "code\game\objects\structures\mirror.dm"
#include "code\game\turfs\open\lava.dm"
#include "code\modules\admin\chat_commands.dm"
#include "code\modules\admin\topic.dm"
#include "code\modules\admin\verbs\fix_air.dm"
#include "code\modules\admin\verbs\mapping.dm"
#include "code\modules\client\preferences_savefile.dm"
#include "code\modules\clothing\glasses\hud.dm"
#include "code\modules\clothing\spacesuit\miscellaneous.dm"
#include "code\modules\clothing\under\color.dm"
#include "code\modules\clothing\under\miscellaneous.dm"
#include "code\modules\clothing\under\jobs\engineering.dm"
#include "code\modules\clothing\under\jobs\medisci.dm"
#include "code\modules\clothing\under\jobs\security.dm"
#include "code\modules\clothing\under\jobs\civilian\civilian.dm"
#include "code\modules\events\bruh_moment.dm"
#include "code\modules\food_and_drinks\drinks\drinks.dm"
#include "code\modules\jobs\job_types\assistant.dm"
#include "code\modules\jobs\job_types\chief_medical_officer.dm"
#include "code\modules\jobs\job_types\emt.dm"
#include "code\modules\jobs\job_types\job.dm"
#include "code\modules\jobs\job_types\medical_doctor.dm"
#include "code\modules\mapping\writer.dm"
#include "code\modules\mapping\random_rooms.dm"
#include "code\modules\mob\mob_defines.dm"
#include "code\modules\mob\dead\new_player\new_player.dm"
#include "code\modules\mob\living\emote.dm"
#include "code\modules\mob\living\carbon\emote.dm"
#include "code\modules\mob\living\carbon\examine.dm"
#include "code\modules\mob\living\carbon\human\emote.dm"
#include "code\modules\mob\living\carbon\human\examine.dm"
#include "code\modules\mob\living\carbon\human\human_defines.dm"
#include "code\modules\mob\living\carbon\human\species_type\felinid.dm"
#include "code\modules\mob\living\silicon\robot\emote.dm"
#include "code\modules\mob\living\silicon\robot\robot_modules.dm"
#include "code\modules\mob\living\simple_animal\bot\deathsky.dm"
#include "code\modules\mob\living\simple_animal\friendly\drone\drone.dm"
#include "code\modules\mob\living\simple_animal\friendly\drone\drone_movement.dm"
#include "code\modules\mob\living\simple_animal\friendly\drone\emote.dm"
#include "code\modules\mob\living\simple_animal\hostile\cat_butcher.dm"
#include "code\modules\mob\living\simple_animal\hostile\retaliate\kangaroo.dm"
#include "code\modules\reagents\chemistry\reagents\other_reagents.dm"
#include "code\modules\reagents\chemistry\reagents\toxin_reagents.dm"
#include "code\modules\reagents\chemistry\recipes\others.dm"
#include "code\modules\reagents\chemistry\recipes\toxins.dm"
#include "code\modules\reagents\reagent_containers\bottle.dm"
#include "code\modules\reagents\reagent_containers\custompen.dm"
#include "code\modules\research\designs\AI_module_designs.dm"
#include "code\modules\research\designs\bluespace_designs.dm"
#include "code\modules\research\designs\mecha_designs.dm"
#include "code\modules\research\designs\mechfabricator_designs.dm"
#include "code\modules\research\designs\medical_designs.dm"
#include "code\modules\research\techweb\all_nodes.dm"
#include "code\modules\surgery\organs\tongue.dm"
#include "code\modules\surgery\tools.dm"
#include "code\modules\uplink\uplink_items.dm"
#include "code\modules\vehicles\cars\thanoscar.dm"
#include "code\modules\pool\pool_controller.dm"
#include "code\modules\pool\pool_drain.dm"
#include "code\modules\pool\pool_effects.dm"
#include "code\modules\pool\pool_main.dm"
#include "code\modules\pool\pool_noodles.dm"
#include "code\modules\pool\pool_structures.dm"
#include "code\modules\pool\pool_wires.dm"
#include "code\modules\vending\_vending.dm"
#include "code\modules\vending\autodrobe.dm"
#include "code\modules\vending\clothesmate.dm"
#include "code\modules\vending\wardrobes.dm"
#include "code\modules\surgery\advanced\bioware\cortex_folding.dm"
#include "code\modules\surgery\advanced\bioware\cortex_imprint.dm"
#include "code\modules\atmospherics\machinery\atmosmachinery.dm"
#include "code\modules\atmospherics\machinery\components\unary_devices\thermomachine.dm"
#include "code\modules\cargo\exports\food_and_drink\processed.dm"
#include "code\modules\cargo\exports\organs.dm"
