; REGISTERS
; R0: Primary
; R1: (FREE) Current Value
; R2: (FREE) Previous Value
; R3: Operator Vector for JSRR
; R4: RPN Stack Pointer
; R5: RESULT Value
; R6: (DON'T USE) (PURPOSE: STACK)
; R7: (DON'T USE) (PURPOSE: RET address)

; ================================================================================
; ==============              START OF INITALIZATION                ==============
; ================================================================================

                .ORIG x0027
                .FILL FLIP_SIGNS    ; Changes signs of R2 and R1 (For multiplication and division)
                .end
                
                .ORIG x0028
                .FILL MULT_10
                .end
                
                .ORIG x0029
                .FILL OUT_NUM
                .end
                
                .ORIG x300
FLIP_SIGNS      NOT R2, R2
                ADD R2, R2, #1
                NOT R1, R1
                ADD R1, R1, #1
                RTI
                .end
       
                .ORIG x310
SAVE_R5         .BLKW #1    ; Save Result

MULT_10         ST  R5, SAVE_R5
                ADD R5, R1, #0      ;   R1 = R1 * 10
                ADD R1, R1, R5
                ADD R1, R1, R5
                ADD R1, R1, R5
                ADD R1, R1, R5
                ADD R1, R1, R5
                ADD R1, R1, R5
                ADD R1, R1, R5
                ADD R1, R1, R5
                ADD R1, R1, R5
                LD  R5, SAVE_R5
                RTI
                .end
                
                .ORIG x320
TEN_THOUSAND    .FILL #10000
THOUSAND        .FILL #1000
HUNDRED         .FILL #100
TENS            .FILL #10
ONES            .FILL #1
COUNT           .FILL #0
OUT_STACK       .FILL #0
                .FILL #0
                .FILL #0
                .FILL #0
                .FILL #0
TMP_R0          .BLKW #1
TMP_R4          .BLKW #1
TMP_R7          .BLKW #1
DEC_TO_CHAR     .FILL #48
OUT_NUM         ST  R0, TMP_R0
                ST  R4, TMP_R4
                ST  R7, TMP_R7
                LEA R4, OUT_STACK
                
                
; TEN_THOUSAND
                LD  R1, TEN_THOUSAND
                LD  R2, COUNT
                NOT R1, R1
                ADD R1, R1, #1
REPEAT_10K      ADD R0, R0, R1      ; R0 - 10,000
                BRn END_10K
                ADD R2, R2, #1      ; COUNT++
                BR  REPEAT_10K
END_10K         LD  R0, DEC_TO_CHAR
                ADD R0, R2, R0
                STR R0, R4, #0      ; STORE COUNT ONTO STACK [HERE][][][][]
                LD  R0, TMP_R0      ; REMOVE TEN_THOUSAND DIGIT
                ADD R2, R2, #0
                BRz FINISH_10K      ; CHECK IF VALID TO REMOVE FIRST
END_10K_2       ADD R0, R0, R1      ; SUB
                ADD R2, R2, #-1     ; COUNT--
                BRp END_10K_2
FINISH_10K      ST  R0, TMP_R0      ; UPDATE CURRENT RESULT
                ADD R4, R4, #1      ; MOVE POINTER

; THOUSAND
                LD  R1, THOUSAND
                LD  R2, COUNT       ; START COUNT OVER
                NOT R1, R1
                ADD R1, R1, #1
REPEAT_1K       ADD R0, R0, R1      ; R0 - 1000
                BRn END_1K
                ADD R2, R2, #1      ; COUNT++
                BR  REPEAT_1K
END_1K          LD  R0, DEC_TO_CHAR
                ADD R0, R2, R0
                STR R0, R4, #0      ; STORE COUNT ONTO STACK [HERE][][][][]
                LD  R0, TMP_R0      ; REMOVE TEN_THOUSAND DIGIT
                ADD R2, R2, #0
                BRz FINISH_1K       ; CHECK IF VALID TO REMOVE FIRST
END_1K_2        ADD R0, R0, R1      ; SUB
                ADD R2, R2, #-1     ; COUNT--
                BRp END_1K_2
FINISH_1K       ST  R0, TMP_R0
                ADD R4, R4, #1
                
; HUNDRED
                LD  R1, HUNDRED
                LD  R2, COUNT       ; START COUNT OVER
                NOT R1, R1
                ADD R1, R1, #1
REPEAT_100      ADD R0, R0, R1      ; R0 - 1000
                BRn END_100
                ADD R2, R2, #1      ; COUNT++
                BR  REPEAT_100
END_100         LD  R0, DEC_TO_CHAR
                ADD R0, R2, R0
                STR R0, R4, #0      ; STORE COUNT ONTO STACK [HERE][][][][]
                LD  R0, TMP_R0      ; REMOVE TEN_THOUSAND DIGIT
                ADD R2, R2, #0
                BRz FINISH_100      ; CHECK IF VALID TO REMOVE FIRST
END_100_2       ADD R0, R0, R1      ; SUB
                ADD R2, R2, #-1     ; COUNT--
                BRp END_100_2
FINISH_100      ST  R0, TMP_R0
                ADD R4, R4, #1
                
; TENS
                LD  R1, TENS
                LD  R2, COUNT       ; START COUNT OVER
                NOT R1, R1
                ADD R1, R1, #1
REPEAT_10       ADD R0, R0, R1      ; R0 - 1000
                BRn END_10
                ADD R2, R2, #1      ; COUNT++
                BR  REPEAT_10
END_10          LD  R0, DEC_TO_CHAR
                ADD R0, R2, R0
                STR R0, R4, #0      ; STORE COUNT ONTO STACK [HERE][][][][]
                LD  R0, TMP_R0      ; REMOVE TEN_THOUSAND DIGIT
                ADD R2, R2, #0
                BRz FINISH_10      ; CHECK IF VALID TO REMOVE FIRST
END_10_2        ADD R0, R0, R1      ; SUB
                ADD R2, R2, #-1     ; COUNT--
                BRp END_10_2
FINISH_10       ST  R0, TMP_R0
                ADD R4, R4, #1
                
; ONES
                LD  R1, ONES
                LD  R2, COUNT       ; START COUNT OVER
                NOT R1, R1
                ADD R1, R1, #1
REPEAT_1        ADD R0, R0, R1      ; R0 - 1000
                BRn END_1
                ADD R2, R2, #1      ; COUNT++
                BR  REPEAT_1
END_1           LD  R0, DEC_TO_CHAR
                ADD R0, R2, R0
                STR R0, R4, #0      ; STORE COUNT ONTO STACK [HERE][][][][]
                LD  R0, TMP_R0      ; REMOVE TEN_THOUSAND DIGIT
                ADD R2, R2, #0
                BRz FINISH_1      ; CHECK IF VALID TO REMOVE FIRST
END_1_2         ADD R0, R0, R1      ; SUB
                ADD R2, R2, #-1     ; COUNT--
                BRp END_1_2
FINISH_1        ST  R0, TMP_R0
                ADD R4, R4, #1
                
FINISH_OUTPUT   LEA R4, OUT_STACK
                LDR R0, R4, #0      ; [!][][][][]
                OUT
                ADD R4, R4, #1
                LDR R0, R4, #0      ; [][!][][][]
                OUT
                ADD R4, R4, #1
                LDR R0, R4, #0      ; [][][!][][]
                OUT
                ADD R4, R4, #1
                LDR R0, R4, #0      ; [][][][!][]
                OUT
                ADD R4, R4, #1
                LDR R0, R4, #0      ; [][][][][!]
                OUT
                LD  R4, TMP_R4
                LD  R7, TMP_R7
                RTI
                .end

                .ORIG x3000
                BR START
;   -= STRINGS =-
JUST_LINES      .stringz "\n====================\n"
NEW_LINE        .stringz "\n"
ERROR_MESSAGE   .stringz "ERROR. RESTARTING PROGRAM..."
PROMPT_START    .stringz "SMC RPN calculator\nEnter 0-9 or +, -, *, /, or . to display result on TOS"
PRINT_TOS       .stringz "\nResult: "

;   -= PROMPTS =-
_PROMPT_NEXT     .FILL x3E   ; '>'
_UNDEFINED_ERROR .FILL x3F   ; '?'
_STACK_ERROR     .FILL x24   ; '$'
_NUM_ERROR       .FILL x21   ; '!'

;   -= VALID CHAR =-
_ZERO           .FILL x30   ; '0'
_NINE           .FILL x39   ; '9'
_ADD            .FILL x2B   ; '+'
_SUBTRACT       .FILL x2D   ; '-'
_MULTIPLY       .FILL x2A   ; '*'
_DIVIDE         .FILL x2F   ; '/'
_PERIOD         .FILL x2E   ; "."
_COMMA          .FILL x2C   ; ","
_ENTER          .FILL x0A   ; ENTER KEY
_SPACE          .FILL x20   ; " " (SPACE KEY)

;   -= VARIABLES =-
STACK           .FILL x4000 ; Main Stack
NUM_STACK       .BLKW #5
SIZE            .FILL #0    ; SIZE OF STACK
RESULT          .FILL #0    ; Saved result from TOS
SAVE_R4         .BLKW #1    ; Switching from regular stack to num stack
SAVE_R7         .BLKW #1    ; R7 save for NUM_COMPUTE
NUM_SIZE        .FILL #0    ; Digits entered into NUM_STACK

;   -= OTHER =-
DECIMAL_TO_CHAR .FILL #48
CHAR_TO_DECIMAL .FILL #-48

; ================================================================================
; ===============              END OF INITALIZATION                ===============
; ================================================================================
; ===============                MAIN PROGRAM                       ==============
; ================================================================================
            
START           LEA R1, NUM_STACK   ;   ADD NULL-TERMINATE VALUE TO NUM_STACK
                AND R0, R0, #0
                STR R0, R1, #4
                LD  R4, STACK       ;   ASSIGN MAIN STACK
                LEA R0, PROMPT_START
                PUTS
                LEA R0, NEW_LINE
                PUTS
                
PRE_INPUT       LD R0, _PROMPT_NEXT
                OUT
INPUT_LOOP      GETC                ;   GETC & OUT
                JSR OPERATOR_CHK    ;   CHECK FOR OPERATORS
                JSR OTHER_CHAR_CHK  ;   CHECK FOR PERIOD "." OR ENTER_KEY
                JSR NUM_CHK         ;   CHECK FOR NUMBERS (0-9)
                BR  INPUT_LOOP      ;   INPUT IS INVALID, REPEATS 

; ================================================================================
; ================               NUMBER INPUT                     ================
; ================================================================================
; R0 = CURRENT VALUE
; R1 = (FREE)
; R2 = (FREE)
; R3 = NUM_SIZE (For Stage 3a)
; R4 = NUM_STACK

;   -= 1. INITALIZATION =-
START_NUM       ST  R4, SAVE_R4
                LEA R4, NUM_STACK
                AND R1, R1, #0
                ST  R1, NUM_SIZE    ;   RESET DIGIT COUNTER

;   -= 2. LOOP =-
IS_NUM          OUT
                LD  R1, CHAR_TO_DECIMAL
                ADD R0, R0, R1       ;   CONVERT ASCII TO DECIMAL
                STR R0, R4, #0       ;   STORE DIGIT
                ADD R4, R4, #1
                LD  R1, NUM_SIZE     ;   NUM_SIZE++
                ADD R1, R1, #1
                ST  R1, NUM_SIZE     ;   SAVE
                ADD R1, R1, #-4
                BRz USER_DONE        ;   FORCE DONE AT 4 DIGITS
REPEAT          GETC
                JSR VALID_CHAR_CHK   ;   CHECK FOR SPACE or OPERATORS (Quick end)
                JSR INVALID_NUM_CHK  ;   CHECK FOR ANOTHER DIGIT
                BR  IS_NUM

;   -= 3. FINISH =-
USER_DONE       LD  R0, _SPACE      ;   Auto inputs a space to prevent user from typing more than 4 digits
                OUT
                JSR NUM_COMPUTE
                LD  R4, SAVE_R4     ;   Restore Main Stack
                JSR PUSH
                BR  INPUT_LOOP
  
;   -= 3a. COMPUTING STAGE =-

NUM_COMPUTE     ST  R7, SAVE_R7     ;   For PUSH
                LEA R4, NUM_STACK   ;   Return pointer back to begining of digit
                AND R1, R1, #0      ;   R1 = Result
                LD  R3, NUM_SIZE
NUM_LOOP        ADD R3, R3, #0
                BRz NUM_DONE
                LDR R0, R4, #0      ;   R0 = next decimal digit
                ADD R4, R4, #1
                ADD R3, R3, #-1
                TRAP x28            ;   MULT_10
                ADD R1, R1, R0      ;   ADD TOGETHER (Ex. 1 + 10 + 100 + 1000)
                BR  NUM_LOOP
NUM_DONE        ADD R0, R1, #0      ;   PUSH uses R0
                RET

;   -= FUNCTION CHECKS =-

INVALID_NUM_CHK  LD  R1, _NINE       ;   R0 = '9'
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRp REPEAT          ;   INPUT WAS INVALID, IGNORES
                LD  R1, _ZERO       ;   R0 = '0'
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRn REPEAT          ;   INPUT WAS INVALID, IGNORES
                RET

VALID_CHAR_CHK  LD  R1, _SPACE      ;   RO = " "
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz USER_DONE
                LD  R1, _ADD        ;   RO = "+"
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz USER_DONE
                LD  R1, _SUBTRACT   ;   RO = "-"
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz USER_DONE
                LD  R1, _MULTIPLY   ;   RO = "*"
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz USER_DONE
                LD  R1, _DIVIDE     ;   RO = "/"
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz USER_DONE
                LD  R1, _PERIOD     ;   RO = "."
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz USER_DONE
                RET                 ;   NO SPECIAL CHAR

; ================================================================================
; ================               TOS FUNCTION                     ================
; ================================================================================

TOS_CHECK       LD  R2, SIZE
                BRz ERROR_STACK     ;   EMPTY STACK -> ERROR (Can't check empty)
                LDR R0, R4, #0      ;   TOS value
                ADD R5, R0, #0
                ST  R0, RESULT
_TOS_PRINT      LEA R0, PRINT_TOS
                PUTS
                LD  R0, RESULT
                TRAP x29
                BR INPUT_LOOP
      
; ================================================================================
; ================                FUNCTIONS                       ================
; ================================================================================

NUM_CHK         LD  R1, _NINE       ;   R0 = '9'
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRp INPUT_LOOP      ;   IGNORE, INVALID INPUT (R0 > x39 ('9'))
                LD  R1, _ZERO       ;   R0 = '0'
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRn INPUT_LOOP      ;   IGNORE, INVALID INPUT (R0 < x2A ('0'))
                BR  START_NUM
                
OTHER_CHAR_CHK  LD  R1, _ENTER      ;   R0 = ENTER_KEY
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz _HIT_ENTER      ;   New line for additional expression
                LD  R1, _PERIOD     ;   R0 = '.'
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz TOS_CHECK       ;   Check Top of Stack if R0 == '.'
                RET
                
_HIT_ENTER      OUT
                BR PRE_INPUT

; ================================================================================
; =============                ERROR FUNCTIONS                       =============
; ================================================================================
;   INTRODUCED POINTERS TO PREVENT INSTRUCTION DISTANCE ERROR (value is too big for signed 9-bit integer)
PTR_JUST_LINES    .FILL JUST_LINES
PTR_ERROR_MESSAGE .FILL ERROR_MESSAGE

ERROR           LD R0, PTR_JUST_LINES
                PUTS
                LD R0, PTR_ERROR_MESSAGE
                PUTS
                LD R0, PTR_JUST_LINES
                PUTS
                AND R0, R0, #0      ; Resets SIZE
                ST  R0, SIZE
                BR  START
               
ERROR_STACK     LD  R0, _STACK_ERROR
                OUT
                BR  ERROR

ERROR_NUM       LD  R0, _NUM_ERROR
                OUT
                BR  ERROR
                
ERROR_UNDEFINED LD R0, _UNDEFINED_ERROR    ; Divide by 0 case
                OUT
                BR  ERROR

; ================================================================================
; =============                STACK FUNCTIONS                       =============
; ================================================================================

PUSH            ADD R4, R4, #-1     ;   Decrement
                STR R0, R4, #0      ;   Store
                LD  R2, SIZE        ;   SIZE++
                ADD R2, R2, #1
                ST  R2, SIZE
                RET
                
POP             LDR R0, R4, #0      ;   Load
                ADD R4, R4, #1      ;   Increment
                LD  R2, SIZE        ;   SIZE--
                ADD R2, R2, #-1
                ST  R2, SIZE
                RET

; ================================================================================
; ============                OPERATOR FUNCTIONS                       ===========
; ================================================================================

OPERATOR_CHK    LD  R1, _ADD
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz ADD_SUBROUTINE
                LD  R1, _SUBTRACT
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz SUB_SUBROUTINE
                LD  R1, _MULTIPLY
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz MUL_SUBROUTINE
                LD  R1, _DIVIDE
                NOT R1, R1
                ADD R1, R1, #1
                ADD R1, R0, R1
                BRz DIV_SUBROUTINE
                RET                 ;   NO OPERATOR WAS FOUND
                
ADD_SUBROUTINE  OUT
                LEA R3, ADDITION
                BR  EXECUTE_OPERATOR
                
SUB_SUBROUTINE  OUT
                LEA R3, SUBTRACTION
                BR  EXECUTE_OPERATOR
                
MUL_SUBROUTINE  OUT
                LEA R3, MULTIPLICATION
                BR  EXECUTE_OPERATOR
                
DIV_SUBROUTINE  OUT
                LEA R3, DIVISION
                BR  EXECUTE_OPERATOR

EXECUTE_OPERATOR LD  R2, SIZE
                ADD  R2, R2, #-1
                BRnz ERROR_STACK    ;   SIZE >= 2, else invalid computation
                JSR  POP
                ADD  R1, R0, #0     ;   (...) +-*/ (THIS)
                JSR  POP
                ADD  R2, R0, #0     ;   (THIS) +-*/ (...)
                AND  R0, R0, #0
                JSRR R3             ;   JUMP TO SAVED OPERATOR FUNCITON
IS_VALID        JSR  PUSH
                BR   INPUT_LOOP

; ========================================================
; ============      ADDITION / SUBTRACTION    ============
; ========================================================
; R2+ & R1+ = (-)
; R2- & R1- = (+)
; Otherwise, do a regular add
        
SUBTRACTION     NOT R1, R1          ;   Flip signs of R1
                ADD R1, R1, #1
ADDITION        ADD R2, R2, #0      ;   Check R2 Sign
                BRp R2_IS_POS       ;   (+) + (?)
                BRn R2_IS_NEG       ;   (-) + (?)
                BRz REGULAR_ADD     ;    0  + (?)

R2_IS_POS       ADD  R1, R1, #0
                BRp  POS_ADD        ;   (+) + (+)
                BRnz REGULAR_ADD    ;   (+) + (-) OR (+) + 0

R2_IS_NEG       ADD  R1, R1, #0
                BRzp REGULAR_ADD    ;   (-) + (+) OR (-) + 0
                BRn  NEG_ADD        ;   (-) + (-)
                
POS_ADD         ADD  R0, R2, R1
                BRnz ERROR_NUM      ;   (+) + (+) = (-) means an OVERFLOW occured
                RET

NEG_ADD         ADD  R0, R2, R1
                BRzp ERROR_NUM      ;   (-) + (-) = (+) means an UNDERFLOW occured
                RET
                
; Its impossible for overflow/underflow here as R1 or R2 cannot hold a value more than 16-bits
; As such, if (+) + (-) or vice versa, it'll always equal to something else less together
REGULAR_ADD     ADD R0, R2, R1
                RET

; ================================================
; ============      MULTIPLICATION    ============
; ================================================

MULTIPLICATION  ADD R1, R1, #0
                BRz TIMES_ZERO      ;   R2 * 0
                BRp SKIP            ;   R2 * (+)
                TRAP x27            ;   R1 is negative, flip signs of both
SKIP            ADD R2, R2, #0
                BRn NEG_MULT
                BRp POS_MULT
                BRz TIMES_ZERO

;   -= POSITIVE MULTIPLCATION =-
POS_MULT        ADD  R0, R2, #0     ;   Multiply by 1
                ADD  R1, R1, #-1
                BRz  FINISHED_MULT
POS_MULT_NEXT   ADD  R0, R0, R2     ;   Multiply (R0 + R2)
                BRnz ERROR_NUM      ;   [ (+) * (-) = (+) ] -> OVERFLOW
                ADD  R1, R1, #-1    ;   Decrement loop
                BRp  POS_MULT_NEXT  ;   REPEAT
                BR   FINISHED_MULT

;   -= NEGATIVE MULTIPLCATION =-
NEG_MULT        ADD R0, R2, #0      ;   Multiply by 1
                ADD R1, R1, #-1
                BRz FINISHED_MULT
NEG_MULT_NEXT   ADD R0, R0, R2      ;   Multiply (R0 + R2)
                BRzp ERROR_NUM      ;   [ (+) * (-) = (+) ] -> UNDERFLOW
                ADD R1, R1, #-1     ;   Decrement loop
                BRp NEG_MULT_NEXT   ;   REPEAT
                BR  FINISHED_MULT

;   -= CONDITIONS =-
TIMES_ZERO      AND R0, R0, #0
                RET
                
TIMES_ONE       ADD R0, R2, #0
                RET
                
FINISHED_MULT   RET

; ==========================================
; ============      DIVISION    ============
; ==========================================

DIVISION        ADD R1, R1, #0
                BRz ERROR_UNDEFINED ;    Cannot divide by zero
                BRp DIV_CHK_R2      ;    R1 is already positive, move on
                TRAP x27            ;    R1 is negative, so flip BOTH
DIV_CHK_R2      ADD R2, R2, #0
                BRp DIV_POS_SETUP   ;    R2 positive -> Positive division
                BRn DIV_NEG_SETUP   ;    R2 negative -> Negative division
                AND R0, R0, #0      ;    R2 = 0, so finished
                RET

;   -= NEGATIVE DIVISION =-           
DIV_NEG_SETUP   TRAP x27            ;    R2 negative -> Setup for Negative Division
DIV_NEG_LOOP    ADD R2, R2, R1      ;    R2 - R1
                BRn NEG_DONE        ;    R2 < 0 = STOP
                ADD R0, R0, #1      ;    Count 1 successful division
                BR DIV_NEG_LOOP
NEG_DONE        NOT R0, R0          ;    Flip result to negative
                ADD R0, R0, #1
                RET

;   -= POSTIIVE DIVISION =-
DIV_POS_SETUP   NOT R1, R1
                ADD R1, R1, #1
DIV_POS_LOOP    ADD R2, R2, R1      ;    R2 - R1
                BRn POS_DONE        ;    R2 < 0 = STOP
                ADD R0, R0, #1      ;    Count 1 successful division
                BR DIV_POS_LOOP
POS_DONE        RET

END             HALT
                .END
                

; ===============================================
; ============      LOGIC PROCESS    ============
; ===============================================
; -= MULTIPLICATION =-
; R0 = R2 * R1
; Process (WITHOUT OVERFLOW/UNDERFLOW CHECK):
;   if (R1 == 0) {
;       return 0
;   } else if (R1 > 0) {
;       R0 = multiply()
;   } else if (R1 < 0) {
;       R1 = R1 * -1
;       R2 = R2 * -1
;       R0 = multiply()
;   }
;   return R0

;   multiply() {
;       R0 = R0 + R2
;       R1--
;       if (R1 == 0) { 
;           return R0 
;       }
;       return multiply()
;   }


; -= DIVISION =-
; R0 = R2 / R1
; Process (WITHOUT OVERFLOW/UNDERFLOW CHECK):
;   if (R1 == 0) {                  ; R2 / R1 = Undefined
;     return ERROR
;   } else if (R1 < 0) {            ; Flip signs for proper condition checks
;       R1 = R1 * -1
;       R2 = R2 * -1
;   }
;
;   if (R2 > 0) {                   ; Positive Division
;       R1 = R1 * -1
;       R0 = divide() [DIV_POS_SETUP]
;       return R0
;   } else if (R2 < 0) {            ; Negative Division
;       R2 = R2 * -1
;       R1 = R1 * -1
;       R0 = divide() [DIV_NEG_SETUP]
;       R0 = R0 * -1
;       return R0
;   } else if (R2 == 0) {           ; R2 / R1 = 0
;       return R2
;   }