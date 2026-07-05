#include "vendor/unity.h"

#include <stdint.h>
#include <stdio.h>

unsigned count = 0;

/* extern */ char winner(const char *board);

extern void find_dimensions(const char *board, unsigned *columns, unsigned *rows);

#ifdef FIND_DIMENSIONS
void find_dimensions(const char *board, unsigned *columns, unsigned *rows) {
    *columns = 1;
    *rows = 1;

    unsigned offset;
    unsigned step;

    while (board[2 * *columns - 1] != '\n')
        (*columns)++;

    offset = 2 * *columns;
    step = offset;
    while (board[offset]) {
        (*rows)++;
        step++;
        offset += step;
    }
}
#endif

typedef struct {
    uint16_t parent;
    uint16_t rank;
} element_t;

extern void init_parents(element_t* parents, unsigned rows, unsigned columns);

#ifdef INIT_PARENTS
void init_parents(element_t* parents, unsigned rows, unsigned columns) {
    unsigned i;

    for (i = 0; i < rows * columns + 4; ++i) {
        parents[i].parent = i;
        parents[i].rank = 0;
    }

}
#endif

extern unsigned root(element_t* parents, unsigned node);

#ifdef ROOT
unsigned root(element_t* parents, unsigned node) {
    unsigned grandparent;
    while ((grandparent = parents[parents[node].parent].parent) != node) {
        parents[node].parent = grandparent;
        node = grandparent;
    }
    return node;
}
#endif

extern void merge(element_t* parents, unsigned first, unsigned second);

#ifdef MERGE
void merge(element_t* parents, unsigned first, unsigned second) {
    first = root(parents, first);
    second = root(parents, second);

    if (first == second)
        return;

    if (parents[first].rank > parents[second].rank) {
        parents[second].parent = first;
    } else {
        if (parents[first].rank == parents[second].rank) {
            parents[second].rank++;
        }

        parents[first].parent = second;
    }
}
#endif

extern unsigned index(unsigned columns, unsigned row, unsigned column);

#ifdef INDEX
unsigned index(unsigned columns, unsigned row, unsigned column) {
    return columns * row + column + 4;
}
#endif

extern char occupant(const char *board, unsigned columns, unsigned row, unsigned column);

#ifdef OCCUPANT
char occupant(const char *board, unsigned columns, unsigned row, unsigned column) {
    unsigned offset;
    unsigned step;

    offset = 2 * column;
    step = 2 * columns;
    offset += row * step + row * (row + 1) / 2;
    return board[offset];
}
#endif

extern void edge(element_t* parents, const char *board, unsigned columns, unsigned row, unsigned column, unsigned idx, char player);

#ifndef EDGE
void edge(element_t* parents, const char *board, unsigned columns, unsigned row, unsigned column, unsigned idx, char player) {
    if (occupant(board, columns, row, column) == player) {
        merge(parents, idx, index(columns, row, column));
    }
}
#endif

void adjacent(element_t* parents, const char *board, unsigned columns, unsigned row1, unsigned column1, unsigned row2, unsigned column2);

void adjacent(element_t* parents, const char *board, unsigned columns, unsigned row1, unsigned column1, unsigned row2, unsigned column2) {
    if (occupant(board, columns, row1, column1) == occupant(board, columns, row2, column2)) {
        merge(parents, index(columns, row1, column1), index(columns, row2, column2));
    }
}


void edges(element_t* parents, const char *board, unsigned columns, unsigned rows);

void edges(element_t* parents, const char *board, unsigned columns, unsigned rows) {
    unsigned i;
    unsigned j;

    for (j = 0; j < columns; ++j) {
        // top edge
        edge(parents, board, columns, 0, j, 0, 'O');

        // bottom edge
        edge(parents, board, columns, rows - 1, j, 1, 'O');
    }

    for (i = 0; i < rows; ++i) {
        // left edge
        edge(parents, board, columns, i, 0, 2, 'X');

        // right edge
        edge(parents, board, columns, i, columns - 1, 3, 'X');
    }
}

void adjacents(element_t* parents, const char *board, unsigned columns, unsigned rows);

void adjacents(element_t* parents, const char *board, unsigned columns, unsigned rows) {
    unsigned i;
    unsigned j;

    // - horizontal
    for (i = 0; i < rows; ++i) {
        for (j = 0; j + 1 < columns; ++j) {
            adjacent(parents, board, columns, i, j, i, j + 1);
        }
    }

    // \ diagonal 
    for (i = 0; i + 1 < rows; ++i) {
        for (j = 0; j < columns; ++j) {
            adjacent(parents, board, columns, i, j, i + 1, j);
        }
    }

    // / diagonal
    for (i = 0; i + 1 < rows; ++i) {
        for (j = 0; j + 1 < columns; ++j) {
            adjacent(parents, board, columns, i, j + 1, i + 1, j);
        }
    }
}

char winner(const char *board) {
    unsigned columns = 1;
    unsigned rows = 1;

    element_t parents[1024];
//    unsigned i;
  //  unsigned j;

#if 1
    find_dimensions(board, &columns, &rows);
#else
    unsigned offset;
    unsigned step;

    while (board[2 * columns - 1] != '\n')
        columns++;

    offset = 2 * columns;
    step = offset;
    while (board[offset]) {
        rows++;
        step++;
        offset += step;
    }
#endif

    init_parents(parents, rows, columns);

#if 0
    printf("\n%s\n", board);
    printf("columns %d, rows %d\n", columns, rows);

    for (i = 0; i < rows; ++i) {
        for (j = 0; j < columns; ++j) {
            printf("%c", occupant(board, columns, i, j));
        }
        printf("\n");
    }
#endif


    /*
        Ideally code like the following would become a function call

        if (occupant(board, columns, 0, j) == 'O') {
            merge(parents, 0, index(columns, 0, j));
        }
    */

#if 1
    edges(parents, board, columns, rows);
#else
    for (j = 0; j < columns; ++j) {
        // top edge
        if (occupant(board, columns, 0, j) == 'O') {
            merge(parents, 0, index(columns, 0, j));
        }

        // bottom edge
        if (occupant(board, columns, rows - 1, j) == 'O') {
            merge(parents, 1, index(columns, rows - 1, j));
        }
    }

    for (i = 0; i < rows; ++i) {
        // left edge
        if (occupant(board, columns, i, 0) == 'X') {
            merge(parents, 2, index(columns, i, 0));
        }

        // right edge
        if (occupant(board, columns, i, columns - 1) == 'X') {
            merge(parents, 3, index(columns, i, columns - 1));
        }
    }
#endif

    // Ideally we would call a function like    adjacent parents board i j i (j + 1)

#if 1
    adjacents(parents, board, columns, rows);
#else
    // - horizontal
    for (i = 0; i < rows; ++i) {
        for (j = 0; j + 1 < columns; ++j) {
            if (occupant(board, columns, i, j) == occupant(board, columns, i, j + 1)) {
                merge(parents, index(columns, i, j), index(columns, i, j + 1));
            }
        }
    }

    // \ diagonal 
    for (i = 0; i + 1 < rows; ++i) {
        for (j = 0; j < columns; ++j) {
            if (occupant(board, columns, i, j) == occupant(board, columns, i + 1, j)) {
                merge(parents, index(columns, i, j), index(columns, i + 1, j));
            }
        }
    }

    // / diagonal
    for (i = 0; i + 1 < rows; ++i) {
        for (j = 0; j + 1 < columns; ++j) {
            if (occupant(board, columns, i, j + 1) == occupant(board, columns, i + 1, j)) {
                merge(parents, index(columns, i, j + 1), index(columns, i + 1, j));
            }
        }
    }
#endif

    printf("\n%d\n", count); // 368

#if 1
    if (root(parents, 0) == root(parents, 1))
        return 'O';

    if (root(parents, 2) == root(parents, 3))
        return 'X';
#endif

    return '.';
}

void setUp(void) {
}

void tearDown(void) {
}

void test_an_empty_board_has_no_winner(void) {
    const char board[] =
        ". . . . .\n"
        " . . . . .\n"
        "  . . . . .\n"
        "   . . . . .\n"
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
        "O O O X\n"
        " X . . X\n"
        "  X . . X\n"
        "   X O O O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING(".", result);
}

void test_illegal_diagonal_does_not_make_a_winner(void) {
    TEST_IGNORE();
    const char board[] =
        "X O . .\n"
        " O X X X\n"
        "  O X O .\n"
        "   . O X .\n"
        "    X X O O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING(".", result);
}

void test_nobody_wins_crossing_adjacent_angles(void) {
    TEST_IGNORE();
    const char board[] =
        "X . . .\n"
        " . X O .\n"
        "  O . X O\n"
        "   . O . X\n"
        "    . . O .\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING(".", result);
}

void test_x_wins_crossing_from_left_to_right(void) {
    TEST_IGNORE();
    const char board[] =
        ". O . .\n"
        " O X X X\n"
        "  O X O .\n"
        "   X X O X\n"
        "    . O X .\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("X", result);
}

void test_x_wins_with_lefthand_dead_end_fork(void) {
    TEST_IGNORE();
    const char board[] =
        ". . X .\n"
        " X X . .\n"
        "  . X X X\n"
        "   O O O O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("X", result);
}

void test_x_wins_with_righthand_dead_end_fork(void) {
    TEST_IGNORE();
    const char board[] =
        ". . X X\n"
        " X X . .\n"
        "  . X X .\n"
        "   O O O O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("X", result);
}

void test_o_wins_crossing_from_top_to_bottom(void) {
    TEST_IGNORE();
    const char board[] =
        ". O . .\n"
        " O X X X\n"
        "  O O O .\n"
        "   X X O X\n"
        "    . O X .\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("O", result);
}

void test_x_wins_using_a_convoluted_path(void) {
    TEST_IGNORE();
    const char board[] =
        ". X X . .\n"
        " X . X . X\n"
        "  . X . X .\n"
        "   . X X . .\n"
        "    O O O O O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("X", result);
}

void test_x_wins_using_a_spiral_path(void) {
    TEST_IGNORE();
    const char board[] =
        "O X X X X X X X X\n"
        " O X O O O O O O O\n"
        "  O X O X X X X X O\n"
        "   O X O X O O O X O\n"
        "    O X O X X X O X O\n"
        "     O X O O O X O X O\n"
        "      O X X X X X O X O\n"
        "       O O O O O O O X O\n"
        "        X X X X X X X X O\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("X", result);
}

void test_o_wins_using_a_long_windy_path(void) {
    TEST_IGNORE();
    const char board[] =
        "O . . O O X X X X X .\n"
        " O O . X X O O O . X X\n"
        "  . O X O O . X O O . X\n"
        "   . O X O O O X X O . X\n"
        "    O X X X . O X O . X .\n"
        "     O O X X O . X O O X X\n"
        "      X O X X O O X X O . X\n"
        "       . O X X X O X O X X .\n"
        "        O X O O X O X O O X .\n"
        "         O O X O O . . . O X X\n"
        "          X X . . . O O O X . .\n";
    const char result[2] = { winner(board), 0 };
    TEST_ASSERT_EQUAL_STRING("O", result);
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
    RUN_TEST(test_x_wins_with_lefthand_dead_end_fork);
    RUN_TEST(test_x_wins_with_righthand_dead_end_fork);
    RUN_TEST(test_o_wins_crossing_from_top_to_bottom);
    RUN_TEST(test_x_wins_using_a_convoluted_path);
    RUN_TEST(test_x_wins_using_a_spiral_path);
    RUN_TEST(test_o_wins_using_a_long_windy_path);
    return UNITY_END();
}
