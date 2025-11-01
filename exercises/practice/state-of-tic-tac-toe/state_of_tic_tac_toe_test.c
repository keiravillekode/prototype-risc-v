#include "vendor/unity.h"

enum state {
    ONGOING,
    DRAW,
    WIN,
    INVALID
};

extern int gamestate(const char *board);

void setUp(void) {
}

void tearDown(void) {
}

void test_finished_game_where_x_won_via_left_column_victory(void) {
    const char board[] =
        "XOO\n"
        "X  \n"
        "X  \n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_x_won_via_middle_column_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "OXO\n"
        " X \n"
        " X \n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_x_won_via_right_column_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "OOX\n"
        "  X\n"
        "  X\n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_o_won_via_left_column_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "OXX\n"
        "OX \n"
        "O  \n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_o_won_via_middle_column_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "XOX\n"
        " OX\n"
        " O \n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_o_won_via_right_column_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "XXO\n"
        " XO\n"
        "  O\n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_x_won_via_top_row_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "XXX\n"
        "XOO\n"
        "O  \n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_x_won_via_middle_row_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "O  \n"
        "XXX\n"
        " O \n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_x_won_via_bottom_row_victory(void) {
    TEST_IGNORE();
    const char board[] =
        " OO\n"
        "O X\n"
        "XXX\n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_o_won_via_top_row_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "OOO\n"
        "XXO\n"
        "XX \n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_o_won_via_middle_row_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "XX \n"
        "OOO\n"
        "X  \n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_o_won_via_bottom_row_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "XOX\n"
        " XX\n"
        "OOO\n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_x_won_via_falling_diagonal_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "XOO\n"
        " X \n"
        "  X\n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_x_won_via_rising_diagonal_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "O X\n"
        "OX \n"
        "X  \n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_o_won_via_falling_diagonal_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "OXX\n"
        "OOX\n"
        "X O\n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_o_won_via_rising_diagonal_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "  O\n"
        " OX\n"
        "OXX\n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_x_won_via_a_row_and_a_column_victory(void) {
    TEST_IGNORE();
    const char board[] =
        "XXX\n"
        "XOO\n"
        "XOO\n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_finished_game_where_x_won_via_two_diagonal_victories(void) {
    TEST_IGNORE();
    const char board[] =
        "XOX\n"
        "OXO\n"
        "XOX\n";
    TEST_ASSERT_EQUAL_INT(WIN, gamestate(board));
}

void test_draw(void) {
    TEST_IGNORE();
    const char board[] =
        "XOX\n"
        "XXO\n"
        "OXO\n";
    TEST_ASSERT_EQUAL_INT(DRAW, gamestate(board));
}

void test_another_draw(void) {
    TEST_IGNORE();
    const char board[] =
        "XXO\n"
        "OXX\n"
        "XOO\n";
    TEST_ASSERT_EQUAL_INT(DRAW, gamestate(board));
}

void test_ongoing_game_one_move_in(void) {
    TEST_IGNORE();
    const char board[] =
        "   \n"
        "X  \n"
        "   \n";
    TEST_ASSERT_EQUAL_INT(ONGOING, gamestate(board));
}

void test_ongoing_game_two_moves_in(void) {
    TEST_IGNORE();
    const char board[] =
        "O  \n"
        " X \n"
        "   \n";
    TEST_ASSERT_EQUAL_INT(ONGOING, gamestate(board));
}

void test_ongoing_game_five_moves_in(void) {
    TEST_IGNORE();
    const char board[] =
        "X  \n"
        " XO\n"
        "OX \n";
    TEST_ASSERT_EQUAL_INT(ONGOING, gamestate(board));
}

void test_invalid_board_x_went_twice(void) {
    TEST_IGNORE();
    const char board[] =
        "XX \n"
        "   \n"
        "   \n";
    TEST_ASSERT_EQUAL_INT(INVALID, gamestate(board));
}

void test_invalid_board_o_started(void) {
    TEST_IGNORE();
    const char board[] =
        "OOX\n"
        "   \n"
        "   \n";
    TEST_ASSERT_EQUAL_INT(INVALID, gamestate(board));
}

void test_invalid_board_x_won_and_o_kept_playing(void) {
    TEST_IGNORE();
    const char board[] =
        "XXX\n"
        "OOO\n"
        "   \n";
    TEST_ASSERT_EQUAL_INT(INVALID, gamestate(board));
}

void test_invalid_board_players_kept_playing_after_a_win(void) {
    TEST_IGNORE();
    const char board[] =
        "XXX\n"
        "OOO\n"
        "XOX\n";
    TEST_ASSERT_EQUAL_INT(INVALID, gamestate(board));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_finished_game_where_x_won_via_left_column_victory);
    RUN_TEST(test_finished_game_where_x_won_via_middle_column_victory);
    RUN_TEST(test_finished_game_where_x_won_via_right_column_victory);
    RUN_TEST(test_finished_game_where_o_won_via_left_column_victory);
    RUN_TEST(test_finished_game_where_o_won_via_middle_column_victory);
    RUN_TEST(test_finished_game_where_o_won_via_right_column_victory);
    RUN_TEST(test_finished_game_where_x_won_via_top_row_victory);
    RUN_TEST(test_finished_game_where_x_won_via_middle_row_victory);
    RUN_TEST(test_finished_game_where_x_won_via_bottom_row_victory);
    RUN_TEST(test_finished_game_where_o_won_via_top_row_victory);
    RUN_TEST(test_finished_game_where_o_won_via_middle_row_victory);
    RUN_TEST(test_finished_game_where_o_won_via_bottom_row_victory);
    RUN_TEST(test_finished_game_where_x_won_via_falling_diagonal_victory);
    RUN_TEST(test_finished_game_where_x_won_via_rising_diagonal_victory);
    RUN_TEST(test_finished_game_where_o_won_via_falling_diagonal_victory);
    RUN_TEST(test_finished_game_where_o_won_via_rising_diagonal_victory);
    RUN_TEST(test_finished_game_where_x_won_via_a_row_and_a_column_victory);
    RUN_TEST(test_finished_game_where_x_won_via_two_diagonal_victories);
    RUN_TEST(test_draw);
    RUN_TEST(test_another_draw);
    RUN_TEST(test_ongoing_game_one_move_in);
    RUN_TEST(test_ongoing_game_two_moves_in);
    RUN_TEST(test_ongoing_game_five_moves_in);
    RUN_TEST(test_invalid_board_x_went_twice);
    RUN_TEST(test_invalid_board_o_started);
    RUN_TEST(test_invalid_board_x_won_and_o_kept_playing);
    RUN_TEST(test_invalid_board_players_kept_playing_after_a_win);
    return UNITY_END();
}
