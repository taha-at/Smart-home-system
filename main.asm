
_main:

;main.c,70 :: 		void main() {
;main.c,72 :: 		ADCON1 = 0x07;
	MOVLW      7
	MOVWF      ADCON1+0
;main.c,75 :: 		PIR_Direction = 1;
	BSF        TRISD6_bit+0, BitPos(TRISD6_bit+0)
;main.c,76 :: 		MQ2_Direction = 1;
	BSF        TRISD7_bit+0, BitPos(TRISD7_bit+0)
;main.c,79 :: 		LED_Direction = 0;
	BCF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;main.c,80 :: 		LED_Pin = 0;
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
;main.c,83 :: 		BUZZER_Direction = 0;
	BCF        TRISB1_bit+0, BitPos(TRISB1_bit+0)
;main.c,84 :: 		BUZZER_Pin = 0;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;main.c,87 :: 		UART_Init();
	CALL       _UART_Init+0
;main.c,90 :: 		I2C1_Init(100000);
	MOVLW      50
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;main.c,91 :: 		Delay_ms(100);
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
;main.c,93 :: 		I2C1_Init(100000);
	MOVLW      50
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;main.c,94 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main1:
	DECFSZ     R13+0, 1
	GOTO       L_main1
	DECFSZ     R12+0, 1
	GOTO       L_main1
	DECFSZ     R11+0, 1
	GOTO       L_main1
	NOP
	NOP
;main.c,96 :: 		Lcd_Init_I2C();
	CALL       _Lcd_Init_I2C+0
;main.c,97 :: 		Delay_ms(50);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L_main2:
	DECFSZ     R13+0, 1
	GOTO       L_main2
	DECFSZ     R12+0, 1
	GOTO       L_main2
	DECFSZ     R11+0, 1
	GOTO       L_main2
	NOP
	NOP
;main.c,100 :: 		Lcd_Out(1,1,"T:    PIR:     ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr1_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;main.c,101 :: 		Lcd_Out(2,1,"H:    GAS:     ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr2_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;main.c,103 :: 		while(1) {
L_main3:
;main.c,108 :: 		pir_state = PIR_Pin;
	MOVLW      0
	BTFSC      RD6_bit+0, BitPos(RD6_bit+0)
	MOVLW      1
	MOVWF      _pir_state+0
;main.c,109 :: 		mq2_raw   = MQ2_Pin;
	MOVLW      0
	BTFSC      RD7_bit+0, BitPos(RD7_bit+0)
	MOVLW      1
	MOVWF      _mq2_raw+0
;main.c,114 :: 		if(pir_state){
	MOVF       _pir_state+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main5
;main.c,117 :: 		LED_Pin = 1;
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
;main.c,120 :: 		pir_led_timer = 0;
	CLRF       _pir_led_timer+0
	CLRF       _pir_led_timer+1
;main.c,121 :: 		}
	GOTO       L_main6
L_main5:
;main.c,125 :: 		if(pir_led_timer < 5000)
	MOVLW      19
	SUBWF      _pir_led_timer+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main64
	MOVLW      136
	SUBWF      _pir_led_timer+0, 0
L__main64:
	BTFSC      STATUS+0, 0
	GOTO       L_main7
;main.c,126 :: 		pir_led_timer += 50;
	MOVLW      50
	ADDWF      _pir_led_timer+0, 1
	BTFSC      STATUS+0, 0
	INCF       _pir_led_timer+1, 1
	GOTO       L_main8
L_main7:
;main.c,128 :: 		LED_Pin = 0;
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
L_main8:
;main.c,129 :: 		}
L_main6:
;main.c,134 :: 		if(pir_state != pir_last){
	MOVF       _pir_state+0, 0
	XORWF      _pir_last+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main9
;main.c,136 :: 		if(pir_state)
	MOVF       _pir_state+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main10
;main.c,137 :: 		Lcd_Out(1,12,"ON ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr3_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	GOTO       L_main11
L_main10:
;main.c,139 :: 		Lcd_Out(1,12,"OFF");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr4_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_main11:
;main.c,141 :: 		pir_last = pir_state;
	MOVF       _pir_state+0, 0
	MOVWF      _pir_last+0
;main.c,143 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	NOP
	NOP
;main.c,144 :: 		}
L_main9:
;main.c,149 :: 		if(mq2_raw != mq2_last){
	MOVF       _mq2_raw+0, 0
	XORWF      _mq2_last+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main13
;main.c,151 :: 		if(mq2_raw == GAS_ACTIVE_STATE)
	MOVF       _mq2_raw+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main14
;main.c,152 :: 		Lcd_Out(2,12,"ON ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr5_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	GOTO       L_main15
L_main14:
;main.c,154 :: 		Lcd_Out(2,12,"OFF");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr6_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_main15:
;main.c,156 :: 		mq2_last = mq2_raw;
	MOVF       _mq2_raw+0, 0
	MOVWF      _mq2_last+0
;main.c,158 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main16:
	DECFSZ     R13+0, 1
	GOTO       L_main16
	DECFSZ     R12+0, 1
	GOTO       L_main16
	NOP
	NOP
;main.c,159 :: 		}
L_main13:
;main.c,164 :: 		if(first_read || dht_timer >= 2000) {
	MOVF       _first_read+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main62
	MOVLW      7
	SUBWF      _dht_timer+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main65
	MOVLW      208
	SUBWF      _dht_timer+0, 0
L__main65:
	BTFSC      STATUS+0, 0
	GOTO       L__main62
	GOTO       L_main19
L__main62:
;main.c,166 :: 		first_read = 0;
	CLRF       _first_read+0
;main.c,167 :: 		dht_timer = 0;
	CLRF       _dht_timer+0
	CLRF       _dht_timer+1
;main.c,169 :: 		dht11_init();
	CALL       _dht11_init+0
;main.c,170 :: 		find_response();
	CALL       _find_response+0
;main.c,172 :: 		if(Check_bit == 1) {
	MOVF       _Check_bit+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;main.c,174 :: 		RH_byte_1   = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte_1+0
;main.c,175 :: 		RH_byte_2   = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte_2+0
;main.c,177 :: 		Temp_byte_1 = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _Temp_byte_1+0
;main.c,178 :: 		Temp_byte_2 = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _Temp_byte_2+0
;main.c,180 :: 		Sumation    = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _Sumation+0
;main.c,182 :: 		if(Sumation == ((RH_byte_1 + RH_byte_2 +
	MOVF       _RH_byte_2+0, 0
	ADDWF      _RH_byte_1+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
;main.c,183 :: 		Temp_byte_1 + Temp_byte_2) & 0xFF)) {
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
	GOTO       L__main66
	MOVF       R3+0, 0
	XORWF      R0+0, 0
L__main66:
	BTFSS      STATUS+0, 2
	GOTO       L_main21
;main.c,185 :: 		Temperature = Temp_byte_1;
	MOVF       _Temp_byte_1+0, 0
	MOVWF      _Temperature+0
;main.c,186 :: 		RH = RH_byte_1;
	MOVF       _RH_byte_1+0, 0
	MOVWF      _RH+0
;main.c,191 :: 		if(Temperature != last_temp){
	MOVF       _Temp_byte_1+0, 0
	XORWF      _last_temp+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main22
;main.c,193 :: 		Lcd_Chr(1,3,(Temperature/10)+'0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      3
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
;main.c,194 :: 		Lcd_Chr(1,4,(Temperature%10)+'0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
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
;main.c,195 :: 		Lcd_Chr(1,5,223);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      223
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,196 :: 		Lcd_Chr(1,6,'C');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,198 :: 		last_temp = Temperature;
	MOVF       _Temperature+0, 0
	MOVWF      _last_temp+0
;main.c,200 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main23:
	DECFSZ     R13+0, 1
	GOTO       L_main23
	DECFSZ     R12+0, 1
	GOTO       L_main23
	NOP
	NOP
;main.c,201 :: 		}
L_main22:
;main.c,206 :: 		if(RH != last_rh){
	MOVF       _RH+0, 0
	XORWF      _last_rh+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main24
;main.c,208 :: 		Lcd_Chr(2,3,(RH/10)+'0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      3
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
;main.c,209 :: 		Lcd_Chr(2,4,(RH%10)+'0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
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
;main.c,210 :: 		Lcd_Chr(2,5,'%');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      37
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,212 :: 		last_rh = RH;
	MOVF       _RH+0, 0
	MOVWF      _last_rh+0
;main.c,214 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main25:
	DECFSZ     R13+0, 1
	GOTO       L_main25
	DECFSZ     R12+0, 1
	GOTO       L_main25
	NOP
	NOP
;main.c,215 :: 		}
L_main24:
;main.c,216 :: 		}
L_main21:
;main.c,217 :: 		}
L_main20:
;main.c,218 :: 		}
L_main19:
;main.c,223 :: 		if( ((mq2_raw == GAS_ACTIVE_STATE) || (RH > 60))
	MOVF       _mq2_raw+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main61
	MOVF       _RH+0, 0
	SUBLW      60
	BTFSS      STATUS+0, 0
	GOTO       L__main61
	GOTO       L_main30
;main.c,224 :: 		&& !alarm_latched ){
L__main61:
	MOVF       _alarm_latched+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main30
L__main60:
;main.c,226 :: 		BUZZER_Pin = 1;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;main.c,228 :: 		buzzer_active = 1;
	MOVLW      1
	MOVWF      _buzzer_active+0
;main.c,230 :: 		buzzer_timer = 0;
	CLRF       _buzzer_timer+0
	CLRF       _buzzer_timer+1
;main.c,232 :: 		alarm_latched = 1;
	MOVLW      1
	MOVWF      _alarm_latched+0
;main.c,233 :: 		}
L_main30:
;main.c,236 :: 		if( (mq2_raw != GAS_ACTIVE_STATE) && (RH <= 60) ){
	MOVF       _mq2_raw+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main33
	MOVF       _RH+0, 0
	SUBLW      60
	BTFSS      STATUS+0, 0
	GOTO       L_main33
L__main59:
;main.c,238 :: 		alarm_latched = 0;
	CLRF       _alarm_latched+0
;main.c,239 :: 		}
L_main33:
;main.c,244 :: 		if(buzzer_active){
	MOVF       _buzzer_active+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main34
;main.c,246 :: 		buzzer_timer += 50;
	MOVLW      50
	ADDWF      _buzzer_timer+0, 0
	MOVWF      R1+0
	MOVF       _buzzer_timer+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R1+1
	MOVF       R1+0, 0
	MOVWF      _buzzer_timer+0
	MOVF       R1+1, 0
	MOVWF      _buzzer_timer+1
;main.c,248 :: 		if(buzzer_timer >= 3000){
	MOVLW      11
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main67
	MOVLW      184
	SUBWF      R1+0, 0
L__main67:
	BTFSS      STATUS+0, 0
	GOTO       L_main35
;main.c,250 :: 		BUZZER_Pin = 0;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;main.c,252 :: 		buzzer_active = 0;
	CLRF       _buzzer_active+0
;main.c,253 :: 		}
L_main35:
;main.c,254 :: 		}
L_main34:
;main.c,259 :: 		Send_Sensors();
	CALL       _Send_Sensors+0
;main.c,264 :: 		Delay_ms(50);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L_main36:
	DECFSZ     R13+0, 1
	GOTO       L_main36
	DECFSZ     R12+0, 1
	GOTO       L_main36
	DECFSZ     R11+0, 1
	GOTO       L_main36
	NOP
	NOP
;main.c,266 :: 		dht_timer += 50;
	MOVLW      50
	ADDWF      _dht_timer+0, 1
	BTFSC      STATUS+0, 0
	INCF       _dht_timer+1, 1
;main.c,267 :: 		}
	GOTO       L_main3
;main.c,268 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_dht11_init:

;main.c,273 :: 		void dht11_init() {
;main.c,275 :: 		DHT11_Data_Direction = 0;
	BCF        TRISD5_bit+0, BitPos(TRISD5_bit+0)
;main.c,277 :: 		DHT11_Data_Pin = 0;
	BCF        RD5_bit+0, BitPos(RD5_bit+0)
;main.c,279 :: 		Delay_ms(18);
	MOVLW      117
	MOVWF      R12+0
	MOVLW      225
	MOVWF      R13+0
L_dht11_init37:
	DECFSZ     R13+0, 1
	GOTO       L_dht11_init37
	DECFSZ     R12+0, 1
	GOTO       L_dht11_init37
;main.c,281 :: 		DHT11_Data_Pin = 1;
	BSF        RD5_bit+0, BitPos(RD5_bit+0)
;main.c,283 :: 		Delay_us(30);
	MOVLW      49
	MOVWF      R13+0
L_dht11_init38:
	DECFSZ     R13+0, 1
	GOTO       L_dht11_init38
	NOP
	NOP
;main.c,285 :: 		DHT11_Data_Direction = 1;
	BSF        TRISD5_bit+0, BitPos(TRISD5_bit+0)
;main.c,286 :: 		}
L_end_dht11_init:
	RETURN
; end of _dht11_init

_find_response:

;main.c,288 :: 		void find_response() {
;main.c,290 :: 		Check_bit = 0;
	CLRF       _Check_bit+0
;main.c,292 :: 		Delay_us(40);
	MOVLW      66
	MOVWF      R13+0
L_find_response39:
	DECFSZ     R13+0, 1
	GOTO       L_find_response39
	NOP
;main.c,294 :: 		if(!DHT11_Data_Pin) {
	BTFSC      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_find_response40
;main.c,296 :: 		Delay_us(80);
	MOVLW      133
	MOVWF      R13+0
L_find_response41:
	DECFSZ     R13+0, 1
	GOTO       L_find_response41
;main.c,298 :: 		if(DHT11_Data_Pin)
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_find_response42
;main.c,299 :: 		Check_bit = 1;
	MOVLW      1
	MOVWF      _Check_bit+0
L_find_response42:
;main.c,300 :: 		}
L_find_response40:
;main.c,302 :: 		while(DHT11_Data_Pin);
L_find_response43:
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_find_response44
	GOTO       L_find_response43
L_find_response44:
;main.c,303 :: 		}
L_end_find_response:
	RETURN
; end of _find_response

_read_dht11:

;main.c,305 :: 		char read_dht11() {
;main.c,307 :: 		char i, d = 0;
	CLRF       read_dht11_d_L0+0
;main.c,309 :: 		for(i = 0; i < 8; i++) {
	CLRF       R1+0
L_read_dht1145:
	MOVLW      8
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_read_dht1146
;main.c,311 :: 		while(!DHT11_Data_Pin);
L_read_dht1148:
	BTFSC      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_read_dht1149
	GOTO       L_read_dht1148
L_read_dht1149:
;main.c,313 :: 		Delay_us(30);
	MOVLW      49
	MOVWF      R13+0
L_read_dht1150:
	DECFSZ     R13+0, 1
	GOTO       L_read_dht1150
	NOP
	NOP
;main.c,315 :: 		if(DHT11_Data_Pin) {
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_read_dht1151
;main.c,317 :: 		d = (d << 1) | 1;
	RLF        read_dht11_d_L0+0, 1
	BCF        read_dht11_d_L0+0, 0
	BSF        read_dht11_d_L0+0, 0
;main.c,319 :: 		while(DHT11_Data_Pin);
L_read_dht1152:
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_read_dht1153
	GOTO       L_read_dht1152
L_read_dht1153:
;main.c,320 :: 		}
	GOTO       L_read_dht1154
L_read_dht1151:
;main.c,323 :: 		d = (d << 1);
	RLF        read_dht11_d_L0+0, 1
	BCF        read_dht11_d_L0+0, 0
;main.c,324 :: 		}
L_read_dht1154:
;main.c,309 :: 		for(i = 0; i < 8; i++) {
	INCF       R1+0, 1
;main.c,325 :: 		}
	GOTO       L_read_dht1145
L_read_dht1146:
;main.c,327 :: 		return d;
	MOVF       read_dht11_d_L0+0, 0
	MOVWF      R0+0
;main.c,328 :: 		}
L_end_read_dht11:
	RETURN
; end of _read_dht11

_UART_Init:

;main.c,333 :: 		void UART_Init() {
;main.c,335 :: 		TRISC6_bit = 0;
	BCF        TRISC6_bit+0, BitPos(TRISC6_bit+0)
;main.c,336 :: 		TRISC7_bit = 1;
	BSF        TRISC7_bit+0, BitPos(TRISC7_bit+0)
;main.c,338 :: 		SPBRG = 129;
	MOVLW      129
	MOVWF      SPBRG+0
;main.c,340 :: 		BRGH_bit = 1;
	BSF        BRGH_bit+0, BitPos(BRGH_bit+0)
;main.c,341 :: 		TXEN_bit = 1;
	BSF        TXEN_bit+0, BitPos(TXEN_bit+0)
;main.c,342 :: 		SPEN_bit = 1;
	BSF        SPEN_bit+0, BitPos(SPEN_bit+0)
;main.c,343 :: 		CREN_bit = 1;
	BSF        CREN_bit+0, BitPos(CREN_bit+0)
;main.c,344 :: 		}
L_end_UART_Init:
	RETURN
; end of _UART_Init

_UART_Send:

;main.c,346 :: 		void UART_Send(char c) {
;main.c,348 :: 		while(!TRMT_bit);
L_UART_Send55:
	BTFSC      TRMT_bit+0, BitPos(TRMT_bit+0)
	GOTO       L_UART_Send56
	GOTO       L_UART_Send55
L_UART_Send56:
;main.c,350 :: 		TXREG = c;
	MOVF       FARG_UART_Send_c+0, 0
	MOVWF      TXREG+0
;main.c,351 :: 		}
L_end_UART_Send:
	RETURN
; end of _UART_Send

_UART_SendString:

;main.c,353 :: 		void UART_SendString(char *str) {
;main.c,355 :: 		while(*str)
L_UART_SendString57:
	MOVF       FARG_UART_SendString_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_UART_SendString58
;main.c,356 :: 		UART_Send(*str++);
	MOVF       FARG_UART_SendString_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
	INCF       FARG_UART_SendString_str+0, 1
	GOTO       L_UART_SendString57
L_UART_SendString58:
;main.c,357 :: 		}
L_end_UART_SendString:
	RETURN
; end of _UART_SendString

_Send_Sensors:

;main.c,359 :: 		void Send_Sensors() {
;main.c,361 :: 		UART_SendString("T:");
	MOVLW      ?lstr7_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,362 :: 		UART_Send(Temperature/10 + '0');
	MOVLW      10
	MOVWF      R4+0
	MOVF       _Temperature+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,363 :: 		UART_Send(Temperature%10 + '0');
	MOVLW      10
	MOVWF      R4+0
	MOVF       _Temperature+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,365 :: 		UART_SendString(",H:");
	MOVLW      ?lstr8_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,366 :: 		UART_Send(RH/10 + '0');
	MOVLW      10
	MOVWF      R4+0
	MOVF       _RH+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,367 :: 		UART_Send(RH%10 + '0');
	MOVLW      10
	MOVWF      R4+0
	MOVF       _RH+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,369 :: 		UART_SendString(",PIR:");
	MOVLW      ?lstr9_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,370 :: 		UART_Send(pir_state + '0');
	MOVLW      48
	ADDWF      _pir_state+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,372 :: 		UART_SendString(",GAS:");
	MOVLW      ?lstr10_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,373 :: 		UART_Send(mq2_raw + '0');
	MOVLW      48
	ADDWF      _mq2_raw+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,375 :: 		UART_Send('\n');
	MOVLW      10
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,376 :: 		}
L_end_Send_Sensors:
	RETURN
; end of _Send_Sensors
