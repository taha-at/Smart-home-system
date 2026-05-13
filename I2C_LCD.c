#include "I2C_LCD.h"

// Backlight bit (bit3 of PCF8574)
static unsigned char lcd_backlight = 0x08;

// ================================================
//  LOW-LEVEL: Send one raw byte to PCF8574
//  Inlined to keep stack depth at 1 level
// ================================================
#define LCD_I2C_SEND(b)          \
    I2C1_Start();                \
    I2C1_Wr(LCD_ADDR);          \
    I2C1_Wr((b) | lcd_backlight);\
    I2C1_Stop()

// ================================================
//  LOW-LEVEL: Send one nibble (4 bits) + RS flag
//  Generates Enable pulse inline — no sub-call
//  nibble : upper 4 bits hold the data (D7-D4)
//  rs     : 0 = command, 1 = data
// ================================================
static void Send_Nibble(unsigned char nibble, unsigned char rs) {
    unsigned char d = (nibble & 0xF0) | rs;

    // En = 1
    LCD_I2C_SEND(d | 0x04);
    Delay_us(1);

    // En = 0
    LCD_I2C_SEND(d & 0xFB);
    Delay_us(50);
}

// ================================================
//  Send full byte as two nibbles — COMMAND (RS=0)
// ================================================
void Lcd_Cmd(unsigned char cmd) {
    Send_Nibble(cmd & 0xF0,        0);   // high nibble
    Send_Nibble((cmd << 4) & 0xF0, 0);   // low nibble
    Delay_ms(2);
}

// ================================================
//  Write one character at (row, col)
//  Avoids calling Lcd_Cmd() from here to save
//  one stack level — sets DDRAM address inline
// ================================================
void Lcd_Chr(unsigned char row, unsigned char col, char ch) {
    unsigned char addr;

    addr = (row == 1) ? (0x80 + col - 1) : (0xC0 + col - 1);

    // Send address command inline (RS=0)
    Send_Nibble(addr & 0xF0,        0);
    Send_Nibble((addr << 4) & 0xF0, 0);
    Delay_ms(2);

    // Send character data (RS=1)
    Send_Nibble((unsigned char)ch & 0xF0,        1);
    Send_Nibble(((unsigned char)ch << 4) & 0xF0, 1);
}

// ================================================
//  Write null-terminated string starting at (row, col)
// ================================================
void Lcd_Out(unsigned char row, unsigned char col, char *text) {
    while(*text) {
        Lcd_Chr(row, col++, *text++);
    }
}

// ================================================
//  Initialize LCD in 4-bit mode over I2C
//  Call stack from main: main -> Lcd_Init_I2C
//                               -> Send_Nibble (1 deep only)
// ================================================
void Lcd_Init_I2C() {
    Delay_ms(50);

    // Wake-up sequence (8-bit mode pulses)
    Send_Nibble(0x30, 0);
    Delay_ms(5);
    Send_Nibble(0x30, 0);
    Delay_ms(1);
    Send_Nibble(0x30, 0);

    // Switch to 4-bit mode
    Send_Nibble(0x20, 0);

    // Configuration commands
    Lcd_Cmd(0x28);   // 4-bit, 2-line, 5x8 font
    Lcd_Cmd(0x0C);   // Display ON, Cursor OFF
    Lcd_Cmd(0x06);   // Entry mode: auto-increment
    Lcd_Cmd(0x01);   // Clear display
    Delay_ms(2);
}