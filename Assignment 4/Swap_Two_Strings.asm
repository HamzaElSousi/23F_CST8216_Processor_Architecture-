; Swap_Two_Strings.asm
;
; Author:               [Your Name]
;
; Date:                 [Current Date]
;
; Purpose:              Subroutine to swap two strings in memory

#include "Lab_Section_301_Names.txt"

TempChar    RMB 1  ; Reserve memory for temporary character
TempBuffer  RMB 1  ; Reserve memory for temporary buffer

Swap_Two_Strings:
    ldaa FirstChar
    staa TempChar       ; Save the first character temporarily

    ldaa NamesBuffer, x  ; Load the second character of the first string
    staa TempBuffer      ; Save the second character temporarily

    ldaa NamesBuffer, y  ; Load the first character of the second string
    staa NamesBuffer, x

    ldaa TempChar       ; Load the first character into the second string
    staa NamesBuffer, y

    ldaa TempBuffer      ; Load the second character into the first string
    staa NamesBuffer, x

    rts
