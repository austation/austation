/*
	* Decreases at a rate proportional to it's current value. y=a(1-b)^x

	* A = initial amount
	* B = decay factor
	* x = amount of intervals.
*/
#define EXP_DECAY(A, B, x) (A * (1 - B) ** x)
