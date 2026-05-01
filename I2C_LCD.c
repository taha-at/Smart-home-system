#include "I2C_LCD.h"

unsigned char lcd_backlight = 0x08; // 0x08 turns on the backlight bit

// Internal helper to send a byte over I2C to the PCF8574
void I2C_LCD_Write(unsigned char d) {
    I2C1_Start();
    I2C1_Wr(LCD_ADDR);
    I2C1_Wr(d | lcd_backlight);
    I2C1_Stop();
}

// Generates the Enable pulse
void Lcd_Pulse(unsigned char d){
    I2C_LCD_Write(d | 0x04);   // En = 1
    Delay_us(1);
    I2C_LCD_Write(d & (~0x04)); // En = 0
    Delay_us(50);
}

// Sends 4 bits (nibble) with RS bit
void Lcd_Send_Nibble(unsigned char nibble, unsigned char rs){
    unsigned char d = (nibble & 0xF0) | rs;
    Lcd_Pulse(d);
}

// Sends a command to the LCD
void Lcd_Cmd(unsigned char cmd){
    Lcd_Send_Nibble(cmd & 0xF0, 0);
    Lcd_Send_Nibble((cmd << 4) & 0xF0, 0);
    Delay_ms(2);
}

// Writes a character at specific position
void Lcd_Chr(unsigned char row, unsigned char col, char out_char){
    unsigned char address = (row == 1) ? (0x80 + col - 1) : (0xC0 + col - 1);
    Lcd_Cmd(address);
    Lcd_Send_Nibble(out_char & 0xF0, 1);
    Lcd_Send_Nibble((out_char << 4) & 0xF0, 1);
}

// Writes a string starting at specific position
void Lcd_Out(unsigned char row, unsigned char col, char *text){
    while(*text) {
        Lcd_Chr(row, col++, *text++);
    }
}

// Initializes the LCD in 4-bit mode over I2C
void Lcd_Init_I2C(){
    Delay_ms(50);
    Lcd_Send_Nibble(0x30, 0);
    Delay_ms(5);
    Lcd_Send_Nibble(0x30, 0);
    Delay_ms(1);
    Lcd_Send_Nibble(0x30, 0);
    Lcd_Send_Nibble(0x20, 0);
    Lcd_Cmd(0x28); // 4-bit, 2-line, 5x8 font
    Lcd_Cmd(0x0C); // Display ON, Cursor OFF
    Lcd_Cmd(0x06); // Entry mode: Auto-increment
    Lcd_Cmd(0x01); // Clear display
}