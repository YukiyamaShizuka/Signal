# Scalar and Vector in Signal
*— Structural Cooperation and Transparent Lifecycle in a Path-Oriented Language*

## Overview

In Signal, `scalar` and `vector` are not mere value containers.  
They are **structural nodes** with clearly defined roles in the system’s execution topology.

- `scalar` represents **localized immutable state**, tied to a specific usage scope.
- `vector` represents **transmission of value**, acting as a one-way data injection mechanism.

Together, they form a **transparent, predictable, and fall-safe structure** for data movement and transformation.

---

## Scalar: Immutable and Bounded

```signal
scalar int32 count = 5 usedby <stepA(); stepB()>;

Key Features:
	•	Must be initialized at declaration;
	•	Must declare usedby behavior list;
	•	Value is immutable after declaration;
	•	Destroyed automatically after the last usage completes.

Purpose:

To hold context-local values that can be safely referenced by downstream actress functions.
It acts as a temporary logic node on the path graph, bound by clear origin and endpoint.

⸻

Vector: Directed Injection and Value Movement
vector int32 seed = 3 to <initCount();>;

Key Features:
	•	Acts as a data injection channel;
	•	Cannot be used directly — must flow into a scalar;
	•	Each vector must declare its destination via to <...> syntax;
	•	Automatically destroyed after all targets have received the value.

Purpose:

To perform one-time value transmission from an external context into declared local scalars,
ensuring no global mutation, no ambiguous source, and traceable value flow.

⸻

Typical Cooperation Pattern

vector int32 init = 42 to <stepA(); stepB();>;

actress stepA(vector init) {
    scalar int32 a = init usedby <computeA();>;
    ...
}

actress stepB(vector init) {
    scalar int32 b = init usedby <computeB();>;
    ...
}

Explanation:
	•	The vector init is declared once and transmits its value to both stepA and stepB;
	•	Within each actress, init is locally captured as a scalar and bound to internal logic;
	•	Each scalar is only valid within its usage path (computeA, computeB);
	•	After all scalars fall, the vector also falls automatically.

Anti-patterns and Compiler Errors
	•	Declaring a scalar without usedby → error: unused variable
	•	Using vector as if mutable or directly updatable → error: illegal access
	•	Forgetting fall() or allowing infinite usedby chains → error: lifecycle leak
	•	Using the same scalar in two stages without re-injection → error: cross-stage contamination

Summary

Signal’s scalar and vector are not runtime conveniences — they are the building blocks of computational responsibility.

They enforce:
	•	Declarative ownership;
	•	Immutable locality;
	•	Transparent data flow;
	•	Finite lifecycles.

Together, they allow systems written in Signal to be auditable, predictable, and structurally pure — a foundation no imperative system has ever fully achieved.

