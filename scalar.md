# Signal Language — Scalar System Specification

This document defines the `scalar` construct in the Signal programming language. Scalars represent immutable values bound to a strictly ordered usage lifecycle. They are used to transfer static, constant data through functions, after which they are automatically deallocated.

---

## Syntax
scalar   =  usedby <funcA(); funcB(); …>;
### Components:

- `scalar`: Declaration keyword.
- `<type>`: Data type (e.g., `int8`, `int32`, `uint64`, `float32`, `bool`).
- `<name>`: Unique scalar name (symbolic identifier).
- `=<value>`: Initialization value. Immutable.
- `usedby<...>`: Ordered list of functions that will use this scalar.

---

## Semantics

1. **Immutability**: A scalar is constant. Once defined, its value cannot be reassigned.
2. **Sequential Usage**: The scalar is passed into the listed functions in declared order.
3. **Lifecycle Binding**: Once all `usedby` functions have completed, the scalar is automatically deallocated via `fall()` logic.
4. **No Side-effects**: Scalars are passed read-only to avoid mutation and side-effects.
5. **Destruction**: Scalars are memory-released or flagged as zero once their lifecycle ends.

---

## Example
scalar int32 counter = 3 usedby <increment(); print();>;
- Declares an immutable integer `counter` with value 3.
- It is passed first to `increment()`, then to `print()`.
- After `print()` completes, `counter` is automatically deallocated.

---

## Internal Representation

In assembly-level or runtime implementation (e.g., ARM64 on Apple M-series):

- Scalars are stored in a `.data` or `.bss` segment.
- Their lifecycle is tracked via a `counter` or `function dispatch table`.
- Functions are called in sequence via a flattened address list.
- A `fall` step zeroes the scalar or marks it as freed.

Example memory layout:

[ scalar value ]
[ lifecycle count ]
[ function ptr 0 ]
[ function ptr 1 ]

---

## Future Extensions

- **Typed fall hooks**: Allow scalars to invoke cleanup logic based on type.
- **Scalar groups**: Enable multiple scalars to be declared in dependency trees.
- **Compiler directives**: Optional static validation of `usedby` resolution.

---

## Best Practices

- Always declare `usedby` in execution order.
- Avoid circular logic (e.g., scalar A usedby func B, which spawns scalar A).
- Keep scalar value types minimal — prefer `int32` and `bool` over complex structures.

---

## Related Concepts

- `leaf()`: May bind scalar inputs as part of its context.
- `sap`: May coordinate scalar propagation across functions.
- `fall()`: Scalar deallocation or memory release phase.

---

## Version

Specification: Signal Scalar v0.0  
Status: Experimental  
Architecture target: ARM64 (Apple M-series)

