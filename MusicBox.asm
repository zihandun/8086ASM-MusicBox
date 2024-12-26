IOY0 EQU 0600H
IOY1 EQU 0640H
IOY2 EQU 0680H

MY8254_COUNT0 EQU  IOY2 + 00H * 2 ;8254 计数器0端口地址
MY8254_COUNT1 EQU 06C2H;8254 计数器1端口地址
MY8254_COUNT2 EQU 06C4H;8254 计数器2端口地址
MY8254_MODE EQU IOY2 + 03H * 2 ;8254控制寄存器端口地址
MY8255_A   EQU IOY1 + 00H * 2    ;8255A端口地址
MY8255_B EQU IOY1 + 01H * 2 ;8254B端口地址
MY8255_C  EQU IOY1 + 02H * 2  ;8254C端口地址
MY8255_CON EQU IOY1 + 03H * 2 ;8254控制寄存器端口地址


;菜单显示
DISPLAY MACRO B 		;定义一个宏指令，宏的名称是DISPLAY，带有一个参数B，即把需要重复执行的一段代码，或者是一组指令缩写成一个宏
	LEA DX,B
	MOV AH,9	;调用9号中断，将菜单显示在屏幕上
	INT 21H
ENDM

;定义栈
SSTACK SEGMENT STACK
	DW 256 DUP(?)
SSTACK ENDS


 ;数据定义
DATA SEGMENT


	;初
HZDOTht DB  004H,000H,008H,000H,080H,03FH,03FH,022H
	DB  010H,022H,008H,022H,008H,022H,02CH,022H
	DB  01AH,022H,029H,022H,028H,022H,008H,021H
	DB  008H,021H,088H,020H,048H,014H,028H,008H

	;音   CD2F4
	DB  040H,000H,080H,000H,0FCH,01FH,000H,000H
	DB  010H,004H,020H,002H,0FFH,07FH,000H,000H
	DB  0F8H,00FH,008H,008H,008H,008H,0F8H,00FH
	DB  008H,008H,008H,008H,0F8H,00FH,008H,008H

	;后   CBAF3
	DB  000H,008H,000H,01FH,0F8H,000H,008H,000H
	DB  008H,000H,0F8H,07FH,008H,000H,008H,000H
	DB  008H,000H,0E8H,01FH,028H,010H,024H,010H
	DB  024H,010H,022H,010H,0E1H,01FH,020H,010H

	;来   CC0B4
	DB  080H,000H,080H,000H,080H,000H,0FEH,03FH
	DB  080H,000H,088H,008H,090H,008H,090H,004H
	DB  0FFH,07FH,0C0H,001H,0A0H,002H,090H,004H
	DB  08CH,018H,083H,060H,080H,000H,080H,000H

	;音   CD2F4
	DB  040H,000H,080H,000H,0FCH,01FH,000H,000H
	DB  010H,004H,020H,002H,0FFH,07FH,000H,000H
	DB  0F8H,00FH,008H,008H,008H,008H,0F8H,00FH
	DB  008H,008H,008H,008H,0F8H,00FH,008H,008H

	;乐   CC0D6
	DB  000H,004H,000H,00FH,0F8H,000H,008H,000H
	DB  088H,000H,084H,000H,084H,000H,0FCH,03FH
	DB  080H,000H,090H,004H,090H,008H,088H,010H
	DB  084H,020H,082H,020H,0A0H,000H,040H,000H

	;盒   CBAD0
	DB  080H,000H,040H,001H,030H,006H,00CH,018H
	DB  0F3H,067H,000H,000H,0F8H,00FH,008H,008H
	DB  0F8H,00FH,000H,000H,0FCH,01FH,024H,012H
	DB  024H,012H,024H,012H,0FFH,07FH,000H,000H




NUM	EQU 0007H                                                     	;显示汉字个数
	;菜单定义
MENU    DB  0DH,0AH,'_______________Music Box_______________'                             	;0DH 和 0AH分别代表回车和换行字符。
		DB  0DH,0AH,'     (1) Kung Hei Fat Choi    --Wu ZhuoXian',
		DB  0DH,0AH,'     (2) To the Distant Sky   --Manack',
		DB  0DH,0AH,'     (3) Bad Apple!!              --Zun',
		DB  0DH,0AH,'     (4) Keyboard',
		DB  0DH,0AH,'     (q) EXIT',
		DB  0DH,0AH,'_________________________________________',
		DB  0AH,0AH,'$'

	;功能定义
FUNCTION	DB  0DH,0AH,'_______________Function_______________'
	        DB  0DH,0AH,'                             P:Pause '
	        DB  0DH,0AH,'                             F:2.0*Speed '
	        DB  0DH,0AH,'                             S:0.5*Speed '
	        DB  0DH,0AH,'                             I:1.0*Speed '
	        DB  0DH,0AH,'                             C:Circulate'
	        DB  0DH,0AH,'                             D:NCirculate'
	        DB  0DH,0AH,'                             G:Go_on'
	        DB  0DH,0AH,'                             Q:Exit '
	        DB  0DH,0AH,'                             R:Return_menu'
	        DB  0DH,0AH,'_________________________________________'
	        DB  0DH,0AH,'$'

	;错误定义
ERRORI	DB  0DH,0AH,'INPUT ERROR!$'
	;电子琴演奏定义

PIANO	DB  0DH,0AH
	    DB  0DH,0AH,'_______________keyboard!_______________'
	    DB  0DH,0AH,'                         (1)play keyboard'
	    DB  0DH,0AH,'                         (2)record music'
	    DB  0DH,0AH,'                         (3)play music'
	    DB  0DH,0AH,'                         (4)EXIT'
	    DB  0DH,0AH,'_________________________________________'
	    DB  0DH,0AH,'$'
SPEED	DB  0                                                         	;播放速率
CIRCU	DB  0                                                         	;是否循环播放
ONCIRCULATE	DB  0DH, 0AH, 20H, 'Circulate On! $',0DH, 0AH
OFFCIRCULATE	DB  0DH, 0AH, 20H, 'Circulate OFF! $',0DH, 0AH
RECORD_MEM_FULL DB  0DH, 0AH, 20H, 'RECORD_MEM_FULL ! $',0DH, 0AH
RECORD_SUCCESS  DB  0DH, 0AH, 20H, 'LOAD SUCCESS ! $',0DH, 0AH
RECORD_NONE	DB  0DH, 0AH, 20H, 'THERE IS NOTHING ! $',0DH, 0AH
UIO	DB  0
LEI	DB  88H

	;音乐定义
	;恭喜发财
FREQ_LIST1	DW  587,659,587,784,587,659,587
	        DW  587,587,659,587,523,440,440,523,440
	        DW  587,659,587,784,587,659,587,523
	        DW  440,440,523,440,392,523,523
	        DW  587,659,784,659
	        DW  587,659,587,523,440,0FFFFH
	        DW  587,659,784,659
	        DW  587,659,587,523,440,0FFFFH
	        DW  440,523,440,330,392,440,523,440,330,392
	        DW  440,523,440,330,392,440,392,440
	        DW  440,523,440,330,392,440,523,440,330,392
	        DW  440,523,440,330,392,440,392,440

	        DW  330,440,392,440,392,330
	        DW  0FFFFH,330
	        DW  440,392,440,392,440
	        DW  0FFFFH,330
	        DW  294,330,294,262,220,0FFFFH,330
	        DW  294,330,294,262,294,0FFFFH,262
	        DW  262,294,330,392
	        DW  440
	        DW  0
TIME_LIST1  DB  6,2,4,4,4,4,8
	        DB  4,2,2,4,4,4,2,2,8
	        DB  6,2,4,4,4,4,4,4
	        DB  4,2,2,4,4,8,8
	        DB  8,8,8,8
	        DB  6,2,4,4,8,8
	        DB  8,8,8,8
	        DB  6,2,4,4,8,8
	        DB  4,2,2,4,4,4,2,2,4,4
	        DB  4,2,2,4,4,4,4,8
	        DB  4,2,2,4,4,4,2,2,4,4
	        DB  4,2,2,4,4,4,4,8
	        DB  4,8,8,8,4,28
	        DB  4,4
	        DB  8,8,8,4,28
	        DB  4,4
	        DB  6,2,4,4,8,4,4
	        DB  6,2,4,4,8,4,4
	        DB  8,8,8,8
	        DB  32
	        DB  0
	;飞向遥远的天空
FREQ_LIST2  DW  440,659,494,523,494,392,440,494,523,587                   	;1
	        DW  784,880,784,440,659,784,494,392,440                       	;2
	        DW  587,659,494,440,659,494,523,494,392                       	;3
	        DW  440,494,523,587,784,880,784,440,659                       	;4
	        DW  784,494,392,440,392,494,440,0FFFFH,0FFFFH,659,784         	;5
	        DW  880,784,880,784,587,659,784,494                           	;6
	        DW  523,523,587,659,0FFFFH,659,587,659,587,523,587            	;7
	        DW  659,698,740,784,880,988,880,784,880,784,587
	        DW  659,784,988,1046,1175,1318,1318,1175,1046
	        DW  988,784,988,1046,0FFFFH,1046,988,880,831,880,988
	        DW  1318,0FFFFH,1175,1046,988,784,659,880
	        DW  0
TIME_LIST2  DB  8, 4, 6, 2, 2, 2, 6, 2, 2, 2
	        DB  2, 2, 8, 8, 4, 4, 4, 4, 12
	        DB  4, 4, 4, 8, 4, 6, 2, 2, 2
	        DB  6, 2, 2, 2, 2, 2, 8, 8, 4
	        DB  4, 4, 4, 6, 2, 4, 8, 4, 4, 4, 4
	        DB  8, 2, 2, 8, 4, 4, 4, 4
	        DB  8, 2, 2, 4, 2, 2, 2, 2, 8, 2, 2
	        DB  4, 4, 4, 4, 4, 4, 8, 2, 2, 8, 4
	        DB  4, 4, 4, 4, 4, 4, 8, 2, 2
	        DB  8, 2, 2, 4, 2, 2, 2, 2, 4, 4, 4
	        DB  4, 4, 2, 2, 4, 4, 4, 24
FREQ_LIST3  DW  393, 441, 294, 262, 294, 262, 393, 441, 294, 262, 294, 262
	        DW  393, 441, 294, 262, 294, 262, 350, 330, 350, 330, 294, 262
	        DW  393, 441, 294, 262, 294, 262, 393, 441, 294, 262, 294, 262
	        DW  393, 441, 525, 700, 661, 700, 661, 589, 525, 441
	        DW  393, 441, 294, 262, 294, 262, 393, 441, 294, 262, 294, 262
	        DW  393, 441, 294, 262, 294, 262, 350, 330, 350, 330, 294, 262
	        DW  294, 262, 294, 350, 294, 350, 441, 393, 441, 525, 441, 525
	        DW  700, 661, 700, 661, 589, 525, 589
	        DW  0
TIME_LIST3  DB  6, 6, 3, 3, 3, 3, 6, 6, 6, 6, 6, 6
	        DB  12, 12, 6, 6, 6, 6, 12, 12, 3, 3, 6, 12
	        DB  12, 12, 6, 6, 6, 6, 12, 12, 6, 6, 6, 6
	        DB  12, 12, 12, 12, 6, 6, 6, 6, 12, 12
	        DB  12, 12, 6, 6, 6, 6, 12, 12, 6, 6, 6, 6
	        DB  12, 12, 6, 6, 6, 6, 12, 12, 3, 3, 6, 12
	        DB  12, 6, 6, 12, 6, 6, 12, 6, 6, 12, 6, 6
	        DB  12, 6, 3, 3, 12, 12, 24
	        DB  0


	;电子琴演奏
DTABLE	DB  3FH,06H,5BH,4FH,66H,6DH,7DH,07H
		DB  7FH,6FH,77H,7CH,39H,5EH,79H,71H
KEYBOARD	DW  441,495,556,589,661,742,833
RECORDMEM	DW  20 DUP(0)
TIME_RECORD	DB  19 DUP(3),0
RECORDFLAG	DW  111
RECORDNUM	DW  0
IS_RECORD	DW  0
DATA ENDS


CODE SEGMENT
	ASSUME  DS:DATA,CS:CODE,SS:SSTACK

START:       

	MOV     AX,0000H
	MOV     DS,AX
 
	MOV     AX,OFFSET MIR7
	MOV     SI,003CH
	MOV[SI],AX
	MOV     AX,CS
	MOV     SI,003EH
	MOV[SI],AX
	CLI

	MOV     AL,11H
	OUT     20H,AL
	MOV     AL,08H
	OUT     21H,AL
	MOV     AL,04H
	OUT     21H,AL
	MOV     AL,01H
	OUT     21H,AL
	MOV     AL,6FH
	OUT     21H,AL
	STI
 
	     
 

	JMP     START3

MIR7:        
	STI
	MOV     AH,4CH
	INT     21H
	CALL    DELAY3
	MOV     DX,MY8254_MODE           	;中断
	MOV     AL,10H
	OUT     DX,AL
	MOV     DX,MY8255_C
	MOV     AL,00H
	OUT     DX,AL
	MOV     AH,4CH
	INT     21H
	MOV     AL,20H
	OUT     20H,AL
 
	IRET

DELAY3:      
	PUSH    CX
	MOV     CX,0F00H
AA0:         
	PUSH    AX
	POP     AX
	LOOP    AA0
	POP     CX
	RET
START3:    
	MOV     AX,DATA
	MOV     DS,AX
	CALL    WELCOME  
	MOV DX,MY8254_MODE ;初始化8254
	MOV AL,36H
	OUT     DX,AL
INPUT:       
	DISPLAY MENU                     	;显示菜单
	MOV AH,00H
	INT 16H
	MOV     AH,08H
	INT     21H


	CMP     AL,'q'
	JZ      EXIT_MED
	JNZ     EXIT_NEXT
EXIT_MED:    
	JMP     EXIT
EXIT_NEXT:   

QSC:         
	CMP     AL,'1'                   	;调用子程序Senbon Zakura
	JZ      A
	CMP     AL,'2'                   	;调用子程序bad apple
	JZ      B
	CMP     AL,'3'                   	;调用子程序
	JZ      C
	CMP     AL,'4'                   	;调用子程序演奏电子琴
	JZ      H
	JMP     ERROR                    	;非法输入

A:           
	CALL    MUSIC1
	CMP     UIO,0FH
	JZ      QSC
	JMP     INPUT
B:           
	CALL    MUSIC2
	CMP     UIO,0FH
	JZ      QSC
	JMP     INPUT
C:           
	CALL    MUSIC3
	CMP     UIO,0FH
	JZ      QSC
	JMP     INPUT
H:           
	DISPLAY PIANO
	MOV     RECORDFLAG,111
	MOV     AH,08H
	INT     21H

	CMP     AL,'1'
	MOV     RECORDFLAG,111           	;表示正常电子琴
	JZ      DZQ_MEDIUM               	;电子琴
	JNZ     NEXT1
DZQ_MEDIUM:  
	JMP     DZQ
NEXT1:       
	CMP     AL,'2'
	JNZ	DZQ_NEXT
	MOV     RECORDFLAG,222           	;表示正常电子琴
	MOV RECORDNUM,0					;清零记录
	CMP     RECORDNUM,36
	JBE     DZQ_MED                  	;记录键位
	DISPLAY RECORD_MEM_FULL
	JMP 	H
	;JA      DZQ_NEXT
DZQ_MED:     
	JMP     DZQ
DZQ_NEXT:    
	MOV BX,1
	MOV IS_RECORD,BX
	CMP     AL,'3'				;播放
	JNZ MUSIC_RD_NEXT
	CALL    MUSIC_RECORD
	MOV BX,0
	MOV IS_RECORD,BX
	
	JMP H
	
MUSIC_RD_NEXT:	             

	CMP     AL,'4'
	JZ      START3_MED               	;返回主菜单
	JNZ     START3_NEXT
START3_MED:  
	JMP     INPUT
START3_NEXT: 
	JMP     H
ERROR:       
	DISPLAY ERRORI
	JMP     H
EXIT:        
	MOV     DX,MY8254_MODE
	MOV     AL,10H
	OUT     DX,AL
	MOV     AH,4CH
	INT     21H
MUSIC1 PROC
	MOV     UIO,0H
	MOV     DX,MY8254_MODE
	MOV     AL,36H
	OUT     DX,AL
	MOV     SI,OFFSET FREQ_LIST1
	MOV     DI,OFFSET TIME_LIST1
	DISPLAY FUNCTION
	MOV     DX,MY8255_CON
	MOV     AL,80H
	OUT     DX,AL
	CALL    PLAY

	MOV     AL,CIRCU
	CMP     AL,1
	JZ      CIR1
	MOV     DX,MY8255_C
	MOV     AL,00H
	OUT     DX,AL

	MOV     SPEED,0
	JMP     OVER1
CIR1:        
	CALL    MUSIC1
OVER1:       
RET
MUSIC1 ENDP
MUSIC2 PROC
	MOV     UIO,0H
	MOV     DX,MY8254_MODE
	MOV     AL,36H
	OUT     DX,AL
	MOV     SI,OFFSET FREQ_LIST2
	MOV     DI,OFFSET TIME_LIST2
	DISPLAY FUNCTION

	MOV     DX,MY8255_CON
	MOV     AL,80H
	OUT     DX,AL
	CALL    PLAY
	MOV     AL,CIRCU
	CMP     AL,1
	JZ      CIR2
	MOV     DX,MY8255_C
	MOV     AL,00H
	OUT     DX,AL
	MOV     SPEED,0
	JMP     OVER2
CIR2:        
	CALL    MUSIC2
OVER2:       
	RET
MUSIC2 ENDP
MUSIC3 PROC
	MOV     UIO,0H
	MOV     DX,MY8254_MODE           	;初始化8254
	MOV     AL,36H
	OUT     DX,AL
	MOV     SI,OFFSET FREQ_LIST3     	;装入频率表起始地址
	MOV     DI,OFFSET TIME_LIST3     	;装入时间表起始地址
	DISPLAY FUNCTION
	MOV     DX,MY8255_CON
	MOV     AL,80H
	OUT     DX,AL
	CALL    PLAY
	PUSH    AX
	MOV     AL,CIRCU
	CMP     AL,1
	JZ      CIR3
	MOV     DX,MY8255_C
	MOV     AL,00H
	OUT     DX,AL
	POP     AX
	MOV     SPEED,0
	JMP     OVER3
CIR3:        
	CALL    MUSIC3
OVER3:       
	RET
MUSIC3 ENDP

MUSIC_RECORD PROC
	CMP RECORDNUM,0
	JA	MUSIC_RECORD_NEXT
	DISPLAY RECORD_NONE
	RET
	MUSIC_RECORD_NEXT:
	PUSH DS
	MOV AX,DATA
	MOV DS,AX
	MOV     DX,MY8254_MODE           	;初始化8254
	MOV     AL,36H
	OUT     DX,AL
	MOV     SI,OFFSET RECORDMEM      	;装入频率表起始地址
	MOV     DI,OFFSET TIME_RECORD    	;装入时间表起始地址
	CALL    PLAY
	PUSH    AX
	MOV     AL,CIRCU
	CMP     AL,1
	JZ      CIR4
	POP     AX
	MOV     SPEED,0
	JMP     OVER4
CIR4:        
	CALL    MUSIC_RECORD
OVER4:       
	POP DS
	RET
MUSIC_RECORD ENDP


	;播放子程序
PLAY PROC

BEGIN1:      
	CMP IS_RECORD,1
	JZ SOUND_MED
	JNZ SOUND_NEXT
SOUND_MED:
	JMP SOUND
SOUND_NEXT:
	MOV     AH,01H
	INT     16H

	JNZ      SOUND_MED_NEXT
	JMP SOUND
SOUND_MED_NEXT:
	JNZ     X
SELECTF:     
	MOV     AH,00H
	INT     16H
	MOV     AH,08H                   	;选择功能之后，再次选择功能输入，若begin有输入则
	INT     21H

X:           
	MOV     AH,00H
	INT     16H
	CMP     AL,'P'                   	;暂停
	JZ      Q6
	CMP     AL,'G'                   	;继续播放
	JZ      Q7
	CMP     AL,'Q'                   	;退出
	JZ      Q1
	CMP     AL,'C'                   	;循环
	JZ      Q9
	CMP     AL,'D'                   	;取消循环
	JZ      Q8
	CMP     AL,'F'                   	;2倍速
	JZ      Q5
	CMP     AL,'S'                   	;0.5倍速
	JZ      Q2
	CMP     AL,'I'                   	;1倍速
	JZ      Q10
	CMP     AL,'R'                   	;返回主菜单
	JZ      Q3
	CMP     AL,'1'                   	;调用子程序歌曲1
	MOV     CIRCU,0
	MOV     UIO,0FH
	JZ      Q4
	CMP     AL,'2'                   	;调用子程序歌曲2bad apple
	MOV     CIRCU,0
	MOV     UIO,0FH
	JZ      Q4
	CMP     AL,'3'                   	;调用子程序歌曲3
	MOV     CIRCU,0
	MOV     UIO,0FH
	JZ      Q4
	JMP     Q7

Q1:
	JMP		EXIT1
Q2:          
	JMP     SLOW
Q3:          
	JMP     NORMAL
Q4:			
	JMP 	ENDMUS
Q5:          
	JMP     FAST
Q6:          
	JMP     PAUSE
Q7:          
	JMP     SOUND
Q8:          
	JMP     NREPEAT
Q9:          
	JMP     REPEAT
Q10:         
	JMP     INITIAL

SOUND:       
	MOV     DX,MY8254_MODE           	;初始化8254工作方式
	MOV     AL,36H                   	;定时器0、方式3
	OUT     DX,AL
	MOV     DX,0FH                   	;输入时钟为0F4240H,暂停后继续功能
	MOV     AX,4240H
	DIV     WORD PTR [SI]            	;取出频率值计算计数初值，0F4240H /输出频率,商放AX
	MOV     DX,MY8254_COUNT0
	OUT     DX,AL                    	;装入计数初值，即将AX输出
	MOV     AL,AH
	OUT     DX,AL
	MOV     DX,MY8255_C
	MOV     AL,LEI
	OUT     DX,AL
	MOV     DL,[DI]
	CALL    DELAY                    	;取出演奏相对时间，调用延时子程序
	ADD     SI,2
	INC     DI
	CMP     WORD PTR [SI],0          	;判断是否到曲末
	JZ      ENDMUS
	ROL     LEI,1
	JMP     BEGIN1


PAUSE:       
	MOV     DX,MY8254_MODE           	;初始化8254工作方式
	MOV     AL,10H                   	;定时器0、方式3
	OUT     DX,AL
	JMP     SELECTF

REPEAT:      
	MOV     DX,OFFSET ONCIRCULATE
	MOV     AH,09H
	INT     21H
	MOV     CIRCU,1
	JMP     SOUND

NREPEAT:     
	MOV     DX,OFFSET OFFCIRCULATE
	MOV     AH,09H
	INT     21H
	MOV     CIRCU,0
	JMP     SOUND
ERROR1:      
	DISPLAY ERRORI
	JMP     SOUND
FAST:        
	MOV     SPEED,2
	JMP     SOUND
SLOW:        
	MOV     SPEED,1
	JMP     SOUND
INITIAL:     
	MOV     SPEED,0
	JMP     SOUND
EXIT1:       
	MOV     DX,MY8254_MODE
	MOV     AL,10H
	OUT     DX,AL
	MOV     AH,00H
	INT     16H                      	;最后清一遍缓冲区
	MOV     AH,4CH
	INT     21H
NORMAL:      
	MOV     SPEED,0
    MOV     CIRCU,0
ENDMUS: 
	MOV DX,MY8254_MODE                    		;中断
	MOV     AL,10H
	OUT     DX,AL
	JMP INPUT
PLAY ENDP


	;延时子程序
DELAY PROC
	CMP     SPEED,1
	JZ      S
	CMP     SPEED,2
	JZ      F
D0:          
	MOV     CX,0010H
D1:          
	MOV     AX,0F00H
D2:          
	DEC     AX
	JNZ     D2
	LOOP    D1
	DEC     DL
	JNZ     D0
	JMP     R
F:           
	SHR     DL,1
	JMP     D0
S:           
	SHL     DL,1
    JMP     D0
R:           
	RET
DELAY ENDP


	;电子琴子程序
DZQ:         

	MOV     AX,DATA
	MOV     DS,AX
	MOV     SI,3000H
	MOV     AL,00H
	MOV     [SI],AL                  	;清显示缓冲
	MOV     [SI+1],AL
	MOV     [SI+2],AL
	MOV     [SI+3],AL
	MOV     [SI+4],AL
	MOV     [SI+5],AL
	MOV     DI,3005H
	MOV     DX,MY8255_CON            	;写8255控制字
	MOV     AL,81H
	OUT     DX,AL

BEGIN2:      
	CALL    DIS                      	;调用显示子程序
	CALL    CLEAR                    	;清屏
	CALL    CCSCAN                   	;扫描
	JNZ     INK1
	JMP     BEGIN2

INK1:        
	CALL    DIS
	CALL    DALLY
	CALL    DALLY
	CALL    CLEAR
	CALL    CCSCAN
	JNZ     INK2                     	;有键按下，转到INK2
	JMP     BEGIN2

	;确定按下键的位置
INK2:        
	MOV     CH,0FEH
	MOV     CL,00H
COLUM:       
	MOV     AL,CH
	MOV     DX,MY8255_A
	OUT     DX,AL
	MOV     DX,MY8255_C
	IN      AL,DX
L1:          
	TEST    AL,01H                   	;is L1?
	JNZ     L2

	MOV     AL,00H                   	;L1
	JMP     KCODE
L2:          
	TEST    AL,02H                   	;is L2?
	JNZ     L3
	MOV     AL,04H                   	;L2
	JMP     KCODE
L3:          
	TEST    AL,04H                   	;is L3?
	JNZ     L4
	MOV     AL,08H                   	;L3
	JMP     KCODE
L4:          
	TEST    AL,08H                   	;is L4?
	JNZ     NEXT
	MOV     AL,0CH                   	;L4
KCODE:       
	ADD     AL,CL
	CALL    PUTBUF
	CMP     AL,0H
	JZ      YY
	CALL    DZQ1
	PUSH    AX
KON:         
	CALL    DIS
	CALL    CLEAR
	CALL    CCSCAN
	JNZ     KON
	POP     AX
NEXT:        
	INC     CL
	MOV     AL,CH
	TEST    AL,08H
	JZ      KERR
	ROL     AL,1
	MOV     CH,AL
	JMP     COLUM
KERR:        
	JMP     BEGIN2
CCSCAN:      
	MOV     AL,00H                   	;键盘扫描子程序
	MOV     DX,MY8255_A
	OUT     DX,AL
	MOV     DX,MY8255_C
	IN      AL,DX
	NOT     AL
	AND     AL,0FH
	RET

YY:          
	JMP     INPUT
CLEAR:       
	MOV     DX,MY8255_B              	;清屏子程序
	MOV     AL,00H
	OUT     DX,AL
	RET
DIS:         
	PUSH    AX                       	;显示子程序
	MOV     SI,3000H
	MOV     DL,0DFH
	MOV     AL,DL

AGAIN2:      
	PUSH    DX
	MOV     DX,MY8255_A
	OUT     DX,AL
	MOV     AL,[SI]
	MOV     BX,OFFSET DTABLE
	AND     AX,00FFH
	ADD     BX,AX
	MOV     AL,[BX]
	MOV     DX,MY8255_B
	OUT     DX,AL
	CALL    DALLY
	INC     SI
	POP     DX
	MOV     AL,DL
	TEST    AL,01H
	JZ      OUT1
	ROR     AL,1
	MOV     DL,AL
	JMP     AGAIN2
OUT1:        
	POP     AX
	RET

DALLY:       
	PUSH    CX                       	;延时子程序
	MOV     CX,0010H
T1:          
	MOV     AX,009FH
T2:          
	DEC     AX
	JNZ     T2
	LOOP    T1
	POP     CX
	RET
PUTBUF:      
	MOV     SI,DI                    	;存键盘值到相应位的缓冲中
	MOV     [SI],AL
	DEC     DI
	CMP     DI,2FFFH
	JNZ     GOBACK
	MOV     DI,3005H
GOBACK:      
	RET

	;子程序
DZQ1 PROC
	PUSH    AX

	MOV     DX,MY8254_MODE           	;初始化8254
	MOV     AL,36H
	OUT     DX,AL

	POP     AX

	MOV     SI,OFFSET KEYBOARD       	;电子琴功能
	CMP     AL,01H
	JZ      D
	CMP     AL,02H
	JZ      R1_MED
	JNZ		R1_NEXT
R1_MED:
	JMP 	R1
R1_NEXT:
	CMP     AL,03H
	JZ      M_MED
	JNZ     M_NEXT
M_MED:       
    JMP     M
M_NEXT:      
	CMP     AL,04H
	JZ      F1_MED
	JNZ     F1_NEXT
F1_MED:      
	JMP     F1
F1_NEXT:     
	CMP     AL,05H
	JZ      S1_MED
	JNZ     S1_NEXT
S1_MED:      
	JMP     S1
S1_NEXT:     
	CMP     AL,06H
	JZ      L11_MED
	JNZ		L11_NEXT
L11_MED:
	JMP 	L11 
L11_NEXT:
	CMP     AL,07H
	JZ      X2_MED
	JNZ 	X2_NEXT
X2_MED:
	JMP 	X2
X2_NEXT:
	DISPLAY ERRORI
	JMP     LL

D:           
	MOV     DX,0FH
	MOV     AX,4240H
	DIV     WORD PTR [SI]            	;取出频率值计算计数初值，0F4240H /输出频率,商放AX
	
	MOV     DX,MY8254_COUNT0
	OUT     DX,AL
	MOV     AL,AH
	OUT     DX,AL

	CALL    DALLY1

	CMP     RECORDFLAG,111
	JZ      LL_MED_1
	JNZ     LL_NEXT_1
LL_MED_1:    
			
	JMP     LL
LL_NEXT_1:   
	MOV     BX,RECORDNUM
	CMP 	BX,36
	JAE		FULL_MED1
	JB		FULL_NEXT1
FULL_MED1:
	JMP 	FULL
FULL_NEXT1: 
	MOV     WORD PTR RECORDMEM[BX],441
	INC     BX
	INC     BX
	MOV     RECORDNUM,BX

	MOV     DX,OFFSET RECORD_SUCCESS
	MOV     AH,09H
	INT     21H
	
	JMP     LL

R1:          
	MOV     DX,0FH
	MOV     AX,4240H
	ADD     SI,02H
	DIV     WORD PTR [SI]            	;取出频率值计算计数初值，0F4240H /输出频率,商放AX
	
	MOV     DX,MY8254_COUNT0
	OUT     DX,AL
	MOV     AL,AH
	OUT     DX,AL
	CALL    DALLY1

	CMP     RECORDFLAG,111
	JZ      LL_MED_2
	JNZ     LL_NEXT_2
LL_MED_2:    
	JMP     LL
LL_NEXT_2:   
	MOV     BX,RECORDNUM
	CMP 	BX,36
	JAE		FULL_MED2
	JB		FULL_NEXT2
FULL_MED2:
	JMP 	FULL
FULL_NEXT2: 
	MOV     WORD PTR RECORDMEM[BX],495
	INC     BX
	INC     BX
	MOV     RECORDNUM,BX
	MOV     DX,OFFSET RECORD_SUCCESS
	MOV     AH,09H
	INT     21H
	
	JMP     LL




X2:          
	JMP     X1
L11:         
	JMP     L
M:           
	MOV     DX,0FH
	MOV     AX,4240H
	ADD     SI,04H
	DIV     WORD PTR [SI]            	;取出频率值计算计数初值，0F4240H /输出频率,商放AX
	MOV     DX,MY8254_COUNT0
	OUT     DX,AL
	MOV     AL,AH
	OUT     DX,AL
	CALL    DALLY1

	CMP     RECORDFLAG,111
	JZ      LL_MED_3
	JNZ     LL_NEXT_3
LL_MED_3:    
	JMP     LL
LL_NEXT_3:   
	MOV     BX,RECORDNUM
	CMP 	BX,36
	JAE		FULL_MED3
	JB		FULL_NEXT3
FULL_MED3:
	JMP 	FULL
FULL_NEXT3: 
	MOV     AX,WORD PTR [SI]
	MOV     WORD PTR RECORDMEM[BX],556
	INC     BX
	INC     BX
	MOV     RECORDNUM,BX
	MOV     DX,OFFSET RECORD_SUCCESS
	MOV     AH,09H
	INT     21H
	JMP     LL



F1:          
 	
	MOV     DX,0FH
	MOV     AX,4240H
	ADD     SI,06H
	DIV     WORD PTR [SI]            	;取出频率值计算计数初值，0F4240H /输出频率,商放AX
	MOV     DX,MY8254_COUNT0
	OUT     DX,AL
	MOV     AL,AH
	OUT     DX,AL
	CALL    DALLY1

	CMP     RECORDFLAG,111
	JZ      LL_MED_4
	JNZ     LL_NEXT_4
LL_MED_4:    
	JMP     LL
	LL_NEXT_4:   
	MOV     BX,RECORDNUM
	CMP 	BX,36
	JAE		FULL_MED4
	JB		FULL_NEXT4
FULL_MED4:
	JMP 	FULL
FULL_NEXT4: 
	MOV     AX,WORD PTR [SI]
	MOV     WORD PTR RECORDMEM[BX],589
	INC     BX
	INC     BX
	MOV     RECORDNUM,BX
	MOV     DX,OFFSET RECORD_SUCCESS
	MOV     AH,09H
	INT     21H
 

	JMP     LL

S1:          
				
	MOV     DX,0FH
	MOV     AX,4240H
	ADD     SI,08H
	DIV     WORD PTR [SI]            	;取出频率值计算计数初值，0F4240H /输出频率,商放AX
	MOV     DX,MY8254_COUNT0
	OUT     DX,AL
	MOV     AL,AH
	OUT     DX,AL
	CALL    DALLY1

	CMP     RECORDFLAG,111
	JZ      LL_MED_5
	JNZ     LL_NEXT_5
LL_MED_5:    
	JMP     LL
LL_NEXT_5:   
	MOV     BX,RECORDNUM
	CMP 	BX,36
	JAE		FULL_MED5
	JB		FULL_NEXT5
FULL_MED5:
	JMP 	FULL
FULL_NEXT5: 
	MOV     AX,WORD PTR [SI]
	MOV     WORD PTR RECORDMEM[BX],661
	INC     BX
	INC     BX
	MOV     RECORDNUM,BX
	MOV     DX,OFFSET RECORD_SUCCESS
	MOV     AH,09H
	INT     21H
	
	JMP     LL

L:           
	MOV     DX,0FH
	MOV     AX,4240H
	ADD     SI,0AH
	DIV     WORD PTR [SI]            	;取出频率值计算计数初值，0F4240H /输出频率,商放AX
	MOV     DX,MY8254_COUNT0
	OUT     DX,AL
	MOV     AL,AH
	OUT     DX,AL
	CALL    DALLY1
	CMP     RECORDFLAG,111
	JZ      LL_MED_6
	JNZ     LL_NEXT_6
LL_MED_6:    

	JMP     LL
LL_NEXT_6:   
	MOV     BX,RECORDNUM
	CMP 	BX,36
	JAE		FULL_MED6
	JB		FULL_NEXT6
FULL_MED6:
	JMP 	FULL
FULL_NEXT6: 
	MOV     AX,WORD PTR [SI]
	MOV     WORD PTR RECORDMEM[BX],742
	INC     BX
	MOV     RECORDNUM,BX
	MOV     DX,OFFSET RECORD_SUCCESS
	MOV     AH,09H
	INT     21H
	
	JMP     LL
;441,495,556,589,661,742,833
X1:          
	MOV     DX,0FH
	MOV     AX,4240H
	ADD     SI,0CH
	DIV     WORD PTR [SI]            	;取出频率值计算计数初值，0F4240H /输出频率,商放AX
	MOV     DX,MY8254_COUNT0
	OUT     DX,AL
	MOV     AL,AH
	OUT     DX,AL
	CALL    DALLY1
	CMP     RECORDFLAG,111
	JZ      LL_MED_7
	JNZ     LL_NEXT_7
LL_MED_7:    

	JMP     LL
LL_NEXT_7:   
	MOV     BX,RECORDNUM
	CMP 	BX,36
	JAE		FULL_MED7
	JB		FULL_NEXT7
FULL_MED7:
	JMP 	FULL
FULL_NEXT7: 
	MOV     AX,WORD PTR [SI]
	MOV     WORD PTR RECORDMEM[BX],833
	INC     BX
	INC     BX
	MOV     RECORDNUM,BX
	MOV     DX,OFFSET RECORD_SUCCESS
	MOV     AH,09H
	INT     21H



LL:          
	MOV     DX,MY8254_MODE           	;初始化8254
	MOV     AL,10H
	OUT     DX,AL
	RET
FULL:
	DISPLAY RECORD_MEM_FULL   
	JMP LL

	         
DZQ1 ENDP

	;弹奏延迟子程序
DALLY1 PROC
	MOV     DL,5
T3:          
	MOV     CX,0010H
T4:          
	MOV     AX,0F00H
T5:          
	DEC     AX
	JNZ     T5
	LOOP    T4
	DEC     DL
	JNZ     T3
	RET
DALLY1 ENDP





WELCOME:     
	
	MOV     SI, OFFSET HZDOTht
G1:          
	MOV     CX, 15                   	;滚动速度
	CALL    DISP
	ADD     SI, 2                    	;字库数据向下平移一行
	MOV     AX, SI
	SHR     AX, 5
	MOV     DX, NUM
	DEC     DX
	CMP     AX, DX                   	;判断是否显示结束
	JNZ     G1
	MOV     SI, 0                    	;循环显示
   
	RET

	
	;======显示子程序======
DISP:        
	MOV     DX, 0600H                	;消隐
	MOV     AL, 0
	OUT     DX, AL
	MOV     BX, 0
LL1:         
	MOV     AL, [SI]                 	;取字库数据到AX
	ADD     SI, 1
	MOV     AH, [SI]
	ADD     SI, 1
	CALL    SEND
	ADD     BH, 1
	CMP     BH, 10H                  	;显示16行后跳出LL1
	JNZ     LL1
	SUB     SI, 32                   	;恢复SI
	LOOP    DISP
	RET

	;======发送子程序======
SEND:        
	PUSH    AX                       	;AX:DATA
	PUSH    CX
	MOV     CL, 00H
	MOV     DX, AX                   	;保护DATA
LOOP1:       
	PUSH    BX                       	;BH:ROW
	PUSH    DX
	MOV     AX, DX
	SHR     AX, CL
	AND     AX, 0001H                	;取DATA最低位
	SHL     AL, 4                    	;将DATA最低位移至CSDI
	AND     AL, 10H
	MOV     BL, AL
	OR      BH, 10000000B
	OR      AL, BH
	MOV     DX, 0600H
	OUT     DX, AL                   	;置COE#=1,CSCK=0,CSDI=DATA最低位
	OUT     DX, AL                   	;置COE#=1,CSCK=0,CSDI=DATA最低位
	MOV     AL, BL
	OR      BH, 10100000B
	OR      AL, BH
	OUT     DX, AL                   	;置COE#=1,CSCK=1,CSDI=DATA最低位
	MOV     AL, BH
	OUT     DX, AL                   	;置COE#=1,CSCK=1
	POP     DX
	POP     BX
	INC     CL
	CMP     CL, 10H                  	;循环发送16个串行数据
	JNZ     LOOP1
	
	PUSH    BX                       	;BH:ROW
	PUSH    DX
	MOV     DX, 0600H
	OR      BH, 01000000B
	MOV     AL, BH
	OUT     DX, AL                   	;置COE#=0,CSCK=0,CLE有效，锁16个串行数据
	OR      BH, 00000000B
	MOV     AL, BH
	OUT     DX, AL                   	;置COE#=0,CSCK=0,CLE无效，输出16个并行数据
	POP     DX
	POP     BX
	POP     CX
	POP     AX
	CALL    DELAY2
	RET
		
	;======延时子程序======
DELAY2:      
	PUSH    CX
    MOV     CX, 0080H
DL1:         
	PUSH    AX
	POP     AX
	LOOP    DL1
	POP     CX
	RET


CODE ENDS
END START

