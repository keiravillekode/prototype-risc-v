.data

ohms:   .string " ohms"
kiloohms:
        .string " kiloohms"
megaohms:
        .string " megaohms"
gigaohms:
        .string " gigaohms"


.text
.globl label

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
        jalr    zero, 0(t6)             /* return */

/* extern void label(char *buffer, const char *first, const char *second, const char *third, const char *fourth); */
label:
        move    t4, a0                  /* buffer */
        li      t3, '0'

        move    a0, a1                  /* first */
        jal     t6, color_code          /* subroutine call */
        add     a1, a0, t3

        move    a0, a2                  /* second */
        jal     t6, color_code          /* subroutine call */
        add     a2, a0, t3

        move    a0, a3                  /* third */
        jal     t6, color_code          /* subroutine call */
        addi    a0, a0, 1
        li      t0, 3
        div     t1, a0, t0
        rem     t2, a0, t0
        beqz    t2, .divide

        beq     a1, t3, .skip_first

        sb      a1, 0(t4)               /* write first digit */
        addi    t4, t4, 1

.skip_first:
        sb      a2, 0(t4)               /* write second digit */
        addi    t4, t4, 1
        li      a2, 1
        beq     t2, a2, .append_units

        sb      t3, 0(t4)
        addi    t4, t4, 1               /* write zero */
        j       .append_units

.divide:
        sb      a1, 0(t4)               /* write first digit */
        addi    t4, t4, 1
        beq     a2, t3, .append_units

        li      a1, '.'
        sb      a1, 0(t4)               /* write '.' */
        addi    t4, t4, 1

        sb      a2, 0(t4)               /* write second digit */
        addi    t4, t4, 1

.append_units:

        la      a1, gigaohms
        li      a2, 3
        beq     t1, a2, .copy

        la      a1, megaohms
        li      a2, 2
        beq     t1, a2, .copy

        la      a1, kiloohms
        li      a2, 1
        beq     t1, a2, .copy

        la      a1, ohms

.copy:
        lb      t0, 0(a1)
        addi    a1, a1, 1
        sb      t0, 0(t4)
        addi    t4, t4, 1
        bnez    t0, .copy

        ret
