.section .rodata

i_know: .string "I know an old lady who swallowed a "
stop:   .string ".\n"
she_swallowed:
        .string "She swallowed the "
to_catch:
        .string " to catch the "
that_wriggled:
        .string " that wriggled and jiggled and tickled inside her"

animals:
        .string "flyspiderbirdcatdoggoatcowhorse"

animals_table:
        .hword 0, 0, 3, 9, 13, 16, 19, 23, 26, 31, 31

exclamations:
        .string "I don't know why she swallowed the fly. Perhaps she'll die.\nIt wriggled and jiggled and tickled inside her.\nHow absurd to swallow a bird!\nImagine that, to swallow a cat!\nWhat a hog, to swallow a dog!\nJust opened her throat and swallowed a goat!\nI don't know how she swallowed a cow!\nShe's dead, of course!\n"

exclamations_table:
        .hword 0, 0, 60, 108, 138, 170, 200, 245, 283, 306


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


/* extern void recite(char *buffer, int start_verse, int end_verse); */
recite:
        slli    a1, a1, 1               /* multiply start_verse by 2 */
        slli    a2, a2, 1               /* multiply end_verse by 2 */
        li      a7, 2                   /* fly */
        li      a6, 4                   /* spider */
        li      a5, '\n'

.stanza:
        la      a3, i_know
        jal     t6, copy                /* subroutine call */

        la      a3, animals
        la      t0, animals_table
        add     t0, t0, a1
        lhu     t1, 0(t0)
        add     a3, a3, t1              /* start of animal string */
        addi    t0, t0, 2
        lhu     t2, 0(t0)
        sub     a4, t2, t1              /* length of animal string */
        jal     t6, copy_n              /* subroutine call */

        la      a3, stop
        jal     t6, copy                /* subroutine call */

        la      a3, exclamations
        la      t0, exclamations_table
        add     t0, t0, a1
        lhu     t1, 0(t0)
        add     a3, a3, t1              /* start of exclamation string */
        addi    t0, t0, 2
        lhu     t2, 0(t0)
        sub     a4, t2, t1              /* length of exclamation string */
        jal     t6, copy_n              /* subroutine call */

        li      t0, 2
        beq     a1, t0, .next           /* first verse? */

        li      t0, 16
        beq     a1, t0, .next           /* last verse? */

        move    t3, a1                  /* current animal */

.explain:
        la      a3, she_swallowed
        jal     t6, copy                /* subroutine call */

        la      a3, animals
        la      t0, animals_table
        add     t0, t0, t3
        lhu     t1, 0(t0)
        add     a3, a3, t1              /* start of animal string */
        addi    t0, t0, 2
        lhu     t2, 0(t0)
        sub     a4, t2, t1              /* length of animal string */
        jal     t6, copy_n              /* subroutine call */

        addi    t3, t3, -2              /* previous animal */

        la      a3, to_catch
        jal     t6, copy                /* subroutine call */

        la      a3, animals
        la      t0, animals_table
        add     t0, t0, t3
        lhu     t1, 0(t0)
        add     a3, a3, t1              /* start of animal string */
        addi    t0, t0, 2
        lhu     t2, 0(t0)
        sub     a4, t2, t1              /* length of animal string */
        jal     t6, copy_n              /* subroutine call */

        bne     t3, a6, .stop           /* only spider wriggles */

        la      a3, that_wriggled
        jal     t6, copy                /* subroutine call */

.stop:
        la      a3, stop
        jal     t6, copy                /* subroutine call */

        bne     t3, a7, .explain        /* loop until fly */

        la      a3, exclamations
        la      t0, exclamations_table
        add     t0, t0, t3
        lhu     t1, 0(t0)
        add     a3, a3, t1              /* start of exclamation string */
        addi    t0, t0, 2
        lhu     t2, 0(t0)
        sub     a4, t2, t1              /* length of exclamation string */
        jal     t6, copy_n              /* subroutine call */

.next:
        sb      a5, 0(a0)               /* newline */
        addi    a0, a0, 1
        addi    a1, a1, 2
        ble     a1, a2, .stanza

        sb      zero, -1(a0) 
        ret
