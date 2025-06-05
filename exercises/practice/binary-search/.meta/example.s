.text
.globl find

/*
| Register | Usage        | Type    | Description                      |
| -------- | ------------ | ------- | -------------------------------- |
| `a0`     | input        | integer | target value being searched for  |
| `a1`     | input        | address | array elements                   |
| `a2`     | input        | integer | size of array, in words          |
| `t0`     | temporary    | integer | index of range begin (inclusive) |
| `t1`     | temporary    | integer | index of range end (exclusive)   |
| `t2`     | temporary    | integer | middle index                     |
| `t3`     | temporary    | integer | element at middle index          |
*/

/* extern ptrdiff_t find(int32_t value, const int32_t *array, size_t count); */
find:
        move    t0, zero                /* low index */
        move    t1, a2                  /* high index */

loop:
        beq     t0, t1, absent          /* check if range is empty */
        add     t2, t0, t1              /* low + high */
        srl     t2, t2, 1               /* halve, to obtain middle index */
        sll     t3, t2, 2               /* convert index to byte offset */
        add     t3, a1, t3              /* calculate array element address */
        lw      t3, 0(t3)               /* load array element */

        bgt     a0, t3, increase_low    /* jump if target value is above array element */
        blt     a0, t3, decrease_high   /* jump if target value is below array element */
        move    a0, t2                  /* report index where value was found */
        ret

absent:
        li      a0, -1                  /* report search was unsuccessful */
        ret

increase_low:
        addi    t0, t2, 1               /* set range begin (inclusive) to after middle */
        j       loop

decrease_high:
        move    t1, t2                  /* set range end (exclusive) to middle */
        j       loop
