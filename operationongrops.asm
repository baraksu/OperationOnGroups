.MODEL small
.STACK 100h
.DATA
msg1 db 13,10,'enter 10 numbers for group a $' 
msg2 db 13,10,'enter 10 numbers for group b $'
msg3 db 13,10,'there are two options: 13,10,a:to create a new array with the two arrays combined13,10,b:to create a new array with only the numbers that exist in both of the arrays 13,10,enter "a" for the first option and "b" for the second one$'
msg4 db 13,10,'you did not choose one of the optins,it is not proper,please try again$'  
size dw 10
array1 dw 10 dup<0>                                                                        
array2 dw 10 dup<0>  
newarray dw 20 dup<0>


.CODE
mov ax,@data
mov ds,ax

lea dx,msg1
mov ah,09h
int 21h  
push offset array1 ;push 1
mov cx,size
inputgroupa:  ;input group a of numbers
mov ah,01h
int 21
mov [bp+4+si],al
inc si
loop inputgroupa
  
lea dx,msg2
mov ah,09h
int 21h

mov cx,size
xor si,si
inputgroupb:   ;input group b of numbers
mov ah,01h
int 21
mov [bp+4+si],al
inc si
loop inputgroupb

lea dx,msg3
mov ah,09h
int 21h

mov ah,01h
int 21h

cmp al,'a'
je combined

cmp al,'b'
je  incommon

invalid:
lea dx,msg4
mov ah,09h
int 21h

mov ah,01h
int 21h

cmp al,'a'
je combined

cmp al,'b'
je incommon

cmp size,0
jne invalid
;-----------------------------------------  now we are after he choose the option 
;----------------------------------------- i didnt create the labels of the options so it wont work
