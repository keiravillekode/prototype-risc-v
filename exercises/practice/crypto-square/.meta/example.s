.text
.globl ciphertext

/* extern void ciphertext(char *buffer, const char *plaintext); */
ciphertext:
        move    a2, zero                /* number of alphanumeric characters */
        move    t0, a1                  /* source pointer */
        li      t5, 10
        li      t6, 26
        j       .scan

.count:
        addi    t2, t1, -'0'
        bltu    t2, t5,  .accept        /* digit? */

        ori     t1, t1, 32
        addi    t2, t1, -'a'
        bgeu    t2, t6, .scan           /* non-letter? */

.accept:
        add     a2, a2, 1

.scan:
        lbu     t1, 0(t0)               /* read */
        addi    t0, t0, 1
        bnez    t1, .count

        sb      zero, 0(a0)
        beqz    a2, .return             /* no alphanumeric characters? */

        move    a4, zero                /* number of input columns */
        j       .square

.increment_columns:
        addi    a4, a4, 1

.square:
        mul     t2, a4, a4
        blt     t2, a2, .increment_columns

        addi    a3, a4, -1              /* number of input rows */
        mul     t2, a3, a4
        slt     t2, t2, a2              /* 1 iff rows * columns < number of alphanumeric characters */
        add     a3, a3, t2

        mul     t2, a3, a4
        add     t2, t2, a4              /* add number of input columns */
        addi    t2, t2, -1              /* length of output: (rows + 1) * columns - 1 */
        add     t2, a0, t2

        sb      zero, 0(t2)
        li      t1, ' '

.space:
        addi    t2, t2, -1
        sb      t1, 0(t2)
        bne     t2, a0, .space

        add     a3, a3, 1               /* number of output columns = number of input rows + 1 */

.next_output_column:
        move    t3, a4                  /* number of output rows remaining */
        move    t4, zero

.read:
        lbu     t1, 0(a1)               /* read */
        addi    a1, a1, 1
        addi    t2, t1, -'0'
        bltu    t2, t5, .write          /* digit? */

        ori     t1, t1, 32
        addi    t2, t1, -'a'
        bgeu    t2, t6, .read           /* non-letter? */

.write:
        add     a5, a0, t4
        sb      t1, 0(a5)

        addi    a2, a2, -1
        beqz    a2, .return             /* no alphanumeric characters remain? */

        add     t4, t4, a3
        addi    t3, t3, -1
        bnez    t3, .read

        addi    a0, a0, 1               /* next output column */
        j       .next_output_column

.return:
        ret
