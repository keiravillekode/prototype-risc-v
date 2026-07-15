.equ WHAT_IS, 4
.equ PLUS, 4
.equ MINUS, 8
.equ MULTIPLIED_BY, 12
.equ DIVIDED_BY, 16
.equ QUESTION_MARK, 20

.rodata
what_is:        .string "What is "
plus:           .string " plus "
minus:          .string " minus "
multiplied_by:  .string " multiplied by "
divided_by:     .string " divided by "
question_mark:  .string "?"

.data
word_array:
                .word what_is
                .word 0
                .word plus
                .word minus
                .word multiplied_by
                .word divided_by
                .word question_mark
                .word 0

.text
.globl answer

/*
    Attempts to read a known word from input string a1
    Writes to a2 the id of the matched word
    Jumps to `reject` if the input is invalid
    a5 is an array of pointers to words
*/
read_word:
        move    t4, a1                  /* input pointer */
        move    a2, a5                  /* array of pointers to words */
        j       .next

.compare:
        lb      t2, 0(t1)               /* load word character */
        addi    t1, t1, 1
        beqz    t2, .match

        lb      t3, 0(a1)               /* load input character */
        addi    a1, a1, 1
        beq     t3, t2, .compare

.next:
        move    a1, t4
        lw      t1, 0(a2)               /* load pointer to word */
        addi    a2, a2, 4
        bnez    t1, .compare

        j       reject

.match:
        sub     a2, a2, a5
        ret


/*
    Attempts to read a number from input string a1
    Writes the number to a3
    Jumps to `reject` if the input is invalid
    a6 is 10
*/
read_number:
        li      t1, 10
        lb      t2, 0(a1)
        li      t4, '-'
        sub     t4, t2, t4
        seqz    t4, t4                  /* 0 for positive, 1 for negative */
        add     a1, a1, t4              /* increment input pointer past leading '-' */

        move    a3, zero                /* value of digits so far */
        lb      t2, 0(a1)
        addi    t2, t2, -48
        bgeu    t2, t1, reject

.accept_digit:
        addi    a1, a1, 1
        mul     a3, t1, a3
        add     a3, a3, t2
        lb      t2, 0(a1)
        add     t2, t2, -48
        bltu    t2, t1, .accept_digit

        beqz    t4, .return_number
        neg     a3, a3

.return_number:
        ret


/* extern bool answer(int32_t *result, const char *question); */
answer:
        move    t0, ra                  /* preserve return address */

        la      a5, word_array
        call    read_word               /* Read "What is " */
        addi    a5, a5, 8               /* from now on, the words are operations */
        call    read_number
        move    t5, a3                  /* computation result */

.read_operation:
        call    read_word
        li      t4, QUESTION_MARK
        beq     a2, t4, .success

        call    read_number
        li      t4, MINUS
        beq     a2, t4, .subtract

        li      t4, MULTIPLIED_BY
        beq     a2, t4, .multiply

        li      t4, DIVIDED_BY
        beq     a2, t4, .divide

.add:
        add     t5, t5, a3
        j       .read_operation

.subtract:
        sub     t5, t5, a3
        j       .read_operation

.multiply:
        mul     t5, t5, a3
        j       .read_operation

.divide:
        div     t5, t5, a3
        j       .read_operation

.success:
        sw      t5, 0(a0)
        li      a0, 1
        jr      t0

reject:
        move    a0, zero
        jr      t0
