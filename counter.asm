;Hayden Cameron
;04/10/2023
;LC3 Program 2(counter.asm):This program displays a four digit digital counter. When u is pressed, the counter goes up 1
;							unless the counter is at 9999 in which case it resets to 0000. When d is pressed the counter
;							goes down 1 unless the counter is at 0000 in which case it goes up to 9999. When r is pressed
;							the program resets back to 0000. When p is pressed the program lists the current value in the
;							counter. When q is pressed the program halts. Additionally, the digital counter switches color
;							when the corrosponding capital letter is pressed (G=green, B=blue, R=red, Y=yellow, & W=white).
			.ORIG x3000
RESET							;With the digit values already 0 it jumps to update the digit location
			LD R1, THOU_VAL
			JSR THOU_UPDATE
			LD R1, HUND_VAL 
			JSR HUND_UPDATE
			LD R1, TENS_VAL
			JSR TENS_UPDATE
			LD R1, ONES_VAL
			JSR ONES_UPDATE
INPUT
			GETC

			LD R1, SUB117		;Checks if u is pressed
			ADD R1, R1, R0
			BRz U_INPUT
			
			LD R1, SUB100		;Checks if d is pressed
			ADD R1, R1, R0
			BRz D_INPUT
			
			LD R1, SUB114		;Checks if r is pressed
			ADD R1, R1, R0
			BRz R_INPUT
			
			LD R1, SUB112		;Checks if p is pressed
			ADD R1, R1, R0
			BRz P_INPUT
			
			LD R1, SUB113		;Checks if q is pressed
			ADD R1, R1, R0
			BRz Q_INPUT
			
			LD R1, SUB71		;Checks if G is pressed
			ADD R1, R1, R0
			BRz G_INPUT
			
			LD R1, SUB66		;Checks if B is pressed
			ADD R1, R1, R0
			BRz B_INPUT
			
			LD R1, SUB82		;Checks if R is pressed
			ADD R1, R1, R0
			BRz RED_INPUT
			
			LD R1, SUB89		;Checks if Y is pressed
			ADD R1, R1, R0
			BRz Y_INPUT
			
			LD R1, SUB87		;Checks if W is pressed
			ADD R1, R1, R0
			Brz W_INPUT
			
			BRnzp INPUT		
U_INPUT							;Executes if u is pressed
			LD R1, ONES_VAL		;;Checks if ones value is 9
			LD R2, SUB57
			ADD R2, R2, R1		
			BRz UP_CHECKS		
		
			ADD R1, R1, #1		;;Adds 1 to ones value if its not 9 and updates ones digit
			ST R1, ONES_VAL
			BRnzp ONES_UPDATE
D_INPUT							;Executes if d is pressed
			LD R1, ONES_VAL		;;Checks if ones value is 0
			LD R2, SUB48
			ADD R2, R2, R1
			BRz DOWN_CHECKS
			
			ADD R1, R1, #-1		;;Subtracts 1 from ones value if its not 9 and updates ones digit
			ST R1, ONES_VAL
			BRnzp ONES_UPDATE
R_INPUT							;Executes if r is pressed
			LD R2, NUM48		;;Sets all digit values to 0
			AND R1, R1, #0
			ADD R1, R1, R2
			ST R1, ONES_VAL
			ST R1, TENS_VAL
			ST R1, HUND_VAL
			ST R1, THOU_VAL
			BRnzp RESET
P_INPUT							;Executes if p is pressed
			LD R0, NEWLINE		;;Prints a newline, value prompt, and the current value
			OUT
			LEA R0, VAL_PROMPT
			PUTS
			LD R0, THOU_VAL
			OUT
			LD R0, HUND_VAL
			OUT
			LD R0, TENS_VAL
			OUT
			LD R0, ONES_VAL
			OUT
			BRnzp INPUT
Q_INPUT							;Executes if q is pressed
			LD R0, NEWLINE		;;Prints two newlines, end prompt, a newline, and halts
			OUT
			OUT
			LEA R0, END_PROMPT
			PUTS
			LD R0, NEWLINE
			OUT
			HALT
G_INPUT							;Executes if G is pressed
			LD R2, GREEN		;;makes reference color label = green
			ST R2, COLOR
			BRnzp RESET
B_INPUT							;Executes if B is pressed
			LD R2, BLUE			;;makes reference color label = blue
			ST R2, COLOR
			BRnzp RESET
RED_INPUT						;Executes if R is pressed
			LD R2, RED			;;makes reference color label = red
			ST R2, COLOR
			BRnzp RESET
Y_INPUT							;Executes if Y is pressed
			LD R2, YELLOW		;;makes reference color label = yellow
			ST R2, COLOR	
			BRnzp RESET
W_INPUT							;Executes if W is pressed
			LD R2, WHITE		;;makes reference color label = white
			ST R2, COLOR
			BRnzp RESET
			
			
UP_CHECKS						;Executes when ones value is a 9 and u was pressed
			LD R1, NUM48		;;Resets ones value to zero and jumps to update ones digit
			ADD R1, R1, R2
			ST R1, ONES_VAL		
			JSR ONES_UPDATE		
			
			LD R1, TENS_VAL		;;Checks if tens value is 9
			LD R2, SUB57
			ADD R2, R2, R1		
			BRz RESET_TENS
			
			ADD R1, R1, #1		;;Adds 1 to tens value if its not 9 and updates tens digit
			ST R1, TENS_VAL
			LEA R7, INPUT
			BRnzp TENS_UPDATE
RESET_TENS						;Executes when tens value is 9 and ones value is 9 and u was pressed
			LD R1, NUM48		;;Resets tens value to zero and jumps to update tens digit
			ADD R2, R2, R1
			ST R2, TENS_VAL		
			JSR TENS_UPDATE
		
			LD R1, HUND_VAL		;;Checks if hundreds value is 9
			LD R2, SUB57
			ADD R2, R2, R1		
			BRz RESET_HUND

			ADD R1, R1, #1		;;Adds 1 to hundreds value if its not 9 and updates hundreds digit
			ST R1, HUND_VAL
			LEA R7, INPUT
			BRnzp HUND_UPDATE			
RESET_HUND						;Executes when hundreds value is 9 and preceding digits were 9 and u was pressed
			LD R1, NUM48		;;Resets hundreds value to zero and jumps to update hundreds digit
			ADD R2, R2, R1
			ST R2, HUND_VAL		
			JSR HUND_UPDATE
			
			LD R1, THOU_VAL		;;Checks if thousands value is 9
			LD R2, SUB57
			ADD R2, R2, R1		
			BRz RESET_THOU

			ADD R1, R1, #1		;;Adds 1 to thousands value if its not 9 and updates thousands digit
			ST R1, THOU_VAL
			LEA R7, INPUT
			BRnzp THOU_UPDATE
RESET_THOU						;Executes when thousands value is 9 and preceding digits were 9 and u was pressed
			LD R1, NUM48		;;Resets thousands value to zero and jumps to update thousands digit
			ADD R2, R2, R1
			ST R2, THOU_VAL		
			JSR THOU_UPDATE
			BRnzp INPUT
DOWN_CHECKS						;Executes when ones digit is 0 and d was pressed when
			LD R1, NUM57		;;Sets ones value to 9 and jumps to update ones digit
			ADD R1, R1, R2
			ST R1, ONES_VAL
			JSR ONES_UPDATE

			LD R1, TENS_VAL		;;Checks if tens value is 0
			LD R2, SUB48
			ADD R2, R2, R1		
			BRz SET_TENS9
			
			ADD R1, R1, #-1		;;Subtracts 1 from tens value if its not 0 and updates tens digit
			ST R1, TENS_VAL
			LEA R7, INPUT
			BRnzp TENS_UPDATE
SET_TENS9						;Executes when tens value is 0 and ones value is 0 when d is pressed
			LD R1, NUM57		;;Sets tens value to 9 and jumps to update tens digit
			ADD R2, R2, R1
			ST R2, TENS_VAL		
			JSR TENS_UPDATE
			
			LD R1, HUND_VAL		;;Checks if hundreds value is 0
			LD R2, SUB48
			ADD R2, R2, R1		
			BRz SET_HUND9

			ADD R1, R1, #-1		;;Subracts 1 from hundreds value if its not 0 and updates hundreds digit
			ST R1, HUND_VAL
			LEA R7, INPUT
			BRnzp HUND_UPDATE		
SET_HUND9						;Executes when hundreds value is 0 and preceding digits were 0 and d was pressed
			LD R1, NUM57		;;Sets hundreds value to 9 and jumps to update the hundreds digit
			ADD R2, R2, R1
			ST R2, HUND_VAL		
			JSR HUND_UPDATE
			
			LD R1, THOU_VAL		;;Checks if thousands value is 0
			LD R2, SUB48
			ADD R2, R2, R1		
			BRz SET_THOU9

			ADD R1, R1, #-1		;;Subtracts 1 from thousands value if its not 0 and updates thousands digit
			ST R1, THOU_VAL
			LEA R7, INPUT
			BRnzp THOU_UPDATE
SET_THOU9						;Executes when thousands value is 0 and preceding digits were 0 and d was pressed
			LD R1, NUM57		;;Sets thousands value to 9 and jumps to update the thousands digit
			ADD R2, R2, R1
			ST R2, THOU_VAL		
			JSR THOU_UPDATE
			BRnzp INPUT			

HALFWAY1						;Halfway point to make branch in range
			BRnzp INPUT
		
ZERO .FILL x5000				;Number labels
ONE .FILL x53E8
TWO .FILL x57D0
THREE .FILL x5BB8
FOUR .FILL x5FA0
FIVE .FILL x6388
SIX .FILL x6770
SEVEN .FILL x6B58
EIGHT .FILL x6F40
NINE .FILL x7328	

THOUSANDS .FILL xD508			;Digit location labels
HUNDREDS .FILL xD523
TENS .FILL xD544
ONES .FILL xD55F

THOU_VAL .FILL #48				;Digit value labels
HUND_VAL .FILL #48
TENS_VAL .FILL #48
ONES_VAL .FILL #48

GREEN .FILL x07E0				;Colors label
BLUE .FILL x001F
RED .FILL xF800
YELLOW .FILL xFFE0
WHITE .FILL xFFFF				

COLOR .FILL xFFFF				;Color reference label

NUM25 .FILL #25					;Positive value labels
NUM40 .FILL #40
NUM104 .FILL #104
NUM58 .FILL #58
NUM48 .FILL #48
NUM47 .FILL #47
NUM57 .FILL #57
NEWLINE .FILL #10

SUB117 .FILL #-117				;Negative value labels
SUB57  .FILL #-57
SUB48 .FILL #-48
SUB100 .FILL #-100
SUB114 .FILL #-114
SUB112 .FILL #-112
SUB113 .FILL #-113
SUB71 .FILL #-71
SUB66 .FILL #-66
SUB82 .FILL #-82
SUB89 .FILL #-89
SUB87 .FILL #-87

VAL_PROMPT .STRINGZ "The current value is: "	;Strings labels
END_PROMPT .STRINGZ "Later Yall!!"

ONES_UPDATE						;Sets R6= ones digit location
			LD R6, ONES
			BRnzp UPDATE_DIGIT
TENS_UPDATE						;Sets R6= tens digit location
			LD R6, TENS
			BRnzp UPDATE_DIGIT
HUND_UPDATE						;Sets R6= hundreds digit location
			LD R6, HUNDREDS
			BRnzp UPDATE_DIGIT
THOU_UPDATE						;Sets R6= thousands digit location
			LD R6, THOUSANDS
			BRnzp UPDATE_DIGIT
UPDATE_DIGIT					;Updates the digit on screen with proper digit value
			LEA R5, ZERO		;;Sets R5= the adress of the number label (relative to the current ones value)
			LD R2, SUB48		
			ADD R1, R1, R2		
			ADD R5, R5, R1		
			LDR R5, R5, #0	
		
			LD R4, NUM25		;;Sets important values to registers (across and down counters)
			LD R3, NUM40	
PRINT_DIGIT						
			LDR R0, R5, #0		;;Checks if specific digit value is a 1 or 0
			BRp COLOR_DIGIT	
			
			STR R0, R6, #0		;;puts a black pixel in the corrosponding digit location
			ADD R4, R4, #-1
			BRp ACROSS_DIGIT
			
			LD R4, NUM25		;;Resets the accross counter
			BRnzp DOWN_DIGIT
COLOR_DIGIT						;Executes when digit value is 1
			LD R1, COLOR		;;Puts a white pixel in the corrosponding digit location
			STR R1, R6, #0
			ADD R4, R4, #-1
			BRp ACROSS_DIGIT
			
			LD R4, NUM25		;;Resets the across counter	
			BRnzp DOWN_DIGIT	
ACROSS_DIGIT					
			ADD R6, R6, #1		;;Increments digit value and location by 1
			ADD R5, R5, #1
			BRnzp PRINT_DIGIT
DOWN_DIGIT		
			LD R2, NUM104		;;Increments digit location to next row
			ADD R6, R6, R2
			ADD R5, R5, #1
			ADD R3, R3, #-1
			BRp PRINT_DIGIT
			RET					
			BRnzp HALFWAY1
.END