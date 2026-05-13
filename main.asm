
_Silence_Buzzer:

;main.c,90 :: 		void Silence_Buzzer() {
;main.c,92 :: 		BUZZER_Pin      = 0;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;main.c,93 :: 		buzzer_active   = 0;
	CLRF       _buzzer_active+0
;main.c,94 :: 		buzzer_silenced = 1;
	MOVLW      1
	MOVWF      _buzzer_silenced+0
;main.c,95 :: 		}
L_end_Silence_Buzzer:
	RETURN
; end of _Silence_Buzzer

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;main.c,102 :: 		void interrupt() {
;main.c,104 :: 		if(INTF_bit) {
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt0
;main.c,106 :: 		Silence_Buzzer();
	CALL       _Silence_Buzzer+0
;main.c,109 :: 		INTF_bit = 0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;main.c,110 :: 		}
L_interrupt0:
;main.c,111 :: 		}
L_end_interrupt:
L__interrupt66:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;main.c,116 :: 		void main() {
;main.c,118 :: 		ADCON1 = 0x07;
	MOVLW      7
	MOVWF      ADCON1+0
;main.c,121 :: 		PIR_Direction    = 1;
	BSF        TRISD6_bit+0, BitPos(TRISD6_bit+0)
;main.c,122 :: 		MQ2_Direction    = 1;
	BSF        TRISD7_bit+0, BitPos(TRISD7_bit+0)
;main.c,125 :: 		BUTTON_Direction = 1;
	BSF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;main.c,128 :: 		LED_Direction = 0;
	BCF        TRISB2_bit+0, BitPos(TRISB2_bit+0)
;main.c,129 :: 		LED_Pin       = 0;
	BCF        RB2_bit+0, BitPos(RB2_bit+0)
;main.c,132 :: 		BUZZER_Direction = 0;
	BCF        TRISB1_bit+0, BitPos(TRISB1_bit+0)
;main.c,133 :: 		BUZZER_Pin       = 0;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;main.c,136 :: 		Interrupt_Init();
	CALL       _Interrupt_Init+0
;main.c,139 :: 		UART_Init();
	CALL       _UART_Init+0
;main.c,142 :: 		I2C1_Init(100000);
	MOVLW      50
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;main.c,143 :: 		Delay_ms(100);
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
;main.c,145 :: 		I2C1_Init(100000);
	MOVLW      50
	MOVWF      SSPADD+0
	CALL       _I2C1_Init+0
;main.c,146 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
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
;main.c,148 :: 		Lcd_Init_I2C();
	CALL       _Lcd_Init_I2C+0
;main.c,149 :: 		Delay_ms(50);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	DECFSZ     R11+0, 1
	GOTO       L_main3
	NOP
	NOP
;main.c,152 :: 		Lcd_Out(1,1,"T:    PIR:     ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr1_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;main.c,153 :: 		Lcd_Out(2,1,"H:    GAS:     ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr2_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;main.c,155 :: 		while(1) {
L_main4:
;main.c,162 :: 		UART_CheckCommand();
	CALL       _UART_CheckCommand+0
;main.c,167 :: 		pir_state = PIR_Pin;
	MOVLW      0
	BTFSC      RD6_bit+0, BitPos(RD6_bit+0)
	MOVLW      1
	MOVWF      _pir_state+0
;main.c,168 :: 		mq2_raw   = MQ2_Pin;
	MOVLW      0
	BTFSC      RD7_bit+0, BitPos(RD7_bit+0)
	MOVLW      1
	MOVWF      _mq2_raw+0
;main.c,173 :: 		if(pir_state) {
	MOVF       _pir_state+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main6
;main.c,175 :: 		LED_Pin       = 1;
	BSF        RB2_bit+0, BitPos(RB2_bit+0)
;main.c,176 :: 		pir_led_timer = 0;
	CLRF       _pir_led_timer+0
	CLRF       _pir_led_timer+1
;main.c,177 :: 		}
	GOTO       L_main7
L_main6:
;main.c,180 :: 		if(pir_led_timer < 3000)
	MOVLW      11
	SUBWF      _pir_led_timer+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main68
	MOVLW      184
	SUBWF      _pir_led_timer+0, 0
L__main68:
	BTFSC      STATUS+0, 0
	GOTO       L_main8
;main.c,181 :: 		pir_led_timer += 50;
	MOVLW      50
	ADDWF      _pir_led_timer+0, 1
	BTFSC      STATUS+0, 0
	INCF       _pir_led_timer+1, 1
	GOTO       L_main9
L_main8:
;main.c,183 :: 		LED_Pin = 0;
	BCF        RB2_bit+0, BitPos(RB2_bit+0)
L_main9:
;main.c,184 :: 		}
L_main7:
;main.c,189 :: 		if(pir_state != pir_last) {
	MOVF       _pir_state+0, 0
	XORWF      _pir_last+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main10
;main.c,191 :: 		if(pir_state)
	MOVF       _pir_state+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main11
;main.c,192 :: 		Lcd_Out(1,12,"ON ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr3_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	GOTO       L_main12
L_main11:
;main.c,194 :: 		Lcd_Out(1,12,"OFF");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr4_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_main12:
;main.c,196 :: 		pir_last = pir_state;
	MOVF       _pir_state+0, 0
	MOVWF      _pir_last+0
;main.c,198 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	NOP
	NOP
;main.c,199 :: 		}
L_main10:
;main.c,204 :: 		if(mq2_raw != mq2_last) {
	MOVF       _mq2_raw+0, 0
	XORWF      _mq2_last+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main14
;main.c,206 :: 		if(mq2_raw == GAS_ACTIVE_STATE)
	MOVF       _mq2_raw+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main15
;main.c,207 :: 		Lcd_Out(2,12,"ON ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr5_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
	GOTO       L_main16
L_main15:
;main.c,209 :: 		Lcd_Out(2,12,"OFF");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Out_col+0
	MOVLW      ?lstr6_main+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_main16:
;main.c,211 :: 		mq2_last = mq2_raw;
	MOVF       _mq2_raw+0, 0
	MOVWF      _mq2_last+0
;main.c,213 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main17:
	DECFSZ     R13+0, 1
	GOTO       L_main17
	DECFSZ     R12+0, 1
	GOTO       L_main17
	NOP
	NOP
;main.c,214 :: 		}
L_main14:
;main.c,219 :: 		if(first_read || dht_timer >= 2000) {
	MOVF       _first_read+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main63
	MOVLW      7
	SUBWF      _dht_timer+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main69
	MOVLW      208
	SUBWF      _dht_timer+0, 0
L__main69:
	BTFSC      STATUS+0, 0
	GOTO       L__main63
	GOTO       L_main20
L__main63:
;main.c,221 :: 		first_read = 0;
	CLRF       _first_read+0
;main.c,222 :: 		dht_timer  = 0;
	CLRF       _dht_timer+0
	CLRF       _dht_timer+1
;main.c,224 :: 		dht11_init();
	CALL       _dht11_init+0
;main.c,225 :: 		find_response();
	CALL       _find_response+0
;main.c,227 :: 		if(Check_bit == 1) {
	MOVF       _Check_bit+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main21
;main.c,229 :: 		RH_byte_1   = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte_1+0
;main.c,230 :: 		RH_byte_2   = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte_2+0
;main.c,232 :: 		Temp_byte_1 = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _Temp_byte_1+0
;main.c,233 :: 		Temp_byte_2 = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _Temp_byte_2+0
;main.c,235 :: 		Sumation    = read_dht11();
	CALL       _read_dht11+0
	MOVF       R0+0, 0
	MOVWF      _Sumation+0
;main.c,237 :: 		if(Sumation == ((RH_byte_1 + RH_byte_2 +
	MOVF       _RH_byte_2+0, 0
	ADDWF      _RH_byte_1+0, 0
	MOVWF      R1+0
	CLRF       R1+1
	BTFSC      STATUS+0, 0
	INCF       R1+1, 1
;main.c,238 :: 		Temp_byte_1 + Temp_byte_2) & 0xFF)) {
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
	GOTO       L__main70
	MOVF       R3+0, 0
	XORWF      R0+0, 0
L__main70:
	BTFSS      STATUS+0, 2
	GOTO       L_main22
;main.c,240 :: 		Temperature = Temp_byte_1;
	MOVF       _Temp_byte_1+0, 0
	MOVWF      _Temperature+0
;main.c,241 :: 		RH          = RH_byte_1;
	MOVF       _RH_byte_1+0, 0
	MOVWF      _RH+0
;main.c,246 :: 		if(Temperature != last_temp) {
	MOVF       _Temp_byte_1+0, 0
	XORWF      _last_temp+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main23
;main.c,248 :: 		Lcd_Chr(1,3,(Temperature/10)+'0');
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
;main.c,249 :: 		Lcd_Chr(1,4,(Temperature%10)+'0');
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
;main.c,250 :: 		Lcd_Chr(1,5,223);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      223
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,251 :: 		Lcd_Chr(1,6,'C');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,253 :: 		last_temp = Temperature;
	MOVF       _Temperature+0, 0
	MOVWF      _last_temp+0
;main.c,255 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	DECFSZ     R12+0, 1
	GOTO       L_main24
	NOP
	NOP
;main.c,256 :: 		}
L_main23:
;main.c,261 :: 		if(RH != last_rh) {
	MOVF       _RH+0, 0
	XORWF      _last_rh+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main25
;main.c,263 :: 		Lcd_Chr(2,3,(RH/10)+'0');
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
;main.c,264 :: 		Lcd_Chr(2,4,(RH%10)+'0');
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
;main.c,265 :: 		Lcd_Chr(2,5,'%');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_col+0
	MOVLW      37
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;main.c,267 :: 		last_rh = RH;
	MOVF       _RH+0, 0
	MOVWF      _last_rh+0
;main.c,269 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_main26:
	DECFSZ     R13+0, 1
	GOTO       L_main26
	DECFSZ     R12+0, 1
	GOTO       L_main26
	NOP
	NOP
;main.c,270 :: 		}
L_main25:
;main.c,271 :: 		}
L_main22:
;main.c,272 :: 		}
L_main21:
;main.c,273 :: 		}
L_main20:
;main.c,283 :: 		if( (mq2_raw == GAS_ACTIVE_STATE) || (RH > 70) ) {
	MOVF       _mq2_raw+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main62
	MOVF       _RH+0, 0
	SUBLW      70
	BTFSS      STATUS+0, 0
	GOTO       L__main62
	GOTO       L_main29
L__main62:
;main.c,285 :: 		if(!alarm_latched) {
	MOVF       _alarm_latched+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main30
;main.c,288 :: 		BUZZER_Pin      = 1;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;main.c,289 :: 		buzzer_active   = 1;
	MOVLW      1
	MOVWF      _buzzer_active+0
;main.c,290 :: 		buzzer_silenced = 0;
	CLRF       _buzzer_silenced+0
;main.c,291 :: 		alarm_latched   = 1;
	MOVLW      1
	MOVWF      _alarm_latched+0
;main.c,292 :: 		}
	GOTO       L_main31
L_main30:
;main.c,293 :: 		else if(!buzzer_silenced && !buzzer_active) {
	MOVF       _buzzer_silenced+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main34
	MOVF       _buzzer_active+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main34
L__main61:
;main.c,296 :: 		BUZZER_Pin    = 1;
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
;main.c,297 :: 		buzzer_active = 1;
	MOVLW      1
	MOVWF      _buzzer_active+0
;main.c,298 :: 		}
L_main34:
L_main31:
;main.c,299 :: 		}
	GOTO       L_main35
L_main29:
;main.c,304 :: 		alarm_latched   = 0;
	CLRF       _alarm_latched+0
;main.c,305 :: 		buzzer_silenced = 0;
	CLRF       _buzzer_silenced+0
;main.c,306 :: 		}
L_main35:
;main.c,311 :: 		Send_Sensors();
	CALL       _Send_Sensors+0
;main.c,316 :: 		Delay_ms(50);
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
;main.c,318 :: 		dht_timer += 50;
	MOVLW      50
	ADDWF      _dht_timer+0, 1
	BTFSC      STATUS+0, 0
	INCF       _dht_timer+1, 1
;main.c,319 :: 		}
	GOTO       L_main4
;main.c,320 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_Interrupt_Init:

;main.c,326 :: 		void Interrupt_Init() {
;main.c,328 :: 		BUTTON_Direction = 1;   // RB0 as input
	BSF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;main.c,330 :: 		INTEDG_bit = 0;         // Trigger on falling edge (button press = GND)
	BCF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;main.c,331 :: 		INTF_bit   = 0;         // Clear any pending INT0 flag
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;main.c,332 :: 		INTE_bit   = 1;         // Enable INT0
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;main.c,334 :: 		GIE_bit    = 1;         // Enable global interrupts
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;main.c,335 :: 		}
L_end_Interrupt_Init:
	RETURN
; end of _Interrupt_Init

_dht11_init:

;main.c,340 :: 		void dht11_init() {
;main.c,342 :: 		DHT11_Data_Direction = 0;
	BCF        TRISD5_bit+0, BitPos(TRISD5_bit+0)
;main.c,344 :: 		DHT11_Data_Pin = 0;
	BCF        RD5_bit+0, BitPos(RD5_bit+0)
;main.c,346 :: 		Delay_ms(18);
	MOVLW      117
	MOVWF      R12+0
	MOVLW      225
	MOVWF      R13+0
L_dht11_init37:
	DECFSZ     R13+0, 1
	GOTO       L_dht11_init37
	DECFSZ     R12+0, 1
	GOTO       L_dht11_init37
;main.c,348 :: 		DHT11_Data_Pin = 1;
	BSF        RD5_bit+0, BitPos(RD5_bit+0)
;main.c,350 :: 		Delay_us(30);
	MOVLW      49
	MOVWF      R13+0
L_dht11_init38:
	DECFSZ     R13+0, 1
	GOTO       L_dht11_init38
	NOP
	NOP
;main.c,352 :: 		DHT11_Data_Direction = 1;
	BSF        TRISD5_bit+0, BitPos(TRISD5_bit+0)
;main.c,353 :: 		}
L_end_dht11_init:
	RETURN
; end of _dht11_init

_find_response:

;main.c,355 :: 		void find_response() {
;main.c,357 :: 		Check_bit = 0;
	CLRF       _Check_bit+0
;main.c,359 :: 		Delay_us(40);
	MOVLW      66
	MOVWF      R13+0
L_find_response39:
	DECFSZ     R13+0, 1
	GOTO       L_find_response39
	NOP
;main.c,361 :: 		if(!DHT11_Data_Pin) {
	BTFSC      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_find_response40
;main.c,363 :: 		Delay_us(80);
	MOVLW      133
	MOVWF      R13+0
L_find_response41:
	DECFSZ     R13+0, 1
	GOTO       L_find_response41
;main.c,365 :: 		if(DHT11_Data_Pin)
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_find_response42
;main.c,366 :: 		Check_bit = 1;
	MOVLW      1
	MOVWF      _Check_bit+0
L_find_response42:
;main.c,367 :: 		}
L_find_response40:
;main.c,369 :: 		while(DHT11_Data_Pin);
L_find_response43:
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_find_response44
	GOTO       L_find_response43
L_find_response44:
;main.c,370 :: 		}
L_end_find_response:
	RETURN
; end of _find_response

_read_dht11:

;main.c,372 :: 		char read_dht11() {
;main.c,374 :: 		char i, d = 0;
	CLRF       read_dht11_d_L0+0
;main.c,376 :: 		for(i = 0; i < 8; i++) {
	CLRF       R1+0
L_read_dht1145:
	MOVLW      8
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_read_dht1146
;main.c,378 :: 		while(!DHT11_Data_Pin);
L_read_dht1148:
	BTFSC      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_read_dht1149
	GOTO       L_read_dht1148
L_read_dht1149:
;main.c,380 :: 		Delay_us(30);
	MOVLW      49
	MOVWF      R13+0
L_read_dht1150:
	DECFSZ     R13+0, 1
	GOTO       L_read_dht1150
	NOP
	NOP
;main.c,382 :: 		if(DHT11_Data_Pin) {
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_read_dht1151
;main.c,384 :: 		d = (d << 1) | 1;
	RLF        read_dht11_d_L0+0, 1
	BCF        read_dht11_d_L0+0, 0
	BSF        read_dht11_d_L0+0, 0
;main.c,386 :: 		while(DHT11_Data_Pin);
L_read_dht1152:
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_read_dht1153
	GOTO       L_read_dht1152
L_read_dht1153:
;main.c,387 :: 		}
	GOTO       L_read_dht1154
L_read_dht1151:
;main.c,390 :: 		d = (d << 1);
	RLF        read_dht11_d_L0+0, 1
	BCF        read_dht11_d_L0+0, 0
;main.c,391 :: 		}
L_read_dht1154:
;main.c,376 :: 		for(i = 0; i < 8; i++) {
	INCF       R1+0, 1
;main.c,392 :: 		}
	GOTO       L_read_dht1145
L_read_dht1146:
;main.c,394 :: 		return d;
	MOVF       read_dht11_d_L0+0, 0
	MOVWF      R0+0
;main.c,395 :: 		}
L_end_read_dht11:
	RETURN
; end of _read_dht11

_UART_Init:

;main.c,400 :: 		void UART_Init() {
;main.c,402 :: 		TRISC6_bit = 0;     // TX -> output
	BCF        TRISC6_bit+0, BitPos(TRISC6_bit+0)
;main.c,403 :: 		TRISC7_bit = 1;     // RX -> input
	BSF        TRISC7_bit+0, BitPos(TRISC7_bit+0)
;main.c,405 :: 		SPBRG = 129;        // 20 MHz -> 9600 baud (BRGH=1)
	MOVLW      129
	MOVWF      SPBRG+0
;main.c,407 :: 		BRGH_bit = 1;
	BSF        BRGH_bit+0, BitPos(BRGH_bit+0)
;main.c,408 :: 		TXEN_bit = 1;
	BSF        TXEN_bit+0, BitPos(TXEN_bit+0)
;main.c,409 :: 		SPEN_bit = 1;
	BSF        SPEN_bit+0, BitPos(SPEN_bit+0)
;main.c,410 :: 		CREN_bit = 1;       // Enable continuous receive
	BSF        CREN_bit+0, BitPos(CREN_bit+0)
;main.c,411 :: 		}
L_end_UART_Init:
	RETURN
; end of _UART_Init

_UART_Send:

;main.c,413 :: 		void UART_Send(char c) {
;main.c,415 :: 		while(!TRMT_bit);
L_UART_Send55:
	BTFSC      TRMT_bit+0, BitPos(TRMT_bit+0)
	GOTO       L_UART_Send56
	GOTO       L_UART_Send55
L_UART_Send56:
;main.c,417 :: 		TXREG = c;
	MOVF       FARG_UART_Send_c+0, 0
	MOVWF      TXREG+0
;main.c,418 :: 		}
L_end_UART_Send:
	RETURN
; end of _UART_Send

_UART_SendString:

;main.c,420 :: 		void UART_SendString(char *str) {
;main.c,422 :: 		while(*str)
L_UART_SendString57:
	MOVF       FARG_UART_SendString_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_UART_SendString58
;main.c,423 :: 		UART_Send(*str++);
	MOVF       FARG_UART_SendString_str+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
	INCF       FARG_UART_SendString_str+0, 1
	GOTO       L_UART_SendString57
L_UART_SendString58:
;main.c,424 :: 		}
L_end_UART_SendString:
	RETURN
; end of _UART_SendString

_UART_CheckCommand:

;main.c,436 :: 		void UART_CheckCommand() {
;main.c,441 :: 		if(RCIF_bit) {
	BTFSS      RCIF_bit+0, BitPos(RCIF_bit+0)
	GOTO       L_UART_CheckCommand59
;main.c,443 :: 		cmd = RCREG;    // Reading RCREG clears RCIF automatically
	MOVF       RCREG+0, 0
	MOVWF      UART_CheckCommand_cmd_L0+0
;main.c,445 :: 		if(cmd == UART_CMD_SILENCE) {
	MOVF       UART_CheckCommand_cmd_L0+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_UART_CheckCommand60
;main.c,449 :: 		Silence_Buzzer();
	CALL       _Silence_Buzzer+0
;main.c,452 :: 		UART_SendString("ACK:SILENCE\n");
	MOVLW      ?lstr7_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,453 :: 		}
L_UART_CheckCommand60:
;main.c,456 :: 		}
L_UART_CheckCommand59:
;main.c,457 :: 		}
L_end_UART_CheckCommand:
	RETURN
; end of _UART_CheckCommand

_Send_Sensors:

;main.c,474 :: 		void Send_Sensors() {
;main.c,476 :: 		UART_SendString("T:");
	MOVLW      ?lstr8_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,477 :: 		UART_Send(Temperature/10 + '0');
	MOVLW      10
	MOVWF      R4+0
	MOVF       _Temperature+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,478 :: 		UART_Send(Temperature%10 + '0');
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
;main.c,480 :: 		UART_SendString(",H:");
	MOVLW      ?lstr9_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,481 :: 		UART_Send(RH/10 + '0');
	MOVLW      10
	MOVWF      R4+0
	MOVF       _RH+0, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVLW      48
	ADDWF      R0+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,482 :: 		UART_Send(RH%10 + '0');
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
;main.c,484 :: 		UART_SendString(",PIR:");
	MOVLW      ?lstr10_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,485 :: 		UART_Send(pir_state + '0');
	MOVLW      48
	ADDWF      _pir_state+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,487 :: 		UART_SendString(",GAS:");
	MOVLW      ?lstr11_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,488 :: 		UART_Send(mq2_raw + '0');
	MOVLW      48
	ADDWF      _mq2_raw+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,491 :: 		UART_SendString(",BUZ:");
	MOVLW      ?lstr12_main+0
	MOVWF      FARG_UART_SendString_str+0
	CALL       _UART_SendString+0
;main.c,492 :: 		UART_Send(buzzer_active + '0');
	MOVLW      48
	ADDWF      _buzzer_active+0, 0
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,494 :: 		UART_Send('\n');
	MOVLW      10
	MOVWF      FARG_UART_Send_c+0
	CALL       _UART_Send+0
;main.c,495 :: 		}
L_end_Send_Sensors:
	RETURN
; end of _Send_Sensors
