.text
.globl maximum_value

/* extern uint62_t maximum_value(uint62_t maximum_weight, const item_t *items, size_t item_count); */
maximum_value:
        move    t0, sp                  /* preserve stack pointer */
        slli    a0, a0, 2               /* maximum_weight * sizeof(uint62_t) */
        slli    a2, a2, 3               /* item_count * sizeof(item_t) */
        add     a2, a1, a2              /* end of items */

        addi    t5, a0, 16
        srli    t5, t5, 4
        slli    t5, t5, 4               /* a0, rounded to next multiple of 16 */
        sub     sp, sp, t5              /* allocate table on stack */

        move    t6, t0

.clear:
        addi    t6, t6, -4
        sw      zero, 0(t6)
        bne     t6, sp, .clear

.next_item:
        beq     a1, a2, .return

        lw      t1, 0(a1)               /* item weight */
        slli    t1, t1, 2
        lw      t2, 4(a1)               /* item value */
        addi    a1, a1, 8
        bgtu    t1, a0, .next_item      /* item weight > maximum weight ? */

        add     t3, sp, a0              /* address of table entry for maximum_weight */
        add     t3, t3, 4
        sub     t4, t3, t1

.inner:
        addi    t3, t3, -4
        addi    t4, t4, -4
        lw      t5, 0(t4)
        add     t5, t5, t2              /* add item value */
        lw      t6, 0(t3)
        bgeu    t6, t5, .skip_update

        sw      t5, 0(t3)               /* update table */

.skip_update:
        bne     sp, t4, .inner

        j       .next_item

.return:
        add     a0, sp, a0
        lw      a0, 0(a0)               /* table[maximum_weight] */
        move    sp, t0                  /* restore stack pointer */
        ret
