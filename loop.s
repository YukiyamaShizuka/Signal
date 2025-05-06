// loop_pipeline.s — ARM64 Implementation of Vectorized Loop with Error Handling
// Author: Yukiyama Shizuka
// Platform: Apple M3 Max (ARM64)

.global _start

.section .text
_start:
    MOV     x0, #0          // x0: loop variable i = 0
    MOV     x1, #100        // x1: loop upper bound n = 100
    MOV     x5, #0          // x5: offset for error arrays
    LDR     x10, =D_array   // x10: base address of error array D (transfer errors)
    LDR     x11, =E_array   // x11: base address of error array E (execution errors)

loop_start:
    CMP     x0, x1
    BGT     loop_end        // if i > n, end loop

    MOV     x2, x0          // a passes i to b: x2 = i
    BL      pass_to_b       // call b → c transfer and execute

    CBZ     x4, store_D     // if b→c transfer failed, log to D and retry

    ADD     x0, x0, #1      // on success, increment i
    B       loop_start

// b receives from a and passes to c
pass_to_b:
    MOV     x3, x2          // b → c: x3 = i
    BL      actress_call    // call actress(i)

    CBZ     x4, store_E     // if actress(i) failed, log to E and retry
    MOV     x4, #1          // success: return true to a
    RET

// c executes actress(i)
actress_call:
    CMP     x3, #13         // simulate failure when i == 13
    CSET    x4, NE          // x4 = 1 (success) if i != 13; else x4 = 0
    RET

// store failed transfer to D
store_D:
    STR     x2, [x10, x5]   // store i in D_array
    ADD     x5, x5, #8      // move to next slot
    MOV     x4, #1          // retry loop anyway
    RET

// store failed execution to E
store_E:
    STR     x3, [x11, x5]   // store i in E_array
    ADD     x5, x5, #8      // move to next slot
    MOV     x4, #1          // retry loop anyway
    RET

loop_end:
    MOV     x8, #93         // syscall: exit
    MOV     x0, #0
    SVC     #0

.section .bss
    .align 3
D_array: .skip 1024         // array D: failed transfers
E_array: .skip 1024         // array E: failed executions
