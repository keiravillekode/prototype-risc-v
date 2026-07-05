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

.globl winner0

/* extern char winner(const char *board); */
winner0:
        ret
