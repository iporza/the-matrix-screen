        .model  tiny

        .data
        cre     db      ' Coded by iHerePor x Nat '
        cha     db      80      dup(?)
        row     db      80      dup(?)
        row_t   db      80      dup(?)
        cl_1    db      1       ; Light Green Length
        cl_2    db      4       ; Green Length
        cl_3    db      7       ; Dark Grey Length
        tl      db      8       ; Tail Length
        rnd_79  dw      ?
        rnd_127 dw      ?
        var_a   dw      9797
        var_b   dw      64977

        .code
        org     0100h
main:   
        mov     ah, 00h                 ; Video Mode
        mov     al, 03h         ; Set to 80x25
        int     10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Assign data to array
        mov     bl, 0		; initial column
        mov     bp, offset cha  ; *bp = cha[]
        mov     si, offset row  ; *si = row[]
        mov     di, offset row_t; *di = row_t[]

        mov     ah, 00h  ;random clock      
        int     1ah      ; CX:DX now hold clock ticks since midnight
        mov     rnd_79, dx
        mov     rnd_127, dx

add_data:
        cmp     bl, 79		;compare column		
        ja      end_add_data

rand0_79:		
        mov     ax, rnd_79
        mov     dx, 0         ;clear dx
        mov     cx, 80        ;set cx   
        div     cx            ;dx = ax mod cx
   
        mov     al, dl        ;set al
        mov     cx, var_a
        mul     cx            ;ax = al*cx(var_a)
        add     ax, var_b     ;ax = ax+var_b
        mov     rnd_79, ax
end_rand0_79:
        
        mov     byte ptr [si], 0        ; Random 0to79 to row[]
        sub     byte ptr [si], dl

        mov     al, tl                  ; Random (0to79)-8 to row_t[]
        mov     byte ptr [di], 0
        sub     byte ptr [di], al
        sub     byte ptr [di], dl

rand33_127:
        mov     ax, rnd_127
        mov     dx, 0         ;clear dx
        mov     cx, 95        ;set cx   
        div     cx            ;dx = ax mod cx
	add	dx,33
   
        mov     al, dl        ;set al
        mov     cx, var_a
        mul     cx            ;ax = al*cx(var_a)
        add     ax, var_b     ;ax = ax+var_b
        mov     rnd_127, ax
end_rand33_127:

        mov     byte ptr [bp], 0        ; Random 33-127 to cha[]
        add     byte ptr [bp], dl
        

        inc     bl			;increase col
        inc     bp			;increase character
        inc     si			;increase row
        inc     di			;increase row_t
        jmp     add_data
end_add_data:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; White Character
myloop:
        mov     dl, 0
        mov     bp, offset cha
        mov     si, offset row
start_col:
        cmp     dl, 79
        ja      end_col

        mov     ah, [si]
        cmp     ah, 0
        jge     start_row
        jmp     end_row

start_row:
        mov     ah, 02h                 ; Move cursor
        mov     bh, 00h         ; Page Number
        mov     dh, [si]        ; Row
        ;mov     dl, col        ; Column
        int     10h

        mov     ah, 09h                 ; Write Character
        mov     al, [bp]         ; Character
        mov     bh, 00h         ; Page number
        mov     bl, 0Fh         ; Color
        mov     cx, 01h         ; Time to print
        int     10h
end_row:

        inc     dl
        inc     bp
        inc     si
        jmp     start_col
end_col:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Credit
        mov     ah, 13h                 ; Write String
        mov     al, 00h         ; Write mode
        mov     bh, 00h         ; Page number
        mov     bl, 0Ah         ; Color
        mov     cx, 25          ; Length
        mov     dh, 24          ; Row
        mov     dl, 53          ; Column
        mov     bp, offset cre  ; Offset of string
        int     10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Delay
        mov     si, 65000
delay:
        dec     si              ; Decrease 1
        nop                     ; Kill 1 clock
        cmp     si, 0           ; If(si == 0)
        je      end_delay       ; If yes, Break
        jmp     delay           ; If no, Continue delay
end_delay:     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Light Green Character
        mov     dl, 0
        mov     bp, offset cha
        mov     si, offset row
start_col2:
        cmp     dl, 79
        ja      end_col2

        mov     ah, [si]
        cmp     ah, 0
        jge     start_row2
        jmp     end_row2

start_row2:
        mov     ah, 02h         ; Move cursor
        mov     bh, 00h         ; Page Number
        mov     al, [si]
        sub     al, cl_1
        mov     dh, [si]        ; Row
        ;mov     dl, col        ; Column
        int     10h

        mov     ah, 09h         ; Write Character
        mov     al, [bp]        ; Character
        mov     bh, 00h         ; Page number
        mov     bl, 0Ah         ; Color
        mov     cx, 01h         ; Time to print
        int     10h
end_row2:

        inc     dl
        inc     bp
        inc     si
        jmp     start_col2
end_col2:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Green Character
        mov     dl, 0
        mov     bp, offset cha
        mov     si, offset row
start_col3:
        cmp     dl, 79
        ja      end_col3

        mov     ah, [si]
        cmp     ah, 0
        jge     start_row3
        jmp     end_row3

start_row3:
        mov     ah, 02h         ; Move cursor
        mov     bh, 00h         ; Page Number
        mov     al, [si]
        sub     al, cl_2
        mov     dh, al          ; Row
        ;mov     dl, col        ; Column
        int     10h

        mov     ah, 09h                 ; Write Character
        mov     al, [bp]         ; Character
        mov     bh, 00h         ; Page number
        mov     bl, 02h         ; Color
        mov     cx, 01h         ; Time to print
        int     10h
end_row3:

        inc     dl
        inc     bp
        inc     si
        jmp     start_col3
end_col3:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Dark Grey Character
        mov     dl, 0
        mov     bp, offset cha
        mov     si, offset row
start_col4:
        cmp     dl, 79
        ja      end_col4

        mov     ah, [si]
        cmp     ah, 0
        jge     start_row4
        jmp     end_row4

start_row4:
        mov     ah, 02h         ; Move cursor
        mov     bh, 00h         ; Page Number
        mov     al, [si]
        sub     al, cl_3
        mov     dh, al          ; Row
        ;mov     dl, col        ; Column
        int     10h

        mov     ah, 09h         ; Write Character
        mov     al, [bp]        ; Character
        mov     bh, 00h         ; Page number
        mov     bl, 08h         ; Color
        mov     cx, 01h         ; Time to print
        int     10h
end_row4:

        inc     dl
        inc     bp
        inc     si
        jmp     start_col4
end_col4:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Clear Character
        mov     dl, 0
        mov     di, offset row_t
start_col5:
        cmp     dl, 79
        ja      end_col5

        mov     ah, [di]
        cmp     ah, 0
        jge     start_row5
        jmp     end_row5
start_row5:     
        mov     ah, 02h         ; Move cursor
        mov     bh, 00h         ; Page Number
        mov     dh, [di]        ; Row
        ;mov     dl, col        ; Column
        int     10h

        mov     ah, 09h                 ; Write Character
        mov     al, ''          ; Character
        mov     bh, 00h         ; Page number
        mov     bl, 00h         ; Color
        mov     cx, 01h         ; Time to print
        int     10h
end_row5:

        inc     dl
        inc     di
        jmp     start_col5
end_col5:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Increase row
        mov     bl, 0
        mov     si, offset row
        mov     di, offset cha
loop_forward:
        cmp     bl, 79
        ja      end_loop_forward

        inc     byte ptr [si]   ; row++

rand33_127_2:
        mov     ax, rnd_127
        mov     dx, 0         ;clear dx
        mov     cx, 95        ;set cx   
        div     cx            ;dx = ax mod cx
	add	dx,33
   
        mov     al, dl        ;set al
        mov     cx, var_a
        mul     cx            ;ax = al*cx(var_a)
        add     ax, var_b     ;ax = ax+var_b
        mov     rnd_127, ax

              
        add     byte ptr [di], dl
        
end_rand33_127_2:

        inc     bl
        inc     si
        inc     di
        jmp     loop_forward
end_loop_forward:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Increase row_t
        mov     ah, 0
        mov     si, offset row_t 
loop_forward2:
        cmp     ah, 79
        ja      end_loop_forward2
         
        inc     byte ptr [si]   ; row_t++

        inc     ah
        inc     si
        jmp     loop_forward2
end_loop_forward2:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Check row
        mov     ah, 0
        mov     si, offset row
loop_forward3:
        cmp     ah, 79
        ja      end_loop_forward3

        mov     al, [si]
        cmp     al, 32          ; If(row == 32)
        je      clear_row1
        jmp     pass_row1

clear_row1:
        mov     byte ptr [si], 0        
pass_row1:
        
        inc     ah
        inc     si
        jmp     loop_forward3
end_loop_forward3:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Check row_t
        mov     ah, 0
        mov     si, offset row_t
loop_forward4:
        cmp     ah, 79
        ja      end_loop_forward4
        
        mov     al, [si]
        cmp     al, 32          ; If(row_t == 32)
        je      clear_row_t
        jmp     pass_row_t

clear_row_t:
        mov     al, tl                  
        mov     byte ptr [si], 0
pass_row_t:

        inc     ah
        inc     si
        jmp     loop_forward4
end_loop_forward4:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        jmp     myloop          ; Repeat all statement 

        ret
        end   main
