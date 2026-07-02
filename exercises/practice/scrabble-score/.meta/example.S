.section .rodata

/*           A  B  C  D  E  F  G  H  I  J  K  L  M  N  O  P  Q   R  S  T  U  V  W  X  Y  Z */
table: .byte 1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10

.text
.globl score

/* extern int score(const char *word); */
score:
        la      t0, table
        la      t6, 26

        move    t1, a0
        move    a0, zero
        j       .read

.loop:
        ori     t2, t2, 32
        addi    t2, t2, -'a'
        bge     t2, t6, .read
        add     t2, t0, t2
        lb      t2, 0(t2)
        add     a0, a0, t2

.read:
        lb      t2, 0(t1)
        addi    t1, t1, 1
        bnez    t2, .loop

        ret
