
I2C_LCD_Send_Nibble:

;I2C_LCD.c,22 :: 		static void Send_Nibble(unsigned char nibble, unsigned char rs) {
;I2C_LCD.c,23 :: 		unsigned char d = (nibble & 0xF0) | rs;
	MOVLW      240
	ANDWF      FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	MOVWF      I2C_LCD_Send_Nibble_d_L0+0
	MOVF       FARG_I2C_LCD_Send_Nibble_rs+0, 0
	IORWF      I2C_LCD_Send_Nibble_d_L0+0, 1
;I2C_LCD.c,26 :: 		LCD_I2C_SEND(d | 0x04);
	CALL       _I2C1_Start+0
	MOVLW      78
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
	MOVLW      4
	IORWF      I2C_LCD_Send_Nibble_d_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	MOVF       I2C_LCD_lcd_backlight+0, 0
	IORWF      FARG_I2C1_Wr_data_+0, 1
	CALL       _I2C1_Wr+0
	CALL       _I2C1_Stop+0
;I2C_LCD.c,27 :: 		Delay_us(1);
	NOP
	NOP
	NOP
	NOP
	NOP
;I2C_LCD.c,30 :: 		LCD_I2C_SEND(d & 0xFB);
	CALL       _I2C1_Start+0
	MOVLW      78
	MOVWF      FARG_I2C1_Wr_data_+0
	CALL       _I2C1_Wr+0
	MOVLW      251
	ANDWF      I2C_LCD_Send_Nibble_d_L0+0, 0
	MOVWF      FARG_I2C1_Wr_data_+0
	MOVF       I2C_LCD_lcd_backlight+0, 0
	IORWF      FARG_I2C1_Wr_data_+0, 1
	CALL       _I2C1_Wr+0
	CALL       _I2C1_Stop+0
;I2C_LCD.c,31 :: 		Delay_us(50);
	MOVLW      83
	MOVWF      R13+0
L_I2C_LCD_Send_Nibble0:
	DECFSZ     R13+0, 1
	GOTO       L_I2C_LCD_Send_Nibble0
;I2C_LCD.c,32 :: 		}
L_end_Send_Nibble:
	RETURN
; end of I2C_LCD_Send_Nibble

_Lcd_Cmd:

;I2C_LCD.c,37 :: 		void Lcd_Cmd(unsigned char cmd) {
;I2C_LCD.c,38 :: 		Send_Nibble(cmd & 0xF0,        0);   // high nibble
	MOVLW      240
	ANDWF      FARG_Lcd_Cmd_cmd+0, 0
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	CLRF       FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,39 :: 		Send_Nibble((cmd << 4) & 0xF0, 0);   // low nibble
	MOVF       FARG_Lcd_Cmd_cmd+0, 0
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	MOVLW      240
	ANDWF      FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	CLRF       FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,40 :: 		Delay_ms(2);
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
;I2C_LCD.c,41 :: 		}
L_end_Lcd_Cmd:
	RETURN
; end of _Lcd_Cmd

_Lcd_Chr:

;I2C_LCD.c,48 :: 		void Lcd_Chr(unsigned char row, unsigned char col, char ch) {
;I2C_LCD.c,51 :: 		addr = (row == 1) ? (0x80 + col - 1) : (0xC0 + col - 1);
	MOVF       FARG_Lcd_Chr_row+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_Lcd_Chr2
	MOVF       FARG_Lcd_Chr_col+0, 0
	ADDLW      128
	MOVWF      ?FLOC___Lcd_ChrT12+0
	MOVLW      1
	SUBWF      ?FLOC___Lcd_ChrT12+0, 1
	MOVLW      0
	MOVWF      ?FLOC___Lcd_ChrT12+1
	GOTO       L_Lcd_Chr3
L_Lcd_Chr2:
	MOVF       FARG_Lcd_Chr_col+0, 0
	ADDLW      192
	MOVWF      ?FLOC___Lcd_ChrT12+0
	MOVLW      1
	SUBWF      ?FLOC___Lcd_ChrT12+0, 1
	MOVLW      0
	MOVWF      ?FLOC___Lcd_ChrT12+1
L_Lcd_Chr3:
	MOVF       ?FLOC___Lcd_ChrT12+0, 0
	MOVWF      Lcd_Chr_addr_L0+0
;I2C_LCD.c,54 :: 		Send_Nibble(addr & 0xF0,        0);
	MOVLW      240
	ANDWF      ?FLOC___Lcd_ChrT12+0, 0
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	CLRF       FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,55 :: 		Send_Nibble((addr << 4) & 0xF0, 0);
	MOVF       Lcd_Chr_addr_L0+0, 0
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	MOVLW      240
	ANDWF      FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	CLRF       FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,56 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Lcd_Chr4:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Chr4
	DECFSZ     R12+0, 1
	GOTO       L_Lcd_Chr4
	NOP
	NOP
;I2C_LCD.c,59 :: 		Send_Nibble((unsigned char)ch & 0xF0,        1);
	MOVLW      240
	ANDWF      FARG_Lcd_Chr_ch+0, 0
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	MOVLW      1
	MOVWF      FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,60 :: 		Send_Nibble(((unsigned char)ch << 4) & 0xF0, 1);
	MOVF       FARG_Lcd_Chr_ch+0, 0
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	RLF        FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	BCF        FARG_I2C_LCD_Send_Nibble_nibble+0, 0
	MOVLW      240
	ANDWF      FARG_I2C_LCD_Send_Nibble_nibble+0, 1
	MOVLW      1
	MOVWF      FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,61 :: 		}
L_end_Lcd_Chr:
	RETURN
; end of _Lcd_Chr

_Lcd_Out:

;I2C_LCD.c,66 :: 		void Lcd_Out(unsigned char row, unsigned char col, char *text) {
;I2C_LCD.c,67 :: 		while(*text) {
L_Lcd_Out5:
	MOVF       FARG_Lcd_Out_text+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Lcd_Out6
;I2C_LCD.c,68 :: 		Lcd_Chr(row, col++, *text++);
	MOVF       FARG_Lcd_Out_row+0, 0
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       FARG_Lcd_Out_col+0, 0
	MOVWF      FARG_Lcd_Chr_col+0
	MOVF       FARG_Lcd_Out_text+0, 0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Lcd_Chr_ch+0
	CALL       _Lcd_Chr+0
	INCF       FARG_Lcd_Out_col+0, 1
	INCF       FARG_Lcd_Out_text+0, 1
;I2C_LCD.c,69 :: 		}
	GOTO       L_Lcd_Out5
L_Lcd_Out6:
;I2C_LCD.c,70 :: 		}
L_end_Lcd_Out:
	RETURN
; end of _Lcd_Out

_Lcd_Init_I2C:

;I2C_LCD.c,77 :: 		void Lcd_Init_I2C() {
;I2C_LCD.c,78 :: 		Delay_ms(50);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      69
	MOVWF      R12+0
	MOVLW      169
	MOVWF      R13+0
L_Lcd_Init_I2C7:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Init_I2C7
	DECFSZ     R12+0, 1
	GOTO       L_Lcd_Init_I2C7
	DECFSZ     R11+0, 1
	GOTO       L_Lcd_Init_I2C7
	NOP
	NOP
;I2C_LCD.c,81 :: 		Send_Nibble(0x30, 0);
	MOVLW      48
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	CLRF       FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,82 :: 		Delay_ms(5);
	MOVLW      33
	MOVWF      R12+0
	MOVLW      118
	MOVWF      R13+0
L_Lcd_Init_I2C8:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Init_I2C8
	DECFSZ     R12+0, 1
	GOTO       L_Lcd_Init_I2C8
	NOP
;I2C_LCD.c,83 :: 		Send_Nibble(0x30, 0);
	MOVLW      48
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	CLRF       FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,84 :: 		Delay_ms(1);
	MOVLW      7
	MOVWF      R12+0
	MOVLW      125
	MOVWF      R13+0
L_Lcd_Init_I2C9:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Init_I2C9
	DECFSZ     R12+0, 1
	GOTO       L_Lcd_Init_I2C9
;I2C_LCD.c,85 :: 		Send_Nibble(0x30, 0);
	MOVLW      48
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	CLRF       FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,88 :: 		Send_Nibble(0x20, 0);
	MOVLW      32
	MOVWF      FARG_I2C_LCD_Send_Nibble_nibble+0
	CLRF       FARG_I2C_LCD_Send_Nibble_rs+0
	CALL       I2C_LCD_Send_Nibble+0
;I2C_LCD.c,91 :: 		Lcd_Cmd(0x28);   // 4-bit, 2-line, 5x8 font
	MOVLW      40
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;I2C_LCD.c,92 :: 		Lcd_Cmd(0x0C);   // Display ON, Cursor OFF
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;I2C_LCD.c,93 :: 		Lcd_Cmd(0x06);   // Entry mode: auto-increment
	MOVLW      6
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;I2C_LCD.c,94 :: 		Lcd_Cmd(0x01);   // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_cmd+0
	CALL       _Lcd_Cmd+0
;I2C_LCD.c,95 :: 		Delay_ms(2);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_Lcd_Init_I2C10:
	DECFSZ     R13+0, 1
	GOTO       L_Lcd_Init_I2C10
	DECFSZ     R12+0, 1
	GOTO       L_Lcd_Init_I2C10
	NOP
	NOP
;I2C_LCD.c,96 :: 		}
L_end_Lcd_Init_I2C:
	RETURN
; end of _Lcd_Init_I2C
