INCLUDE Irvine32.inc

.data
; border vars
rows = 20
cols = 40
border Byte "#", 0

; snake vars
MAX_SIZE = 21; max size of snake, grows by eating food
snakelen Byte 1; starts with 1 dot 
snake Byte "O", 0

; coordinates of snake
direction Byte 0
snakeX Byte MAX_SIZE dup(0); x coordinates of snake
snakeY Byte MAX_SIZE dup(0); y coordinates of snake

; food vars
food Byte "*", 0
foodX Byte 0
foodY Byte 0

; old tail position, used for growing
tailX Byte 0
tailY Byte 0

; game state vars
mode Byte 0; for border and borderless
stat Byte 0; 

loseMsg Byte "Game Over, You Out Sir! ", 0
winMsg Byte "You Win Sir! ", 0

sc Byte 0; to track score
scMsg Byte "Score: ", 0

; menu messages
menu Byte "SNAKE GAME", 0Dh, 0Ah
     Byte "1. Border", 0Dh, 0Ah
     Byte "2. Borderless", 0Dh, 0Ah
     Byte "3. Exit", 0Dh, 0Ah
     Byte "Choose (1-3): ", 0

.code
Drawborder PROC; procedure to draw border

;horizontal border
mov ecx, cols
mov dl, 0; x coordinate

xloop: 
;top row
mov dh, 0; y coordinate
call Gotoxy
mov al, border
call writechar

;botton row
mov dh, rows - 1
call Gotoxy
mov al, border
call writechar

inc dl; move x coordinate by 1 to the right
loop xloop

;vertical border
mov ecx, rows
mov dh, 0; y coordinate

yloop:
;left col
mov dl, 0; x coordinate
call Gotoxy
mov al, border
call writechar

;right col
mov dl, cols - 1
call Gotoxy
mov al, border
call writechar

inc dh
loop yloop

ret
drawborder ENDP

PlaceFood PROC; place food at random spots
NewFood:
mov eax, cols - 2
call RandomRange
inc eax; x from 1 to cols - 2
mov foodX, al

mov eax, rows - 2
call RandomRange
inc eax; y from 1 to rows - 2
mov foodY, al

; check food is not on snake
movzx ecx, snakelen
mov esi, 0
CheckSnake:
mov al, foodX
cmp al, snakeX[esi]
jne NextSegment
mov al, foodY
cmp al, snakeY[esi]
je NewFood
NextSegment:
inc esi
loop CheckSnake

mov dl, foodX
mov dh, foodY
call Gotoxy

;food color
mov eax, lightRed + (black * 16)
call SetTextColor

mov al, food
call WriteChar

mov eax, lightgray + (black * 16)
call SetTextColor
ret
PlaceFood ENDP

ShowScore PROC; to display score
mov dl, cols + 2
mov dh, 2
call Gotoxy
mov edx, OFFSET scMsg
call WriteString
movzx eax, sc
call WriteDec
ret
ShowScore ENDP

Game PROC; procedure for input from user
mov stat, 0; play
mov sc, 0; score
mov snakelen, 1; starting length
mov direction, 0; direction 0 so snake stop at start
mov snakeX, 20
mov snakeY, 10

mov dl, snakeX
mov dh, snakeY
call Gotoxy

mov al, snake
call writechar

call PlaceFood
call ShowScore

Gameloop:
call ReadKey
jz MoveStep; if no key press Zero flag will high

cmp al, 0; arrow keys set al = 0
jne MoveStep

cmp ah, 48h ;up arrow
je MoveUp
cmp ah, 50h ;down arrow
je MoveDown
cmp ah, 4Bh ;left arrow
je MoveLeft
cmp ah, 4Dh ;right arrow
je MoveRight
jmp MoveStep; other keys do nothing

; snake cant go opposite direction (when length > 1)
MoveUp:
cmp snakelen, 1
je SetUp
cmp direction, 2
je MoveStep
SetUp:
mov direction, 1
jmp MoveStep

MoveDown:
cmp snakelen, 1
je SetDown
cmp direction, 1
je MoveStep
SetDown:
mov direction, 2
jmp MoveStep

MoveLeft:
cmp snakelen, 1
je SetLeft
cmp direction, 4
je MoveStep
SetLeft:
mov direction, 3
jmp MoveStep

MoveRight:
cmp snakelen, 1
je SetRight
cmp direction, 3
je MoveStep
SetRight:
mov direction, 4
jmp MoveStep

MoveStep:
call MoveSnake
cmp stat, 0; if stat isnt 0 then user is win or lose
jne EndGame

mov eax, 100; control game speed
call Delay
jmp Gameloop

EndGame:
mov dl, cols + 2
mov dh, 4
call Gotoxy

cmp stat, 1 ; won game
jne lose

mov edx, OFFSET winMsg
call writestring
jmp finish
 
lose:
mov edx, OFFSET loseMsg
call writestring

finish:
mov eax, 3000; delay before program ends
call Delay

ret
Game endp

MoveSnake PROC; procedure to move the snake
cmp direction, 0; if direction is 0 then snake will not move
je NoMove

; remove the tail
movzx esi, snakelen
dec esi
mov al, snakeX[esi]
mov tailX, al
mov al, snakeY[esi]
mov tailY, al
mov dl, snakeX[esi]
mov dh, snakeY[esi]
call Gotoxy ;move the cursor to tail

mov al, ' '; update tail
call writechar

; shift coordinates one index ahead
movzx ecx, snakelen
dec ecx; cause tail has been removed

cmp ecx, 0 
je CheckDirection; for if snake length is 1

Shiftloop:
mov al, snakeX[ecx - 1]
mov snakeX[ecx], al

mov al, snakeY[ecx - 1]
mov snakeY[ecx], al
loop Shiftloop

; update head
CheckDirection:
cmp direction, 1
je Up
cmp direction, 2
je Down
cmp direction, 3
je Left
cmp direction, 4
je Right

Up:
dec snakeY
jmp UpdateHead
Down:
inc snakeY
jmp UpdateHead
Left:
dec snakeX
jmp UpdateHead
Right:
inc snakeX
jmp UpdateHead

UpdateHead:
cmp mode, 1
je WrapCheck

; snake hit the border
cmp snakeX, 0
je HitWall
cmp snakeX, cols - 1
je HitWall
cmp snakeY, 0
je HitWall
cmp snakeY, rows - 1
je HitWall
jmp SelfCheck

; borderless mode, snake comes out from opposite side of border
WrapCheck:
cmp snakeX, 0
jne WrapRight
mov snakeX, cols - 2
WrapRight:
cmp snakeX, cols - 1
jne WrapUp
mov snakeX, 1
WrapUp:
cmp snakeY, 0
jne WrapDown
mov snakeY, rows - 2
WrapDown:
cmp snakeY, rows - 1
jne SelfCheck
mov snakeY, 1

; check if head overlaps body
SelfCheck:
movzx ecx, snakelen
dec ecx; body starts from index 1
jz DrawHead; length 1 cant overlap
mov esi, 1
SelfLoop:
mov al, snakeX
cmp al, snakeX[esi]
jne NextSelf
mov al, snakeY
cmp al, snakeY[esi]
je HitSelf
NextSelf:
inc esi
loop SelfLoop

DrawHead:
mov dl, snakeX
mov dh, snakeY
call Gotoxy
mov al, snake
call writechar

; check if head reached food
mov al, snakeX
cmp al, foodX
jne NoMove
mov al, snakeY
cmp al, foodY
jne NoMove

inc sc

; add a segment at old tail position
movzx esi, snakelen
cmp esi, MAX_SIZE
jae FoodEaten
mov al, tailX
mov snakeX[esi], al
mov al, tailY
mov snakeY[esi], al
inc snakelen

mov dl, tailX
mov dh, tailY
call Gotoxy
mov al, snake
call WriteChar

FoodEaten:
call ShowScore
cmp sc, 20
je WonState
call PlaceFood
jmp NoMove

WonState:
mov stat, 1
jmp NoMove

HitSelf:
mov stat, 2
jmp NoMove

HitWall:
mov stat, 3

NoMove:
ret
MoveSnake endp

main PROC
call Randomize; so food spawns at diff spots

MenuLoop:
call clrscr
mov edx, OFFSET menu
call WriteString
call ReadChar

cmp al, '1'
je StartBorder
cmp al, '2'
je StartBorderless
cmp al, '3'
je ExitGame
jmp MenuLoop

StartBorder:
mov mode, 0
jmp RunGame

StartBorderless:
mov mode, 1

RunGame:
call clrscr

;border color 
mov eax, lightCyan + (black * 16)
call SetTextColor
call Drawborder

mov eax, lightgray + (black * 16)
call SetTextColor
call Game
call WaitMsg
jmp MenuLoop

ExitGame:
exit
main ENDP
END main
