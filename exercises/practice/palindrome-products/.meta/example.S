.equ EMPTY_RESULT, 0
.equ INVALID_INPUT, -1

.text
.globl is_palindrome
.globl largest
.globl smallest


/* extern int32_t is_palindrome(void *, void *, void *, int n); */
is_palindrome:
        li      t0, 10
        remu    t1, a3, t0
        divu    t2, a3, t0
        beqz    t1, .trailing_zero

        beqz    t2, .accept_palindrome

.next:
        beq     t1, t2, .accept_palindrome

        remu    a0, t2, t0
        divu    t2, t2, t0
        beq     t1, t2, .accept_palindrome

        mul     t1, t0, t1
        add     t1, t1, a0
        ble     t1, t2, .next

        move    a0, zero
        ret

.accept_palindrome:
        li      a0, 1
        ret

.trailing_zero:
        seqz    a0, a3
        ret


record_product:
        beq     a4, a3, .record_pair

        move    a4, a3
        sw      zero, 0(a5)

.record_pair:
        lw      t0, 0(a5)
        slli    t1, t0, 3
        add     t1, a5, t1
        sw      a1, 4(t1)
        sw      a2, 8(t1)
        addi    t0, t0, 1
        sw      t0, 0(a5)
        ret


/* extern int32_t largest(factor_t *factors, uint32_t min, uint32_t max); */
largest:
        move    t6, ra                  /* return address */
        move    a5, a0                  /* factors */
        move    a4, zero                /* best product so far */
        move    a6, a1
        bgt     a1, a2, .invalid_input

.largest_start_inner:
        move    a1, a2

.largest_consider_inner:
        mul     a3, a1, a2
        bltu    a3, a4, .largest_next_outer

        call    is_palindrome
        bnez    a0, .largest_palindrome

.largest_next_inner:
        addi    a1, a1, -1
        bgeu    a1, a6, .largest_consider_inner

.largest_next_outer:
        addi    a2, a2, -1
        bgeu    a2, a6, .largest_start_inner

        move    t0, zero
        beq     a4, t0, .empty_result

        move    a0, a4
        jr      t6

.largest_palindrome:
        call    record_product
        j       .largest_next_outer


.empty_result:
        li      a0, EMPTY_RESULT
        jr      t6

.invalid_input:
        li      a0, INVALID_INPUT
        jr      t6


/* extern int32_t smallest(factor_t *factors, uint32_t min, uint32_t max); */
smallest:
        move    t6, ra                  /* return address */
        move    a5, a0                  /* factors */
        li      a4, -1                  /* best product so far */
        move    a6, a2
        bgt     a1, a2, .invalid_input

.smallest_start_inner:
        move    a2, a1

.smallest_consider_inner:
        mul     a3, a1, a2
        bgtu    a3, a4, .smallest_next_outer

        call    is_palindrome
        bnez    a0, .smallest_palindrome

.smallest_next_inner:
        addi    a2, a2, 1
        bleu    a2, a6, .smallest_consider_inner

.smallest_next_outer:
        addi    a1, a1, 1
        bleu    a1, a6, .smallest_start_inner

        li      t0, -1
        beq     a4, t0, .empty_result

        move    a0, a4
        jr      t6

.smallest_palindrome:
        call    record_product
        j       .smallest_next_outer
