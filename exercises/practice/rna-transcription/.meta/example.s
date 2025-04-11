.section .rodata

/* translation ascii value for given nucleotide A..Z */
table: .byte 85, 0, 71, 0, 0, 0, 67, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65, 0, 0, 0, 0, 0, 0

.text
.globl to_rna

/* extern void to_rna(char *buffer, const char *dna); */
to_rna:
        la      t0, table
        j       .read

.translate:
        addi    t1, t1, -'A'
        add     t1, t0, t1
        lb      t1, 0(t1)
        sb      t1, 0(a0)
        addi    a0, a0, 1

.read:
        lb      t1, 0(a1)
        addi    a1, a1, 1
        bnez    t1, .translate

        sb      zero, 0(a0)
        ret
