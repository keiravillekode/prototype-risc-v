.text
.globl rows

/* extern void rows(char *buffer, char letter); */
rows:
        li      a2, 'A'
        li      a3, ' '
        li      a4, '\n'

        sub     t0, a1, a2
        li      t1, 0
        move    t2, a2
        li      t3, 1

.row:
        move    t4, t0
        beqz    t4, .skip_left

.left:
        sb      a3, 0(a0)
        addi    a0, a0, 1
        addi    t4, t4, -1
        bnez    t4, .left

.skip_left:
        sb      t2, 0(a0)
        addi    a0, a0, 1

        move    t4, t1
        beqz    t4, .skip_middle

.middle:
        sb      a3, 0(a0)
        addi    a0, a0, 1
        addi    t4, t4, -1
        bnez    t4, .middle

.skip_middle:
        sb      t2, -1(a0)

        move    t4, t0
        beqz    t4, .skip_right

.right:
        sb      a3, 0(a0)
        addi    a0, a0, 1
        addi    t4, t4, -1
        bnez    t4, .right

.skip_right:
        sb      a4, 0(a0)
        addi    a0, a0, 1

        bnez    t1, .step

        beq     a1, a2, .return

        blt     t3, zero, .return

.step:
        sub     t0, t0, t3
        add     t1, t1, t3
        add     t1, t1, t3
        add     t2, t2, t3

        bnez    t0, .row

        li      t3, -1
        j       .row

.return:
        sb      zero, 0(a0)
        ret
