.text
.globl slices

/*
| Register | Usage        | Type    | Description                    |
| -------- | ------------ | ------- | ------------------------------ |
| `a0`     | input/output | address | null-terminated output string  |
| `a1`     | input        | address | null-terminated series string  |
| `a2`     | input        | integer | slice length                   |
| `a6`     | temporary    | byte    | ',' comma separator            |
| `a7`     | temporary    | byte    | ' ' space separator            |
| `t0`     | temporary    | address | end of series string           |
| `t1`     | temporary    | byte    | character in series string     |
| `t2`     | temporary    | integer | length of series string        |
| `t3`     | temporary    | address | pointer into series string     |
| `t4`     | temporary    | address | end of current slice           |
*/

/* extern void slices(char *buffer, const char *series, int slice_length); */
slices:
        move    t0, a1
        li      a6, ','
        li      a7, ' '

scan_input:
        lb      t1, 0(t0)
        addi    t0, t0, 1
        bnez    t1, scan_input          /* repeat until we reach null terminator */

        addi    t0, t0, -1              /* address of null terminator */
        sub     t2, t0, a1              /* length of series string */
        beqz    t2, return

        blez    a2, return

        bgtu    a2, t2, return

        j       copy_slice

separate:
        sb      a6, 0(a0)               /* output comma */
        sb      a7, 1(a0)               /* output space */
        addi    a0, a0, 2

        addi    a1, a1, 1

                                        /* copy a2 characters from a1 to a0 */
copy_slice:
        move    t3, a1
        add     t4, a1, a2              /* end of current slice */

copy_char:
        lb      t1, 0(t3)
        sb      t1, 0(a0)
        addi    t3, t3, 1
        addi    a0, a0, 1
        bne     t3, t4, copy_char

        bne     t3, t0, separate

return:
        sb      zero, 0(a0)
        ret
