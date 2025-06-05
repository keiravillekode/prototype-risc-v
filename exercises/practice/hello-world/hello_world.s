.section .rodata
msg: .string "Goodbye, Mars!"

.text
.global hello
hello:
        la      a0, msg
        ret
