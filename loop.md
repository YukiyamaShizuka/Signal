This file demonstrates a deterministic loop structure using a 3-stage vector model:
	•	a generates i
	•	b receives and forwards i
	•	c executes actress(i)

Each iteration:
	1.	x0 is the loop index (i), counting from 0 to n = 100.
	2.	x2 = x0 simulates a → b transfer.
	3.	x3 = x2 simulates b → c transfer.
	4.	actress_call is called with x3:
	•	Fails if i == 13 (sets x4 = 0)
	•	Otherwise succeeds (x4 = 1)
	5.	On success, the loop continues to next i.

Failure branches (D, E) are not yet implemented, but the structure is designed for future fault recording and retry logic.

Registers used:
	•	x0: loop variable
	•	x2: value passed to b
	•	x3: value passed to c
	•	x4: result flag (1 = success)
