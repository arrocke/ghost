#include "screen.h"

#define TEXT_WIDTH 80
#define TEXT_HEIGHT 25
#define VIDEO_MEMORY_ADDR 0xb8000
#define WHITE 0xF
#define BLACK 0x0

char settings = (BLACK << 4) | WHITE;
int x = 0;
int y = 0;

void write_char(unsigned char ch, unsigned char fg, unsigned char bg, int x, int y) {
    unsigned char* video_memory = (unsigned char*)VIDEO_MEMORY_ADDR;
    int offset = 2 * (y * TEXT_WIDTH + x);
    video_memory[offset] = ch;
    video_memory[offset + 1] = (bg << 4) | (fg & 0xF);
}

void shift_up() {
    unsigned char* video_memory = (unsigned char*)VIDEO_MEMORY_ADDR;

    int next_row = 2 * TEXT_WIDTH;
    for (int i = 0; i < TEXT_WIDTH; i++) {
        for (int j = 0; j < TEXT_HEIGHT - 1; j++) {
            int offset = 2 * (j * TEXT_WIDTH + i);
            video_memory[offset] = video_memory[offset + next_row];
            video_memory[offset + 1] = video_memory[offset + next_row + 1];
        }
    }
    for (int i = 0; i < TEXT_WIDTH; i++) {
        int offset = 2 * ((TEXT_HEIGHT - 1) * TEXT_WIDTH + i);
        video_memory[offset] = 0;
        video_memory[offset + 1] = 0;
    }
}

void increment_cursor() {
    x += 1;
    if (x == TEXT_WIDTH) {
        x = 0;
        y += 1;
    }
    if (y == TEXT_HEIGHT) {
        x = 0;
        y = 0;
        shift_up();
    }
}

void new_line() {
    x = 0;
    y += 1;

    if (y == TEXT_HEIGHT) {
        y = 0;
        shift_up();
    }
}

void print(char* str) {
    for (; *str != 0; str += 1) {
        if (*str == '\n') {
            new_line(); 
            continue;
        }

        write_char(*str, WHITE, BLACK, x, y);
        increment_cursor();
    }
}

void print_ln(char* str) {
    print(str);
    new_line();
}

void clear() {
    unsigned char* video_memory = (unsigned char*)VIDEO_MEMORY_ADDR;

    for (int i = 0; i < TEXT_WIDTH; i++) {
        for (int j = 0; j < TEXT_HEIGHT; j++) {
            int offset = 2 * (j * TEXT_WIDTH + i);
            video_memory[offset] = 0;
            video_memory[offset + 1] = 0;
        }
    }

    x = 0;
    y = 0;
}


