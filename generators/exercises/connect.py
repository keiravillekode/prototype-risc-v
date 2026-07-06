FUNC_PROTO = """\
#include "vendor/unity.h"

extern char winner(const char *board);
"""


def extra_cases():
    return [
        {
          "description": "O wins using a long windy path",
          "property": "winner",
          "input": {
            "board": [
              "O . . O O X X X X X .",
              " O O . X X O O O . X X",
              "  . O X O O . X O O . X",
              "   . O X O O O X X O . X",
              "    O X X X . O X O . X .",
              "     O O X X O . X O O X X",
              "      X O X X O O X X O . X",
              "       . O X X X O X O X X .",
              "        O X O O X O X O O X .",
              "         O O X O O . . . O X X",
              "          X X . . . O O O X . ."
            ]
          },
          "expected": "O"
        }
    ]


def gen_func_body(prop, inp, expected):
    board = inp["board"]
    if expected == '':
        expected = '.'

    str_list = []
    str_list.append("const char board[] =\n")
    for index in range(len(board)):
        line = board[index]
        if index + 1 < len(board):
            str_list.append(f'    "{line}\\n"\n')
        else:
            str_list.append(f'    "{line}\\n";\n')

    str_list.append(f'const char result[2] = {{ winner(board), 0 }};\n')

    str_list.append(f'TEST_ASSERT_EQUAL_STRING("{expected}", result);\n')
    return "".join(str_list)

