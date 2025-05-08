// scalar_core.s
// Signal Language: Scalar System Core for Apple ARM64 (M-series)
// Supports: scalar <type> <name> = <value> usedby <funcA(); funcB(); ...>

.section    __DATA,__data

// Example scalar table (supporting multiple scalars)
    .globl  _scalar_values
_scalar_values:
    .long   3           // scalar0 value
    .long   7           // scalar1 value
    // extend...

    .globl  _scalar_lifecycles
_scalar_lifecycles:
    .long   2           // scalar0: usedby 2 functions
    .long   1           // scalar1: usedby 1 function
    // parallel layout

    .globl  _scalar_func_table
_scalar_func_table:
    .quad   _add        // scalar0 funcA
    .quad   _sub        // scalar0 funcB
    .quad   _mul        // scalar1 funcA
    // flattened function list

.section    __TEXT,__text,regular,pure_instructions
    .globl  _start
_start:
    // scalar_count = 2
    mov     x20, #2                  // number of scalars
    mov     x21, #0                  // scalar index i

_loop_scalars:
    cmp     x21, x20
    b.ge    _done                    // if all scalars done, exit

    // Load scalar value
    adrp    x0, _scalar_values@PAGE
    add     x0, x0, _scalar_values@PAGEOFF
    ldr     w1, [x0, x21, LSL #2]    // w1 = scalar[i]

    // Load lifecycle count
    adrp    x2, _scalar_lifecycles@PAGE
    add     x2, x2, _scalar_lifecycles@PAGEOFF
    ldr     w2, [x2, x21, LSL #2]    // w2 = func count for scalar[i]

    // Calculate function base offset
    mov     x3, #0
    mov     x4, x21
    mov     x5, #0

    // sum lifecycles of all previous scalars
_sum_lifecycles:
    cmp     x5, x4
    b.ge    _invoke_funcs

    ldr     w6, [x2, x5, LSL #2]
    add     x3, x3, x6
    add     x5, x5, #1
    b       _sum_lifecycles

// Invoke function list for scalar[i]
_invoke_funcs:
    mov     x6, #0

_func_loop:
    cmp     x6, w2
    b.ge    _fall_scalar

    // func_addr = func_table[x3 + x6]
    adrp    x10, _scalar_func_table@PAGE
    add     x10, x10, _scalar_func_table@PAGEOFF
    ldr     x11, [x10, x3, LSL #3]   // 8 bytes per entry
    add     x3, x3, #1               // increment offset

    // call function with w1 (scalar value)
    mov     w0, w1
    blr     x11                      // call via register

    add     x6, x6, #1
    b       _func_loop

// Simulate fall() after all funcs called
_fall_scalar:
    adrp    x0, _scalar_values@PAGE
    add     x0, x0, _scalar_values@PAGEOFF
    mov     w9, #0
    str     w9, [x0, x21, LSL #2]    // clear scalar value

    add     x21, x21, #1
    b       _loop_scalars

_done:
    mov     x16, #0x2000001
    mov     x0, #0
    svc     #0

// -- Example dummy functions --
_add:
    add     w1, w0, #5
    ret

_sub:
    sub     w1, w0, #2
    ret

_mul:
    mul     w1, w0, w0
    ret
