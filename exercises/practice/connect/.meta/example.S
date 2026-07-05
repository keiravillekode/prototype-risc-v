.text


.globl find_dimensions

/* extern void find_dimensions(const char *board, unsigned *columns, unsigned *rows); */
find_dimensions:
        move    t5, zero                /* number of columns */
        li      t6, '\n'

.inc_columns:
        addi    t5, t5, 1
        slli    t0, t5, 1
        addi    t0, t0, -1
        add     t2, a0, t0
        lb      t2, 0(t2)
        bne     t2, t6, .inc_columns

        sw      t5, 0(a1)               /* store columns */
        li      t6, 1                   /* number of rows */
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

.store_rows:
        sw      t6, 0(a2)               /* store rows */
        ret


/* Unimplemented idea: we could store indices shifted left by 2, i.e. store byte offsets */

.globl init_parents

/* extern void init_parents(element_t* parents, unsigned rows, unsigned columns); */
init_parents:
        mul     t0, a1, a2
        addi    t0, t0, 4
        move    t1, zero

.init_parent:
        slli    t2, t1, 2
        add     t2, a0, t2
        sw      t1, 0(t2)
        addi    t1, t1, 1
        bne     t1, t0, .init_parent

        ret


.globl root

/* extern unsigned root(element_t* parents, unsigned node); */
root:
        j       .fixed_point_check

.reparent:
        slli    t0, a1, 2
        add     t0, a0, t0
        sh      t1, 0(t0)
        move    a1, t1

.fixed_point_check:
        slli    t0, a1, 2
        add     t0, a0, t0
        lh      t1, 0(t0)
        slli    t0, t1, 2
        add     t0, a0, t0
        lh      t1, 0(t0)
        bne     a1, t1, .reparent

        move    a0, a1
        ret


.globl merge

/* extern void merge(element_t* parents, unsigned first, unsigned second); */
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

        slli    t0, a3, 2
        add     t0, t4, t0
        slli    t1, a0, 2
        add     t1, t4, t1
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

/* extern unsigned index(unsigned columns, unsigned row, unsigned column); */
index:
        mul     a0, a0, a1
        add     a0, a0, a2
        addi    a0, a0, 4
        ret


.globl occupant

/* externs char occupant(const char *board, unsigned columns, unsigned row, unsigned column); */
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


.globl edge1

/* extern void edge(element_t* parents, const char *board, unsigned columns, unsigned row, unsigned column, unsigned idx, char player); */
edge1:


/*
#ifdef EDGE
void edge(element_t* parents, const char *board, unsigned columns, unsigned row, unsigned column, unsigned idx, char player) {
    if (occupant(board, columns, row, column) == player) {
        merge(parents, idx, index(columns, row, column));
    }
}
#endif
*/

.globl winner0

/* extern char winner(const char *board); */
winner0:
        ret
