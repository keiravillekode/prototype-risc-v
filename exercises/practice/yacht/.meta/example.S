.equ CHOICE, 0
.equ ONES, 1
.equ TWOS, 2
.equ THREES, 3
.equ FOURS, 4
.equ FIVES, 5
.equ SIXES, 6
.equ LITTLE_STRAIGHT, 7
.equ BIG_STRAIGHT, 8
.equ FULL_HOUSE, 9
.equ FOUR_OF_A_KIND, 10
.equ YACHT, 11

.text
.globl score

/* extern int score(category_t category, const uint16_t *dice); */
score:
        addi    a2, a1, 10              /* end of dice array */
        move    t0, zero                /* total of dice */
        move    t1, zero                /* value counts */
        li      t6, 1

.read:
        lh      t2, 0(a1)               /* read value from dice */
        addi    a1, a1, 2               /* increment input pointer */
        add     t0, t0, t2              /* update total */
        slli    t2, t2, 2               /* multiply by 4 */
        sll     t3, t6, t2              /* 1 << (4 * value) */
        add     t1, t1, t3
        bne     a1, a2, .read

        move    t3, zero
        beqz    a0, .total              /* CHOICE */

        li      t4, LITTLE_STRAIGHT
        beq     a0, t4, .little_straight

        li      t4, BIG_STRAIGHT
        beq     a0, t4, .big_straight

        li      t5, 0x001100
        li      t4, FULL_HOUSE
        beq     a0, t4, .match

        li      t4, FOUR_OF_A_KIND
        beq     a0, t4, .four_of_a_kind

        li      t5, 0x100000
        li      t4, YACHT
        beq     a0, t4, .match

                                        /* ONES TWOS THREES FOURS FIVES SIXES */
        slli    a3, a0, 2
        srl     t1, t1, a3
        andi    t1, t1, 0xf
        mul     a0, a0, t1
        ret

.match:
        srli    t1, t1, 4
        andi    t2, t1, 0xf
        slli    t2, t2, 2               /* multiply by 4 */
        sll     t2, t6, t2              /* 1 << (4 * count) */
        add     t3, t3, t2
        bnez    t1, .match

        and     t3, t3, t5
        bne     t3, t5, .zero

        li      t3, YACHT
        beq     a0, t3, .fifty

.total:
        move    a0, t0
        ret

.four_of_a_kind:
        srli    t1, t1, 4
        beqz    t1, .zero               /* no more counts */

        andi    t2, t1, 0x4
        addi    t3, t3, 1               /* value */
        beqz    t2, .four_of_a_kind     /* loop as count is not 4 */

        slli    a0, t3, 2               /* 4 * value */
        ret

.little_straight:
        li      t5, 0x0111110
        beq     t1, t5, .thirty

.zero:
        move    a0, zero
        ret

.big_straight:
        li      t5, 0x1111100
        bne     t1, t5, .zero

.thirty:
        li      a0, 30
        ret

.fifty:
        li      a0, 50
        ret
