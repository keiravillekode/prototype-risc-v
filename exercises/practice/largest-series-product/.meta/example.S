.equ INVALID_CHARACTER, -1
.equ NEGATIVE_SPAN, -2
.equ INSUFFICIENT_DIGITS, -3

.text
.globl largest_product

/*
| Register | Usage     | Type    | Description                   |
| -------- | --------- | ------- | ----------------------------- |
| `a0`     | output    | integer | largest series product        |
| `a0`     | input     | integer | span                          |
| `a1`     | input     | address | pointer to start of span      |
| `a2`     | temporary | address | pointer to end of span        |
| `a3`     | temporary | byte    | the digit '0'                 |
| `a4`     | temporary | byte    | the digit '9'                 |
| `t0`     | temporary | integer | length of input               |
| `t1`     | temporary | address | input pointer                 |
| `t2`     | temporary | number  | input digit                   |
| `t3`     | temporary | address | pointer to end of digits      |
| `t4`     | temporary | integer | product in span so far        |
*/

/* extern int32_t largest_product(int span, const char *digits); */
largest_product:
        bltz    a0, negative_span       /* check for negative span */

        li      a3, '0'
        li      a4, '9'
        move    t1, a1

input_scan:
        lb      t2, 0(t1)               /* load digit byte */
        addi    t1, t1, 1               /* increment input pointer */
        bgt     t2, a4, invalid_character

        bge     t2, a3, input_scan      /* only '0'..'9' are valid digits */

        bnez    t2, invalid_character

        addi    t3, t1, -1              /* point to end of digits */
        sub     t0, t3, a1              /* length of input */
        blt     t0, a0, insufficient_digits /* check for string length smaller than span */

        beqz    a0, empty_span          /* empty spans have product 1 */

        add     a2, a1, a0              /* pointer to end of span */
        move    a0, zero                /* largest product so far */

next_span:
        move    t1, a1                  /* pointer into span */
        li      t4, 1                   /* product of digits in span */

next_digit:
        lb      t2, 0(t1)               /* load digit */
        addi    t1, t1, 1               /* increment pointer */
        sub     t2, t2, a3              /* convert '0'..'9' to numeric value 0..9 */
        mul     t4, t4, t2
        bne     t1, a2, next_digit

        ble     t4, a0, check_if_last   /* jump ahead if product is not larger */

        move    a0, t4                  /* update largest product */

check_if_last:
        addi    a1, a1, 1               /* point to start of next span */
        addi    a2, a2, 1               /* point to end of next span */
        ble     a2, t3, next_span       /* repeat until we have reached of digits */

        ret

empty_span:
        li      a0, 1
        ret

invalid_character:
        li      a0, INVALID_CHARACTER
        ret

negative_span:
        li      a0, NEGATIVE_SPAN
        ret

insufficient_digits:
        li      a0, INSUFFICIENT_DIGITS
        ret
