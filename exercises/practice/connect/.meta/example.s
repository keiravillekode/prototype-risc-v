.text

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
        add     a3, a0, a3
        add     a3, a3, a4
        lb      a0, 0(a3)
        ret


.globl winner1

/* extern char winner1(const char *board); */
winner1:
        ret

