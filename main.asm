
_main:

;main.c,16 :: 		void main() {
;main.c,17 :: 		ADCON1 = 0x07;      // Configure all pins as digital (crucial for PIC16F877A)
	MOVLW      7
	MOVWF      ADCON1+0
;main.c,18 :: 		I2C1_Init(100000);  // Initialize I2C at 100kHz
	MOVLW      50
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;main.c,19 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main0:
	DECFSZ     R13+0, 1
	GOTO       L_main0
	DECFSZ     R12+0, 1
	GOTO       L_main0
	DECFSZ     R11+0, 1
	GOTO       L_main0
	NOP
	NOP
;main.c,21 :: 		Lcd_Init_I2C();     // Initialize our custom I2C LCD library
	CALL       _Lcd_Init_I2C+0
;main.c,23 :: 		while(1){
L_main1:
;main.c,24 :: 		dht11_init();
	CALL       _dht11_init+0
;main.c,25 :: 		find_response();
	CALL       _find_response+0
;main.c,27 :: 		if(Check_bit == 1){
	MOVF       _Check_bit+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;main.c,28 :: 		RH_byte_1 = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte_1+0
;main.c,29 :: 		RH_byte_2 = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte_2+0
;main.c,30 :: 		Temp_byte_1 = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _Temp_byte_1+0
;main.c,31 :: 		Temp_byte_2 = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _Temp_byte_2+0
;main.c,32 :: 		Sumation   = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _Sumation+0
;main.c,35 :: 		if(Sumation == ((RH_byte_1 + RH_byte_2 + Temp_byte_1 + Temp_byte_2) & 0xFF)){
	MOVF       _RH_byte_2+0, 0
	ADDWF      _RH_byte_1+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
	MOVF       _Temp_byte_1+0, 0
	ADDWF      R1+0, 1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
	MOVF       _Temp_byte_2+0, 0
	ADDWF      R1+0, 1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
	MOVLW      255
	ANDWF      R1+0, 0
	MOVWF      R3+0
	MOVF       R1+1, 0
	MOVWF      R3+1
	MOVLW      0
	ANDWF      R3+1, 1
	MOVLW      0
	XORWF      R3+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main27
	MOVF       R3+0, 0
	XORWF      R0+0, 0
L__main27:
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;main.c,36 :: 		Temperature = Temp_byte_1;
	MOVF       _Temp_byte_1+0, 0
	MOVWF      _Temperature+0
;main.c,37 :: 		RH = RH_byte_1;
	MOVF       _RH_byte_1+0, 0
	MOVWF      _RH+0
;main.c,39 :: 		Lcd_Cmd(0x01); // Clear screen
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;main.c,41 :: 		Lcd_Out(1,1,"Temp:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr1_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;main.c,42 :: 		Lcd_Chr(1,7,(Temperature/10)+'0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _Temperature+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,43 :: 		Lcd_Chr(1,8,(Temperature%10)+'0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _Temperature+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,44 :: 		Lcd_Chr(1,9,223); // Degree symbol
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      223
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,45 :: 		Lcd_Chr(1,10,'C');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,47 :: 		Lcd_Out(2,1,"Hum:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr2_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;main.c,48 :: 		Lcd_Chr(2,6,(RH/10)+'0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _RH+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,49 :: 		Lcd_Chr(2,7,(RH%10)+'0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      10
	MOVWF      R4+0
	MOVF       _RH+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,50 :: 		Lcd_Chr(2,8,'%');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      8
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      37
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,51 :: 		}
	GOTO       L_main5
L_main4:
;main.c,53 :: 		Lcd_Cmd(0x01);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;main.c,54 :: 		Lcd_Out(1,1,"Checksum Error");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr3_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;main.c,55 :: 		}
L_main5:
;main.c,56 :: 		}
	GOTO       L_main6
L_main3:
;main.c,58 :: 		Lcd_Cmd(0x01);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;main.c,59 :: 		Lcd_Out(1,1,"No Response");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr4_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;main.c,60 :: 		}
L_main6:
;main.c,63 :: 		Delay_ms(2000);
	MOVLW      51
	MOVWF      R11+0
	MOVLW      187
	MOVWF      R12+0
	MOVLW      223
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
	NOP
;main.c,64 :: 		}
	GOTO       L_main1
;main.c,65 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_dht11_init:

;main.c,68 :: 		void dht11_init(){
;main.c,69 :: 		DHT11_Data_Direction = 0; // Set as Output
	BCF        TRISD5_bit+0, BitPos(TRISD5_bit+0)
;main.c,70 :: 		DHT11_Data_Pin = 0;       // Send Start Signal (Low)
	BCF        RD5_bit+0, BitPos(RD5_bit+0)
;main.c,71 :: 		Delay_ms(18);             // Hold low for at least 18ms
	MOVLW      117
	MOVWF      R12+0
	MOVLW      225
	MOVWF      R13+0
L_dht11_init8:
	DECFSZ     R13+0, 1
	GOTO       L_dht11_init8
	DECFSZ     R12+0, 1
	GOTO       L_dht11_init8
;main.c,72 :: 		DHT11_Data_Pin = 1;       // Pull high
	BSF        RD5_bit+0, BitPos(RD5_bit+0)
;main.c,73 :: 		Delay_us(30);             // Wait for response
	MOVLW      49
	MOVWF      R13+0
L_dht11_init9:
	DECFSZ     R13+0, 1
	GOTO       L_dht11_init9
	NOP
	NOP
;main.c,74 :: 		DHT11_Data_Direction = 1; // Set as Input to read sensor
	BSF        TRISD5_bit+0, BitPos(TRISD5_bit+0)
;main.c,75 :: 		}
L_end_dht11_init:
	RETURN
; end of _dht11_init

_find_response:

;main.c,77 :: 		void find_response(){
;main.c,78 :: 		Check_bit = 0;
	CLRF       _Check_bit+0
;main.c,79 :: 		Delay_us(40);
	MOVLW      66
	MOVWF      R13+0
L_find_response10:
	DECFSZ     R13+0, 1
	GOTO       L_find_response10
	NOP
;main.c,80 :: 		if(!DHT11_Data_Pin){
	BTFSC      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_find_response11
;main.c,81 :: 		Delay_us(80);
	MOVLW      133
	MOVWF      R13+0
L_find_response12:
	DECFSZ     R13+0, 1
	GOTO       L_find_response12
;main.c,82 :: 		if(DHT11_Data_Pin) Check_bit = 1;
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_find_response13
	MOVLW      1
	MOVWF      _Check_bit+0
L_find_response13:
;main.c,83 :: 		}
L_find_response11:
;main.c,84 :: 		while(DHT11_Data_Pin); // Wait for sensor to finish response signal
L_find_response14:
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_find_response15
	GOTO       L_find_response14
L_find_response15:
;main.c,85 :: 		}
L_end_find_response:
	RETURN
; end of _find_response

_read_dht11:

;main.c,87 :: 		char read_dht11(){
;main.c,88 :: 		char i, d = 0;
	CLRF       read_dht11_d_L0+0
;main.c,89 :: 		for(i = 0; i < 8; i++){
	CLRF       R1+0
L_read_dht1116:
	MOVLW      8
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_read_dht1117
;main.c,90 :: 		while(!DHT11_Data_Pin); // Wait for the start of the bit pulse
L_read_dht1119:
	BTFSC      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_read_dht1120
	GOTO       L_read_dht1119
L_read_dht1120:
;main.c,91 :: 		Delay_us(30);           // If still high after 30us, bit is '1'
	MOVLW      49
	MOVWF      R13+0
L_read_dht1121:
	DECFSZ     R13+0, 1
	GOTO       L_read_dht1121
	NOP
	NOP
;main.c,92 :: 		if(DHT11_Data_Pin) {
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_read_dht1122
;main.c,93 :: 		d = (d << 1) | 1;
	RLF        read_dht11_d_L0+0, 1
	BCF        read_dht11_d_L0+0, 0
	BSF        read_dht11_d_L0+0, 0
;main.c,94 :: 		while(DHT11_Data_Pin); // Wait for bit pulse to end
L_read_dht1123:
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_read_dht1124
	GOTO       L_read_dht1123
L_read_dht1124:
;main.c,95 :: 		}
	GOTO       L_read_dht1125
L_read_dht1122:
;main.c,97 :: 		d = (d << 1);
	RLF        read_dht11_d_L0+0, 1
	BCF        read_dht11_d_L0+0, 0
;main.c,98 :: 		}
L_read_dht1125:
;main.c,89 :: 		for(i = 0; i < 8; i++){
	INCF       R1+0, 1
;main.c,99 :: 		}
	GOTO       L_read_dht1116
L_read_dht1117:
;main.c,100 :: 		return d;
	MOVF       read_dht11_d_L0+0, 0
	MOVWF      R0+0
;main.c,101 :: 		}
L_end_read_dht11:
	RETURN
; end of _read_dht11
