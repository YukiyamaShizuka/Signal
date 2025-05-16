# Signal Function Behavior Specification

This document defines the function-level runtime behavior model in **Signal**, a low-level language designed for deterministic, memory-transparent execution. It establishes core conventions for value scope, memory safety, and computational traceability.

---

## Overview

Functions in Signal are **non-persistent, scope-bound computation blocks** that explicitly avoid hidden state, global memory leaks, or implicit side effects.

```signal
actress(vector i; ...) {
    scalar j = i;
    result = ?
}
bringto<vector x; actress y>

Design Principles

1. No Global Variables

Signal does not allow global state. All variables must be:
	•	Declared within a function or passed through an external vector.
	•	Bound to a local lifetime.
	•	Explicitly destroyed after use.

Rationale: Prevents accidental state retention, race conditions, and promotes structural predictability.

⸻

2. Value Isolation via Vector-to-Scalar Copy

When a function receives a vector input, it must declare explicit scalar replicas:

scalar j = i;

	•	j is isolated from i — modifications to j do not affect i.
	•	This guarantees functional purity and enables memory-level traceability.
	•	Scalars are ephemeral: they live only inside the function scope.

⸻

3. Explicit Return Routing with bringto<>

Signal prohibits implicit return values. Instead, all results must be routed into external vectors using bringto<>:

bringto<vector x; actress y…>

•	x is the destination vector for the result of y.
	•	The actress function does not “return” in the traditional sense — instead, it resolves into a computation endpoint which bringto binds.

This design:
	•	Eliminates hidden flow.
	•	Makes the entire computational graph structurally navigable.
	•	Ensures every function call has a declared result sink.

⸻

4. Lifecycle Completion and Memory Cleanup

All temporary values created within a function (e.g. scalars) are:
	•	Automatically deallocated upon function scope exit.
	•	Non-persistent, unless explicitly copied into an external vector or structure.

There is no garbage collector. Every memory movement is visible and scope-bound.

Feature
Signal Behavior
Global variables
Disallowed
Vector arguments
Immutable, must be copied
Local scalars
Ephemeral, memory-cleared after use
Return values
Routed via bringto<>, never implicit
Memory management
Manual, declarative, deterministic

Future Extensions

This model serves as the foundational contract for the Signal runtime. Future extensions may support:
	•	Static memory pools for scoped reuse
	•	Named lifecycles for batch deallocation
	•	Conditional bringto bindings

But the no global state, no hidden lifetime rule will remain fundamental.

⸻

Author: Yukiyama Shizuka
Project: Signal Language Runtime
