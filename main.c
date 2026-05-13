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

// LED on RB2
#define LED_Pin               RB2_bit
#define LED_Direction         TRISB2_bit

#define BUZZER_Pin            RB1_bit
#define BUZZER_Direction      TRISB1_bit

// Push button on RB0 (INT0 pin)
#define BUTTON_Pin            RB0_bit
#define BUTTON_Direction      TRISB0_bit

// ================================================
//  CONFIG
// ================================================
#define GAS_ACTIVE_STATE 0

// ================================================
//  UART Command Definitions
//  Raspberry Pi sends a single binary byte:
//    0x01 (logic 1) -> Silence the buzzer (same as button press)
// ================================================
#define UART_CMD_SILENCE  0x01

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
// buzzer_active   : 1 = buzzer is currently ringing
// alarm_latched   : 1 = alarm condition was seen (prevents re-trigger until cleared)
// buzzer_silenced : 1 = user pressed button OR Pi sent 'S' to silence this alarm event
unsigned char buzzer_active   = 0;
unsigned char alarm_latched   = 0;
unsigned char buzzer_silenced = 0;

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
void UART_CheckCommand();

void Interrupt_Init();
void Silence_Buzzer();

// ================================================
//  Silence_Buzzer
//  Shared logic used by both the hardware INT0
//  and the UART software command from the Pi.
// ================================================
void Silence_Buzzer() {

    BUZZER_Pin      = 0;
    buzzer_active   = 0;
    buzzer_silenced = 1;
}

// ================================================
//  INT0 Interrupt Service Routine
//  Triggered on falling edge of RB0 (button press)
//  -> silences the buzzer immediately
// ================================================
void interrupt() {

    if(INTF_bit) {

        Silence_Buzzer();

        // Clear the interrupt flag
        INTF_bit = 0;
    }
}

// ================================================
//  MAIN
// ================================================
void main() {

    ADCON1 = 0x07;

    // Sensor directions
    PIR_Direction    = 1;
    MQ2_Direction    = 1;

    // Push button: input on RB0
    BUTTON_Direction = 1;

    // LED setup on RB2
    LED_Direction = 0;
    LED_Pin       = 0;

    // Buzzer setup
    BUZZER_Direction = 0;
    BUZZER_Pin       = 0;

    // External Interrupt (INT0 on RB0)
    Interrupt_Init();

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
        // Check UART for Pi Commands FIRST
        // so the Pi can silence the buzzer with
        // minimal latency each loop iteration.
        // =====================================
        UART_CheckCommand();

        // =====================================
        // Read Sensors
        // =====================================
        pir_state = PIR_Pin;
        mq2_raw   = MQ2_Pin;

        // =====================================
        // PIR LED Logic  (LED on RB2)
        // =====================================
        if(pir_state) {

            LED_Pin       = 1;
            pir_led_timer = 0;
        }
        else {

            if(pir_led_timer < 3000)
                pir_led_timer += 50;
            else
                LED_Pin = 0;
        }

        // =====================================
        // PIR LCD Update
        // =====================================
        if(pir_state != pir_last) {

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
        if(mq2_raw != mq2_last) {

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
            dht_timer  = 0;

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
                    RH          = RH_byte_1;

                    // =============================
                    // TEMP LCD Update
                    // =============================
                    if(Temperature != last_temp) {

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
                    if(RH != last_rh) {

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
        // Buzzer rings CONTINUOUSLY until the
        // user presses the button (INT0) OR the
        // Raspberry Pi sends the 'S' command.
        // It will not re-trigger while conditions
        // persist AND buzzer_silenced is set.
        // =====================================
        if( (mq2_raw == GAS_ACTIVE_STATE) || (RH > 70) ) {

            if(!alarm_latched) {

                // Fresh alarm event -> start buzzer
                BUZZER_Pin      = 1;
                buzzer_active   = 1;
                buzzer_silenced = 0;
                alarm_latched   = 1;
            }
            else if(!buzzer_silenced && !buzzer_active) {

                // Was active but stopped without silence command -> re-arm
                BUZZER_Pin    = 1;
                buzzer_active = 1;
            }
        }
        else {

            // Alarm conditions fully gone -> reset latch & silence flag
            // so the next alarm event starts fresh
            alarm_latched   = 0;
            buzzer_silenced = 0;
        }

        // =====================================
        // UART Send all sensor data + buzzer status
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
//  INTERRUPT INIT
//  INT0 on RB0, falling edge (button pulls low)
// ================================================
void Interrupt_Init() {

    BUTTON_Direction = 1;   // RB0 as input

    INTEDG_bit = 0;         // Trigger on falling edge (button press = GND)
    INTF_bit   = 0;         // Clear any pending INT0 flag
    INTE_bit   = 1;         // Enable INT0

    GIE_bit    = 1;         // Enable global interrupts
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

    TRISC6_bit = 0;     // TX -> output
    TRISC7_bit = 1;     // RX -> input

    SPBRG = 129;        // 20 MHz -> 9600 baud (BRGH=1)

    BRGH_bit = 1;
    TXEN_bit = 1;
    SPEN_bit = 1;
    CREN_bit = 1;       // Enable continuous receive
}

void UART_Send(char c) {

    while(!TRMT_bit);

    TXREG = c;
}

void UART_SendString(char *str) {

    while(*str)
        UART_Send(*str++);
}

// ================================================
//  UART_CheckCommand
//  Non-blocking RX poll. Called once per main loop.
//  Handles commands sent FROM the Raspberry Pi:
//
//    'S' -> Silence buzzer (software interrupt)
//
//  The PIC acknowledges each valid command back
//  to the Pi so it can confirm receipt.
// ================================================
void UART_CheckCommand() {

    char cmd;

    // RCIF is set when the USART receive buffer has data
    if(RCIF_bit) {

        cmd = RCREG;    // Reading RCREG clears RCIF automatically

        if(cmd == UART_CMD_SILENCE) {

            // Software "interrupt" from Pi -> identical effect
            // to the physical button press on RB0 (INT0)
            Silence_Buzzer();

            // Acknowledge back to Pi
            UART_SendString("ACK:SILENCE\n");
        }
        // Unknown commands are silently ignored.
        // Extend here with more 'else if' cases as needed.
    }
}

// ================================================
//  Send_Sensors
//  Transmits one CSV line per call:
//
//  Format:
//    T:XX,H:XX,PIR:X,GAS:X,BUZ:X\n
//
//  Field   Values
//  ------  ------
//  T       Temperature (°C), two digits
//  H       Humidity (%),     two digits
//  PIR     0 = no motion,  1 = motion detected
//  GAS     0 = gas present (active LOW), 1 = clear
//  BUZ     0 = buzzer OFF, 1 = buzzer ON (alarm ringing)
// ================================================
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

    // NEW: Buzzer status field
    UART_SendString(",BUZ:");
    UART_Send(buzzer_active + '0');

    UART_Send('\n');
}
