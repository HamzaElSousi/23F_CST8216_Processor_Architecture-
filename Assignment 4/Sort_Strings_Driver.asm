; Sort_Strings_Driver.asm
;
; Author:               [Your Name]
;
; Date:                 [Current Date]
;
; Purpose:              Main driver program to sort an array of strings
; Start of the program memory
 org $2000
START:      ; Entry point
    ldx #0  ; Initialize index register to 0

MainLoop:
    jsr Find_Two_Strings  ; Call subroutine to find two strings
    bne NeedSwap          ; Branch if strings need to be swapped

    ; Continue traversing through the array
    inx
    cmpa #NumberOfNames   ; Check if all names have been processed
    beq DoneSorting

    bra MainLoop

NeedSwap:
    jsr Swap_Two_Strings   ; Call subroutine to swap two strings
    bra MainLoop

DoneSorting:
    ; Sorting complete, you can add further code or exit here

NumberOfNames EQU 27  ; Update this value based on the number of names in the file

#include "Lab_Section_301_Names.txt"
#include "Find_Two_Strings.asm"
#include "Swap_Two_Strings.asm"
