#include "vendor/unity.h"

#include <stddef.h>
#include <stdint.h>

extern void tick(uint32_t *buffer, const uint32_t *matrix, size_t row_count, size_t column_count);

void setUp(void) {
}

void tearDown(void) {
}

void test_live_cells_with_zero_live_neighbors_die(void) {
    uint32_t actual[3];
    const uint32_t matrix[] = {
        // clang-format off
        0b000,
        0b010,
        0b000,
        // clang-format on
    };
    const uint32_t expected[] = {
        // clang-format off
        0b000,
        0b000,
        0b000,
        // clang-format on
    };
    tick(actual, matrix, 3, 3);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, 3);
}

void test_live_cells_with_only_one_live_neighbor_die(void) {
    TEST_IGNORE();
    uint32_t actual[3];
    const uint32_t matrix[] = {
        // clang-format off
        0b000,
        0b010,
        0b010,
        // clang-format on
    };
    const uint32_t expected[] = {
        // clang-format off
        0b000,
        0b000,
        0b000,
        // clang-format on
    };
    tick(actual, matrix, 3, 3);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, 3);
}

void test_live_cells_with_two_live_neighbors_stay_alive(void) {
    TEST_IGNORE();
    uint32_t actual[3];
    const uint32_t matrix[] = {
        // clang-format off
        0b101,
        0b101,
        0b101,
        // clang-format on
    };
    const uint32_t expected[] = {
        // clang-format off
        0b000,
        0b101,
        0b000,
        // clang-format on
    };
    tick(actual, matrix, 3, 3);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, 3);
}

void test_live_cells_with_three_live_neighbors_stay_alive(void) {
    TEST_IGNORE();
    uint32_t actual[3];
    const uint32_t matrix[] = {
        // clang-format off
        0b010,
        0b100,
        0b110,
        // clang-format on
    };
    const uint32_t expected[] = {
        // clang-format off
        0b000,
        0b100,
        0b110,
        // clang-format on
    };
    tick(actual, matrix, 3, 3);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, 3);
}

void test_dead_cells_with_three_live_neighbors_become_alive(void) {
    TEST_IGNORE();
    uint32_t actual[3];
    const uint32_t matrix[] = {
        // clang-format off
        0b110,
        0b000,
        0b100,
        // clang-format on
    };
    const uint32_t expected[] = {
        // clang-format off
        0b000,
        0b110,
        0b000,
        // clang-format on
    };
    tick(actual, matrix, 3, 3);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, 3);
}

void test_live_cells_with_four_or_more_neighbors_die(void) {
    TEST_IGNORE();
    uint32_t actual[3];
    const uint32_t matrix[] = {
        // clang-format off
        0b111,
        0b111,
        0b111,
        // clang-format on
    };
    const uint32_t expected[] = {
        // clang-format off
        0b101,
        0b000,
        0b101,
        // clang-format on
    };
    tick(actual, matrix, 3, 3);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, 3);
}

void test_bigger_matrix(void) {
    TEST_IGNORE();
    uint32_t actual[8];
    const uint32_t matrix[] = {
        // clang-format off
        0b11011000,
        0b10110000,
        0b11100111,
        0b00000110,
        0b10001100,
        0b11000111,
        0b00101001,
        0b10000011,
        // clang-format on
    };
    const uint32_t expected[] = {
        // clang-format off
        0b11011000,
        0b00000110,
        0b10111101,
        0b10000001,
        0b11001001,
        0b11010001,
        0b10000000,
        0b00000011,
        // clang-format on
    };
    tick(actual, matrix, 8, 8);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, 8);
}

void test_matrix_with_0_columns(void) {
    TEST_IGNORE();
    uint32_t actual[5];
    const uint32_t matrix[] = {
        // clang-format off
        0b0,
        0b0,
        0b0,
        0b0,
        0b0,
        // clang-format on
    };
    const uint32_t expected[] = {
        // clang-format off
        0b0,
        0b0,
        0b0,
        0b0,
        0b0,
        // clang-format on
    };
    tick(actual, matrix, 5, 0);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, 5);
}

void test_matrix_with_32_columns(void) {
    TEST_IGNORE();
    uint32_t actual[5];
    const uint32_t matrix[] = {
        // clang-format off
        0b11101100011011101111101101001000,
        0b10111110101100100011100010011000,
        0b11101101000001101011111010110110,
        0b10010001001000000101101010010110,
        0b10010011011100010000110000101100,
        // clang-format on
    };
    const uint32_t expected[] = {
        // clang-format off
        0b10100010011011110100110110011000,
        0b00000001101100001000000010000000,
        0b10000001111101110000001010100010,
        0b10010101011100111100001000000000,
        0b00000011111100000001110000011110,
        // clang-format on
    };
    tick(actual, matrix, 5, 32);
    TEST_ASSERT_EQUAL_UINT32_ARRAY(expected, actual, 5);
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_live_cells_with_zero_live_neighbors_die);
    RUN_TEST(test_live_cells_with_only_one_live_neighbor_die);
    RUN_TEST(test_live_cells_with_two_live_neighbors_stay_alive);
    RUN_TEST(test_live_cells_with_three_live_neighbors_stay_alive);
    RUN_TEST(test_dead_cells_with_three_live_neighbors_become_alive);
    RUN_TEST(test_live_cells_with_four_or_more_neighbors_die);
    RUN_TEST(test_bigger_matrix);
    RUN_TEST(test_matrix_with_0_columns);
    RUN_TEST(test_matrix_with_32_columns);
    return UNITY_END();
}
