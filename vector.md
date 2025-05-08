# Signal Language — Vector System Specification

This document defines the `vector` construct in the Signal programming language. A vector is a temporary, one-directional data conduit used to initialize or propagate values into one or more `scalar` entities. It exists only during the value transfer phase and is automatically destroyed after.

---

## Syntax
vector   = <value_expression> to <scalarA; scalarB; …>;

vector int32 init = 5 to <a; b;>;
scalar int32 a = init usedby <sum();>;
scalar int32 b = init usedby <sum();>;
### Components:

- `vector`: Declaration keyword.
- `<type>`: Data type of the vector (e.g., `int32`, `float64`).
- `<name>`: Identifier for the vector instance.
- `=<value_expression>`: Assigned value or computed expression.
- `to<...>`: Target list of scalars that will receive this value (order matters).

---

## Semantics

1. **Single Assignment**: A vector holds a single value (literal or computed).
2. **Value Propagation**: The value is written into each `scalar` listed in the `to<...>` block.
3. **One-Way Transfer**: Scalars receive the value but do not remain bound to the vector.
4. **Auto-Destruction**: Once all transfers are complete, the vector is destroyed (equivalent to `fall()`).
5. **No Reuse**: A vector cannot be reused, reassigned, or updated after declaration.

---

## Example
vector int32 initializer = 42 to <count; limit; depth;>;

- Defines a vector `initializer` with value 42.
- The value 42 is written into the scalars `count`, `limit`, and `depth`.
- After transfer, the vector is deallocated.

---

## Runtime Behavior

At a lower-level (e.g., ARM64 assembly), vectors are compiled into:

- A temporary register or memory slot holding the computed value.
- A sequence of `store` operations to each target scalar memory location.
- An explicit zeroing or release of the vector after final transfer.

Example pseudocode equivalent:

```c
int initializer = 42;
count  = initializer;
limit  = initializer;
depth  = initializer;
initializer = 0; // optional fall()

Lifecycle

Vectors exist only during the current execution step. Unlike scalars, they are not retained in memory between calls or passed through usedby.
	•	create → transfer → fall
	•	No pointer sharing, no mutation allowed after creation.

⸻

Future Extensions
	•	Vector expressions: Support arithmetic or signal-derived values (e.g., = scalarA + scalarB).
	•	Vector-to-vector: Enable value broadcasting across computed vector fields.
	•	Parallel expansion: SIMD-style injection into scalar arrays.

⸻

Best Practices
	•	Use vectors only for setup, not as persistent state.
	•	Avoid complex expressions inside vector values — keep declarative.
	•	Avoid transferring to scalars already bound or active in another lifecycle path.

⸻

Related Concepts
	•	scalar: The recipient of values passed by vectors.
	•	fall(): Implicitly invoked at the end of vector use.
	•	leaf(): May allow vectors as part of entry initialization phase.

⸻

Version

Specification: Signal Vector v0.0
Status: Experimental
Architecture target: ARM64 (Apple M-series)
