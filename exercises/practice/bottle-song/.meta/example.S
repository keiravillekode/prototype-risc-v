.section .rodata

green:
        .string " green bottle"
hanging:
        .string " hanging on the wall"
and:
        .string "And if one green bottle should accidentally fall,\nThere'll be "
comma:  .string ",\n"
stop:   .string ".\n\n"

numbers:
        .string "noonetwothreefourfivesixseveneightnineten"

numbers_table:
        .byte 0, 2, 5, 8, 13, 17, 21, 24, 29, 34, 38, 41


.text
.globl recite


/* char *copy(char *dest, void *, void *, const char *source); */
copy:
        lb      t0, 0(a3)
        addi    a3, a3, 1
        sb      t0, 0(a0)
        addi    a0, a0, 1
        bnez    t0, copy

        addi    a0, a0, -1
        jalr    zero, 0(t6)             /* return */


/* char *copy_n(char *dest, void *, void *, const char *source, size_t length); */
copy_n:
        beqz    a4, .copy_n_return

        lb      t0, 0(a3)
        addi    a3, a3, 1
        sb      t0, 0(a0)
        addi    a0, a0, 1
        addi    a4, a4, -1
        j       copy_n

.copy_n_return:
        jalr    zero, 0(t6)             /* return */


/* extern void recite(char *buffer, int start_bottles, int take_down); */
recite:
        sub     a2, a1, a2
        li      a6, 1
        li      a7, 's'

.stanza:
        move    t4, a0

        la      a3, numbers
        la      t0, numbers_table
        add     t0, t0, a1
        lbu     t1, 0(t0)
        add     a3, a3, t1              /* start of number string */
        addi    t0, t0, 1
        lbu     t2, 0(t0)
        sub     a4, t2, t1              /* length of number string */
        jal     t6, copy_n              /* subroutine call */

        la      a3, green
        jal     t6, copy                /* subroutine call */

        beq     a1, a6, .hanging1       /* 1? */

        sb      a7, 0(a0)               /* 's' */
        addi    a0, a0, 1

.hanging1:
        la      a3, hanging
        jal     t6, copy                /* subroutine call */

        la      a3, comma
        jal     t6, copy                /* subroutine call */

        lb      t0, 0(t4)
        addi    t0, t0, -32             /* convert first letter to upper case */
        sb      t0, 0(t4)

        move    a3, t4                  /* start of most recent line */
        sub     a4, a0, t4              /* length of most recent line */
        jal     t6, copy_n              /* subroutine call */

        la      a3, and
        jal     t6, copy                /* subroutine call */

        addi    a1, a1, -1              /* decrement number of bottles */

        la      a3, numbers
        la      t0, numbers_table
        add     t0, t0, a1
        lbu     t1, 0(t0)
        add     a3, a3, t1              /* start of number string */
        addi    t0, t0, 1
        lbu     t2, 0(t0)
        sub     a4, t2, t1              /* length of number string */
        jal     t6, copy_n              /* subroutine call */

        la      a3, green
        jal     t6, copy                /* subroutine call */

        beq     a1, a6, .hanging4       /* 1? */

        sb      a7, 0(a0)               /* 's' */
        addi    a0, a0, 1

.hanging4:
        la      a3, hanging
        jal     t6, copy                /* subroutine call */

        la      a3, stop
        jal     t6, copy                /* subroutine call */

        bne     a1, a2, .stanza

        sb      zero, -1(a0)
        ret
