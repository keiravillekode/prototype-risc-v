#include "vendor/unity.h"

#define BUFFER_SIZE 400

extern void recite(char *buffer, const char *strings);

void setUp(void) {
}

void tearDown(void) {
}

void test_zero_pieces(void) {
    char buffer[BUFFER_SIZE];
    const char *strings = "";
    const char *expected = "";
    recite(buffer, strings);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_one_piece(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];
    const char *strings = "nail\n";
    const char *expected = "And all for the want of a nail.\n";
    recite(buffer, strings);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_two_pieces(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];
    const char *strings = "nail\nshoe\n";
    const char *expected = "For want of a nail the shoe was lost.\nAnd all for the want of a nail.\n";
    recite(buffer, strings);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_three_pieces(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];
    const char *strings = "nail\nshoe\nhorse\n";
    const char *expected = "For want of a nail the shoe was lost.\nFor want of a shoe the horse was lost.\nAnd all for the want of a nail.\n";
    recite(buffer, strings);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_full_proverb(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];
    const char *strings = "nail\nshoe\nhorse\nrider\nmessage\nbattle\nkingdom\n";
    const char *expected = "For want of a nail the shoe was lost.\nFor want of a shoe the horse was lost.\nFor want of a horse the rider was lost.\nFor want of a rider the message was lost.\nFor want of a message the battle was lost.\nFor want of a battle the kingdom was lost.\nAnd all for the want of a nail.\n";
    recite(buffer, strings);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

void test_four_pieces_modernized(void) {
    TEST_IGNORE();
    char buffer[BUFFER_SIZE];
    const char *strings = "pin\ngun\nsoldier\nbattle\n";
    const char *expected = "For want of a pin the gun was lost.\nFor want of a gun the soldier was lost.\nFor want of a soldier the battle was lost.\nAnd all for the want of a pin.\n";
    recite(buffer, strings);
    TEST_ASSERT_EQUAL_STRING(expected, buffer);
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_zero_pieces);
    RUN_TEST(test_one_piece);
    RUN_TEST(test_two_pieces);
    RUN_TEST(test_three_pieces);
    RUN_TEST(test_full_proverb);
    RUN_TEST(test_four_pieces_modernized);
    return UNITY_END();
}
