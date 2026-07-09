from string import Template

FUNC_PROTO = """\
#include "vendor/unity.h"

#include <stddef.h>
#include <stdint.h>

#define BUFFER_SIZE 15
#define ARRAY_SIZE(x) sizeof(x) / sizeof(x[0])

typedef struct {
    size_t row;
    size_t column;
} point_t;

extern size_t saddle_points(point_t *output, const int32_t *matrix, size_t row_count, size_t column_count);
"""

INPUT_TEMPLATE = Template("""point_t points[BUFFER_SIZE];
const int32_t matrix[] = ${matrix};
""")

WITH_SADDLE_POINTS_TEMPLATE = Template("""${input}
const point_t expected[] = ${expected};

TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), ${prop}(points, matrix, ${rows}, ${columns}));

for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
    TEST_ASSERT_EQUAL_INT32(expected[i].row, points[i].row);
    TEST_ASSERT_EQUAL_INT32(expected[i].column, points[i].column);
}
""")

WITHOUT_SADDLE_POINTS_TEMPLATE = Template("""${input}
TEST_ASSERT_EQUAL_UINT32(0, ${prop}(points, matrix, ${rows}, ${columns}));
""")


def matrix_literal(matrix):
    numbers = [n for row in matrix for n in row]
    if not numbers:
        return "{ 0 }"
    width = max(len(str(n)) for n in numbers)
    lines = [
        "    " + ", ".join(str(n).rjust(width) for n in row) + ","
        for row in matrix
    ]
    return "{\n" + "\n".join(lines) + "\n}"


def points_literal(points):
    inner = ", ".join(f"{{ {p['row']}, {p['column']} }}" for p in points)
    return "{ " + inner + " }"


def gen_func_body(prop, inp, expected):
    matrix = inp["matrix"]
    rows = len(matrix)
    columns = len(matrix[0]) if matrix else 0
    input_str = INPUT_TEMPLATE.substitute(matrix=matrix_literal(matrix))
    if len(expected) == 0:
        return WITHOUT_SADDLE_POINTS_TEMPLATE.substitute(
            input=input_str, prop=prop, rows=rows, columns=columns
        )
    points = sorted(expected, key=lambda p: (p["row"], p["column"]))
    return WITH_SADDLE_POINTS_TEMPLATE.substitute(
        input=input_str,
        prop=prop,
        rows=rows,
        columns=columns,
        expected=points_literal(points),
    )
