#include "vendor/unity.h"

#define BUFFER_SIZE 2000

extern void slices(char *buffer, const char *series, int slice_length);

void setUp(void) {
}

void tearDown(void) {
}

void test_slices_of_one_from_one(void) {
    const char expected[] =
        "1";
    char buffer[BUFFER_SIZE];

    slices(buffer, "1", 1);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_slices_of_one_from_two(void) {
    TEST_IGNORE();
    const char expected[] =
        "1, "
        "2";
    char buffer[BUFFER_SIZE];

    slices(buffer, "12", 1);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_slices_of_two(void) {
    TEST_IGNORE();
    const char expected[] =
        "35";
    char buffer[BUFFER_SIZE];

    slices(buffer, "35", 2);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_slices_of_two_overlap(void) {
    TEST_IGNORE();
    const char expected[] =
        "91, "
        "14, "
        "42";
    char buffer[BUFFER_SIZE];

    slices(buffer, "9142", 2);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_slices_can_include_duplicates(void) {
    TEST_IGNORE();
    const char expected[] =
        "777, "
        "777, "
        "777, "
        "777";
    char buffer[BUFFER_SIZE];

    slices(buffer, "777777", 3);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_slices_of_a_long_series(void) {
    TEST_IGNORE();
    const char expected[] =
        "91849, "
        "18493, "
        "84939, "
        "49390, "
        "93904, "
        "39042, "
        "90424, "
        "04243";
    char buffer[BUFFER_SIZE];

    slices(buffer, "918493904243", 5);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_slice_length_is_too_large(void) {
    TEST_IGNORE();
    const char expected[] = "";
    char buffer[BUFFER_SIZE];

    slices(buffer, "12345", 6);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_slice_length_is_way_too_large(void) {
    TEST_IGNORE();
    const char expected[] = "";
    char buffer[BUFFER_SIZE];

    slices(buffer, "12345", 42);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_slice_length_cannot_be_zero(void) {
    TEST_IGNORE();
    const char expected[] = "";
    char buffer[BUFFER_SIZE];

    slices(buffer, "12345", 0);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_slice_length_cannot_be_negative(void) {
    TEST_IGNORE();
    const char expected[] = "";
    char buffer[BUFFER_SIZE];

    slices(buffer, "123", -1);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_empty_series_is_invalid(void) {
    TEST_IGNORE();
    const char expected[] = "";
    char buffer[BUFFER_SIZE];

    slices(buffer, "", 1);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_slices_of_one_from_one);
    RUN_TEST(test_slices_of_one_from_two);
    RUN_TEST(test_slices_of_two);
    RUN_TEST(test_slices_of_two_overlap);
    RUN_TEST(test_slices_can_include_duplicates);
    RUN_TEST(test_slices_of_a_long_series);
    RUN_TEST(test_slice_length_is_too_large);
    RUN_TEST(test_slice_length_is_way_too_large);
    RUN_TEST(test_slice_length_cannot_be_zero);
    RUN_TEST(test_slice_length_cannot_be_negative);
    RUN_TEST(test_empty_series_is_invalid);
    return UNITY_END();
}
