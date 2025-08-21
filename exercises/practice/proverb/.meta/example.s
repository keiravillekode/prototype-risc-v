/*
| Register | Usage        | Type    | Description                                                |
| -------- | ------------ | ------- | ---------------------------------------------------------- |
| `a0`     | input/output | address | null-terminated output string                              |
| `a1`     | input        | address | null-terminated input string with newline after each input |
| `a2`     | temporary    | address | null-terminated or newline-terminated source string        |
| `t0`     | temporary    | byte    | character for output                                       |
| `t2`     | temporary    | address | current string                                             |
| `t3`     | temporary    | address | first string                                               |
| `t5`     | temporary    | byte    | '\n' newline                                               |
| `t6`     | temporary    | address | return address                                             |
*/

.section .rodata

for_want: .string "For want of a "
the:      .string " the "
was_lost: .string " was lost.\n"
and_all:  .string "And all for the want of a "
stop:     .string ".\n"


.text
.globl recite


/* char *copy(char *dest, void *, const char *source); */
copy:
                                        /* copy string from source a2 to destination a0 */
        lb      t0, 0(a2)               /* load source byte */
        addi    a2, a2, 1               /* increment souce pointer */
        sb      t0, 0(a0)               /* write byte to destination */
        addi    a0, a0, 1               /* increment destination pointer */
        bgtu    t0, t5, copy            /* repeat until we have reached terminator - \n or \0 */

        addi    a0, a0, -1              /* decrement destination pointer,
                                           ready to append other strings */
        jalr    zero, 0(t6)             /* return */


recite:
        lb      t0, 0(a1)               /* read input byte */
        beqz    t0, .done               /* empty? */

        move    t3, a1                  /* first string */
        li      t5, '\n'
        j       .next

.write_line:
        la      a2, for_want
        jal     t6, copy                /* subroutine call */

        move    a2, t2
        jal     t6, copy                /* subroutine call */

        la      a2, the
        jal     t6, copy                /* subroutine call */

        move    a2, a1
        jal     t6, copy                /* subroutine call */

        la      a2, was_lost
        jal     t6, copy                /* subroutine call */
        addi    a0, a0, 1               /* avoid overwriting newline */

.next:
        move    t2, a1                  /* current string */

.scan:
        lb      t0, 0(a1)               /* read input byte */
        addi    a1, a1, 1               /* increment input pointer */
        bne     t0, t5, .scan           /* loop until newline */

        lb      t0, 0(a1)               /* first byte after newline */
        bnez    t0, .write_line

.write_final_line:
        la      a2, and_all
        jal     t6, copy                /* subroutine call */

        move    a2, t3                  /* first string */
        jal     t6, copy                /* subroutine call */

        la      a2, stop
        jal     t6, copy                /* subroutine call */
        addi    a0, a0, 1               /* avoid overwriting newline */

.done:
        sb      zero, 0(a0)
        ret
