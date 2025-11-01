FUNC_PROTO = """\
#include "vendor/unity.h"

enum state {
    ONGOING,
    DRAW,
    WIN,
    INVALID
};

extern int gamestate(const char *board);
"""


def gen_func_body(prop, inp, expected):
    board = inp["board"]
    if isinstance(expected, dict):
        expected = "invalid"
    str_list = []

    str_list.append("const char board[] =")
    for index in range(len(board)):
        line = board[index]
        if index + 1 < len(board):
            str_list.append(f'    "{line}\\n"')
        else:
            str_list.append(f'    "{line}\\n";')

    str_list.append(f"TEST_ASSERT_EQUAL_INT({expected.upper()}, {prop}(board));\n")
    return "\n".join(str_list)
