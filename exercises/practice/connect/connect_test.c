#include "vendor/unity.h"

extern char winner(const char *board);

typedef struct {
    uint32_t parent;
    uint32_t rank;
} entry_t;

#define TOP 0
#define LEFT 1
#define BOTTOM 2
#define RIGHT 3

uint32_t root(entry_t *parents, uint32_t index);

uint32_t root(entry_t *parents, uint32_t index) {
    uint32_t parent = parents[index].parent;
    while (parent != index) {
        uint32_t grandparent = parents[parent].parent;
        parents[index].parent = grandparent;
        index = parent;

        parent = grandparent;
    }
    return index;
}

// was char occupant(const char *board, uint32_t rows, uint32_t columns, uint32_t row, uint32_t column);

char occupant(const char *board, uint32_t row_length, uint32_t row, uint32_t column);

char occupant(const char *board, uint32_t row_length, uint32_t row, uint32_t column) {
    // was TODO: increase columns by 1, to simplify to board[row * columns + 2 * column];
    // TODO: increase row_length by 1, to simplify to board[row * row_length + 2 * column];
    return board[row * row_length + row + 2 * column];
}

void merge(entry_t *parents, uint32_t index1, uint32_t index2);

void adjacent(const char *board, uint32_t row_length, entry_t *parents, uint32_t row1, uint32_t column1, uint32_t row2, uint32_t column2);

void adjacent(const char *board, uint32_t row_length, entry_t *parents, uint32_t row1, uint32_t column1, uint32_t row2, uint32_t column2) {
    char occupant1 = occupant(board, row_length, row1, column1);
    char occupant2 = occupant(board, row_length, row2, column2);
    if (occupant1 != occupant2) {
        return;
    }

    merge(row1 * row_length + column1 + 4, row2 * row_length + column2 + 4);
}

void merge(entry_t *parents, uint32_t index1, uint32_t index2) {
    uint32_t root1 = root(parents, index1);
    uint32_t root2 = root(parents, index2);
    if (root1 == root2) {
        return;
    }

    if (parents[root1].rank < parents[root2].rank) {
        uint32_t temp = root1;
        root1 = root2;
        root2 = temp;
    }

    parents[root2].parent = root1;
    if (parents[root1].rank == parents[root2].rank) {
        parents[root1].rank++;
    }
}

void adjacent1(const char *board, uint32_t row_length, entry_t *parents, uint32_t index1, char occupant1, uint32_t row2, uint32_t column2);

void adjacent1(const char *board, uint32_t row_length, entry_t *parents, uint32_t index1, char occupant1, uint32_t row2, uint32_t column2) {
    char occupant2 = occupant(board, row_length, row2, column2);
    if (occupant1 != occupant2) {
        return;
    }

    merge(index1, row2 * row_length + column2 + 4);
}



def occupant [m] [n] (board: [m][n]u8) (row: i64) (column: i64): u8 =
  if row < m then board[row][row + 2 * column] else
  match column
    case 0 -> 'O'  -- top edge
    case 1 -> 'O'  -- bottom edge
    case 2 -> 'X'  -- left edge
    case 3 -> 'X'  -- right edge
    case _ -> assert false '.'



def root (parents: []i64) (i: i64): i64 =
  let i = loop i = i while parents[i] != i do
    parents[i]
  in
    i


char winner(const char *board) {

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
