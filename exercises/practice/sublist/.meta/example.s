.equ UNEQUAL, 0
.equ EQUAL, 1
.equ SUBLIST, 2
.equ SUPERLIST, 3

.text
.globl sublist

/*
| Register | Usage     | Type    | Description                                                |
| -------- | --------- | ------- | ---------------------------------------------------------- |
| `a0`     | output    | integer | `0` = equal, `1` = unequal, `2` = sublist, `3` = superlist |
| `a0`     | input     | address | array one elements                                         |
| `a1`     | input     | integer | size of array one, in words                                |
| `a2`     | input     | address | array two elements                                         |
| `a3`     | input     | integer | size of array two, in words                                |
| `t0`     | temporary | address | pointer to end of array one                                |
| `t1`     | temporary | address | pointer into array one                                     |
| `t2`     | temporary | address | pointer into array two                                     |
| `t3`     | temporary | word    | array one element                                          |
| `t4`     | temporary | word    | array two element                                          |
| `t5`     | temporary | integer | `2` = possible sublist, `3` = possible superlist           |
*/

/* extern relation_t sublist(const int32_t *list_one, size_t list_one_count, const int32_t *list_two, size_t list_two_count); */
sublist:
        bne     a1, a3, different_len

        beqz    a1, equal               /* empty lists are equal */

        sll     t0, a1, 2               /* size of each array, in bytes */
        add     t0, a0, t0              /* pointer to end of array one */

full_scan:
        lw      t3, 0(a0)               /* load array one word */
        addi    a0, a0, 4               /* increment array one pointer */
        lw      t4, 0(a2)               /* load array two word */
        addi    a2, a2, 4               /* increment array two pointer */
        bne     t3, t4, unequal
        bne     a0, t0, full_scan

equal:
        li      a0, EQUAL
        ret

different_len:
        li      t5, SUBLIST
        blt     a1, a3, prepare_nested_scan

        li      t5, SUPERLIST
        move    t0, a0                  /* swap a0 and a2 */
        move    a0, a2
        move    a2, t0
        move    t1, a1                  /* swap a1 and a3 */
        move    a1, a3
        move    a3, t1

prepare_nested_scan:
                                        /* check if list one is a sublist of list two */
        beqz    a1, prefix_match_found  /* an empty list is a sublist */

        sll     t0, a1, 2               /* size of array one, in bytes */
        add     t0, a0, t0              /* pointer to end of array one */
        j       prepare_prefix_scan

discard_list_two_head:
                                        /* drop the first element from list two, */
                                        /* and check again for a prefix match */
        addi    a2, a2, 4
        addi    a3, a3, -1
        blt     a3, a1, unequal

prepare_prefix_scan:
        move    t1, a0
        move    t2, a2

prefix_scan:
        lw      t3, 0(t1)               /* load array one word */
        addi    t1, t1, 4               /* increment array one pointer */
        lw      t4, 0(t2)               /* load array two word */
        addi    t2, t2, 4               /* increment array two pointer */
        bne     t3, t4, discard_list_two_head
        bne     t1, t0, prefix_scan

prefix_match_found:
        move a0, t5                     /* SUBLIST or SUPERLIST */
        ret

unequal:
        li      a0, UNEQUAL
        ret
