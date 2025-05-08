// vector_core.s
// Apple M-series (ARM64) - Signal Vector Broadcast System
// Implements: vector int32 initializer = 42 to <count; limit; depth;>

.section    __DATA,__data
    .globl  _count
_count:     .long   0       // scalar count

    .globl  _limit
_limit:     .long   0       // scalar limit

    .globl  _depth
_depth:     .long   0       // scalar depth

    .globl  _initializer
_initializer:
    .long   42              // vector value (int32)

.section    __TEXT,__text,regular,pure_instructions
    .globl  _start
_start:
    // Load initializer vector
    adrp    x1, _initializer@PAGE
    add     x1, x1, _initializer@PAGEOFF
    ldr     w0, [x1]                    // w0 = initializer

    // Propagate to count
    adrp    x2, _count@PAGE
    add     x2, x2, _count@PAGEOFF
    str     w0, [x2]

    // Propagate to limit
    adrp    x3, _limit@PAGE
    add     x3, x3, _limit@PAGEOFF
    str     w0, [x3]

    // Propagate to depth
    adrp    x4, _depth@PAGE
    add     x4, x4, _depth@PAGEOFF
    str     w0, [x4]

    // fall(): destroy vector (clear initializer)
    mov     w5, #0
    str     w5, [x1]                    // initializer = 0

    // exit
    mov     x16, #0x2000001            // syscall: exit
    mov     x0, #0
    svc     #0
