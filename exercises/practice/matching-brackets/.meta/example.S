.text
.globl is_paired

/*
| Register | Usage        | Type    | Description                      |
| -------- | ------------ | ------- | -------------------------------- |
| `a0`     | input        | address | null-terminated string           |
| `a1`     | temporary    | address | input pointer                    |
| `t0`     | temporary    | address | original stack pointer           |
| `t1`     | temporary    | byte    | input character                  |
| `t2`     | temporary    | byte    | opening character                |
| `t3`     | temporary    | byte    | closing character                |
*/

/* extern int is_paired(const char *value); */
is_paired:
        move    t0, sp
        move    a1, a0
        j       read

loop:
        li      t2, '['                 /* '[' is the expected opening character */
        li      t3, ']'                 /* when closing character ']' is found */
        beq     t1, t3, close

        li      t2, '{'                 /* '{' is the expected opening character */
        li      t3, '}'                 /* when closing character '}' is found */
        beq     t1, t3, close

        li      t2, '('                 /* '(' is the expected opening character */
        li      t3, ')'                 /* when closing character ')' is found */
        beq     t1, t3, close

        li      t2, '['
        beq     t1, t2, open

        li      t2, '{'
        beq     t1, t2, open

        li      t2, '('
        beq     t1, t2, open

read:
        lb      t1, 0(a1)               /* Load a character, */
        addi    a1, a1, 1               /* Increment the pointer */
        bnez    t1, loop                /* if not end of string, continue loop. */

restore:
        sltu    a0, sp, t0 
        xori    a0, a0, 1               /* Check if all brackets have matched. */
        move    sp, t0                  /* Restore original stack pointer. */

return:
        ret

open:
        add     sp, sp, -8              /* Push character onto the stack */
        sb      t2, 0(sp)
        j       read

close:
        sltu     a0, sp, t0             /* Set a0 to 1 if there are open brackets, otherwise 0. */
        beqz     a0, return             /* If there are no open brackets, return. */

        lb      t1, 0(sp)               /* Read the top opening bracket. */
        bne     t1, t2, restore         /* If different from expected, restore stack and report no match. */

        addi    sp, sp, 8               /* Pop opening character from stack. */
        j       read
