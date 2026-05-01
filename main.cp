#line 1 "C:/Users/antah/OneDrive/Desktop/Simulatiom/main.c"
#line 1 "c:/users/antah/onedrive/desktop/simulatiom/i2c_lcd.h"








void Lcd_Init_I2C();
void Lcd_Cmd(unsigned char cmd);
void Lcd_Chr(unsigned char row, unsigned char col, char out_char);
void Lcd_Out(unsigned char row, unsigned char col, char *text);
#line 8 "C:/Users/antah/OneDrive/Desktop/Simulatiom/main.c"
unsigned char Check_bit, Temp_byte_1, Temp_byte_2, RH_byte_1, RH_byte_2;
unsigned char Temperature, RH, Sumation;


void dht11_init();
void find_response();
char read_dht11();

void main() {
 ADCON1 = 0x07;
 I2C1_Init(100000);
 Delay_ms(100);

 Lcd_Init_I2C();

 while(1){
 dht11_init();
 find_response();

 if(Check_bit == 1){
 RH_byte_1 = read_dht11();
 RH_byte_2 = read_dht11();
 Temp_byte_1 = read_dht11();
 Temp_byte_2 = read_dht11();
 Sumation = read_dht11();


 if(Sumation == ((RH_byte_1 + RH_byte_2 + Temp_byte_1 + Temp_byte_2) & 0xFF)){
 Temperature = Temp_byte_1;
 RH = RH_byte_1;

 Lcd_Cmd(0x01);

 Lcd_Out(1,1,"Temp:");
 Lcd_Chr(1,7,(Temperature/10)+'0');
 Lcd_Chr(1,8,(Temperature%10)+'0');
 Lcd_Chr(1,9,223);
 Lcd_Chr(1,10,'C');

 Lcd_Out(2,1,"Hum:");
 Lcd_Chr(2,6,(RH/10)+'0');
 Lcd_Chr(2,7,(RH%10)+'0');
 Lcd_Chr(2,8,'%');
 }
 else {
 Lcd_Cmd(0x01);
 Lcd_Out(1,1,"Checksum Error");
 }
 }
 else {
 Lcd_Cmd(0x01);
 Lcd_Out(1,1,"No Response");
 }


 Delay_ms(2000);
 }
}


void dht11_init(){
  TRISD5_bit  = 0;
  RD5_bit  = 0;
 Delay_ms(18);
  RD5_bit  = 1;
 Delay_us(30);
  TRISD5_bit  = 1;
}

void find_response(){
 Check_bit = 0;
 Delay_us(40);
 if(! RD5_bit ){
 Delay_us(80);
 if( RD5_bit ) Check_bit = 1;
 }
 while( RD5_bit );
}

char read_dht11(){
 char i, d = 0;
 for(i = 0; i < 8; i++){
 while(! RD5_bit );
 Delay_us(30);
 if( RD5_bit ) {
 d = (d << 1) | 1;
 while( RD5_bit );
 }
 else {
 d = (d << 1);
 }
 }
 return d;
}
