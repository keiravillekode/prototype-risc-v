#include "vendor/unity.h"

extern char winner(const char *board);

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
    RUN_TEST(test_x_wins_using_a_spiral_path);
    return UNITY_END();
}
