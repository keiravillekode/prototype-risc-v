.section .rodata
pling: .string "Pling"
plang: .string "Plang"
plong: .string "Plong"

.text
.globl convert

/* extern void convert(char *buffer, size_t number); */
convert:
        li      t4, 10
        move    t5, a0

        la      a2, pling
        li      a3, 3
        jal     t6, sound               /* subroutine call */

        la      a2, plang
        li      a3, 5
        jal     t6, sound               /* subroutine call */

        la      a2, plong
        li      a3, 7
        jal     t6, sound               /* subroutine call */

        sb      zero, 0(a0)             /* store null terminator */
        bne     a0, t5, .done

.write:
        move    t1, a1
        divu    a1, t1, t4              /* divide number by 10 */
        remu    t0, t1, t4
        addi    t0, t0, '0'
        sb      t0, 0(a0)               /* store output digit */
        addi    a0, a0, 1               /* Increment output pointer */
        bnez    a1, .write

        sb      zero, 0(a0)             /* store null terminator */

.reverse:
        addi    a0, a0, -1
        beq     t5, a0, .done

        lb      t2, 0(t5)
        lb      t3, 0(a0)
        sb      t2, 0(a0)
        sb      t3, 0(t5)
        addi    t5, t5, 1
        bne     t5, a0, .reverse

.done:
        ret


sound:
        remu    t0, a1, a3
        bnez    t0, .return             /* skip if number is not a multiple of a3 */

.copy_string:
        lb      t0, 0(a2)
        beqz    t0, .return

        addi    a2, a2, 1               /* Increment input pointer */
        sb      t0, 0(a0)
        addi    a0, a0, 1               /* Increment output pointer */
        j       .copy_string

.return:
        jalr    zero, 0(t6)
