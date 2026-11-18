INCLUDE Irvine32.inc

.data
; border vars
rows = 20
cols = 40
border Byte "#", 0

; snake vars
MAX_SIZE = 20; max size of snake, grows by eating food
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

PlaceFood PROC; place food at a random location inside the border
NewFood:
mov eax, cols - 2
call RandomRange
inc eax; x coordinate from 1 to cols - 2
mov foodX, al

mov eax, rows - 2
call RandomRange
inc eax; y coordinate from 1 to rows - 2
mov foodY, al

; food must not land on the snake
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
mov al, food
call WriteChar
ret
PlaceFood ENDP

Game PROC; procedure to take the input key from user
mov snakeX, 20
mov snakeY, 10

mov dl, snakeX
mov dh, snakeY
call Gotoxy

mov al, snake
call writechar

call PlaceFood

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

MoveUp:
mov direction, 1
jmp MoveStep
MoveDown:
mov direction, 2
jmp MoveStep
MoveLeft:
mov direction, 3
jmp MoveStep
MoveRight:
mov direction, 4
jmp MoveStep

MoveStep:
call MoveSnake
mov eax, 100; control game speed
call Delay
loop Gameloop

ret
Game endp

MoveSnake PROC; procedure to move the snake
cmp direction, 0; if direction is 0 then snake will not move
je NoMove

; remove the tail
movzx esi, snakelen
dec esi
mov dl, snakeX[esi]
mov dh, snakeY[esi]
call Gotoxy ;move the cursor to tail

mov al, ' '; update tail
call writechar

; shift dots one index ahead to overwrite head
mov al, snake
movzx ecx, snakelen
dec ecx; cause tail has been removed

cmp ecx, 0
je CheckDirection

Shiftloop:
mov snakeX[ecx], al
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
mov dl, snakeX
mov dh, snakeY
call Gotoxy
mov al, snake
call writechar

; check whether the head reached the food
mov al, snakeX
cmp al, foodX
jne NoMove
mov al, snakeY
cmp al, foodY
jne NoMove
call PlaceFood

NoMove:
ret
MoveSnake endp

main PROC
call clrscr
call Drawborder
call Game

mov dl, 0
mov dh, rows+1
call Gotoxy

exit
main ENDP
END main