.text
.globl color_code

/* extern int color_code(const char *color); */
color_code:
        lw      t0, 0(a0)

        li      a0, 0
        li      t1, 0x63616C62          /* blac */
        beq     t0, t1, .return

        li      a0, 1
        li      t1, 0x776F7262          /* brow */
        beq     t0, t1, .return

        li      a0, 2
        li      t1, 0x646572            /* red */
        beq     t0, t1, .return

        li      a0, 3
        li      t1, 0x6E61726F          /* oran */
        beq     t0, t1, .return

        li      a0, 4
        li      t1, 0x6C6C6579          /* yell */
        beq     t0, t1, .return

        li      a0, 5
        li      t1, 0x65657267          /* gree */
        beq     t0, t1, .return

        li      a0, 6
        li      t1, 0x65756C62          /* blue */
        beq     t0, t1, .return

        li      a0, 7
        li      t1, 0x6C6F6976          /* viol */
        beq     t0, t1, .return

        li      a0, 8
        li      t1, 0x79657267          /* grey */
        beq     t0, t1, .return

        li      a0, 9
        li      t1, 0x74696877          /* whit */
        beq     t0, t1, .return

        li      a0, -1

.return:
        ret
