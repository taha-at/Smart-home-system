#line 1 "C:/Users/AbdElrahman/Downloads/Smart-home-system-main (1)/Smart-home-system-main/main.c"
#line 1 "c:/users/abdelrahman/downloads/smart-home-system-main (1)/smart-home-system-main/i2c_lcd.h"








void Lcd_Init_I2C();
void Lcd_Cmd(unsigned char cmd);
void Lcd_Chr(unsigned char row, unsigned char col, char out_char);
void Lcd_Out(unsigned char row, unsigned char col, char *text);
#line 29 "C:/Users/AbdElrahman/Downloads/Smart-home-system-main (1)/Smart-home-system-main/main.c"
unsigned char Check_bit, Temp_byte_1, Temp_byte_2;
unsigned char RH_byte_1, RH_byte_2;
unsigned char Temperature = 0, RH = 0, Sumation;

unsigned char pir_state, pir_last = 255;
unsigned char mq2_raw, mq2_last = 255;

unsigned char last_temp = 255;
unsigned char last_rh = 255;

unsigned int dht_timer = 0;
unsigned char first_read = 1;




unsigned int pir_led_timer = 0;




unsigned int buzzer_timer = 0;
unsigned char buzzer_active = 0;
unsigned char alarm_latched = 0;




void dht11_init();
void find_response();
char read_dht11();

void UART_Init();
void UART_Send(char c);
void UART_SendString(char *str);
void Send_Sensors();





void main() {

 ADCON1 = 0x07;


  TRISD6_bit  = 1;
  TRISD7_bit  = 1;


  TRISB0_bit  = 0;
  RB0_bit  = 0;


  TRISB1_bit  = 0;
  RB1_bit  = 0;


 UART_Init();


 I2C1_Init(100000);
 Delay_ms(100);

 I2C1_Init(100000);
 Delay_ms(100);

 Lcd_Init_I2C();
 Delay_ms(50);


 Lcd_Out(1,1,"T:    PIR:     ");
 Lcd_Out(2,1,"H:    GAS:     ");

 while(1) {




 pir_state =  RD6_bit ;
 mq2_raw =  RD7_bit ;




 if(pir_state){


  RB0_bit  = 1;


 pir_led_timer = 0;
 }
 else{


 if(pir_led_timer < 5000)
 pir_led_timer += 50;
 else
  RB0_bit  = 0;
 }




 if(pir_state != pir_last){

 if(pir_state)
 Lcd_Out(1,12,"ON ");
 else
 Lcd_Out(1,12,"OFF");

 pir_last = pir_state;

 Delay_ms(2);
 }




 if(mq2_raw != mq2_last){

 if(mq2_raw ==  0 )
 Lcd_Out(2,12,"ON ");
 else
 Lcd_Out(2,12,"OFF");

 mq2_last = mq2_raw;

 Delay_ms(2);
 }




 if(first_read || dht_timer >= 2000) {

 first_read = 0;
 dht_timer = 0;

 dht11_init();
 find_response();

 if(Check_bit == 1) {

 RH_byte_1 = read_dht11();
 RH_byte_2 = read_dht11();

 Temp_byte_1 = read_dht11();
 Temp_byte_2 = read_dht11();

 Sumation = read_dht11();

 if(Sumation == ((RH_byte_1 + RH_byte_2 +
 Temp_byte_1 + Temp_byte_2) & 0xFF)) {

 Temperature = Temp_byte_1;
 RH = RH_byte_1;




 if(Temperature != last_temp){

 Lcd_Chr(1,3,(Temperature/10)+'0');
 Lcd_Chr(1,4,(Temperature%10)+'0');
 Lcd_Chr(1,5,223);
 Lcd_Chr(1,6,'C');

 last_temp = Temperature;

 Delay_ms(2);
 }




 if(RH != last_rh){

 Lcd_Chr(2,3,(RH/10)+'0');
 Lcd_Chr(2,4,(RH%10)+'0');
 Lcd_Chr(2,5,'%');

 last_rh = RH;

 Delay_ms(2);
 }
 }
 }
 }




 if( ((mq2_raw ==  0 ) || (RH > 60))
 && !alarm_latched ){

  RB1_bit  = 1;

 buzzer_active = 1;

 buzzer_timer = 0;

 alarm_latched = 1;
 }


 if( (mq2_raw !=  0 ) && (RH <= 60) ){

 alarm_latched = 0;
 }




 if(buzzer_active){

 buzzer_timer += 50;

 if(buzzer_timer >= 3000){

  RB1_bit  = 0;

 buzzer_active = 0;
 }
 }




 Send_Sensors();




 Delay_ms(50);

 dht_timer += 50;
 }
}




void dht11_init() {

  TRISD5_bit  = 0;

  RD5_bit  = 0;

 Delay_ms(18);

  RD5_bit  = 1;

 Delay_us(30);

  TRISD5_bit  = 1;
}

void find_response() {

 Check_bit = 0;

 Delay_us(40);

 if(! RD5_bit ) {

 Delay_us(80);

 if( RD5_bit )
 Check_bit = 1;
 }

 while( RD5_bit );
}

char read_dht11() {

 char i, d = 0;

 for(i = 0; i < 8; i++) {

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




void UART_Init() {

 TRISC6_bit = 0;
 TRISC7_bit = 1;

 SPBRG = 129;

 BRGH_bit = 1;
 TXEN_bit = 1;
 SPEN_bit = 1;
 CREN_bit = 1;
}

void UART_Send(char c) {

 while(!TRMT_bit);

 TXREG = c;
}

void UART_SendString(char *str) {

 while(*str)
 UART_Send(*str++);
}

void Send_Sensors() {

 UART_SendString("T:");
 UART_Send(Temperature/10 + '0');
 UART_Send(Temperature%10 + '0');

 UART_SendString(",H:");
 UART_Send(RH/10 + '0');
 UART_Send(RH%10 + '0');

 UART_SendString(",PIR:");
 UART_Send(pir_state + '0');

 UART_SendString(",GAS:");
 UART_Send(mq2_raw + '0');

 UART_Send('\n');
}
