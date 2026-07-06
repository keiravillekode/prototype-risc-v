.global format

.section .rodata
you: .string ", you are the "
customer: .string " customer we serve today. Thank you!"
th: .string "th"
st: .string "st"
nd: .string "nd"
rd: .string "rd"

.text

/* extern void format(char *buffer, const char *name, uint16_t number); */
format:
        move    a7, ra
        call    copy_string             /* Output name */
        la      a1, you
        li      t4, 10
        call    copy_string             /* Output you... */
        move    t5, a0

.write:
        move    t1, a2
        divu    a2, t1, t4              /* divide number by 10 */
        remu    t0, t1, t4
        addi    t0, t0, '0'
        sb      t0, 0(a0)               /* Output digit */
        addi    a0, a0, 1
        bnez    a2, .write

        move    t4, a0

.reverse:
        addi    t4, t4, -1
        beq     t5, t4, .choose

        lb      t2, 0(t5)
        lb      t3, 0(t4)
        sb      t2, 0(t4)
        sb      t3, 0(t5)
        addi    t5, t5, 1
        bne     t5, t4, .reverse

.choose:
        li      t1, '1'
        li      t2, '2'
        li      t3, '3'



        la      a1, th
        lb      t6, -2(a0)              /* tens digit */
        beq     t6, t1, suffix

        lb      t6, -1(a0)              /* units digit */
        beq     t6, t1, first
        beq     t6, t2, second
        beq     t6, t3, third

suffix:
        call    copy_string             /* Output th or st or nd or rd */
        la      a1, customer
        jal     copy_string             /* Output customer... */
        jr      a7                      /* Return to original caller */

first:
        la      a1, st
        j       suffix

second:
        la      a1, nd
        j       suffix

third:
        la      a1, rd
        j       suffix


copy_more_chars:
        addi    a1, a1, 1
        addi    a0, a0, 1

copy_string:
        lb      t0, 0(a1)
        sb      t0, 0(a0)
        bnez    t0, copy_more_chars

        ret
