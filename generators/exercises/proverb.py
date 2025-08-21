FUNC_PROTO = """\
#include "vendor/unity.h"

#define BUFFER_SIZE 400

extern void recite(char *buffer, const char *strings);
"""


def gen_func_body(prop, inp, expected):
    strings = inp["strings"]
    strings = "".join(map(lambda line: line + "\\n", strings))
    expected = "".join(map(lambda line: line + "\\n", expected))

    str_list = []
    str_list.append("char buffer[BUFFER_SIZE];\n")
    str_list.append(f'const char *strings = "{strings}";\n')
    str_list.append(f'const char *expected = "{expected}";\n')
    str_list.append(f"{prop}(buffer, strings);\n")
    str_list.append("TEST_ASSERT_EQUAL_STRING(expected, buffer);\n")
    return "".join(str_list)
