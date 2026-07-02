.text
.globl roman

/*
| Register | Usage        | Type    | Description                               |
| -------- | ------------ | ------- | ----------------------------------------- |
| `a0`     | output       | address | destination buffer                        |
| `a1`     | input        | integer | number                                    |
| `a2`     | input        | char    | roman letter for ten                      |
| `a3`     | input        | char    | roman letter for five                     |
| `a4`     | input        | char    | roman letter for one                      |
| `t0`     | temporary    | address | dividend                                  |
| `t1`     | temporary    | integer | divisor                                   |
| `t3`     | temporary    | integer | 9                                         |
| `t4`     | temporary    | integer | 4                                         |
| `t5`     | temporary    | integer | 5                                         |
| `t6`     | temporary    | address | return address                            |
*/

/* char* digit(char *buffer, unsigned number, char ten, char five, char one); */
digit:
        beq     a1, t3, .nine

        beq     a1, t4, .four

        blt     a1, t5, .check

        sb      a3, 0(a0)               /* five */
        addi    a0, a0, 1
        addi    a1, a1, -5
        j       .check

.unit:
        sb      a4, 0(a0)               /* one */
        addi    a0, a0, 1
        addi    a1, a1, -1

.check:
        bnez    a1, .unit

        ret

.nine:
        move    a3, a2                  /* ten */

.four:
        sb      a4, 0(a0)               /* one */
        sb      a3, 1(a0)               /* five (or ten) */
        addi    a0, a0, 2
        ret

/* extern void roman(char *buffer, unsigned number); */
roman:
        li      t3, 9
        li      t4, 4
        li      t5, 5
        move    t6, ra

        move    t0, a1
        li      t1, 1000
        div     a1, t0, t1              /* thousands */
        rem     t0, t0, t1
        li      a4, 'M'
        call    digit

        li      t1, 100
        div     a1, t0, t1              /* hundreds */
        rem     t0, t0, t1
        li      a2, 'M'
        li      a3, 'D'
        li      a4, 'C'
        call    digit

        li      t1, 10
        div     a1, t0, t1              /* tens */
        rem     t0, t0, t1
        li      a2, 'C'
        li      a3, 'L'
        li      a4, 'X'
        call    digit

        move    a1, t0                  /* ones */
        li      a2, 'X'
        li      a3, 'V'
        li      a4, 'I'
        call    digit

        sb      zero, 0(a0)
        jalr    zero, 0(t6)             /* return */
