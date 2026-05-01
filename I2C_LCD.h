#ifndef _I2C_LCD_H_
#define _I2C_LCD_H_

// Default I2C Address for most PCF8574 backpacks is 0x27.
// MikroC I2C1_Wr() expects the 8-bit address (0x27 << 1 = 0x4E).
#define LCD_ADDR 0x4E

// Function Prototypes
void Lcd_Init_I2C();
void Lcd_Cmd(unsigned char cmd);
void Lcd_Chr(unsigned char row, unsigned char col, char out_char);
void Lcd_Out(unsigned char row, unsigned char col, char *text);

#endif