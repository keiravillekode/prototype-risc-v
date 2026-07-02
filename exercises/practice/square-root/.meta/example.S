.text
.globl square_root

/* extern size_t square_root(size_t radicand); */
square_root:
        move    a1, a0
        move    a0, zero
        j       .multiply

.increment:
        addi    a0, a0, 1

.multiply:
        mul     t0, a0, a0
        blt     t0, a1, .increment

        ret
