.text

.equ TOP 0
.equ LEFT 1
.equ BOTTOM 2
.equ RIGHT 3

/*
typedef struct {
        uint32_t parent;
        uint32_t rank;
} entry_t;
*/

.globl root

/* uint32_t root(void *unused1, void *unused2, entry_t *parents, uint32_t index); */
root:
        slli    t3, a3, 3
        add     t3, a2, t3              /* address of parents[index] */
        lw      a4, 0(t3)               /* parent = parents[index].parent */
        j       .root_test

.root_loop:
        slli    t4, a4, 3
        add     t4, a2, t4              /* address of parents[parent] */
        move    a3, a4                  /* index = parent */
        lw      a4, 0(t4)               /* parent = parents[parent].parent, i.e. grandparent */

.root_test:
        bne     a4, a3, .root_loop

        move    a0, a3
        ret


.globl merge

/* void merge(void *unused1, void *unused2, entry_t *parents, uint32_t index1, uint32_t index2) */
merge:
        move    t0, ra
        move    t1, a4                  /* index2 */
        call    root
        move    a1, a0                  /* root1 */
        move    a3, t1                  /* index2 */
        call    root                    /* writes root2 in a0 */
        beq     a0, a1, .merge_return

        slli    t3, a1, 3
        add     t3, a2, t3              /* address of parents[root1] */
        lw      a3, 4(t3)               /* rank of root1 */

        slli    t4, a0, 3
        add     t4, a2, t4              /* address of parents[root2] */
        lw      a4, 4(t4)               /* rank of root2 */

        bge     a3, a4, .merge_reparent

        xor     a0, a0, a1
        xor     a1, a1, a0
        xor     a0, a0, a1

        xor     t3, t3, t4
        xor     t4, t4, t3
        xor     t3, t3, t4

        xor     a3, a3, a4
        xor     a4, a4, a3
        xor     a3, a3, a4

.merge_reparent:
        sw      a1, 0(t4)               /* update parent of root2 to root1 */
        bne     a3, a4, .merge_return

        addi    a3, a3, 1
        sw      a3, 4(t3)               /* increment rank of root1 */

.merge_return:
        jalr    zero, 0(t0)             /* return */



.globl occupant

/* char occupant(const char *board, uint32_t row_length, void *unused, uint32_t row, uint32_t column) */
occupant:
        slli    a4, a4, 1               /* column * 2 */
        mul     a3, a3, a1              /* row * row_length */
        add     a3, a3, a4              /* index into board */
        add     a4, a0, a3
        lb      a0, 0(a4)
        ret

.globl adjacent1

/* void adjacent1(const char *board, uint32_t row_length, entry_t *parents, uint32_t index1, char occupant1, uint32_t row2, uint32_t column2) */
adjacent1:
        mul     t0, a5, a1
        add     t0, t0, a6
        add     t0, t0, 4               /* row2 * row_length + column2 + 4 */

        add     sp, sp, -32
        sd      ra, 0(sp)
        sd      a3, 8(sp)               /* index1 */
        sd      a4, 16(sp)              /* occupant1 */
        sd      t0, 24(sp)              /* computed index */

        move    a3, a5                  /* row2 */
        move    a4, a6                  /* column2 */
        call    occupant

        ld      ra, 0(sp)
        ld      a3, 8(sp)               /* index1 */
        ld      t1, 16(sp)              /* occupant1 */
        ld      a4, 24(sp)              /* computed index */
        add     sp, sp, 32

        bne     a0, t1, .adjacent1_return

        j       merge                   /* tail call */

.adjacent1_return:
        ret


.globl adjacent

/* void adjacent(const char *board, uint32_t row_length, entry_t *parents, uint32_t row1, uint32_t column1, uint32_t row2, uint32_t column2) */
adjacent:
        mul     t0, a5, a1
        add     t0, t0, a6
        add     t0, t0, 4               /* row2 * row_length + column2 + 4 */

        mul     t1, a3, a1
        add     t1, t1, a4
        add     t1, t1, 4               /* row1 * row_length + column1 + 4 */

        add     sp, sp, -32
        sd      ra, 0(sp)
        sd      a0, 8(sp)               /* board */

        call    occupant
        move    t2, a0                  /* occupant1 */

        ld      a0, 8(sp)               /* board */

        move    a3, a5                  /* row2 */
        move    a4, a6                  /* column2 */
        call    occupant

        ld      ra, 0(sp)
        add     sp, sp, 32

        bne     a0, t2, .adjacent_return

        move    a3, t1
        move    a4, t0
        j       merge                   /* tail call */

.adjacent_return:
        ret





.globl winner

/* extern char winner(const char *board); */
winner:
        add     sp, sp -80
        sd      s0, 0(sp)
        sd      s1, 8(sp)
        sd      s2, 16(sp)
        sd      s3, 24(sp)
        sd      s4, 32(sp)
        sd      s5, 40(sp)
        sd      s6, 48(sp)
        sd      s7, 56(sp)
        sd      s8, 64(sp)
        sd      ra, 72(sp)
        move    s8, sp

        move    s0, a0                  /* board */

        move    t0, '\n'
        lb      t1, 0(s0)               /* board[0] */
        move    s1, s0
        move    s2, 0
        move    a0, '.'
        ble     t1, t0, .winner_return

.find_row_length:
        lb      t1, 0(s1)               /* board[0] */
        add     s1, s1, 1
        bne     t1, t0, .find_row_length

        sub     s1, s1, s0              /* row_length */

.find_rows:
        add     s2, s2, 1               /* rows */
        mul     s3, s2, s1              /* rows * row_length */
        add     s3, s0, s3
        lb      s3, 0(s3)               /* board[rows * row_length] */
        bnez    s3, .find_rows

        add     s1, s1, 1               /* row_length */
        sub     s3, s1, s2
        srli    s3, s3, 1               /* columns = (row_length - rows) / 2 */

        mul     t0, s2, s1
        add     t0, t0, 4               /* number of elements in parents table */
        slli    t1, t0, 4
        sub     sp, sp, t1
        mov     s7, sp                  /* parents table */
        mov     t2, 0

.init_parents:
        add     t0, t0, -1
        slli    t1, t0, 3
        add     t1, s7, t1
        sw      t0, 0(t1)
        sw      t2, 4(t1)
        cbnz    t0, .init_parents

        move    t2, 100
        sw      t2, 4(s7)               /* parents TOP rank */
        sw      t2, 12(s7)              /* parents LEFT rank */

        move    s6, s3

.top_bottom:
        add     s6, s6, -1
        move    a0, s0
        move    a1, s1
        move    a2, s7
        move    a3, TOP
        move    a4, 'O'
        move    a5, 0
        move    a6, s6
        call    adjacent1

        move    a0, s0
        move    a1, s1
        move    a2, s7
        move    a3, BOTTOM
        move    a4, 'O'
        add     a5, s2, -1              /* rows - 1 */
        move    a6, s6
        call    adjacent1
        cbnz    s6, .top_bottom

        move    s5, s2

.left_right:
        add     s5, s5, -1
        move    a0, s0
        move    a1, s1
        move    a2, s7
        move    a3, LEFT
        move    a4, 'X'
        move    a5, s5
        move    a6, 0
        call    adjacent1

        move    a0, s0
        move    a1, s1
        move    a2, s7
        move    a3, RIGHT
        move    a4, 'X'
        move    a5, s5
        add     a6, s3, -1              /* columns - 1 */
        call    adjacent1




        for (uint32_t j = 0; j < columns - 1; ++j) {
            adjacent(board, row_length, parents, i, j, i, j + 1); /* horizontal - */
        }




        cbnz    s5, .left_right





.winner_return:
        move    sp, s8
        ld      s0, 0(sp)
        ld      s1, 8(sp)
        ld      s2, 16(sp)
        ld      s3, 24(sp)
        ld      s4, 32(sp)
        ld      s5, 40(sp)
        ld      s6, 48(sp)
        ld      s7, 56(sp)
        ld      s8, 64(sp)
        ld      ra, 72(sp)
        add     sp, sp 80
        ret



















    entry_t parents[800];
    for (uint32_t i = 0; i < ARRAY_SIZE(parents); ++i) {
        parents[i].parent = i;
        parents[i].rank = 0;
    }


