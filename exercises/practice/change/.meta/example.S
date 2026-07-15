.equ NEGATIVE_TARGET, -1
.equ UNREACHABLE_TARGET, -2

.text
.globl find_fewest_coins

negative_target:
        li      a0, NEGATIVE_TARGET
        ret

unreachable_target:
        li      a0, UNREACHABLE_TARGET
        add     sp, sp, a4
        ret

/* extern int32_t find_fewest_coins(uint32_t *buffer, const uint32_t *coins, size_t coins_count, int32_t target); */
find_fewest_coins:
        blt     a3, zero, negative_target

        slli    a2, a2, 2
        add     a2, a1, a2              /* end of coins */
        addi    a4, a3, 4
        andi    a4, a4, -4
        slli    a4, a4, 2               /* table size in bytes, rounded up to a multiple of 16 */
        move    a5, a0                  /* output pointer */
        sub     sp, sp, a4
        beqz    a3, return

        sw      zero, 0(sp)
        li      t0, 1                   /* index into table */

table_do:
        li      t1, -1                  /* best count */
        addi    t2, a1, -4              /* pointer into coins */
        j       coins_while

coins_do:
        lw      t3, 0(t2)               /* coin */
        sub     t4, t0, t3
        blt     t4, zero, coins_while

        slli    t4, t4, 2
        add     t4, sp, t4
        lw      t4, 0(t4)
        bgeu    t4, t1, coins_while

        addi    t1, t4, 1

coins_while:
        addi    t2, t2, 4
        bne     t2, a2, coins_do

        slli    t5, t0, 2
        add     t5, sp, t5
        sw      t1, 0(t5)

table_while:
        addi    t0, t0, 1
        bleu    t0, a3, table_do

        blt     t1, zero, unreachable_target

target_while:
        slli    t6, a3, 2
        add     t6, sp, t6
        lw      t6, 0(t6)
        addi    t6, t6, -1              /* table[target] - 1 */
        addi    t2, a1, -4

candidate_do:
        addi    t2, t2, 4
        lw      t3, 0(t2)               /* candidate coin */
        sub     t4, a3, t3
        blt     t4, zero, candidate_do

        slli    t5, t4, 2
        add     t5, sp, t5
        lw      t5, 0(t5)               /* table[target - coin] */
        bne     t5, t6, candidate_do

output_coin:
        move    a3, t4                  /* target -= coin */
        sw      t3, 0(a5)               /* record coin */
        addi    a5, a5, 4

target_do:
        bnez    a3, target_while

return:
        sub     a0, a5, a0
        srli    a0, a0, 2
        add     sp, sp, a4
        ret
