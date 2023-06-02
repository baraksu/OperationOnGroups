;ver 102
.MODEL small
.STACK 100h
.DATA 

logo db 13,10,   
 db 13,10,"  ____                       _   _            "
 db 13,10," / __ \                     | | (_)           "
 db 13,10,"| |  | |_ __   ___ _ __ __ _| |_ _  ___  _ __ "
 db 13,10,"| |  | | '_ \ / _ \ '__/ _` | __| |/ _ \| '_ \"
 db 13,10,"| |__| | |_) |  __/ | | (_| | |_| | (_) | | | "
 db 13,10," \____/| .__/ \___|_|  \__,_|\__|_|\___/|_| |_"
 db 13,10,"       | |                                    "
 db 13,10,"       |_|                                    $"




msg1 db 13,10,'enter 10 numbers for group 1: $'  ;the user inserts the numbers for array1
msg2 db 13,10,'enter 10 numbers for group 2: $'  ;the user inserts the numbers for array2
msg3 db 13,10,'there are three options: ',13,10
     db       'a: to create a new array with the two arrays combined',13,10,
     db       'b: to create a new array with the numbers combined but if the number exits in both arrays the number will be only once in the new array',13,10
     db       'c: to create a new array with only the numbers that exist in both of the arrays',13,10
     db       'press "a" for the first option, "b" for the second one and "c" for the third, and press e for exit if you want:',13,10
     db       '$'
msg4 db 13,10,'you did not choose one of the optins,it is not proper,please try again$'  
size dw 10                       ; the size of the arrays,used for loops mainly
msg5 db 13,10,'this is not a digit please try again $' 
array1 db 10 dup(0)              ;the first array,the user is putting the numbers inside it,the numbers moves to the new array                                                         
array2 db 10 dup(0)              ;the second array the user is putting the numbers inside it,thet move to the new array,the first and second arrays is used to hold the numbers and go over them before the needed numbers move to the new array it is the purpose
newarray db 20 dup(10)           ;the destination,the needed numbers move to this array it is printed in the end of the code.


.CODE
mov ax,@data
mov ds,ax

lea dx,logo
mov ah,09h
int 21h
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

cmp al,'e'
je exit

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
jmp output                
showonce: 
call united
jmp output
onlyincommon:
call incommon
jmp output

output:
call PrintingNewArray
jmp afterinput                
exit:
    mov ah, 4ch
    int 21h
  
;-------------------------------------------------------
proc input1 ;the offset of the first aray and its size(the parameters:offset array1,size)
lea dx,msg1
mov ah,09h
int 21h 
push bp
mov bp,sp
mov cx,size
jmp inputgroupa

errornum:
lea dx,msg5
mov ah,09h
int 21h
inputgroupa:  ;input group a of numbers
mov ah,01h
int 21h 
sub al,30h
cmp al,0
jb errornum

cmp al,9
jg errornum 
mov bx,[bp+4]
mov [bx+si],al
inc si
loop inputgroupa 
pop bp
ret 
endp input1         ;the proc manufacted new array with the numbers the user inserted,array1
;============
proc input2         ;the offset of the second aray and its size(the parameters:offset array2,size)
push bp
mov bp,sp
lea dx,msg2
mov ah,09h
int 21h

mov cx,size
xor si,si
jmp inputgroupb

incurrect:
lea dx,msg5
mov ah,09h
int 21h
inputgroupb:   ;input group b of numbers
mov ah,01h
int 21h 
sub al,30h

cmp al,0
jb incurrect

cmp al,9
jg incurrect
mov bx,[bp+6]
mov [bx+si],al
inc si
loop inputgroupb 
pop bp
ret
endp input2      ;the proc manufacted new array with the numbers the user inserted,array2
;------------------------------------------------------- 

;-------------------------------------------------------
proc combination     ;the offsets of the three arrays,size and capacity          
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
xor di,di
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
endp combination      ;move to array three(new array) the numbers combined,first and then second arrays
;-----------------------------------------------

;-----------------------------------------------

proc united            ;the offsets of the thrree array and its capacity
push bp
mov bp,sp
mov si,1
xor di,di 
xor cx,cx
mov bx,[bp+4] 
mov al,[bx]
mov bx,[bp+8]
mov [bx],ax

newnumarraya:
mov bx,[bp+4]
mov dl,[bx+si]      ;new num in dx
cmp si,20          
je ending

runonthearray: 
mov bx,[bp+8]  
cmp dl,[bx+di] 
je equal

inc di
cmp di,20
je correct

jmp runonthearray

equal:
inc si
xor di,di
jmp newnumarraya                             

correct:
inc cx  
mov bx,[bp+8]
mov di,cx 
mov [bx+di],dl
inc si       
xor di,di
jmp newnumarraya

ending:
pop bp
ret
endp united           ;move to array three(new array) the numbers combined with the numbers from the first two arrays but every number can be showen only once
;-----------------------------

;----------------------------- 
proc incommon      ;offsets of the arrays and its capacity
push bp
mov bp,sp
xor si,si
xor di,di
xor dx,dx
xor cx,cx
jmp NewContenderNum

nextnum: 
cmp si,9
je endincommon
inc si
xor di,di
NewContenderNum:
mov bx,[bp+4]
mov dl,[bx+si]
ComperingToB:
mov bx,[bp+6]
cmp dl,[bx+di]
je success


cmp di,10
je nextnum
inc di
jmp ComperingToB

success:
xor di,di
MakeSureTheNummberIsnotAlreadyOnTheArray:
mov bx,[bp+8]
cmp dl,[bx+di]
je nextnum


cmp di,10
je getin

inc di
jmp MakeSureTheNummberIsnotAlreadyOnTheArray

getin:
mov di,cx
mov bx,[bp+8]
mov [bx+di],dl
inc cx
jmp nextnum

endincommon:
xor dx,dx
pop bp
ret
endp incommon     ;move to the new array only the numbers that exits in both of the first arrays
;---------------------------------------

;---------------------------------------
proc PrintingNewArray       ;the offset of the third array,its capacity 

push bp
mov bp,sp 
xor di,di
mov dl,' '
mov ah,2
int 21h

mov dl,' '
mov ah,2
int 21h
 
jmp printing

nextnumber:
inc di
cmp di,19
je lastnumber
printing:
mov bx,[bp+8]
cmp [bx+di],10
je nextnumber 
mov dl,[bx+di]
add dl,'0'
mov ah,2
int 21h 
cmp [bx+di+1],10
je done
mov dl,','
mov ah,2
int 21h
jmp nextnumber 

lastnumber:
mov dl,[bx+di]
add dl,'0'
mov ah,2
int 21h
jmp done


done:
pop bp
ret
endp PrintingNewArray      ;printing the new array on the screen

END   
