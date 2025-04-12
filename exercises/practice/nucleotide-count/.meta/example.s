.equ INVALID, -1

/* offsets */
.equ ADENINE, 0
.equ CYTOSINE, 2
.equ GUANINE, 4
.equ THYMINE, 6

.text
.globl nucleotide_counts

/* extern void nucleotide_counts(int16_t *counts, const char *strand); */
nucleotide_counts:
        move    t2, zero
        move    t3, zero
        move    t4, zero
        move    t5, zero
        li      a2, 'A'
        li      a3, 'C'
        li      a4, 'G'
        li      a5, 'T'

.loop:
        lb      t0, 0(a1)
        addi    a1, a1, 1               /* increment input pointer */
        beqz    t0, .return

        beq     t0, a2, .adenine
        beq     t0, a3, .cytosine
        beq     t0, a4, .guanine
        beq     t0, a5, .thymine

        li      t2, INVALID
        li      t3, INVALID
        li      t4, INVALID
        li      t5, INVALID

.return:
        sh      t2, ADENINE(a0)
        sh      t3, CYTOSINE(a0)
        sh      t4, GUANINE(a0)
        sh      t5, THYMINE(a0)
        ret

.adenine:
        addi    t2, t2, 1
        j       .loop

.cytosine:
        addi    t3, t3, 1
        j       .loop

.guanine:
        addi    t4, t4, 1
        j       .loop

.thymine:
        addi    t5, t5, 1
        j       .loop
