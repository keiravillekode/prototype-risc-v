FUNC_PROTO = """\
#include "vendor/unity.h"

extern char winner(const char *board);
"""

def gen_func_body(prop, inp, expected):
    board = inp["board"]
    if expected == '':
        expected = '.'

    str_list = []
    str_list.append("const char board[] =\n")
    length = max(map(len, board))
    for index in range(len(board)):
        line = board[index]
        line = line + " " * (length - len(line))
        if index + 1 < len(board):
            str_list.append(f'    "{line}\\n"\n')
        else:
            str_list.append(f'    "{line}\\n";\n')

    str_list.append(f"TEST_ASSERT_EQUAL_INT('{expected}', winner(board));\n")
    return "".join(str_list)

