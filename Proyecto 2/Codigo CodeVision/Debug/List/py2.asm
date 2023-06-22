
;CodeVisionAVR C Compiler V3.51 
;(C) Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega8535
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x37
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x025F
	.EQU __DSTACK_SIZE=0x0080
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x20

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	RCALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	RCALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _control=R4
	.DEF _control_msb=R5
	.DEF _control2=R6
	.DEF _control2_msb=R7
	.DEF _control3=R8
	.DEF _control3_msb=R9
	.DEF _i=R10
	.DEF _i_msb=R11
	.DEF _control4=R12
	.DEF _control4_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0


__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0xE0

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;void mover(int movimientos[], int j){
; 0000 0038 void mover(int movimientos[], int j){

	.CSEG
_mover:
; .FSTART _mover
; 0000 0039 for(i=0; i<=j; i++){
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
;	movimientos -> R18,R19
;	j -> R16,R17
	CLR  R10
	CLR  R11
_0x4:
	__CPWRR 16,17,10,11
	BRLT _0x5
; 0000 003A //Muestra los movivimientos en los motores
; 0000 003B if (movimientos[i]==0){
	RCALL SUBOPT_0x0
	__GETW1P
	SBIW R30,0
	BREQ _0x59
; 0000 003C PORTA=0x00;
; 0000 003D delay_ms(100);
; 0000 003E } else if(movimientos[i]==1){  //Adelante
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8
; 0000 003F PORTA=0x05;
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x2
; 0000 0040 delay_ms(2000);
	RJMP _0x5A
; 0000 0041 } else if(movimientos[i]==2){   //Atras
_0x8:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA
; 0000 0042 PORTA=0x0A;
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x2
; 0000 0043 delay_ms(2000);
	RJMP _0x5A
; 0000 0044 } else if(movimientos[i]==3){   //A la derecha
_0xA:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC
; 0000 0045 PORTA=0x08;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x2
; 0000 0046 delay_ms(2000);
	RJMP _0x5A
; 0000 0047 } else if(movimientos[i]==4){   //A la izquierda
_0xC:
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xE
; 0000 0048 PORTA=0x02;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x2
; 0000 0049 delay_ms(2000);
	RJMP _0x5A
; 0000 004A } else {
_0xE:
; 0000 004B PORTA=0x00;
_0x59:
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 004C delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
_0x5A:
	RCALL _delay_ms
; 0000 004D }
; 0000 004E 
; 0000 004F }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x4
_0x5:
; 0000 0050 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0051 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;void main(void)
; 0000 0055 {
_main:
; .FSTART _main
; 0000 0056 // Declare your local variables here
; 0000 0057 
; 0000 0058 // Input/Output Ports initialization
; 0000 0059 // Port A initialization
; 0000 005A // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 005B DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 005C // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 005D PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 005E 
; 0000 005F // Port B initialization
; 0000 0060 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0061 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0062 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0063 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	OUT  0x18,R30
; 0000 0064 
; 0000 0065 // Port C initialization
; 0000 0066 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0067 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	OUT  0x14,R30
; 0000 0068 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0069 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 006A 
; 0000 006B // Port D initialization
; 0000 006C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 006D DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	OUT  0x11,R30
; 0000 006E // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 006F PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 0070 
; 0000 0071 // Timer/Counter 0 initialization
; 0000 0072 // Clock source: System Clock
; 0000 0073 // Clock value: Timer 0 Stopped
; 0000 0074 // Mode: Normal top=0xFF
; 0000 0075 // OC0 output: Disconnected
; 0000 0076 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0077 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0078 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0079 
; 0000 007A // Timer/Counter 1 initialization
; 0000 007B // Clock source: System Clock
; 0000 007C // Clock value: Timer1 Stopped
; 0000 007D // Mode: Normal top=0xFFFF
; 0000 007E // OC1A output: Disconnected
; 0000 007F // OC1B output: Disconnected
; 0000 0080 // Noise Canceler: Off
; 0000 0081 // Input Capture on Falling Edge
; 0000 0082 // Timer1 Overflow Interrupt: Off
; 0000 0083 // Input Capture Interrupt: Off
; 0000 0084 // Compare A Match Interrupt: Off
; 0000 0085 // Compare B Match Interrupt: Off
; 0000 0086 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0087 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0088 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0089 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 008A ICR1H=0x00;
	OUT  0x27,R30
; 0000 008B ICR1L=0x00;
	OUT  0x26,R30
; 0000 008C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 008D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 008E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 008F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0090 
; 0000 0091 // Timer/Counter 2 initialization
; 0000 0092 // Clock source: System Clock
; 0000 0093 // Clock value: Timer2 Stopped
; 0000 0094 // Mode: Normal top=0xFF
; 0000 0095 // OC2 output: Disconnected
; 0000 0096 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0097 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0098 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0099 OCR2=0x00;
	OUT  0x23,R30
; 0000 009A 
; 0000 009B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 009C TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 009D 
; 0000 009E // External Interrupt(s) initialization
; 0000 009F // INT0: Off
; 0000 00A0 // INT1: Off
; 0000 00A1 // INT2: Off
; 0000 00A2 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00A3 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00A4 
; 0000 00A5 // USART initialization
; 0000 00A6 // USART disabled
; 0000 00A7 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00A8 
; 0000 00A9 // Analog Comparator initialization
; 0000 00AA // Analog Comparator: Off
; 0000 00AB // The Analog Comparator's positive input is
; 0000 00AC // connected to the AIN0 pin
; 0000 00AD // The Analog Comparator's negative input is
; 0000 00AE // connected to the AIN1 pin
; 0000 00AF ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00B0 SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00B1 
; 0000 00B2 // ADC initialization
; 0000 00B3 // ADC disabled
; 0000 00B4 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00B5 
; 0000 00B6 // SPI initialization
; 0000 00B7 // SPI disabled
; 0000 00B8 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00B9 
; 0000 00BA // TWI initialization
; 0000 00BB // TWI disabled
; 0000 00BC TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00BD 
; 0000 00BE while (1)
_0x10:
; 0000 00BF {
; 0000 00C0 
; 0000 00C1 //Detecta si se presiono el BOTON GO
; 0000 00C2 if (boton4==0)
	SBIC 0x10,4
	RJMP _0x13
; 0000 00C3 botone=0;
	CLT
	RJMP _0x5B
; 0000 00C4 else
_0x13:
; 0000 00C5 botone=1;
	SET
_0x5B:
	BLD  R3,3
; 0000 00C6 
; 0000 00C7 if ((botonp4==1)&&(botone==0)) {//hubo cambio de flanco de 1 a 0
	SBRS R2,4
	RJMP _0x16
	SBRS R3,3
	RJMP _0x17
_0x16:
	RJMP _0x15
_0x17:
; 0000 00C8 //El boton GO esta activo por lo tanto el control = 3 para recorrer el arreglo
; 0000 00C9 control=2;
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 00CA delay_ms(30);
; 0000 00CB }
; 0000 00CC 
; 0000 00CD if ((botonp4==0)&&(botone==1)) //hubo cambio de flanco de 0 a 1
_0x15:
	SBRC R2,4
	RJMP _0x19
	SBRC R3,3
	RJMP _0x1A
_0x19:
	RJMP _0x18
_0x1A:
; 0000 00CE delay_ms(30);
	RCALL SUBOPT_0x5
; 0000 00CF botonp4=botone;
_0x18:
	BST  R3,3
	BLD  R2,4
; 0000 00D0 
; 0000 00D1 //-----------Se dejo de presionar el boton GO
; 0000 00D2 
; 0000 00D3 //Detecta si se presiono el BOTON CLEAR
; 0000 00D4 if (boton5==0)
	SBIC 0x10,5
	RJMP _0x1B
; 0000 00D5 botonf=0;
	CLT
	RJMP _0x5C
; 0000 00D6 else
_0x1B:
; 0000 00D7 botonf=1;
	SET
_0x5C:
	BLD  R3,4
; 0000 00D8 
; 0000 00D9 if ((botonp5==1)&&(botonf==0)){//hubo cambio de flanco de 1 a 0
	SBRS R2,5
	RJMP _0x1E
	SBRS R3,4
	RJMP _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 00DA control=1;
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x4
; 0000 00DB delay_ms(30);
; 0000 00DC }
; 0000 00DD 
; 0000 00DE if ((botonp5==0)&&(botonf==1)) //hubo cambio de flanco de 0 a 1
_0x1D:
	SBRC R2,5
	RJMP _0x21
	SBRC R3,4
	RJMP _0x22
_0x21:
	RJMP _0x20
_0x22:
; 0000 00DF delay_ms(30);
	RCALL SUBOPT_0x5
; 0000 00E0 botonp5=botonf;
_0x20:
	BST  R3,4
	BLD  R2,5
; 0000 00E1 //-----------Se dejo de presionar el boton GO
; 0000 00E2 
; 0000 00E3 
; 0000 00E4 
; 0000 00E5 //Pregunta que boton se presiono GO o CLEAR por defecto no se presiona nada y guarda movimientos
; 0000 00E6 if(control==0) {//Por defecto se inicia un ciclo para guardar los movimientos
	MOV  R0,R4
	OR   R0,R5
	BREQ PC+2
	RJMP _0x23
; 0000 00E7 // Ejecutamos un while mientras que los movimientos no superan los 10 y los guardamos en el arreglo
; 0000 00E8 while(control2<1){
_0x24:
	RCALL SUBOPT_0x6
	CP   R6,R30
	CPC  R7,R31
	BRLT PC+2
	RJMP _0x26
; 0000 00E9 //Detecta si se presiono el boton ADELANTE
; 0000 00EA if (boton==0)
	SBIC 0x10,0
	RJMP _0x27
; 0000 00EB botona=0;
	CLT
	RJMP _0x5D
; 0000 00EC else
_0x27:
; 0000 00ED botona=1;
	SET
_0x5D:
	BLD  R2,7
; 0000 00EE 
; 0000 00EF if ((botonp==1)&&(botona==0)) { //hubo cambio de flanco de 1 a 0
	SBRS R2,0
	RJMP _0x2A
	SBRS R2,7
	RJMP _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
; 0000 00F0 //Guarda el movimiento
; 0000 00F1 movimientos[posicion] = 1;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x8
; 0000 00F2 posicion++;
; 0000 00F3 delay_ms(30);
; 0000 00F4 }
; 0000 00F5 
; 0000 00F6 if ((botonp==0)&&(botona==1)) //hubo cambio de flanco de 0 a 1
_0x29:
	SBRC R2,0
	RJMP _0x2D
	SBRC R2,7
	RJMP _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
; 0000 00F7 delay_ms(30);
	RCALL SUBOPT_0x5
; 0000 00F8 botonp=botona;
_0x2C:
	BST  R2,7
	BLD  R2,0
; 0000 00F9 //-----------Se dejo de presionar el boton ADELANTE
; 0000 00FA 
; 0000 00FB //Detecta si se presiono el boton ATRAS
; 0000 00FC if (boton1==0)
	SBIC 0x10,1
	RJMP _0x2F
; 0000 00FD botonb=0;
	CLT
	RJMP _0x5E
; 0000 00FE else
_0x2F:
; 0000 00FF botonb=1;
	SET
_0x5E:
	BLD  R3,0
; 0000 0100 
; 0000 0101 if ((botonp1==1)&&(botonb==0)) { //hubo cambio de flanco de 1 a 0
	SBRS R2,1
	RJMP _0x32
	SBRS R3,0
	RJMP _0x33
_0x32:
	RJMP _0x31
_0x33:
; 0000 0102 //Guarda el movimiento
; 0000 0103 movimientos[posicion] = 2;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x8
; 0000 0104 posicion++;
; 0000 0105 delay_ms(30);
; 0000 0106 }
; 0000 0107 
; 0000 0108 if ((botonp1==0)&&(botonb==1)) //hubo cambio de flanco de 0 a 1
_0x31:
	SBRC R2,1
	RJMP _0x35
	SBRC R3,0
	RJMP _0x36
_0x35:
	RJMP _0x34
_0x36:
; 0000 0109 delay_ms(30);
	RCALL SUBOPT_0x5
; 0000 010A botonp1=botonb;
_0x34:
	BST  R3,0
	BLD  R2,1
; 0000 010B //-----------Se dejo de presionar el boton ATRAS
; 0000 010C 
; 0000 010D //Detecta si se presiono el boton DERECHA
; 0000 010E if (boton2==0)
	SBIC 0x10,2
	RJMP _0x37
; 0000 010F botonc=0;
	CLT
	RJMP _0x5F
; 0000 0110 else
_0x37:
; 0000 0111 botonc=1;
	SET
_0x5F:
	BLD  R3,1
; 0000 0112 
; 0000 0113 if ((botonp2==1)&&(botonc==0)) { //hubo cambio de flanco de 1 a 0
	SBRS R2,2
	RJMP _0x3A
	SBRS R3,1
	RJMP _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
; 0000 0114 movimientos[posicion]=3;
	RCALL SUBOPT_0x7
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x8
; 0000 0115 posicion++;
; 0000 0116 delay_ms(30);
; 0000 0117 }
; 0000 0118 
; 0000 0119 if ((botonp2==0)&&(botonc==1)) //hubo cambio de flanco de 0 a 1
_0x39:
	SBRC R2,2
	RJMP _0x3D
	SBRC R3,1
	RJMP _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
; 0000 011A delay_ms(30);
	RCALL SUBOPT_0x5
; 0000 011B botonp2=botonc;
_0x3C:
	BST  R3,1
	BLD  R2,2
; 0000 011C 
; 0000 011D //-----------Se dejo de presionar el boton DERECHA
; 0000 011E 
; 0000 011F //Detecta si se presiono el boton IZQUIERDA
; 0000 0120 if (boton3==0)
	SBIC 0x10,3
	RJMP _0x3F
; 0000 0121 botond=0;
	CLT
	RJMP _0x60
; 0000 0122 else
_0x3F:
; 0000 0123 botond=1;
	SET
_0x60:
	BLD  R3,2
; 0000 0124 
; 0000 0125 if ((botonp3==1)&&(botond==0)) { //hubo cambio de flanco de 1 a 0
	SBRS R2,3
	RJMP _0x42
	SBRS R3,2
	RJMP _0x43
_0x42:
	RJMP _0x41
_0x43:
; 0000 0126 movimientos[posicion]=4;
	RCALL SUBOPT_0x7
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x8
; 0000 0127 posicion++;
; 0000 0128 delay_ms(30);
; 0000 0129 }
; 0000 012A 
; 0000 012B if ((botonp3==0)&&(botond==1)) //hubo cambio de flanco de 0 a 1
_0x41:
	SBRC R2,3
	RJMP _0x45
	SBRC R3,2
	RJMP _0x46
_0x45:
	RJMP _0x44
_0x46:
; 0000 012C delay_ms(30);
	RCALL SUBOPT_0x5
; 0000 012D botonp3=botond;
_0x44:
	BST  R3,2
	BLD  R2,3
; 0000 012E 
; 0000 012F //-----------Se dejo de presionar el boton IZQUIERDA
; 0000 0130 
; 0000 0131 //Preguntamos si ya se guardaron los 10 movimientos
; 0000 0132 if(posicion == 9){
	RCALL SUBOPT_0x9
	SBIW R26,9
	BRNE _0x47
; 0000 0133 control2=1;
	RCALL SUBOPT_0x6
	MOVW R6,R30
; 0000 0134 //control = 2;
; 0000 0135 //posicion=10;
; 0000 0136 }
; 0000 0137 
; 0000 0138 
; 0000 0139 //Detecta si se presiono el boton GO
; 0000 013A if (boton4==0)
_0x47:
	SBIC 0x10,4
	RJMP _0x48
; 0000 013B botone=0;
	CLT
	RJMP _0x61
; 0000 013C else
_0x48:
; 0000 013D botone=1;
	SET
_0x61:
	BLD  R3,3
; 0000 013E 
; 0000 013F if ((botonp4==1)&&(botone==0)) { //hubo cambio de flanco de 1 a 0
	SBRS R2,4
	RJMP _0x4B
	SBRS R3,3
	RJMP _0x4C
_0x4B:
	RJMP _0x4A
_0x4C:
; 0000 0140 if(posicion > 9){
	RCALL SUBOPT_0x9
	SBIW R26,10
	BRLT _0x4D
; 0000 0141 posicion=9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _posicion,R30
	STS  _posicion+1,R31
; 0000 0142 }
; 0000 0143 
; 0000 0144 control2=1;
_0x4D:
	RCALL SUBOPT_0x6
	MOVW R6,R30
; 0000 0145 control = 2;
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 0146 
; 0000 0147 delay_ms(30);
; 0000 0148 }
; 0000 0149 
; 0000 014A if ((botonp4==0)&&(botone==1)) //hubo cambio de flanco de 0 a 1
_0x4A:
	SBRC R2,4
	RJMP _0x4F
	SBRC R3,3
	RJMP _0x50
_0x4F:
	RJMP _0x4E
_0x50:
; 0000 014B delay_ms(30);
	RCALL SUBOPT_0x5
; 0000 014C botonp4=botone;
_0x4E:
	BST  R3,3
	BLD  R2,4
; 0000 014D //control2 = 1;
; 0000 014E }
	RJMP _0x24
_0x26:
; 0000 014F control2=0;
	CLR  R6
	CLR  R7
; 0000 0150 
; 0000 0151 } else if(control==1){ //Se presiono el boton CLEAR por lo tanto limpia
	RJMP _0x51
_0x23:
	RCALL SUBOPT_0x6
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x52
; 0000 0152 while(control3<10){
_0x53:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R8,R30
	CPC  R9,R31
	BRGE _0x55
; 0000 0153 movimientos[control3]=0;
	MOVW R30,R8
	LDI  R26,LOW(_movimientos)
	LDI  R27,HIGH(_movimientos)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
; 0000 0154 control3++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0155 }
	RJMP _0x53
_0x55:
; 0000 0156 control3=0;
	CLR  R8
	CLR  R9
; 0000 0157 posicion=0;
	LDI  R30,LOW(0)
	STS  _posicion,R30
	STS  _posicion+1,R30
; 0000 0158 control=0;
	CLR  R4
	CLR  R5
; 0000 0159 } else if(control==2){ //Se presiono el boton GO
	RJMP _0x56
_0x52:
	RCALL SUBOPT_0x3
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x57
; 0000 015A mover(movimientos, posicion);//Se llama a la funcion para mostrar los movimientos junto con la cantidad de movimientos
	LDI  R30,LOW(_movimientos)
	LDI  R31,HIGH(_movimientos)
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x9
	RCALL _mover
; 0000 015B control = 3;// Se mantiene en espera
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R4,R30
; 0000 015C //posicion=10;
; 0000 015D }
; 0000 015E 
; 0000 015F }
_0x57:
_0x56:
_0x51:
	RJMP _0x10
; 0000 0160 }
_0x58:
	RJMP _0x58
; .FEND

	.DSEG
_posicion:
	.BYTE 0x2
_movimientos:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x0:
	MOVW R30,R10
	MOVW R26,R18
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	OUT  0x1B,R30
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	MOVW R4,R30
	LDI  R26,LOW(30)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(30)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x7:
	LDS  R30,_posicion
	LDS  R31,_posicion+1
	LDI  R26,LOW(_movimientos)
	LDI  R27,HIGH(_movimientos)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x8:
	ST   X+,R30
	ST   X,R31
	LDI  R26,LOW(_posicion)
	LDI  R27,HIGH(_posicion)
	RCALL SUBOPT_0x1
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDS  R26,_posicion
	LDS  R27,_posicion+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
