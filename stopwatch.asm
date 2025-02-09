;Секундомер. Три кнопки (с кликом).
;Старт (продолжение), стоп , сброс.
LIST p=16F877A
 __CONFIG H'3F72'
include <p16F877A.inc>
DCounter1 equ 0x22
DCounter2 equ 0x23
DCounter3 equ 0x24
STATUS equ 0x03
PORTB equ 0x06
PORTС equ 0x07
TRISB equ 0x86
TRISC equ 0x87
RP0 equ 0x05
FLAG equ 0x27
MasRAM equ 0x20
MasRAM1 equ 0x21
tmp equ MasRAM +10
tmp1 equ MasRAM1 +10
counter equ 0x29
counter1 equ 0x28
org 0x00
goto Start
 ORG 0x05
Start:
 clrf INTCON ;запрещаем все прерывания
 bsf STATUS, RP0 ;переходим в банк 1
 movlw B'11111111'
 movwf TRISB
 clrf TRISB
 movlw B'00000000'
 movwf TRISC
 bcf STATUS, RP0 ;переходим в банк 0
; movlw B'11111111'
; movwf PORTB ; Обнуляем порт B
 ; Начальные установки
 ;movlw 0xFF
 ;movwf COUNT ; Устанавливаем счетчик в максимальное значение
movlw .0
movwf tmp1
movlw .0
movwf tmp
call DELAY
MainLoop
movlw .1
movwf FLAG
;является ли на выводе порта 1, из-за резистора по умолчанию 1
btfss PORTB, 4
call LOOP11
;нажмем на кнопку, будет равняться 0 или заземелено
btfsc PORTB, 4
call ZERO
goto MainLoop
ZERO
movlw .0
movwf tmp1
movlw .0
movwf tmp
call DELAY
btfss PORTB, 4
nop
;нажмем на кнопку, будет равняться 0 или заземелено
btfsc PORTB, 4
call ZERO
return
LOOP11
movlw .255
movwf tmp1
movlw .11
movwf counter1
LOOOP:
movlw .0
movwf tmp
movlw .10
movwf counter
;movfw tmp1
 ; call MasROM1
 ;movwf 0
 ; Передача значения на порт C
 incf tmp1,F
 ;incf FSR,F
 decfsz counter1,F
 goto label1
 goto LOOP11
label1
Loop:
btfss PORTB, 4
call ZERO
;нажмем на кнопку, будет равняться 0 или заземелено
btfsc PORTB, 4
nop
call DELAY
 ; movfw tmp
 ; call MasROM
 ;movwf 0
 ;movwf PORTС ; Передача значения на порт C
 incf tmp,F
 ;incf FSR,F
 decfsz counter,F
 ; Вызов подпрограммы задержки
 goto Loop
 goto LOOOP
goto LOOP11
MasROM: ;{0,1,2,3,4,5,6,7,8,9}
addwf PCL,F
 retlw B'00010000' ; 0
 retlw B'01011011' ; 1
 retlw B'00001100' ; 2
 retlw B'00001001' ; 3
 retlw B'01000011' ; 4
 retlw B'00100001' ; 5
 retlw B'00100000' ; 6
 retlw B'00011011' ; 7
 retlw B'00000000' ; 8
 retlw B'00000001' ; 9
return
MasROM1: ;{0,1,2,3,4,5,6,7,8,9}
addwf PCL,F
 retlw B'10010000' ; 0
 retlw B'11011011' ; 1
 retlw B'10001100' ; 2
 retlw B'10001001' ; 3
 retlw B'11000011' ; 4
 retlw B'10100001' ; 5
 retlw B'10100000' ; 6
 retlw B'10011011' ; 7
 retlw B'10000000' ; 8
 retlw B'10000001' ; 9
return
DELAY
 MOVLW 0X6d
 MOVWF DCounter1
 MOVLW 0X5e
 MOVWF DCounter2
 MOVLW 0X5
 MOVWF DCounter3
LOOP2
 movfw tmp1
 call MasROM1
 movwf PORTС
 movfw tmp
 call MasROM
 movwf PORTС
 DECFSZ DCounter1, 1
 GOTO LOOP2

 DECFSZ DCounter2, 1
 GOTO LOOP2
 DECFSZ DCounter3, 1
 GOTO LOOP2
 RETURN
end
