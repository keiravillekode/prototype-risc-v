#include "vendor/unity.h"

#include <stddef.h>
#include <stdint.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))

extern int can_chain(size_t domino_count, const uint8_t *dominoes);

void setUp(void) {
}

void tearDown(void) {
}

void test_empty_input__empty_output(void) {
    TEST_ASSERT_TRUE(can_chain(0, NULL));
}

void test_singleton_input__singleton_output(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x11};
    TEST_ASSERT_TRUE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_singleton_that_cant_be_chained(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12};
    TEST_ASSERT_FALSE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_three_elements(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12, 0x31, 0x23};
    TEST_ASSERT_TRUE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_can_reverse_dominoes(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12, 0x13, 0x23};
    TEST_ASSERT_TRUE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_cant_be_chained(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12, 0x41, 0x23};
    TEST_ASSERT_FALSE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_disconnected__simple(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x11, 0x22};
    TEST_ASSERT_FALSE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_disconnected__double_loop(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12, 0x21, 0x34, 0x43};
    TEST_ASSERT_FALSE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_disconnected__single_isolated(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12, 0x23, 0x31, 0x44};
    TEST_ASSERT_FALSE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_need_backtrack(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12, 0x23, 0x31, 0x24, 0x24};
    TEST_ASSERT_TRUE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_separate_loops(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12, 0x23, 0x31, 0x11, 0x22, 0x33};
    TEST_ASSERT_TRUE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_nine_elements(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12, 0x53, 0x31, 0x12, 0x24, 0x16, 0x23, 0x34, 0x56};
    TEST_ASSERT_TRUE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

void test_separate_threedomino_loops(void) {
    TEST_IGNORE();
    const uint8_t dominoes[] = {0x12, 0x23, 0x31, 0x45, 0x56, 0x64};
    TEST_ASSERT_FALSE(can_chain(ARRAY_SIZE(dominoes), dominoes));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_empty_input__empty_output);
    RUN_TEST(test_singleton_input__singleton_output);
    RUN_TEST(test_singleton_that_cant_be_chained);
    RUN_TEST(test_three_elements);
    RUN_TEST(test_can_reverse_dominoes);
    RUN_TEST(test_cant_be_chained);
    RUN_TEST(test_disconnected__simple);
    RUN_TEST(test_disconnected__double_loop);
    RUN_TEST(test_disconnected__single_isolated);
    RUN_TEST(test_need_backtrack);
    RUN_TEST(test_separate_loops);
    RUN_TEST(test_nine_elements);
    RUN_TEST(test_separate_threedomino_loops);
    return UNITY_END();
}
