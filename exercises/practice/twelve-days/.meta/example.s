.section .rodata

on_the: .string "On the "

ordinals:
        .string "firstsecondthirdfourthfifthsixthseventheighthninthtentheleventhtwelfth"

ordinals_table:
        .byte -1, 0, 5, 11, 16, 22, 27, 32, 39, 45, 50, 55, 63, 70

day_of: .string " day of Christmas my true love gave to me: "

gifts:  .string "twelve Drummers Drumming, eleven Pipers Piping, ten Lords-a-Leaping, nine Ladies Dancing, eight Maids-a-Milking, seven Swans-a-Swimming, six Geese-a-Laying, five Gold Rings, four Calling Birds, three French Hens, two Turtle Doves, and a Partridge in a Pear Tree.\n"

gifts_table:
        .byte -1, 235, 213, 194, 174, 157, 137, 113, 90, 69, 48, 26, 0


.text
.globl recite


/* char *copy(char *dest, void *, void *, const char *source); */
copy:
        lb      t0, 0(a3)
        addi    a3, a3, 1
        sb      t0, 0(a0)
        addi    a0, a0, 1
        bnez    t0, copy

        addi    a0, a0, -1
        jalr    zero, 0(t6)             /* return */


/* char *copy_n(char *dest, void *, void *, const char *source, size_t length); */
copy_n:
        beqz    a4, .copy_n_return

        lb      t0, 0(a3)
        addi    a3, a3, 1
        sb      t0, 0(a0)
        addi    a0, a0, 1
        addi    a4, a4, -1
        j       copy_n

.copy_n_return:
        jalr    zero, 0(t6)             /* return */


/* extern void recite(char *buffer, int start_verse, int end_verse); */
recite:
        la      a3, on_the
        jal     t6, copy                /* subroutine call */

        la      a3, ordinals
        la      t0, ordinals_table
        add     t0, t0, a1
        lbu     t1, 0(t0)
        add     a3, a3, t1              /* start of ordinal string */
        addi    t0, t0, 1
        lbu     t2, 0(t0)
        sub     a4, t2, t1              /* length of ordinal string */
        jal     t6, copy_n              /* subroutine call */

        la      a3, day_of
        jal     t6, copy                /* subroutine call */

        la      a3, gifts
        la      t0, gifts_table
        add     t0, t0, a1
        lbu     t1, 0(t0)
        add     a3, a3, t1
        jal     t6, copy                /* subroutine call */

        addi    a1, a1, 1
        ble     a1, a2, recite

        ret
