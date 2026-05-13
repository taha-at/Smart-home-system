#line 1 "C:/Users/AbdElrahman/Downloads/Smart-home-system-main (1)/Smart-home-system-main/I2C_LCD.c"
#line 1 "c:/users/abdelrahman/downloads/smart-home-system-main (1)/smart-home-system-main/i2c_lcd.h"








void Lcd_Init_I2C();
void Lcd_Cmd(unsigned char cmd);
void Lcd_Chr(unsigned char row, unsigned char col, char out_char);
void Lcd_Out(unsigned char row, unsigned char col, char *text);
#line 4 "C:/Users/AbdElrahman/Downloads/Smart-home-system-main (1)/Smart-home-system-main/I2C_LCD.c"
static unsigned char lcd_backlight = 0x08;
#line 22 "C:/Users/AbdElrahman/Downloads/Smart-home-system-main (1)/Smart-home-system-main/I2C_LCD.c"
static void Send_Nibble(unsigned char nibble, unsigned char rs) {
 unsigned char d = (nibble & 0xF0) | rs;


  I2C1_Start(); I2C1_Wr( 0x4E ); I2C1_Wr((d | 0x04) | lcd_backlight); I2C1_Stop() ;
 Delay_us(1);


  I2C1_Start(); I2C1_Wr( 0x4E ); I2C1_Wr((d & 0xFB) | lcd_backlight); I2C1_Stop() ;
 Delay_us(50);
}




void Lcd_Cmd(unsigned char cmd) {
 Send_Nibble(cmd & 0xF0, 0);
 Send_Nibble((cmd << 4) & 0xF0, 0);
 Delay_ms(2);
}






void Lcd_Chr(unsigned char row, unsigned char col, char ch) {
 unsigned char addr;

 addr = (row == 1) ? (0x80 + col - 1) : (0xC0 + col - 1);


 Send_Nibble(addr & 0xF0, 0);
 Send_Nibble((addr << 4) & 0xF0, 0);
 Delay_ms(2);


 Send_Nibble((unsigned char)ch & 0xF0, 1);
 Send_Nibble(((unsigned char)ch << 4) & 0xF0, 1);
}




void Lcd_Out(unsigned char row, unsigned char col, char *text) {
 while(*text) {
 Lcd_Chr(row, col++, *text++);
 }
}






void Lcd_Init_I2C() {
 Delay_ms(50);


 Send_Nibble(0x30, 0);
 Delay_ms(5);
 Send_Nibble(0x30, 0);
 Delay_ms(1);
 Send_Nibble(0x30, 0);


 Send_Nibble(0x20, 0);


 Lcd_Cmd(0x28);
 Lcd_Cmd(0x0C);
 Lcd_Cmd(0x06);
 Lcd_Cmd(0x01);
 Delay_ms(2);
}
