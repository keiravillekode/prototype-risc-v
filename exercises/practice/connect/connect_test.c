#include "vendor/unity.h"

#include <stdio.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

extern char winner(const char *board);


/*

 thoughts - we can have TOP LEFT RIGHT BOTTOM at the end,
 avoid the + 4

 we can make use of the fact that every second square is a space,
 to halve the table size.

 Do we want to have 16 bits instead of 32 bits for parent / rank?
 
*/

typedef struct {
    uint32_t parent;
    uint32_t rank;
} entry_t;

#define TOP 0
#define LEFT 1
#define BOTTOM 2
#define RIGHT 3

uint32_t root(void *unused1, void *unused2, entry_t *parents, uint32_t index);


char occupant(const char *board, uint32_t row_length, void *unused, uint32_t row, uint32_t column);



void merge(void *unused1, void *unused2, entry_t *parents, uint32_t index1, uint32_t index2);

void adjacent(const char *board, uint32_t row_length, entry_t *parents, uint32_t row1, uint32_t column1, uint32_t row2, uint32_t column2);



void adjacent1(const char *board, uint32_t row_length, entry_t *parents, uint32_t index1, char occupant1, uint32_t row2, uint32_t column2);


char winner2(const char *board) {

char winner2(const char *board) {

    if (board[0] <= '\n') {
        return '.'; // zero rows or zero columns
    }

    uint32_t row_length = 0;

    while (board[row_length] != '\n') {
        ++row_length;
    }
    ++row_length;

    uint32_t rows = 1;
    while (board[rows * row_length] != '\0') {
        ++rows;
    }

    ++row_length;
    uint32_t columns;
    columns = (row_length - rows) / 2;
  

    entry_t parents[800];
    for (uint32_t i = 0; i < ARRAY_SIZE(parents); ++i) {
        parents[i].parent = i;
        parents[i].rank = 0;
    }
    parents[TOP].rank = 100;
    parents[LEFT].rank = 100;

    for (uint32_t j = 0; j < columns; ++j) {
        adjacent1(board, row_length, parents, TOP, 'O', 0, j); // top edge
        adjacent1(board, row_length, parents, BOTTOM, 'O', rows - 1, j); // bottom edge
    }

    for (uint32_t i = 0; i < rows; ++i) {
        adjacent1(board, row_length, parents, LEFT, 'X', i, 0); // left edge
        adjacent1(board, row_length, parents, RIGHT, 'X', i, columns - 1); // right edge
    }

    for (uint32_t i = 0; i < rows; ++i) {
        for (uint32_t j = 0; j < columns - 1; ++j) {
            adjacent(board, row_length, parents, i, j, i, j + 1); /* horizontal - */
        }
    }

    for (uint32_t i = 0; i < rows - 1; ++i) {
        for (uint32_t j = 0; j < columns; ++j) {
            adjacent(board, row_length, parents, i, j, i + 1, j); /* diagonal \ */
        }
    }

    for (uint32_t i = 0; i < rows - 1; ++i) {
        for (uint32_t j = 0; j < columns - 1; ++j) {
            adjacent(board, row_length, parents, i, j + 1, i + 1, j); /* diagonal / */
        }
    }

    if (root(NULL, NULL, parents, BOTTOM) == TOP) {
        return 'O';
    }

    if (root(NULL, NULL, parents, RIGHT) == LEFT) {
        return 'X';
    }

    return '.'; // no winner yet
}

void setUp(void) {
}

void tearDown(void) {
}

void test_an_empty_board_has_no_winner(void) {
    const char board[] =
        ". . . . .    \n"
        " . . . . .   \n"
        "  . . . . .  \n"
        "   . . . . . \n"
        "    . . . . .\n";
    TEST_ASSERT_EQUAL_INT('.', winner(board));
}

void test_x_can_win_on_a_1x1_board(void) {
    TEST_IGNORE();
    const char board[] =
        "X\n";
    TEST_ASSERT_EQUAL_INT('X', winner(board));
}

void test_o_can_win_on_a_1x1_board(void) {
    TEST_IGNORE();
    const char board[] =
        "O\n";
    TEST_ASSERT_EQUAL_INT('O', winner(board));
}

void test_only_edges_does_not_make_a_winner(void) {
    TEST_IGNORE();
    const char board[] =
        "O O O X   \n"
        " X . . X  \n"
        "  X . . X \n"
        "   X O O O\n";
    TEST_ASSERT_EQUAL_INT('.', winner(board));
}

void test_illegal_diagonal_does_not_make_a_winner(void) {
    TEST_IGNORE();
    const char board[] =
        "X O . .    \n"
        " O X X X   \n"
        "  O X O .  \n"
        "   . O X . \n"
        "    X X O O\n";
    TEST_ASSERT_EQUAL_INT('.', winner(board));
}

void test_nobody_wins_crossing_adjacent_angles(void) {
    TEST_IGNORE();
    const char board[] =
        "X . . .    \n"
        " . X O .   \n"
        "  O . X O  \n"
        "   . O . X \n"
        "    . . O .\n";
    TEST_ASSERT_EQUAL_INT('.', winner(board));
}

void test_x_wins_crossing_from_left_to_right(void) {
    TEST_IGNORE();
    const char board[] =
        ". O . .    \n"
        " O X X X   \n"
        "  O X O .  \n"
        "   X X O X \n"
        "    . O X .\n";
    TEST_ASSERT_EQUAL_INT('X', winner(board));
}

void test_o_wins_crossing_from_top_to_bottom(void) {
    TEST_IGNORE();
    const char board[] =
        ". O . .    \n"
        " O X X X   \n"
        "  O O O .  \n"
        "   X X O X \n"
        "    . O X .\n";
    TEST_ASSERT_EQUAL_INT('O', winner(board));
}

void test_x_wins_using_a_convoluted_path(void) {
    TEST_IGNORE();
    const char board[] =
        ". X X . .    \n"
        " X . X . X   \n"
        "  . X . X .  \n"
        "   . X X . . \n"
        "    O O O O O\n";
    TEST_ASSERT_EQUAL_INT('X', winner(board));
}



int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_an_empty_board_has_no_winner);
    RUN_TEST(test_x_can_win_on_a_1x1_board);
    RUN_TEST(test_o_can_win_on_a_1x1_board);
    RUN_TEST(test_only_edges_does_not_make_a_winner);
    RUN_TEST(test_illegal_diagonal_does_not_make_a_winner);
    RUN_TEST(test_nobody_wins_crossing_adjacent_angles);
    RUN_TEST(test_x_wins_crossing_from_left_to_right);
    RUN_TEST(test_o_wins_crossing_from_top_to_bottom);
    RUN_TEST(test_x_wins_using_a_convoluted_path);
    return UNITY_END();
}
