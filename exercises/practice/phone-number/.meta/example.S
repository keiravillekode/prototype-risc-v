.text
.globl clean

/*
| Register | Usage        | Type      | Description                               |
| -------- | ------------ | --------- | ----------------------------------------- |
| `a0`     | input/output | address   | phone number as null-terminated string    |
| `a1`     | temporary    | address   | input pointer for current digit           |
| `a2`     | temporary    | address   | output pointer for current digit          |
| `t0`     | temporary    | character | the digit '0'                             |
| `t1`     | temporary    | character | the digit '1'                             |
| `t2`     | temporary    | character | the digit '9'                             |
| `t3`     | temporary    | integer   | 10                                        |
| `t4`     | temporary    | character | current digit                             |
| `t5`     | temporary    | boolean   | indicates if input contained country code |
*/

/* extern void clean(char *str); */
clean:
        move    a1, a0                  /* input pointer */
        move    a2, a0                  /* output pointer */
        li      t0, '0'
        li      t1, '1'
        li      t2, '9'
        move    t5, zero                /* country code has not been seen */

read:
        lb      t4, 0(a1)               /* read input digit */
        addi    a1, a1, 1               /* increment input pointer */
        beqz    t4, terminate
        blt     t4, t0, read            /* ignore characters below '0' */
        bgt     t4, t2, read            /* or above '9' */
        bnez    t5, write               /* write digit if country code has appeared */
        bne     a2, a0, write           /* write if other digits have already appeared */
        bne     t4, t1, write           /* write digit other than '1' */
        li      t5, 1                   /* record that we have seen the country code */
        j       read

write:
        sb      t4, 0(a2)               /* output digit */
        addi    a2, a2, 1               /* increment output pointer */
        j       read

terminate:
        sb      zero, 0(a2)             /* write null terminator */
        sub     a2, a2, a0              /* calculate number of digits */
        li      t3, 10
        bne     a2, t3, invalid         /* phone number must have 10 digits */
        lb      t4, 0(a0)               /* first digit of area code */
        ble     t4, t1, invalid         /* must not be '0' or '1' */
        lb      t4, 3(a0)               /* first digit of exchange code */
        ble     t4, t1, invalid         /* must not be '0' or '1' */
        ret

invalid:
        sb      zero, 0(a0)             /* write an empty string */
        ret
