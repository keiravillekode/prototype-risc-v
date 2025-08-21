#include "vendor/unity.h"

#include <stddef.h>

#define BUFFER_SIZE 20

extern void label(char *buffer, const char *first, const char *second, const char *third, const char *fourth);

void setUp(void) {
}

void tearDown(void) {
}

void test_orange_and_orange_and_black(void) {
    char buffer[BUFFER_SIZE];

    label(buffer, "orange", "orange", "black", NULL);
    TEST_ASSERT_EQUAL_STRING("33 ohms", buffer);
}

void test_blue_and_grey_and_brown(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "blue", "grey", "brown", NULL);
    TEST_ASSERT_EQUAL_STRING("680 ohms", buffer);
}

void test_red_and_black_and_red(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "red", "black", "red", NULL);
    TEST_ASSERT_EQUAL_STRING("2 kiloohms", buffer);
}

void test_green_and_brown_and_orange(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "green", "brown", "orange", NULL);
    TEST_ASSERT_EQUAL_STRING("51 kiloohms", buffer);
}

void test_yellow_and_violet_and_yellow(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "yellow", "violet", "yellow", NULL);
    TEST_ASSERT_EQUAL_STRING("470 kiloohms", buffer);
}

void test_blue_and_violet_and_blue(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "blue", "violet", "blue", NULL);
    TEST_ASSERT_EQUAL_STRING("67 megaohms", buffer);
}

void test_minimum_possible_value(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "black", "black", "black", NULL);
    TEST_ASSERT_EQUAL_STRING("0 ohms", buffer);
}

void test_maximum_possible_value(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "white", "white", "white", NULL);
    TEST_ASSERT_EQUAL_STRING("99 gigaohms", buffer);
}

void test_first_two_colors_make_an_invalid_octal_number(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "black", "grey", "black", NULL);
    TEST_ASSERT_EQUAL_STRING("8 ohms", buffer);
}

void test_ignore_extra_colors(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "blue", "green", "yellow", "orange");
    TEST_ASSERT_EQUAL_STRING("650 kiloohms", buffer);
}

void test_orange_and_orange_and_red(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "orange", "orange", "red", NULL);
    TEST_ASSERT_EQUAL_STRING("3.3 kiloohms", buffer);
}

void test_orange_and_orange_and_green(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "orange", "orange", "green", NULL);
    TEST_ASSERT_EQUAL_STRING("3.3 megaohms", buffer);
}

void test_white_and_white_and_violet(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "white", "white", "violet", NULL);
    TEST_ASSERT_EQUAL_STRING("990 megaohms", buffer);
}

void test_white_and_white_and_grey(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];

    label(buffer, "white", "white", "grey", NULL);
    TEST_ASSERT_EQUAL_STRING("9.9 gigaohms", buffer);
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_orange_and_orange_and_black);
    RUN_TEST(test_blue_and_grey_and_brown);
    RUN_TEST(test_red_and_black_and_red);
    RUN_TEST(test_green_and_brown_and_orange);
    RUN_TEST(test_yellow_and_violet_and_yellow);
    RUN_TEST(test_blue_and_violet_and_blue);
    RUN_TEST(test_minimum_possible_value);
    RUN_TEST(test_maximum_possible_value);
    RUN_TEST(test_first_two_colors_make_an_invalid_octal_number);
    RUN_TEST(test_ignore_extra_colors);
    RUN_TEST(test_orange_and_orange_and_red);
    RUN_TEST(test_orange_and_orange_and_green);
    RUN_TEST(test_white_and_white_and_violet);
    RUN_TEST(test_white_and_white_and_grey);
    return UNITY_END();
}
