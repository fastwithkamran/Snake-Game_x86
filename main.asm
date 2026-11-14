INCLUDE Irvine32.inc

.data
; border vars
rows = 20
cols = 40
border Byte "#", 0

; snake vars
MAX_SIZE = 20; max size of snake, grows by eating food
snakelen Byte 1; starts with 1 dot
snakechar Byte "O", 0

; coordinates of snake
snakeX Byte MAX_SIZE dup(0); x coordinates of snake
snakeY Byte MAX_SIZE dup(0); y coordinates of snake

.code
drawborder PROC; procedure to draw border

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

snake PROC
mov snakeX, 20
mov snakeY, 10

mov dl, snakeX
mov dh, snakeY
call Gotoxy

mov al, snakechar
call writechar

ret
snake endp

main PROC
call clrscr
call drawborder
call snake

mov dl, 0
mov dh, rows+1
call Gotoxy

exit
main ENDP
END main