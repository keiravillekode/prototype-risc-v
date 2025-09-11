#include "vendor/unity.h"

#include <stdio.h>

extern char winner(const char *board);

char winner(const char *board) {
    const char *iter = board;
    if (*iter <= '\n') {
        return '.'; // zero rows or zero columns
    }

    while (*iter++ != '\n') {}
    uint32_t row_length = iter - board;

    uint32_t rows = 1;
    while (*iter != '\0') {
        iter += row_length;
        ++rows;
    }

    ++row_length;
    uint32_t columns = (row_length - rows) / 2;
  

/*
    fprintf(stderr, "%d %d %d\n", row_length, rows, columns);
    return '?';
*/

    char seen[800];
    for (int i = 0; i < 800; ++i) {
        seen[i] = 0;
    }
    /*
    We need a "seen" record that is the same size as  [iter - board]. OR    row_length * row + column
    shift right 4
    add 1
    shift left 4

    this gives final size */

    char queue_row[800];
    char queue_column[800];
    uint32_t queue_len = 0;
    /*
    we need a queue, and a head of queue
    each entry in queue will be a (row, column) pair
    */

    for (uint32_t column = 0; column < columns; ++column) {
        uint32_t row = rows - 1;
        uint32_t index = row * row_length + column * 2;
        if (board[index] == 'O') {
            seen[index] = 1;
            queue_row[queue_len] = row;
            queue_column[queue_len] = column;
            queue_len += 1;
        }
    }

    loop along bottom row. If O, add to queue and mark seen
    loop along right column. If X, add to queue and mark seen

    when we take an entry off the queue:
      we read the character   row_length * row + column
      if O and row + 1 == rows, we have winner.  [better to use row 0]
      if X and column + 1 == rows, we have winner.  [better to use column 0]
      then we go all 6 neighbours:
        if next_row >= 0 and next_column >= 0 and next_row < rows and next_col < colums
            read the character   row_length * row + column
            if different, move on
            if "seen", move on
            add to queue, mark seen
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
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING(".", result);
}

void test_x_can_win_on_a_1x1_board(void) {
    TEST_IGNORE();
    const char board[] =
        "X\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("X", result);
}

void test_o_can_win_on_a_1x1_board(void) {
    TEST_IGNORE();
    const char board[] =
        "O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("O", result);
}

void test_only_edges_does_not_make_a_winner(void) {
    TEST_IGNORE();
    const char board[] =
        "O O O X   \n"
        " X . . X  \n"
        "  X . . X \n"
        "   X O O O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING(".", result);
}

void test_illegal_diagonal_does_not_make_a_winner(void) {
    TEST_IGNORE();
    const char board[] =
        "X O . .    \n"
        " O X X X   \n"
        "  O X O .  \n"
        "   . O X . \n"
        "    X X O O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING(".", result);
}

void test_nobody_wins_crossing_adjacent_angles(void) {
    TEST_IGNORE();
    const char board[] =
        "X . . .    \n"
        " . X O .   \n"
        "  O . X O  \n"
        "   . O . X \n"
        "    . . O .\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING(".", result);
}

void test_x_wins_crossing_from_left_to_right(void) {
    TEST_IGNORE();
    const char board[] =
        ". O . .    \n"
        " O X X X   \n"
        "  O X O .  \n"
        "   X X O X \n"
        "    . O X .\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("X", result);
}

void test_o_wins_crossing_from_top_to_bottom(void) {
    TEST_IGNORE();
    const char board[] =
        ". O . .    \n"
        " O X X X   \n"
        "  O O O .  \n"
        "   X X O X \n"
        "    . O X .\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("O", result);
}

void test_x_wins_using_a_convoluted_path(void) {
    TEST_IGNORE();
    const char board[] =
        ". X X . .    \n"
        " X . X . X   \n"
        "  . X . X .  \n"
        "   . X X . . \n"
        "    O O O O O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("X", result);
}

void test_x_wins_using_a_spiral_path(void) {
    TEST_IGNORE();
    const char board[] =
        "O X X X X X X X X        \n"
        " O X O O O O O O O       \n"
        "  O X O X X X X X O      \n"
        "   O X O X O O O X O     \n"
        "    O X O X X X O X O    \n"
        "     O X O O O X O X O   \n"
        "      O X X X X X O X O  \n"
        "       O O O O O O O X O \n"
        "        X X X X X X X X O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("X", result);
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
    RUN_TEST(test_x_wins_using_a_spiral_path);
    return UNITY_END();
}
