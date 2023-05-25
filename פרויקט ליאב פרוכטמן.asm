.MODEL small
.STACK 100h
.DATA
msg1 db 13,10,'enter 10 numbers for group 1: $' 
msg2 db 13,10,'enter 10 numbers for group 2: $'
msg3 db 13,10,'there are three options:',13,10
     db       'a: to create a new array with the two arrays combined',13,10,
     db       'b: to create a new array with the numbers combined but if the number exits in both arrays the number will be only once in the new array',13,10
     db       'c: to create a new array with only the numbers that exist in both of the arrays',13,10
     db       'press "a" for the first option, "b" for the second one and "c" for the third$',13,10
msg4 db 13,10,'you did not choose one of the optins,it is not proper,please try again$'  
size dw 10 
array1 db 10 dup(0)                                                                       
array2 db 10 dup(0) 
newarray db 20 dup(0)


.CODE
mov ax,@data
mov ds,ax


push offset newarray
push offset array2
push offset array1
 
xor dx,dx 
xor si,si
call input1
call input2 

afterinput:
lea dx,msg3
mov ah,09h
int 21h

mov ah,01h
int 21h

cmp al,'a'
je combined

cmp al,'b'
je  showonce

cmp al,'c'
je onlyincommon

invalid:
lea dx,msg4
mov ah,09h
int 21h

mov ah,01h
int 21h

cmp al,'a'
je combined

cmp al,'b'
je showonce

cmp al,'c'
je onlyincommon

cmp size,0
jne invalid 

combined:
call combination
                
showonce: 

onlyincommon:
                
exit:
    mov ah, 4ch
    int 21h
  
;-------------------------------------------------------
proc input1
lea dx,msg1
mov ah,09h
int 21h 
push bp
mov bp,sp
mov cx,size
inputgroupa:  ;input group a of numbers
 
mov ah,01h
int 21h 
sub al,30h 
mov bx,[bp+4]
mov [bx+si],al
inc si
loop inputgroupa 
pop bp
ret 
endp input1
;============
proc input2
push bp
mov bp,sp
lea dx,msg2
mov ah,09h
int 21h

mov cx,size
xor si,si
inputgroupb:   ;input group b of numbers
mov ah,01h
int 21h 
sub al,30h
mov bx,[bp+6]
mov [bx+si],al
inc si
loop inputgroupb 
pop bp
ret
endp input2
;------------------------------------------------------- 


;-----------------------------------
proc combination               
push bp
mov bp,sp  
xor di,di
xor si,si
xor bx,bx
mov cx,size
arraya:
mov bx,[bp+4]
mov ax,[bx+si]
mov bx,[bp+8]
mov [bx+si],ax
inc si          

loop arraya

xor si,si
mov cx,size
arrayb:
mov bx,[bp+6]
mov ax,[bx+si]
mov bx,[bp+8]
mov [bx+si+10],ax
inc si

loop arrayb
pop bp
ret
endp combination


END   