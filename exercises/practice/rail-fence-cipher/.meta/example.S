.text
.globl encode
.globl decode

/* extern void encode(char *buffer, const char *msg, int rails); */
encode:
        move    a3, zero
        j       process

/* extern void decode(char *buffer, const char *msg, int rails); */
decode:
        li      a3, 1

process:
        addi    a2, a2, -1
        slli    a2, a2, 2               /* byte offset of the last rail */
        li      a4, 1                   /* phase: 1 = computing offsets, 2 = writing to buffer */
        add     a5, a2, 20
        andi    a5, a5, -16             /* table size in bytes */
        move    a6, sp
        sub     sp, sp, a5

clear:
        addi    a6, a6, -4
        sw      zero, 0(a6)
        bne     a6, sp, clear

traverse:
        move    t0, a0                  /* output */
        move    t1, a1                  /* input */
        move    t2, zero                /* rail, as byte offset in table */
        li      t3, 4                   /* step, in bytes */

read:
        add     t4, sp, t2
        lw      t5, 0(t4)
        lb      t6, 0(t1)
        addi    t1, t1, 1
        beqz    t6, end

        bnez    a4, skip_write

        bnez    a3, decode_char

        add     a7, a0, t5              /* buffer + rail offset */
        sb      t6, 0(a7)
        j       skip_write

decode_char:
        add     a7, a1, t5              /* msg + rail offset */
        lb      t6, 0(a7)
        sb      t6, 0(t0)

skip_write:
        addi    t0, t0, 1
        addi    t5, t5, 1
        sw      t5, 0(t4)
        add     t2, t2, t3
        beq     t2, a2, reverse

        bnez    t2, read

reverse:
        sub     t3, zero, t3
        j       read

end:
        beqz    a4, return

        move    t2, zero
        move    t3, zero

cumulative:
        add     t4, sp, t2
        lw      t5, 0(t4)
        sw      t3, 0(t4)
        add     t3, t3, t5
        addi    t2, t2, 4
        ble     t2, a2, cumulative

        move    a4, zero
        j       traverse

return:
        sb      zero, 0(t0)
        add     sp, sp, a5
        ret
