.equ BAD_BASE, -1
.equ BAD_DIGIT, -2

.text
.globl rebase

/*
| Register | Usage        | Type    | Description                               |
| -------- | ------------ | ------- | ----------------------------------------- |
| `a0`     | output       | integer | number of output digits                   |
| `a0`     | input        | integer | in base                                   |
| `a1`     | input        | address | in digits                                 |
| `a2`     | input        | integer | number of input digits                    |
| `a3`     | input        | integer | out base                                  |
| `a4`     | input/output | address | out digits                                |
| `t0`     | temporary    | integer | number represented by digits              |
| `t1`     | temporary    | address | pointer to current digit                  |
| `t2`     | temporary    | address | end of input digits                       |
| `t3`     | temporary    | integer | individual digit                          |
| `t4`     | temporary    | integer | individual digit (during final reverse)   |
*/

/* extern int rebase(int32_t in_base, const int32_t *in_digits, int in_digit_count, int32_t out_base, int32_t *out_digits); */
rebase:
        li      t5, 1
        ble     a0, t5, bad_base        /* input base must be at least 2 */
        ble     a3, t5, bad_base        /* output base must be at least 2 */

        move    t0, zero                /* number before any digits seen */
        move    t1, a1                  /* pointer to input digit */
        sll     t2, a2, 2               /* num bytes occupied by input digits */
        add     t2, a1, t2              /* end of input digits */
        beq     t1, t2, end_input       /* if there are no input digits, jump ahead */

read_input:
        lw      t3, 0(t1)               /* read current digit */
        bltz     t3, bad_digit          /* each digit must be non-negative */
        bge     t3, a0, bad_digit       /* and must be smaller than the input base */
        mul     t0, t0, a0              /* number *= input base */
        add     t0, t0, t3              /* number += digit */
        addi    t1, t1, 4               /* advance input pointer */
        bne     t1, t2, read_input      /* repeat while there are more digits */

end_input:
        move    t1, a4                  /* prepare to overwrite digits */

                                        /* We initially generate the digits in reverse order. */
generate:
        rem      t3, t0, a3             /* remainder becomes an output digit */
        div      t0, t0, a3             /* overwrite number with quotient */
        sw      t3, 0(t1)               /* store digit */
        addi    t1, t1, 4               /* advance output pointer */
        bnez     t0, generate           /* repeat while there are more digits */

        sub     a0, t1, a4              /* num bytes occupied by output digits */
        srl     a0, a0, 2               /* number of output digits */

reverse:
        addi    t1, t1, -4              /* last digit not yet reversed */
        beq     a4, t1, return          /* when pointers meet, we are done */

        lw      t3, 0(a4)               /* swap the digits */
        lw      t4, 0(t1)
        sw      t3, 0(t1)
        sw      t4, 0(a4)

        addi    a4, a4, 4               /* first digit not yet reversed */
        bne     a4, t1, reverse         /* when pointers meet, we are done */

return:
        ret

bad_base:
        li      a0, BAD_BASE
        ret

bad_digit:
        li      a0, BAD_DIGIT
        ret
