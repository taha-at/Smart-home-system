#include "I2C_LCD.h"

// ================================================
//  Pin Definitions
// ================================================
#define DHT11_Data_Pin        RD5_bit
#define DHT11_Data_Direction  TRISD5_bit

#define PIR_Pin               RD6_bit
#define PIR_Direction         TRISD6_bit

#define MQ2_Pin               RD7_bit
#define MQ2_Direction         TRISD7_bit

#define LED_Pin               RB0_bit
#define LED_Direction         TRISB0_bit

#define BUZZER_Pin            RB1_bit
#define BUZZER_Direction      TRISB1_bit

// ================================================
//  CONFIG
// ================================================
#define GAS_ACTIVE_STATE 0

// ================================================
//  Global Variables
// ================================================
unsigned char Check_bit, Temp_byte_1, Temp_byte_2;
unsigned char RH_byte_1, RH_byte_2;
unsigned char Temperature = 0, RH = 0, Sumation;

unsigned char pir_state, pir_last = 255;
unsigned char mq2_raw, mq2_last = 255;

unsigned char last_temp = 255;
unsigned char last_rh   = 255;

unsigned int dht_timer = 0;
unsigned char first_read = 1;

// ================================================
//  LED Variables
// ================================================
unsigned int pir_led_timer = 0;

// ================================================
//  Buzzer Variables
// ================================================
unsigned int buzzer_timer = 0;
unsigned char buzzer_active = 0;
unsigned char alarm_latched = 0;

// ================================================
//  Function Prototypes
// ================================================
void dht11_init();
void find_response();
char read_dht11();

void UART_Init();
void UART_Send(char c);
void UART_SendString(char *str);
void Send_Sensors();


// ================================================
//  MAIN
// ================================================
void main() {

    ADCON1 = 0x07;

    // Sensor directions
    PIR_Direction = 1;
    MQ2_Direction = 1;

    // LED setup
    LED_Direction = 0;
    LED_Pin = 0;

    // Buzzer setup
    BUZZER_Direction = 0;
    BUZZER_Pin = 0;

    // UART Init
    UART_Init();

    // LCD Init
    I2C1_Init(100000);
    Delay_ms(100);

    I2C1_Init(100000);
    Delay_ms(100);

    Lcd_Init_I2C();
    Delay_ms(50);

    // LCD Static Labels
    Lcd_Out(1,1,"T:    PIR:     ");
    Lcd_Out(2,1,"H:    GAS:     ");

    while(1) {

        // =====================================
        // Read Sensors
        // =====================================
        pir_state = PIR_Pin;
        mq2_raw   = MQ2_Pin;

        // =====================================
        // PIR LED Logic
        // =====================================
        if(pir_state){

            // Turn LED ON
            LED_Pin = 1;

            // Reset timer
            pir_led_timer = 0;
        }
        else{

            // Count no-motion time
            if(pir_led_timer < 5000)
                pir_led_timer += 50;
            else
                LED_Pin = 0;
        }

        // =====================================
        // PIR LCD Update
        // =====================================
        if(pir_state != pir_last){

            if(pir_state)
                Lcd_Out(1,12,"ON ");
            else
                Lcd_Out(1,12,"OFF");

            pir_last = pir_state;

            Delay_ms(2);
        }

        // =====================================
        // GAS LCD Update
        // =====================================
        if(mq2_raw != mq2_last){

            if(mq2_raw == GAS_ACTIVE_STATE)
                Lcd_Out(2,12,"ON ");
            else
                Lcd_Out(2,12,"OFF");

            mq2_last = mq2_raw;

            Delay_ms(2);
        }

        // =====================================
        // DHT11 Read Every 2 Seconds
        // =====================================
        if(first_read || dht_timer >= 2000) {

            first_read = 0;
            dht_timer = 0;

            dht11_init();
            find_response();

            if(Check_bit == 1) {

                RH_byte_1   = read_dht11();
                RH_byte_2   = read_dht11();

                Temp_byte_1 = read_dht11();
                Temp_byte_2 = read_dht11();

                Sumation    = read_dht11();

                if(Sumation == ((RH_byte_1 + RH_byte_2 +
                                 Temp_byte_1 + Temp_byte_2) & 0xFF)) {

                    Temperature = Temp_byte_1;
                    RH = RH_byte_1;

                    // =============================
                    // TEMP LCD Update
                    // =============================
                    if(Temperature != last_temp){

                        Lcd_Chr(1,3,(Temperature/10)+'0');
                        Lcd_Chr(1,4,(Temperature%10)+'0');
                        Lcd_Chr(1,5,223);
                        Lcd_Chr(1,6,'C');

                        last_temp = Temperature;

                        Delay_ms(2);
                    }

                    // =============================
                    // HUMIDITY LCD Update
                    // =============================
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

        // =====================================
        // BUZZER TRIGGER LOGIC
        // =====================================
        if( ((mq2_raw == GAS_ACTIVE_STATE) || (RH > 60))
            && !alarm_latched ){

            BUZZER_Pin = 1;

            buzzer_active = 1;

            buzzer_timer = 0;

            alarm_latched = 1;
        }

        // Reset latch when alarm conditions disappear
        if( (mq2_raw != GAS_ACTIVE_STATE) && (RH <= 60) ){

            alarm_latched = 0;
        }

        // =====================================
        // BUZZER TIMER
        // =====================================
        if(buzzer_active){

            buzzer_timer += 50;

            if(buzzer_timer >= 3000){

                BUZZER_Pin = 0;

                buzzer_active = 0;
            }
        }

        // =====================================
        // UART Send
        // =====================================
        Send_Sensors();

        // =====================================
        // Main Loop Timing
        // =====================================
        Delay_ms(50);

        dht_timer += 50;
    }
}

// ================================================
//  DHT11 FUNCTIONS
// ================================================
void dht11_init() {

    DHT11_Data_Direction = 0;

    DHT11_Data_Pin = 0;

    Delay_ms(18);

    DHT11_Data_Pin = 1;

    Delay_us(30);

    DHT11_Data_Direction = 1;
}

void find_response() {

    Check_bit = 0;

    Delay_us(40);

    if(!DHT11_Data_Pin) {

        Delay_us(80);

        if(DHT11_Data_Pin)
            Check_bit = 1;
    }

    while(DHT11_Data_Pin);
}

char read_dht11() {

    char i, d = 0;

    for(i = 0; i < 8; i++) {

        while(!DHT11_Data_Pin);

        Delay_us(30);

        if(DHT11_Data_Pin) {

            d = (d << 1) | 1;

            while(DHT11_Data_Pin);
        }
        else {

            d = (d << 1);
        }
    }

    return d;
}

// ================================================
//  UART FUNCTIONS
// ================================================
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