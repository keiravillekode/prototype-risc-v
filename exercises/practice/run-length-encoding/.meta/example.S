.text
.globl encode
.globl decode

/* extern void encode(char *buffer, const char *string); */
encode:
        li      t5, 1
        li      t6, 10
        j       .encode_read_run

.encode_write_char:
        sb      t0, 0(a0)
        addi    a0, a0, 1

.encode_read_run:
        move    a2, a1                  /* input pointer at start of run */
        lb      t0, 0(a1)
        addi    a1, a1, 1
        beqz    t0, end_string

.encode_read_char:
        lb      t1, 0(a1)
        addi    a1, a1, 1
        beq     t1, t0, .encode_read_char

        addi    a1, a1, -1              /* input pointer at end of run */
        sub     a2, a1, a2              /* length of run */
        beq     a2, t5, .encode_write_char /* omit digits if length 1 */

        move    a3, a0                  /* address of first digit */

.encode_write_digit:
        rem     t2, a2, t6
        div     a2, a2, t6              /* divide by 10 */
        addi    t2, t2, '0'             /* digit */
        sb      t2, 0(a0)
        addi    a0, a0, 1
        bnez    a2, .encode_write_digit

        move    a4, a0                  /* address at end of digits */

.encode_reverse:
        addi    a4, a4, -1
        beq     a4, a3, .encode_write_char /* reached middle digit */

        lb      t3, 0(a3)               /* swap digits */
        lb      t4, 0(a4)
        sb      t3, 0(a4)
        sb      t4, 0(a3)
        addi    a3, a3, 1
        beq     a3, a4, .encode_write_char /* reached middle digits */

        j       .encode_reverse


/* extern void decode(char *buffer, const char *string); */
decode:
        li      t6, 10
        j       .decode_read_run       

.decode_write_run:
        seqz    t1, t2
        add     t2, t2, t1              /* if run length was 0, change to 1 */
        add     t3, a0, t2

.decode_write_char:
        sb      t0, 0(a0)
        addi    a0, a0, 1
        bne     a0, t3, .decode_write_char

.decode_read_run:
        move    t2, zero                /* run length */

.decode_read_char:
        lb      t0, 0(a1)
        addi    a1, a1, 1
        beqz    t0, end_string

        addi    t1, t0, -'0'
        bgeu    t1, t6, .decode_write_run

        mul     t2, t2, t6              /* multiply run length by 10 */
        add     t2, t2, t1              /* add digit */
        j       .decode_read_char


end_string:
        sb      zero, 0(a0)
        ret
