// 初始化寄存器
MOV     x0, #s         // i = s
MOV     x1, #n         // 上限
MOV     x10, #addr_D   // 错误数组 D
MOV     x11, #addr_E   // 错误数组 E
MOV     x5, #0         // offset = 0

loop_start:
    CMP     x0, x1
    BGT     loop_end   // 若 i > n，跳出循环

    MOV     x2, x0     // a 向 b 传递 i
    BL      pass_to_b  // 尝试传给 b

    CBZ     x0, store_D_and_retry  // 如果失败，存入 D 并 retry

pass_to_b:
    // 模拟 b 接收并传给 c
    MOV     x3, x2
    BL      actress_call

    CBZ     x4, store_E_and_retry  // 执行失败，存入 E 并 retry

    // actress 执行成功，准备下一个 i
    ADD     x0, x0, #1
    B       loop_start

store_D_and_retry:
    STR     x2, [x10, x5]
    ADD     x5, x5, #8     // 每条错误记录占8字节
    B       loop_start     // retry 逻辑与下次 i 相同处理

store_E_and_retry:
    STR     x3, [x11, x5]
    ADD     x5, x5, #8
    B       loop_start

loop_end:
    RET
