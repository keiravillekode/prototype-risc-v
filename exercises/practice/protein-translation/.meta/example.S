.equ AUG, 0x475541
.equ UUU, 0x555555
.equ UUC, 0x435555
.equ UUA, 0x415555
.equ UUG, 0x475555
.equ UCU, 0x554355
.equ UCC, 0x434355
.equ UCA, 0x414355
.equ UCG, 0x474355
.equ UAU, 0x554155
.equ UAC, 0x434155
.equ UGU, 0x554755
.equ UGC, 0x434755
.equ UGG, 0x474755
.equ UAA, 0x414155
.equ UAG, 0x474155
.equ UGA, 0x414755

.section .rodata
methionine:    .string "Methionine\n"
phenylalanine: .string "Phenylalanine\n"
leucine:       .string "Leucine\n"
serine:        .string "Serine\n"
tyrosine:      .string "Tyrosine\n"
cysteine:      .string "Cysteine\n"
tryptophan:    .string "Tryptophan\n"

.text
.globl proteins

/* extern void proteins(char *buffer, const char *strand); */
proteins:
        move    a2, a0
        j       .read_codon

.write:
        sb      t1, 0(a0)
        addi    t0, t0, 1
        addi    a0, a0, 1

.copy:
        lb      t1, 0(t0)
        bnez    t1, .write

.read_codon:
        lb      t0, 0(a1)
        beqz    t0, .stop

        lb      t1, 1(a1)
        beqz    t1, .invalid

        lb      t2, 2(a1)
        beqz    t2, .invalid

        addi    a1, a1, 3
        slli    t2, t2, 16
        slli    t1, t1, 8
        or      t2, t2, t1
        or      t2, t2, t0


        la      t0, methionine
        li      t1, AUG
        beq     t2, t1, .copy


        la      t0, phenylalanine
        li      t1, UUU
        beq     t2, t1, .copy

        li      t1, UUC
        beq     t2, t1, .copy


        la      t0, leucine
        li      t1, UUA
        beq     t2, t1, .copy

        li      t1, UUG
        beq     t2, t1, .copy


        la      t0, serine
        li      t1, UCU
        beq     t2, t1, .copy

        li      t1, UCC
        beq     t2, t1, .copy

        li      t1, UCA
        beq     t2, t1, .copy

        li      t1, UCG
        beq     t2, t1, .copy


        la      t0, tyrosine
        li      t1, UAU
        beq     t2, t1, .copy

        li      t1, UAC
        beq     t2, t1, .copy


        la      t0, cysteine
        li      t1, UGU
        beq     t2, t1, .copy

        li      t1, UGC
        beq     t2, t1, .copy


        la      t0, tryptophan
        li      t1, UGG
        beq     t2, t1, .copy


        li      t1, UAA
        beq     t2, t1, .stop

        li      t1, UAG
        beq     t2, t1, .stop

        li      t1, UGA
        beq     t2, t1, .stop


.invalid:
        sb      zero, 0(a2)
        ret

.stop:
        sb      zero, 0(a0)
        ret
