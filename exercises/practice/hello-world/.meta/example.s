.section .rodata
msg: .string "Hello, World!"

.text
.global hello
hello:
    la a0, msg
    ret
