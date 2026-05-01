#line 1 "C:/Users/antah/OneDrive/Desktop/Simulatiom/I2C_LCD.c"
#line 1 "c:/users/antah/onedrive/desktop/simulatiom/i2c_lcd.h"








void Lcd_Init_I2C();
void Lcd_Cmd(unsigned char cmd);
void Lcd_Chr(unsigned char row, unsigned char col, char out_char);
void Lcd_Out(unsigned char row, unsigned char col, char *text);
#line 3 "C:/Users/antah/OneDrive/Desktop/Simulatiom/I2C_LCD.c"
unsigned char lcd_backlight = 0x08;


void I2C_LCD_Write(unsigned char d) {
 I2C1_Start();
 I2C1_Wr( 0x4E );
 I2C1_Wr(d | lcd_backlight);
 I2C1_Stop();
}


void Lcd_Pulse(unsigned char d){
 I2C_LCD_Write(d | 0x04);
 Delay_us(1);
 I2C_LCD_Write(d & (~0x04));
 Delay_us(50);
}


void Lcd_Send_Nibble(unsigned char nibble, unsigned char rs){
 unsigned char d = (nibble & 0xF0) | rs;
 Lcd_Pulse(d);
}


void Lcd_Cmd(unsigned char cmd){
 Lcd_Send_Nibble(cmd & 0xF0, 0);
 Lcd_Send_Nibble((cmd << 4) & 0xF0, 0);
 Delay_ms(2);
}


void Lcd_Chr(unsigned char row, unsigned char col, char out_char){
 unsigned char address = (row == 1) ? (0x80 + col - 1) : (0xC0 + col - 1);
 Lcd_Cmd(address);
 Lcd_Send_Nibble(out_char & 0xF0, 1);
 Lcd_Send_Nibble((out_char << 4) & 0xF0, 1);
}


void Lcd_Out(unsigned char row, unsigned char col, char *text){
 while(*text) {
 Lcd_Chr(row, col++, *text++);
 }
}


void Lcd_Init_I2C(){
 Delay_ms(50);
 Lcd_Send_Nibble(0x30, 0);
 Delay_ms(5);
 Lcd_Send_Nibble(0x30, 0);
 Delay_ms(1);
 Lcd_Send_Nibble(0x30, 0);
 Lcd_Send_Nibble(0x20, 0);
 Lcd_Cmd(0x28);
 Lcd_Cmd(0x0C);
 Lcd_Cmd(0x06);
 Lcd_Cmd(0x01);
}
