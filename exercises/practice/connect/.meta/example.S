.text


.globl find_dimensions

find_dimensions:
        move    t5, zero
        li      t6, '\n'

.inc_columns:
        addi    t5, t5, 1
        slli    t0, t5, 1
        addi    t0, t0, -1
        add     t2, a0, t0
        lb      t2, 0(t2)
        bne     t2, t6, .inc_columns

        li      t6, 1
        slli    t0, t5, 1
        move    t1, t0
        j       .check_null

.inc_rows:
        addi    t6, t6, 1
        addi    t1, t1, 1
        add     t0, t0, t1

.check_null:
        add     t2, a0, t0
        lb      t2, 0(t2)
        bnez    t2, .inc_rows

        ret


.globl init_parents

init_parents:
        mul     t0, t5, t6
        addi    t0, t0, 4
        slli    t0, t0, 2
        move    t1, zero

.init_parent:
        add     t2, a0, t1
        sw      t1, 0(t2)
        addi    t1, t1, 4
        bne     t1, t0, .init_parent

        ret


.globl root

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


.globl merge

merge:
        move    t3, ra
        move    t4, a0
        call    root
        move    a3, a0
        move    a0, t4
        move    a1, a2
        call    root
        move    ra, t3
        beq     a0, a3, .merge_ret

        add     t0, t4, a3
        add     t1, t4, a0
        lh      t2, 2(t0)
        lh      t3, 2(t1)
        bgt     t2, t3, .merge_into_first

        blt     t2, t3, .merge_into_second

        addi    t3, t3, 1
        sh      t3, 2(t1)

.merge_into_second:
        sh      a0, 0(t0)

.merge_ret:
        ret

.merge_into_first:
        sh      a3, 0(t1)
        ret


.globl index

index:
        mul     a0, t5, a1
        add     a0, a0, a2
        addi    a0, a0, 4
        ret


.globl occupant

occupant:
        slli    a1, a1, 2
        add     a1, a1, a2
        addi    a1, a1, 1
        mul     a1, a2, a1
        srli    a1, a1, 1
        add     a1, a1, a3
        add     a1, a1, a3
        add     a1, a0, a1
        lb      a0, 0(a1)
        ret


.globl edge

edge:
        move    a7, ra
        move    t4, a0
        move    t5, a2

        move    a0, a1
        move    a1, t5
        move    a2, a3
        move    a3, a4
        call    occupant
        bne     a0, a6, .edge_ret

        move    a1, a2
        move    a2, a3
        call    index
        move    a2, a0
        move    a0, t4
        move    a1, a5
        call    merge

.edge_ret:
        move    ra, a7
        ret


.globl adjacent

adjacent:
        move    a7, ra
        move    t4, a0
        move    t3, a1

        move    t0, a3
        move    t1, a4

        move    a0, t3
        move    a1, t5
        move    a2, a3
        move    a3, a4
        call    occupant
        move    t2, a0

        move    a0, t3
        move    a1, t5
        move    a2, a5
        move    a3, a6
        call    occupant

        bne     a0, t2, .adjacent_ret

        move    a1, t0
        move    a2, t1
        call    index
        move    t0, a0

        move    a1, a5
        move    a2, a6
        call    index

        move    a1, t0
        move    a2, a0
        move    a0, t4
        move    ra, a7
        j       merge

.adjacent_ret:
        move    ra, a7
        ret


.globl edges

edges:
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)
        sw      s1, 4(sp)
        sw      s2, 0(sp)

        move    t4, a0
        move    s0, a1
        move    s2, zero

.next_j:
                                        /* top edge */
        move    a0, t4
        move    a1, s0
        move    a2, t5
        move    a3, zero
        move    a4, s2
        li      a5, 0
        li      a6, 'O'
        call    edge

                                        /* bottom edge */
        move    a0, t4
        move    a1, s0
        move    a2, t5
        move    a3, t6
        addi    a3, a3, -1
        move    a4, s2
        li      a5, 1
        li      a6, 'O'
        call    edge

        addi    s2, s2, 1
        bne     s2, t5, .next_j

        move    s2, zero

.next_i:
                                        /* left edge */
        move    a0, t4
        move    a1, s0
        move    a2, t5
        move    a3, s2
        move    a4, zero
        li      a5, 2
        li      a6, 'X'
        call    edge

                                        /* right edge */
        move    a0, t4
        move    a1, s0
        move    a2, t5
        move    a3, s2
        move    a4, t5
        addi    a4, a4, -1
        li      a5, 3
        li      a6, 'X'
        call    edge

        addi    s2, s2, 1
        bne     s2, t6, .next_i

        lw      s2, 0(sp)
        lw      s1, 4(sp)
        lw      s0, 8(sp)
        lw      ra, 12(sp)
        addi    sp, sp, 16
        ret


.globl adjacents

adjacents:
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)
        sw      s1, 4(sp)
        sw      s2, 0(sp)

        move    t4, a0
        move    s0, a1
        move    s1, zero                /* i */

.adjacents_next_i:
        move    s2, zero                /* j */

.adjacents_next_j:

        beqz    s2, .skip_horizontal

        move    a0, t4
        move    a1, s0
        move    a2, t5
        move    a3, s1
        move    a4, s2
        move    a5, s1
        move    a6, s2
        addi    a6, a6, -1
        call    adjacent

.skip_horizontal:

        beqz    s1, .skip_forwards
        beqz    s2, .skip_forwards

        move    a0, t4
        move    a1, s0
        move    a2, t5
        move    a3, s1
        move    a4, s2
        addi    a4, a4, -1
        move    a5, s1
        addi    a5, a5, -1
        move    a6, s2
        call    adjacent

.skip_forwards:

        beqz    s1, .skip_backwards

        move    a0, t4
        move    a1, s0
        move    a2, t5
        move    a3, s1
        move    a4, s2
        move    a5, s1
        addi    a5, a5, -1
        move    a6, s2
        call    adjacent

.skip_backwards:

        addi    s2, s2, 1
        bne     s2, t5, .adjacents_next_j

        addi    s1, s1, 1
        bne     s1, t6, .adjacents_next_i

        lw      s2, 0(sp)
        lw      s1, 4(sp)
        lw      s0, 8(sp)
        lw      ra, 12(sp)
        addi    sp, sp, 16
        ret


.globl winner

/* extern char winner(const char *board); */
winner:
        addi    sp, sp, -16
        sw      ra, 12(sp)
        sw      s0, 8(sp)

        move    s0, a0
        call    find_dimensions
                                        /* t5 = number of columns */
                                        /* t6 = number of rows */

        addi    sp, sp, -2032

        move    a0, sp
        move    a1, t6
        move    a2, t5
        call    init_parents

        move    a0, sp
        move    a1, s0
        move    a2, t5
        move    a3, t6
        call    edges

        move    a0, sp
        move    a1, s0
        move    a2, t5
        move    a3, t6
        call    adjacents

        move    a0, sp
        li      a1, 0
        call    root
        move    t3, a0

        move    a0, sp
        li      a1, 1
        call    root
        beq     t3, a0, .winner_o

        move    a0, sp
        li      a1, 2
        call    root
        move    t3, a0

        move    a0, sp
        li      a1, 3
        call    root
        beq     t3, a0, .winner_x

        li      a0, '.'

.winner_ret:
        addi    sp, sp, 2032

        lw      s0, 8(sp)
        lw      ra, 12(sp)
        addi    sp, sp, 16
        ret

.winner_o:
       li       a0, 'O'
       j        .winner_ret

.winner_x:
       li       a0, 'X'
       j        .winner_ret
