.section .rodata
sure: .string "Sure."
whoa: .string "Whoa, chill out!"
calm: .string "Calm down, I know what I'm doing!"
fine: .string "Fine. Be that way!"
whatever: .string "Whatever."

.text
.globl response

/* extern const char *response(const char *hey_bob); */
response:
        move    t1, zero                /* most recent non-whitespace character */
        move    t2, zero                /* count upper case */
        move    t3, zero                /* count lower case */
        li      t4, '?'
        li      t5, ' '
        li      t6, 26
        j       .read

.upper:
        addi    t2, t2, 1               /* increment upper case count */

.read:
        lb      t0, 0(a0)
        addi    a0, a0, 1
        beqz    t0, .select_response

        ble     t0, t5, .read

        move    t1, t0                  /* non-whitespace character */
        addi    t0, t0, -'A'
        bltu    t0, t6, .upper

        addi    t0, t0, -32
        bgeu    t0, t6, .read

        addi    t3, t3, 1               /* increment lower case count */
        j       .read

.select_response:
        beqz    t1, .silence

        bnez    t3, .not_yell           /* does the input contain lower case letters? */
        beqz    t2, .not_yell           /* does the input contain no upper case letters? */

        beq     t1, t4, .calm

        la      a0, whoa
        ret

.calm:
        la      a0, calm
        ret


.not_yell:
        beq     t1, t4, .sure

        la      a0, whatever
        ret

.sure:
        la      a0, sure
        ret

.silence:
        la      a0, fine
        ret
