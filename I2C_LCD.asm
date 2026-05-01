
_I2C_LCD_Write:

;I2C_LCD.c,6 :: 		void I2C_LCD_Write(unsigned char d) {
;I2C_LCD.c,7 :: 		I2C1_Start();
	CALL       _I2C1_Start+0
;I2C_LCD.c,8 :: 		I2C1_Wr(LCD_ADDR);
	MOVLW      78
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;I2C_LCD.c,9 :: 		I2C1_Wr(d | lcd_backlight);
	MOVF       _lcd_backlight+0, 0
	IORWF      FARG_I2C_LCD_Write_d+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
;I2C_LCD.c,10 :: 		I2C1_Stop();
	CALL       _I2C1_Stop+0
;I2C_LCD.c,11 :: 		}
L_end_I2C_LCD_Write:
	RETURN
; end of _I2C_LCD_Write

_Lcd_Pulse:

;I2C_LCD.c,14 :: 		void Lcd_Pulse(unsigned char d){
;I2C_LCD.c,15 :: 		I2C_LCD_Write(d | 0x04);   // En = 1
	MOVLW      4
	IORWF      FARG_Lcd_Pulse_d+0, 0
	MOVWF      FARG_I2C_LCD_Write_d+0
	CALL       _I2C_LCD_Write+0
;I2C_LCD.c,16 :: 		Delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;I2C_LCD.c,17 :: 		I2C_LCD_Write(d & (~0x04)); // En = 0
	MOVLW      251
	ANDWF      FARG_Lcd_Pulse_d+0, 0
	MOVWF      FARG_I2C_LCD_Write_d+0
	CALL       _I2C_LCD_Write+0
;I2C_LCD.c,18 :: 		Delay_us(50);
	MOVLW      83
	MOVWF      R13+0
L_Lcd_Pulse0:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Pulse0
;I2C_LCD.c,19 :: 		}
L_end_Lcd_Pulse:
	RETURN
; end of _Lcd_Pulse

_Lcd_Send_Nibble:

;I2C_LCD.c,22 :: 		void Lcd_Send_Nibble(unsigned char nibble, unsigned char rs){
;I2C_LCD.c,23 :: 		unsigned char d = (nibble & 0xF0) | rs;
	MOVLW      240
	ANDWF      FARG_Lcd_Send_Nibble_nibble+0, 0
	MOVWF      FARG_Lcd_Pulse_d+0
	MOVF       FARG_Lcd_Send_Nibble_rs+0, 0
	IORWF      FARG_Lcd_Pulse_d+0, 1
;I2C_LCD.c,24 :: 		Lcd_Pulse(d);
	CALL       _Lcd_Pulse+0
;I2C_LCD.c,25 :: 		}
L_end_Lcd_Send_Nibble:
	RETURN
; end of _Lcd_Send_Nibble

_Lcd_Cmd:

;I2C_LCD.c,28 :: 		void Lcd_Cmd(unsigned char cmd){
;I2C_LCD.c,29 :: 		Lcd_Send_Nibble(cmd & 0xF0, 0);
	MOVLW      240
	ANDWF      FARG_Lcd_Cmd_cmd+0, 0
	MOVWF      FARG_Lcd_Send_Nibble_nibble+0
	CLRF       FARG_Lcd_Send_Nibble_rs+0
	CALL       _Lcd_Send_Nibble+0
;I2C_LCD.c,30 :: 		Lcd_Send_Nibble((cmd << 4) & 0xF0, 0);
	MOVF       FARG_Lcd_Cmd_cmd+0, 0
	MOVWF      FARG_Lcd_Send_Nibble_nibble+0
	RLF        FARG_Lcd_Send_Nibble_nibble+0, 1
	BCF        FARG_Lcd_Send_Nibble_nibble+0, 0
	RLF        FARG_Lcd_Send_Nibble_nibble+0, 1
	BCF        FARG_Lcd_Send_Nibble_nibble+0, 0
	RLF        FARG_Lcd_Send_Nibble_nibble+0, 1
	BCF        FARG_Lcd_Send_Nibble_nibble+0, 0
	RLF        FARG_Lcd_Send_Nibble_nibble+0, 1
	BCF        FARG_Lcd_Send_Nibble_nibble+0, 0
	MOVLW      240
	ANDWF      FARG_Lcd_Send_Nibble_nibble+0, 1
	CLRF       FARG_Lcd_Send_Nibble_rs+0
	CALL       _Lcd_Send_Nibble+0
;I2C_LCD.c,31 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Lcd_Cmd1:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Cmd1
	DECFSZ     R12+0, 1
	GOTO       L_Lcd_Cmd1
	NOP
	NOP
;I2C_LCD.c,32 :: 		}
L_end_Lcd_Cmd:
	RETURN
; end of _Lcd_Cmd

_Lcd_Chr:

;I2C_LCD.c,35 :: 		void Lcd_Chr(unsigned char row, unsigned char col, char out_char){
;I2C_LCD.c,36 :: 		unsigned char address = (row == 1) ? (0x80 + col - 1) : (0xC0 + col - 1);
	MOVF       FARG_Lcd_Chr_row+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Lcd_Chr2
	MOVF       FARG_Lcd_Chr_col+0, 0
	ADDLW      128
	MOVWF      ?FLOC___Lcd_ChrT12+0
	CLRF       ?FLOC___Lcd_ChrT12+1
	BTFSC      STATUS+0, 0
	INCF       ?FLOC___Lcd_ChrT12+1, 1
	MOVLW      1
	SUBWF      ?FLOC___Lcd_ChrT12+0, 1
	BTFSS      STATUS+0, 0
	DECF       ?FLOC___Lcd_ChrT12+1, 1
	GOTO       L_Lcd_Chr3
L_Lcd_Chr2:
	MOVF       FARG_Lcd_Chr_col+0, 0
	ADDLW      192
	MOVWF      ?FLOC___Lcd_ChrT12+0
	CLRF       ?FLOC___Lcd_ChrT12+1
	BTFSC      STATUS+0, 0
	INCF       ?FLOC___Lcd_ChrT12+1, 1
	MOVLW      1
	SUBWF      ?FLOC___Lcd_ChrT12+0, 1
	BTFSS      STATUS+0, 0
	DECF       ?FLOC___Lcd_ChrT12+1, 1
L_Lcd_Chr3:
;I2C_LCD.c,37 :: 		Lcd_Cmd(address);
	MOVF       ?FLOC___Lcd_ChrT12+0, 0
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;I2C_LCD.c,38 :: 		Lcd_Send_Nibble(out_char & 0xF0, 1);
	MOVLW      240
	ANDWF      FARG_Lcd_Chr_out_char+0, 0
	MOVWF      FARG_Lcd_Send_Nibble_nibble+0
	MOVLW      1
	MOVWF      FARG_Lcd_Send_Nibble_rs+0
	CALL       _Lcd_Send_Nibble+0
;I2C_LCD.c,39 :: 		Lcd_Send_Nibble((out_char << 4) & 0xF0, 1);
	MOVF       FARG_Lcd_Chr_out_char+0, 0
	MOVWF      FARG_Lcd_Send_Nibble_nibble+0
	RLF        FARG_Lcd_Send_Nibble_nibble+0, 1
	BCF        FARG_Lcd_Send_Nibble_nibble+0, 0
	RLF        FARG_Lcd_Send_Nibble_nibble+0, 1
	BCF        FARG_Lcd_Send_Nibble_nibble+0, 0
	RLF        FARG_Lcd_Send_Nibble_nibble+0, 1
	BCF        FARG_Lcd_Send_Nibble_nibble+0, 0
	RLF        FARG_Lcd_Send_Nibble_nibble+0, 1
	BCF        FARG_Lcd_Send_Nibble_nibble+0, 0
	MOVLW      240
	ANDWF      FARG_Lcd_Send_Nibble_nibble+0, 1
	MOVLW      1
	MOVWF      FARG_Lcd_Send_Nibble_rs+0
	CALL       _Lcd_Send_Nibble+0
;I2C_LCD.c,40 :: 		}
L_end_Lcd_Chr:
	RETURN
; end of _Lcd_Chr

_Lcd_Out:

;I2C_LCD.c,43 :: 		void Lcd_Out(unsigned char row, unsigned char col, char *text){
;I2C_LCD.c,44 :: 		while(*text) {
L_Lcd_Out4:
	MOVF       FARG_Lcd_Out_text+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Lcd_Out5
;I2C_LCD.c,45 :: 		Lcd_Chr(row, col++, *text++);
	MOVF       FARG_Lcd_Out_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       FARG_Lcd_Out_col+0, 0
	MOVWF      FARG_Lcd_Chr_col+0
	MOVF       FARG_Lcd_Out_text+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
	INCF       FARG_Lcd_Out_col+0, 1
	INCF       FARG_Lcd_Out_text+0, 1
;I2C_LCD.c,46 :: 		}
	GOTO       L_Lcd_Out4
L_Lcd_Out5:
;I2C_LCD.c,47 :: 		}
L_end_Lcd_Out:
	RETURN
; end of _Lcd_Out

_Lcd_Init_I2C:

;I2C_LCD.c,50 :: 		void Lcd_Init_I2C(){
;I2C_LCD.c,51 :: 		Delay_ms(50);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L_Lcd_Init_I2C6:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Init_I2C6
	DECFSZ     R12+0, 1
	GOTO       L_Lcd_Init_I2C6
	DECFSZ     R11+0, 1
	GOTO       L_Lcd_Init_I2C6
	NOP
	NOP
;I2C_LCD.c,52 :: 		Lcd_Send_Nibble(0x30, 0);
	MOVLW      48
	MOVWF      FARG_Lcd_Send_Nibble_nibble+0
	CLRF       FARG_Lcd_Send_Nibble_rs+0
	CALL       _Lcd_Send_Nibble+0
;I2C_LCD.c,53 :: 		Delay_ms(5);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Lcd_Init_I2C7:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Init_I2C7
	DECFSZ     R12+0, 1
	GOTO       L_Lcd_Init_I2C7
	NOP
;I2C_LCD.c,54 :: 		Lcd_Send_Nibble(0x30, 0);
	MOVLW      48
	MOVWF      FARG_Lcd_Send_Nibble_nibble+0
	CLRF       FARG_Lcd_Send_Nibble_rs+0
	CALL       _Lcd_Send_Nibble+0
;I2C_LCD.c,55 :: 		Delay_ms(1);
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_Lcd_Init_I2C8:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Init_I2C8
	DECFSZ     R12+0, 1
	GOTO       L_Lcd_Init_I2C8
;I2C_LCD.c,56 :: 		Lcd_Send_Nibble(0x30, 0);
	MOVLW      48
	MOVWF      FARG_Lcd_Send_Nibble_nibble+0
	CLRF       FARG_Lcd_Send_Nibble_rs+0
	CALL       _Lcd_Send_Nibble+0
;I2C_LCD.c,57 :: 		Lcd_Send_Nibble(0x20, 0);
	MOVLW      32
	MOVWF      FARG_Lcd_Send_Nibble_nibble+0
	CLRF       FARG_Lcd_Send_Nibble_rs+0
	CALL       _Lcd_Send_Nibble+0
;I2C_LCD.c,58 :: 		Lcd_Cmd(0x28); // 4-bit, 2-line, 5x8 font
	MOVLW      40
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;I2C_LCD.c,59 :: 		Lcd_Cmd(0x0C); // Display ON, Cursor OFF
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;I2C_LCD.c,60 :: 		Lcd_Cmd(0x06); // Entry mode: Auto-increment
	MOVLW      6
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;I2C_LCD.c,61 :: 		Lcd_Cmd(0x01); // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;I2C_LCD.c,62 :: 		}
L_end_Lcd_Init_I2C:
	RETURN
; end of _Lcd_Init_I2C
