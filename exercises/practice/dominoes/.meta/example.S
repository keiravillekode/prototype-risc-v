.text
.globl init_parents
.globl root
.globl merge
.globl can_chain


init_parents:
        li      t0, 64
        move    t1, zero

.init_parent:
        add     t2, a0, t1
        sw      t1, 0(t2)
        addi    t1, t1, 4
        bne     t1, t0, .init_parent

        ret


root:
        slli    a1, a1, 2
        j       .fixed_point_check

.reparent:
        add     t0, a0, a1
        sh      t1, 0(t0)
        move    a1, t1

.fixed_point_check:
        add     t0, a0, a1
        lh      t1, 0(t0)
        add     t0, a0, t1
        lh      t1, 0(t0)
        bne     a1, t1, .reparent

        move    a0, a1
        ret


merge:
        move    t6, ra
        move    t4, a0
        call    root
        move    a3, a0                  /* a3 first root */
        move    a0, t4
        move    a1, a2
        call    root                    /* a0 second root */
        beq     a0, a3, .merge_ret

        add     t0, t4, a3
        add     t1, t4, a0
        lh      t2, 2(t0)               /* first depth */
        lh      t3, 2(t1)               /* second depth */
        bgt     t2, t3, .merge_into_first

        blt     t2, t3, .merge_into_second

        addi    t3, t3, 1
        sh      t3, 2(t1)

.merge_into_second:
        sh      a0, 0(t0)
        jr      t6

.merge_into_first:
        sh      a3, 0(t1)

.merge_ret:
        jr      t6


/* extern int can_chain(size_t domino_count, const uint8_t *dominoes); */
can_chain:
        move    t5, ra                  /* return address */

        move    a6, a1                  /* start of dominoes */
        add     a7, a1, a0              /* end of dominoes */

        add     sp, sp, -128
        move    a0, sp                  /* table for Disjoint Set operations */
        call    init_parents


        addi    t0, a0, 128
        addi    a5, a0, 64

.init_tally:
        addi    t0, t0, -4
        sw      zero, 0(t0)
        bne     t0, a5, .init_tally

        beq     a7, a6, .report

.tally:
        addi    a7, a7, -1
        lb      a2, 0(a7)
        andi    a1, a2, 0xf
        srli    a2, a2, 4

        slli    t0, a1, 2
        add     t0, a5, t0
        lw      t1, 0(t0)
        addi    t1, t1, 1
        sw      t1, 0(t0)

        slli    t0, a2, 2
        add     t0, a5, t0
        lw      t1, 0(t0)
        addi    t1, t1, 1
        sw      t1, 0(t0)

        move    a0, sp
        call    merge
        bne     a7, a6, .tally

.report:
        addi    t0, sp, 128
        move    t4, zero                /* number of non-empty roots */

.read_tally:
        addi    t0, t0, -4
        lw      t1, 0(t0)
        beqz    t1, .next_tally

        andi    t1, t1, 1
        bnez    t1, .fail               /* odd tally? */

        sub     t1, t0, a5
        add     t2, sp, t1
        lh      t3, 0(t2)
        sub     t3, t3, t1
        seqz    t3, t3
        add     t4, t4, t3              /* update number of roots */

.next_tally:
        bne     t0, a5, .read_tally

        li      a0, 1
        ble     t4, a0, .return

.fail:
        move    a0, zero

.return:
        add     sp, sp, 128
        jr      t5
