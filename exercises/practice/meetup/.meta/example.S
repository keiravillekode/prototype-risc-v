.equ FIRST, 1
.equ SECOND, 2
.equ THIRD, 3
.equ FOURTH, 4
.equ TEENTH, 5
.equ LAST, 6

.equ MONDAY, 1
.equ TUESDAY, 2
.equ WEDNESDAY, 3
.equ THURSDAY, 4
.equ FRIDAY, 5
.equ SATURDAY, 6
.equ SUNDAY, 7

.section .rodata

/* offset from end February for the start of the specified month */
offset_array:
        .hword -1
        .hword 307
        .hword 338
        .hword 1 /* March */
        .hword 32
        .hword 62
        .hword 93
        .hword 123
        .hword 154
        .hword 185
        .hword 215
        .hword 246
        .hword 276
        .hword 307
        .hword 338 /* February */

/* day in month for last day in specified week */
week_array:
        .byte -1
        .byte 7 /* first */
        .byte 14
        .byte 21
        .byte 28
        .byte 19 /* teenth */


.text
.globl meetup


/* int leap_year(void *unused, long year); */
leap_year:
        move    t2, a1
        li      t0, 100
        rem     t1, t2, t0
        bnez    t1, .test

        div     t2, t2, t0

.test:
        andi    a0, t2, 3
        slti    a0, a0, 1
        ret


/* int days_in_month(void *unused, int year, int month); */
days_in_month:
        li      t0, 2
        beq     a2, t0, .february

        la      t1, offset_array
        slli    t2, a2, 1               /* month * sizeof(hword) */
        add     t1, t1, t2
        lh      t3, 0(t1)               /* days offset for required month */
        lh      a0, 2(t1)               /* days offset for following month */
        sub     a0, a0, t3
        ret

.february:
        move    t3, ra
        call    leap_year
        add     a0, a0, 28
        jr      t3


/* int week_concludes(void *unused, int year, int month, week_t week); */
week_concludes:
        li      t0, LAST
        beq     a3, t0, days_in_month   /* tail call */
        la      t0, week_array
        add     t0, t0, a3
        lb      a0, 0(t0)               /* day in month at end of requested week */
        ret


/* dayofweek_t day_of_week(void *unused, int year, int month, int day); */
day_of_week:
        move    t2, a2                  /* month */
        move    t1, a1                  /* year */
        li      t0, 2
        bgt     t2, t0, .read_offset

        addi    t2, t2, 12              /* Consider January and February to be the 13th and 14th months of */
        addi    t1, t1, -1              /* the previous year */

.read_offset:
        slli    t2, t2, 1               /* (adjusted month) * sizeof(hword) */
        la      t0, offset_array
        add     t0, t0, t2
        lh      a0, 0(t0)               /* days offset for required month */

        add     a0, a0, a3              /* add day in month */

        add     a0, a0, t1              /* adjusted year */

        srli    t1, t1, 2
        add     a0, a0, t1              /* adjusted year / 4 */

        li      t0, 25
        divu    t1, t1, t0
        sub     a0, a0, t1              /* adjusted year / 100 */

        srli    t1, t1, 2
        add     a0, a0, t1              /* adjusted year / 400 */

        li      t0, 7
        remu    a0, a0, t0
        addi    a0, a0, 1
        ret


/* extern void meetup(char *buffer, int year, int month, week_t week, dayofweek_t dayofweek); */
meetup:
        move    t6, a0
        move    t5, ra
        call    week_concludes
        move    a3, a0
        move    t4, a0
        call    day_of_week

        sub     a4, a4, a0              /* delta: requested day of week minus current day of week */
        ble     a4, zero, .print

        addi    a4, a4, -7              /* if delta was positive, subtract 7 */

.print:
        add     a3, t4, a4              /* required day of month */
        move    a0, t6
        move    ra, t5


/* void print_date(char *buffer, int year, int month, int day); */
print_date:
        li      t5, '-'
        li      t6, 10

        remu    t0, a1, t6
        divu    a1, a1, t6
        addi    t0, t0, '0'
        sb      t0, 3(a0)

        remu    t0, a1, t6
        divu    a1, a1, t6
        addi    t0, t0, '0'
        sb      t0, 2(a0)

        remu    t0, a1, t6
        divu    a1, a1, t6
        addi    t0, t0, '0'
        sb      t0, 1(a0)

        addi    t0, a1, '0'
        sb      t0, 0(a0)

        sb      t5, 4(a0)

        remu    t0, a2, t6
        divu    a1, a2, t6
        addi    t0, t0, '0'
        sb      t0, 6(a0)

        addi    t0, a1, '0'
        sb      t0, 5(a0)

        sb      t5, 7(a0)

        remu    t0, a3, t6
        divu    a1, a3, t6
        addi    t0, t0, '0'
        sb      t0, 9(a0)

        addi    t0, a1, '0'
        sb      t0, 8(a0)

        sb      zero, 10(a0)
        ret
