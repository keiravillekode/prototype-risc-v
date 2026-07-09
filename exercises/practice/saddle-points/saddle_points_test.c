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

void setUp(void) {
}

void tearDown(void) {
}

void test_can_identify_single_saddle_point(void) {
    point_t points[BUFFER_SIZE];
    const int32_t matrix[] = {
        9, 8, 7,
        5, 3, 2,
        6, 6, 7,
    };

    const point_t expected[] = { { 2, 1 } };

    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), saddle_points(points, matrix, 3, 3));

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_INT32(expected[i].row, points[i].row);
        TEST_ASSERT_EQUAL_INT32(expected[i].column, points[i].column);
    }
}

void test_can_identify_lack_of_saddle_points_when_there_are_none(void) {
    TEST_IGNORE();
    point_t points[BUFFER_SIZE];
    const int32_t matrix[] = {
        1, 2, 3,
        3, 1, 2,
        2, 3, 1,
    };

    TEST_ASSERT_EQUAL_UINT32(0, saddle_points(points, matrix, 3, 3));
}

void test_can_identify_multiple_saddle_points_in_a_column(void) {
    TEST_IGNORE();
    point_t points[BUFFER_SIZE];
    const int32_t matrix[] = {
        4, 5, 4,
        3, 5, 5,
        1, 5, 4,
    };

    const point_t expected[] = { { 1, 2 }, { 2, 2 }, { 3, 2 } };

    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), saddle_points(points, matrix, 3, 3));

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_INT32(expected[i].row, points[i].row);
        TEST_ASSERT_EQUAL_INT32(expected[i].column, points[i].column);
    }
}

void test_can_identify_multiple_saddle_points_in_a_row(void) {
    TEST_IGNORE();
    point_t points[BUFFER_SIZE];
    const int32_t matrix[] = {
        6, 7, 8,
        5, 5, 5,
        7, 5, 6,
    };

    const point_t expected[] = { { 2, 1 }, { 2, 2 }, { 2, 3 } };

    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), saddle_points(points, matrix, 3, 3));

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_INT32(expected[i].row, points[i].row);
        TEST_ASSERT_EQUAL_INT32(expected[i].column, points[i].column);
    }
}

void test_can_identify_saddle_point_in_bottom_right_corner(void) {
    TEST_IGNORE();
    point_t points[BUFFER_SIZE];
    const int32_t matrix[] = {
        8, 7, 9,
        6, 7, 6,
        3, 2, 5,
    };

    const point_t expected[] = { { 3, 3 } };

    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), saddle_points(points, matrix, 3, 3));

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_INT32(expected[i].row, points[i].row);
        TEST_ASSERT_EQUAL_INT32(expected[i].column, points[i].column);
    }
}

void test_can_identify_saddle_points_in_a_non_square_matrix(void) {
    TEST_IGNORE();
    point_t points[BUFFER_SIZE];
    const int32_t matrix[] = {
        3, 1, 3,
        3, 2, 4,
    };

    const point_t expected[] = { { 1, 1 }, { 1, 3 } };

    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), saddle_points(points, matrix, 2, 3));

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_INT32(expected[i].row, points[i].row);
        TEST_ASSERT_EQUAL_INT32(expected[i].column, points[i].column);
    }
}

void test_can_identify_that_saddle_points_in_a_single_column_matrix_are_those_with_the_minimum_value(void) {
    TEST_IGNORE();
    point_t points[BUFFER_SIZE];
    const int32_t matrix[] = {
        2,
        1,
        4,
        1,
    };

    const point_t expected[] = { { 2, 1 }, { 4, 1 } };

    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), saddle_points(points, matrix, 4, 1));

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_INT32(expected[i].row, points[i].row);
        TEST_ASSERT_EQUAL_INT32(expected[i].column, points[i].column);
    }
}

void test_can_identify_that_saddle_points_in_a_single_row_matrix_are_those_with_the_maximum_value(void) {
    TEST_IGNORE();
    point_t points[BUFFER_SIZE];
    const int32_t matrix[] = {
        2, 5, 3, 5,
    };

    const point_t expected[] = { { 1, 2 }, { 1, 4 } };

    TEST_ASSERT_EQUAL_UINT32(ARRAY_SIZE(expected), saddle_points(points, matrix, 1, 4));

    for (size_t i = 0; i < ARRAY_SIZE(expected); ++i) {
        TEST_ASSERT_EQUAL_INT32(expected[i].row, points[i].row);
        TEST_ASSERT_EQUAL_INT32(expected[i].column, points[i].column);
    }
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_can_identify_single_saddle_point);
    RUN_TEST(test_can_identify_lack_of_saddle_points_when_there_are_none);
    RUN_TEST(test_can_identify_multiple_saddle_points_in_a_column);
    RUN_TEST(test_can_identify_multiple_saddle_points_in_a_row);
    RUN_TEST(test_can_identify_saddle_point_in_bottom_right_corner);
    RUN_TEST(test_can_identify_saddle_points_in_a_non_square_matrix);
    RUN_TEST(test_can_identify_that_saddle_points_in_a_single_column_matrix_are_those_with_the_minimum_value);
    RUN_TEST(test_can_identify_that_saddle_points_in_a_single_row_matrix_are_those_with_the_maximum_value);
    return UNITY_END();
}
