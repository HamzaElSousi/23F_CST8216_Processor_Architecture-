; Counter_HEX_Display.asm
;
; Author:               D. Haley, Professor, for CST8216
; Modified by:          Hamza El Sousi && Mansi Joshi
; Student Number(s):    040982818 && 041091664
; Lab Section(s):       301
; Course:               CST8216 Fall 2023
; Date:                 November 19th 2023

; Description   This counter counts from START_COUNT to END_COUNT as defined
;               in the program's equ statements
;               Behaviour:
;               This counter continually counts until Stop is pressed
;               on the simulator, or Reset is press on the Dragron12 Plus
;               Hardware Training board, as follows:
;
;                set Count_Mode to BCD
;                do
;                  count according to Count_Mode setting
;                  set Count_Mode to opposite mode e.g. BCD to HEX or HEX to BCD
;               while (Stop not pressed on the simulator)
;
;               The speed of the counter is adjusted by changing DVALUE,
;               which changes the delay of displaying values in
;               the Delay Subroutine Value
;
; Other info:   The counter will use the Hex Displays to display the count.
;               The count must be in a single register, Accumulator A.
;               The range of the count can be altered by stopping the program,
;               changing the START_COUNT and END_COUNT values, re-assembling
;               and loading/running the program in the Simulator again.
;
;               START_COUNT must be >=0 and END_COUNT must be <= 99

; ***** DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****
; Library Routines used in this software - you must load API.s19 into the
; Simulator to use the following subroutines as detailed in the API Booklet
;
Config_Hex_Displays         equ        $2117
Delay_Ms                    equ        $211F
Hex_Display                 equ        $2139
Extract_Msb                 equ        $2144
Extract_Lsb                 equ        $2149

; Program Constants
STACK           equ     $2000

                                ; Port P (PPT) Display Selection Values
DIGIT3_PP0      equ     %1110   ; Left-most display LSB
DIGIT2_PP1      equ     %1101   ; 2nd from Left-most display MSB

                org     $1000
Count_Mode      ds      1       ; Count_Mode is a flag used to control the
                                ; switching of the count between HEX and BCD
                                ; a $00 here causes the count to be in BCD
                                ; a $FF here causes the count to be in HEX
; ***** END OF DO NOT CHANGE ANY CODE BETWEEN THESE MARKERS *****
; Delay Subroutine Value
DVALUE  equ     #500            ; Delay value (base 10) 0 - 255 ms
                                ; 125 = 1/8 second <- good for Dragon12 Board
; Changing these values will change the Starting and Ending count
START_COUNT     equ     $00     ; Starting count
END_COUNT       equ     $15     ; Ending count

COUNT_VALUE     ds      1
        org     $2000           ; program code
Start   lds     #STACK          ; stack location
        jsr     Config_HEX_Displays ; Use the Hex Displays to display the count
        ldaa    $00
        staa    Count_Mode; Continually Count. Start as BCD counter, then switch to HEX, then BCD ...
Change  ldaa    #START_COUNT       ; Load the initial count value into Accumulator A
        psha                      ; Push the value onto the stack for later use
Cycle   pula                      ; Pop the value from the stack into Accumulator A
        tfr     a,b               ; Transfer the value to register B for further processing
        pshb                      ; Push the value onto the stack for later use
        jsr     Extract_Msb       ; Call subroutine to extract the Most Significant Byte (MSB) of the count
        ldab    #DIGIT3_PP0       ; Load the display selection value for the left-most display (MSB)
        jsr     Hex_Display       ; Display the MSB on the left-most Hex display
        ldaa    #DVALUE            ; Load the delay value into Accumulator A
        jsr     Delay_Ms           ; Delay for the specified milliseconds
        pula                      ; Pop the original count value back into Accumulator A
        tfr     a,b               ; Transfer the value to register B for further processing
        pshb                      ; Push the value onto the stack for later use
        jsr     Extract_Lsb       ; Call subroutine to extract the Least Significant Byte (LSB) of the count
        ldab    #DIGIT2_PP1       ; Load the display selection value for the 2nd left-most display (LSB)
        jsr     Hex_Display       ; Display the LSB on the 2nd left-most Hex display
        ldaa    #DVALUE            ; Load the delay value into Accumulator A
        jsr     Delay_Ms           ; Delay for the specified milliseconds
        ldaa    Count_Mode         ; Load the current Count_Mode flag into Accumulator A
        cmpa    #00                ; Compare with BCD mode flag
        beq     BcdM               ; Branch if in BCD mode
        pula                      ; Pop the original count value back into Accumulator A
        adda    #$1                ; Increment the count for HEX mode
        psha                      ; Push the updated count back onto the stack
        cmpa    #END_COUNT         ; Compare with the specified END_COUNT
        bls     CheckEndCount      ; Branch if less than or equal to the maximum HEX count value
        bra     CMode              ; Branch to change counting mode if the HEX count exceeds the maximum

BcdM    pula                      ; Pop the original count value back into Accumulator A
        adda    #1                 ; Increment the count for BCD mode
        daa                        ; Decimal adjust Accumulator A for valid BCD value
        psha                      ; Push the updated count back onto the stack
CheckEndCount
        cmpa    #END_COUNT         ; Compare the count with the specified END_COUNT
        bhi     CMode              ; Branch if higher (BCD mode) or if greater than (HEX mode) the END_COUNT
        bra     Cycle               ; Branch back to the main counting loop

CMode   com     Count_Mode         ; Change counting mode: BCD to HEX or HEX to BCD, as applicable
        bra     Change              ; Branch back to the beginning of the loop
end