.section .rodata

lyrics:
        .string "This is the horse and the hound and the horn that belonged to the farmer sowing his corn that kept the rooster that crowed in the morn that woke the priest all shaven and shorn that married the man all tattered and torn that kissed the maiden all forlorn that milked the cow with the crumpled horn that tossed the dog that worried the cat that killed the rat that ate the malt that lay in the house that Jack built.\n"

table:
        .hword -1, 388, 367, 350, 330, 309, 266, 231, 189, 144, 98, 61, 7

.text
.globl recite

/*
| Register | Usage        | Type    | Description                  |
| -------- | ------------ | ------- | ---------------------------- |
| `a0`    | input/output | address | null-terminated output string |
| `a1`    | input        | integer | start verse                   |
| `a2`    | input        | integer | end verse                     |
| `t0`    | temporary    | byte    | character being copied        |
| `t3`    | temporary    | address | pointer into lyrics           |
| `t4`    | temporary    | address | table                         |
| `t5`    | temporary    | address | lyrics                        |
*/

/* extern void recite(char *buffer, int start_verse, int end_verse); */
recite:
        la      t5, lyrics
        la      t4, table
        addi    a2, a2, 1
        sll     a1, a1, 1
        sll     a2, a2, 1
        add     a1, t4, a1              /* pointer into table for current verse */
        add     a2, t4, a2              /* pointer into table after end verse */

line:
        lb      t0, 0(t5)               /* Copy "This is" */
        sb      t0, 0(a0)
        lb      t0, 1(t5)
        sb      t0, 1(a0)
        lb      t0, 2(t5)
        sb      t0, 2(a0)
        lb      t0, 3(t5)
        sb      t0, 3(a0)
        lb      t0, 4(t5)
        sb      t0, 4(a0)
        lb      t0, 5(t5)
        sb      t0, 5(a0)
        lb      t0, 6(t5)
        sb      t0, 6(a0)
        addi    a0, a0, 7               /* Update destination pointer */

        lh      t3, 0(a1)
        add     t3, t5, t3

copy_string:
                                        /* copy string from source t3 to destination a0 */
        lb      t0, 0(t3)               /* load source byte */
        sb      t0, 0(a0)               /* write byte to destination */
        addi    t3, t3, 1               /* increment souce pointer */
        addi    a0, a0, 1               /* increment destination pointer */
        bnez     t0, copy_string        /* repeat until we have reached null terminator */

        addi    a0, a0, -1              /* decrement destination pointer, */
                                        /* ready to append other strings */

        add     a1, a1, 2
        bne     a1, a2, line

        ret
