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
        lw      a5, 0(t4)               /* grandparent = parents[parent].parent */
        move    a3, a4
        move    a4, a5

.root_test:
        bne     a4, a3, .root_loop

        move    a0, a3
        ret





.globl winner1

/* extern char winner1(const char *board); */
winner1:
        ret

