; Find_Two_Strings.asm
;
; Author:               [Your Name]
;
; Date:                 [Current Date]
;
; Purpose:              Subroutine to find the first character of two strings

#include "Lab_Section_301_Names.txt"
FirstChar    RMB 1  ; Reserve memory for the first character
SecondChar   RMB 1  ; Reserve memory for the second character

Find_Two_Strings:
    ldaa NamesBuffer, x  ; Load the first character of the first string
    staa FirstChar

    ; Check if the end of the first string is reached
    cmpa #Space
    beq FirstStringEnd

    ; Increment index and load the first character of the second string
    inx
    ldaa NamesBuffer, x
    staa SecondChar

    ; Check if the end of the second string is reached
    cmpa #Space
    beq SecondStringEnd

    bra ExitSubroutine

FirstStringEnd:
    ldaa #Space  ; Load space as the second character
    staa SecondChar
    bra ExitSubroutine

SecondStringEnd:
    ldaa #NullChar  ; Load null character as the second character
    staa SecondChar

ExitSubroutine:
    rts

Space       EQU $20  ; ASCII code for space character
NullChar    EQU $00  ; Null character to indicate the end of a string