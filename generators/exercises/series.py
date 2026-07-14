FUNC_PROTO = """\
#include "vendor/unity.h"

#define BUFFER_SIZE 2000

extern void slices(char *buffer, const char *series, int slice_length);
"""


def gen_func_body(prop, inp, expected):
    series = inp["series"]
    slice_length = inp["sliceLength"]
    str_list = []
    str_list.append("const char expected[] =")
    if expected.__class__ == dict:
        str_list[-1] += ' "";'
    else:
        for index in range(len(expected)):
            line = expected[index]
            if index + 1 == len(expected):
                str_list.append(f'    "{line}";')
            else:
                str_list.append(f'    "{line}, "')
    str_list.append("char buffer[BUFFER_SIZE];\n")
    str_list.append(f'{prop}(buffer, "{series}", {slice_length});')
    str_list.append("TEST_ASSERT_EQUAL_STRING(expected, buffer);\n")
    return "\n".join(str_list)
