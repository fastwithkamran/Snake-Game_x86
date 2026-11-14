INCLUDE Irvine32.inc

.data
; border vars
rows = 20
cols = 40
border Byte "#", 0

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

main PROC
call clrscr
call drawborder

exit
main ENDP
END main