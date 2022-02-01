#define BOMB_TARGET_POINTS			50000 //Adjust as needed. Actual hard cap is double this, but will never be reached due to hyperbolic curve.
#define BOMB_TARGET_SIZE			200 // The shockwave radius required for a bomb to get TECHWEB_BOMB_MIDPOINT points.
#define BOMB_SUB_TARGET_EXPONENT	2 // The power of the points curve below the target size. Higher = less points for worse bombs, below target.
