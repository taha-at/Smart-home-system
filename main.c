#include "I2C_LCD.h"

// DHT11 Pin Definitions
#define DHT11_Data_Pin       RD5_bit
#define DHT11_Data_Direction TRISD5_bit

// Global Variables
unsigned char Check_bit, Temp_byte_1, Temp_byte_2, RH_byte_1, RH_byte_2;
unsigned char Temperature, RH, Sumation;

// --- DHT11 Function Prototypes ---
void dht11_init();
void find_response();
char read_dht11();

void main() {
    ADCON1 = 0x07;      // Configure all pins as digital (crucial for PIC16F877A)
    I2C1_Init(100000);  // Initialize I2C at 100kHz
    Delay_ms(100);
    
    Lcd_Init_I2C();     // Initialize our custom I2C LCD library

    while(1){
        dht11_init();
        find_response();

        if(Check_bit == 1){
            RH_byte_1 = read_dht11();
            RH_byte_2 = read_dht11();
            Temp_byte_1 = read_dht11();
            Temp_byte_2 = read_dht11();
            Sumation   = read_dht11();

            // Verify Checksum
            if(Sumation == ((RH_byte_1 + RH_byte_2 + Temp_byte_1 + Temp_byte_2) & 0xFF)){
                Temperature = Temp_byte_1;
                RH = RH_byte_1;

                Lcd_Cmd(0x01); // Clear screen
                
                Lcd_Out(1,1,"Temp:");
                Lcd_Chr(1,7,(Temperature/10)+'0');
                Lcd_Chr(1,8,(Temperature%10)+'0');
                Lcd_Chr(1,9,223); // Degree symbol
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
        
        // The DHT11 needs about 2 seconds between measurements to stabilize
        Delay_ms(2000); 
    }
}

// --- DHT11 Logic ---
void dht11_init(){
    DHT11_Data_Direction = 0; // Set as Output
    DHT11_Data_Pin = 0;       // Send Start Signal (Low)
    Delay_ms(18);             // Hold low for at least 18ms
    DHT11_Data_Pin = 1;       // Pull high
    Delay_us(30);             // Wait for response
    DHT11_Data_Direction = 1; // Set as Input to read sensor
}

void find_response(){
    Check_bit = 0;
    Delay_us(40);
    if(!DHT11_Data_Pin){
        Delay_us(80);
        if(DHT11_Data_Pin) Check_bit = 1;
    }
    while(DHT11_Data_Pin); // Wait for sensor to finish response signal
}

char read_dht11(){
    char i, d = 0;
    for(i = 0; i < 8; i++){
        while(!DHT11_Data_Pin); // Wait for the start of the bit pulse
        Delay_us(30);           // If still high after 30us, bit is '1'
        if(DHT11_Data_Pin) {
            d = (d << 1) | 1;
            while(DHT11_Data_Pin); // Wait for bit pulse to end
        }
        else {
            d = (d << 1);
        }
    }
    return d;
}
