.text
.globl encode
.globl decode

/* extern size_t encode(uint8_t *buffer, const uint32_t *integers, size_t integer_count); */
encode:
        sll     a2, a2, 2               /* size of integers array, in bytes */
        add     a2, a1, a2              /* end of integers */
        move    a3, a0                  /* start of output */
        li      t6, 128
        beq     a1, a2, .encode_end

.encode_read:
        lw      t0, 0(a1)
        addi    a1, a1, 4
        bltu    t0, t6, .one

        srl     t1, t0, 7
        bltu    t1, t6, .two

        srl     t2, t1, 7
        bltu    t2, t6, .three

        srl     t3, t2, 7
        bltu    t3, t6, .four

        srl     t4, t3, 7
        andi    t4, t4, 15              /* at most 4 bits remain of the original 32 */
        or      t4, t4, t6
        sb      t4, 0(a0)
        addi    a0, a0, 1

.four:
        or      t3, t3, t6
        sb      t3, 0(a0)
        addi    a0, a0, 1

.three:
        or      t2, t2, t6
        sb      t2, 0(a0)
        addi    a0, a0, 1

.two:
        or      t1, t1, t6
        sb      t1, 0(a0)
        addi    a0, a0, 1

.one:
        andi    t0, t0, 127
        sb      t0, 0(a0)
        addi    a0, a0, 1
        bne     a1, a2, .encode_read

.encode_end:
        sub     a0, a0, a3
        ret



/* extern size_t decode(uint32_t *buffer, const uint8_t *integers, size_t integer_count); */
decode:
        add     a2, a1, a2              /* end of integers array */
        move    a3, a0                  /* start of output */
        move    t4, zero
        beq     a1, a2, .decode_end

.decode_read:
        lb      t5, 0(a1)
        addi    a1, a1, 1
        sll     t4, t4, 7
        andi    t6, t5, 127             /* low 7 bits only */
        or      t4, t4, t6
        andi    t5, t5, 128
        bnez    t5, .decode_read        /* if high bit it set, read remaining bytes */

        sw      t4, 0(a0)
        addi    a0, a0, 4
        move    t4, zero
        bne     a1, a2, .decode_read

.decode_end:
        sub     a0, a0, a3              /* length of output, in bytes */
        srl     a0, a0, 2               /* number of uint32_t values output */
        ret
