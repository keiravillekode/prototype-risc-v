.equ WRONG_PARITY, -1

.text
.globl transmit_sequence
.globl decode_message

/* extern int transmit_sequence(uint8_t *buffer, const uint8_t *message, int message_length); */
transmit_sequence:
        add     a2, a1, a2              /* end of input */
        move    a3, a0                  /* start of output */
        move    t0, zero                /* count of pending bits */
        move    t1, zero                /* pending data */
        li      a7, 7
        j       .transmit_start

.transmit_odd_parity:
        ori     t4, t4, 1

.transmit_even_parity:
        sb      t4, 0(a0)               /* write to buffer */
        addi    a0, a0, 1

        beq     t0, a7, .transmit_encode

.transmit_start:
        bne     a1, a2, .transmit_read

        beqz    t0, done

        sub     t0, a7, t0
        sll     t1, t1, t0              /* shift final bits */
        move    t0, a7
        j       .transmit_encode

.transmit_read:
        lbu     t2, 0(a1)               /* read unsigned message byte */
        addi    a1, a1, 1
        sll     t1, t1, 8
        or      t1, t1, t2
        addi    t0, t0, 8

.transmit_encode:
        sub     t0, t0, a7
        srl     t2, t1, t0              /* 7 most significant pending bits */
        andi    t2, t2, 127
        sll     t4, t2, 1

.transmit_parity:
        beqz    t2, .transmit_even_parity

        neg     t5, t2
        and     t5, t2, t5              /* least significant set bit */
        xor     t2, t2, t5
        beqz    t2, .transmit_odd_parity

        neg     t5, t2
        and     t5, t2, t5              /* least significant set bit */
        xor     t2, t2, t5
        j       .transmit_parity


done:
        sub a0, a0, a3
        ret


/* extern int decode_message(uint8_t *buffer, const uint8_t *message, int message_length); */
decode_message:
        add     a2, a1, a2              /* end of input */
        move    a3, a0                  /* start of output */
        move    t0, zero                /* count of pending bits */
        move    t1, zero                /* pending data */
        li      t6, 8
        j       .decode_start

.decode_write:
        addi    t0, t0, 7               /* update count of pending bits */
        srl     t4, t4, 1               /* discard parity bit */
        sll     t1, t1, 7
        or      t1, t1, t4              /* update pending data */
        blt     t0, t6, .decode_start

        sub     t0, t0, t6
        srl     t4, t1, t0
        sb      t4, 0(a0)
        addi    a0, a0, 1

.decode_start:
        beq     a1, a2, done

        lbu     t2, 0(a1)               /* read unsigned message byte */
        addi    a1, a1, 1
        move    t4, t2
        j       .decode_check_parity

.decode_parity:
        neg     t5, t2
        and     t5, t2, t5
        xor     t2, t2, t5              /* clear least significant set bit */

.decode_check_parity:
        beqz    t2, .decode_write

        neg     t5, t2
        and     t5, t2, t5
        xor     t2, t2, t5              /* clear least significant set bit */
        bnez    t2, .decode_parity

        li      a0, WRONG_PARITY
        ret
