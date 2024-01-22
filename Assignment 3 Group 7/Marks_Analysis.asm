; Marks.asm
;
; Author:               D. Haley, Professor, for CST8216
; Modified by:          Hamza El Sousi && Mansi Joshi
; Student Number(s):    040982818 && 040
; Lab Section(s):       301
; Course:               CST8216 Fall 2023
; Date:                 Nov. 20th 2023

; Description   This counter counts from START_COUNT to END_COUNT as defined
	   org    $2000      ; Start address of the program
	   db	80, 81, 91, 100, 32, 55, 49, 77
	   db	51, 61, 71, 59, 69, 22, 89, 0
; Define Constants for Marks to Grade Conversions
EIGHTY     EQU    80
SEVENTY    EQU    70
SIXTY      EQU    60
FIFTY      EQU    50

; Define Labels for Count (tally) of each grade
Num_As     EQU    $103A
Num_Bs     EQU    $103B
Num_Cs     EQU    $103C
Num_Ds     EQU    $103D
Num_Es     EQU    $103E     ; Not used, but controlled value
Num_Fs     EQU    $103F

; Marks array starts at $1000
Marks      EQU    $1000

; Grades array starts at $1020
Grades     EQU    $1020

MAIN:       LDAA   Marks, X     ; Load a mark from Marks array
            CMPA   #EIGHTY      ; Compare mark with 80
            BGE    CHECK_SEVENTY

            ; Mark < 80
            CMPA   #SEVENTY     ; Compare mark with 70
            BGE    CHECK_SIXTY

            ; Mark < 70
            CMPA   #SIXTY       ; Compare mark with 60
            BGE    CHECK_FIFTY

            ; Mark < 60
            STAA   Grades, Y    ; Store "F" in Grades array
            INX
            BRA    CHECK_END

CHECK_FIFTY:
            ; Mark >= 50
            STAA   Grades, Y    ; Store "D" in Grades array
            INX
            BRA    CHECK_END

CHECK_SIXTY:
            ; Mark >= 60
            STAA   Grades, Y    ; Store "C" in Grades array
            INX
            BRA    CHECK_END

CHECK_SEVENTY:
            ; Mark >= 70
            STAA   Grades, Y    ; Store "B" in Grades array
            INX
            BRA    CHECK_END

CHECK_EIGHTY:
            ; Mark >= 80
            STAA   Grades, Y    ; Store "A" in Grades array
            INX

CHECK_END:
            CMPX   #$1000       ; Check if at the end of Marks array
            BNE    MAIN         ; If not, continue the loop

            ; Update grade counts
            CMPA   #'A'
            BEQ    INC_NUM_AS
            CMPA   #'B'
            BEQ    INC_NUM_BS
            CMPA   #'C'
            BEQ    INC_NUM_CS
            CMPA   #'D'
            BEQ    INC_NUM_DS
            CMPA   #'F'
            BEQ    INC_NUM_FS

INC_NUM_AS:
            INC    Num_As       ; Increment count of A grades
            BRA    INC_NUM_END

INC_NUM_BS:
            INC    Num_Bs       ; Increment count of B grades
            BRA    INC_NUM_END

INC_NUM_CS:
            INC    Num_Cs       ; Increment count of C grades
            BRA    INC_NUM_END

INC_NUM_DS:
            INC    Num_Ds       ; Increment count of D grades
            BRA    INC_NUM_END

INC_NUM_FS:
            INC    Num_Fs       ; Increment count of F grades

INC_NUM_END:

