
;CodeVisionAVR C Compiler V3.51 Evaluation
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
	.DEF _puntuacionj1=R4
	.DEF _puntuacionj1_msb=R5
	.DEF _puntuacionj2=R6
	.DEF _puntuacionj2_msb=R7
	.DEF _a1=R8
	.DEF _a1_msb=R9
	.DEF _b1=R10
	.DEF _b1_msb=R11
	.DEF _c1=R12
	.DEF _c1_msb=R13

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

_tabla7segmentos:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7C,0x7
	.DB  0x7F,0x6F

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x1,0x0,0x1,0x1,0x1,0x1,0x1

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x07
	.DW  _filas
	.DW  _0x3*2

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

	.DSEG
;void muevej1der();
;void muevej1izq();
;void muevej2der();
;void muevej2izq();
;void muevepunto();
;void main(void)
; 0000 0053 {

	.CSEG
_main:
; .FSTART _main
; 0000 0054 // Declare your local variables here
; 0000 0055 
; 0000 0056 // Input/Output Ports initialization
; 0000 0057 // Port A initialization
; 0000 0058 // Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0059 DDRA=(0<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(127)
	OUT  0x1A,R30
; 0000 005A // State: Bit7=T Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 005B PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 005C 
; 0000 005D // Port B initialization
; 0000 005E // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 005F DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 0060 // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 0061 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(15)
	OUT  0x18,R30
; 0000 0062 
; 0000 0063 // Port C initialization
; 0000 0064 // Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 0065 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(31)
	OUT  0x14,R30
; 0000 0066 // State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0067 PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0068 
; 0000 0069 // Port D initialization
; 0000 006A // Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 006B DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
	LDI  R30,LOW(127)
	OUT  0x11,R30
; 0000 006C // State: Bit7=T Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 006D PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 006E 
; 0000 006F // Timer/Counter 0 initialization
; 0000 0070 // Clock source: System Clock
; 0000 0071 // Clock value: Timer 0 Stopped
; 0000 0072 // Mode: Normal top=0xFF
; 0000 0073 // OC0 output: Disconnected
; 0000 0074 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0075 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0076 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0077 
; 0000 0078 // Timer/Counter 1 initialization
; 0000 0079 // Clock source: System Clock
; 0000 007A // Clock value: Timer1 Stopped
; 0000 007B // Mode: Normal top=0xFFFF
; 0000 007C // OC1A output: Disconnected
; 0000 007D // OC1B output: Disconnected
; 0000 007E // Noise Canceler: Off
; 0000 007F // Input Capture on Falling Edge
; 0000 0080 // Timer1 Overflow Interrupt: Off
; 0000 0081 // Input Capture Interrupt: Off
; 0000 0082 // Compare A Match Interrupt: Off
; 0000 0083 // Compare B Match Interrupt: Off
; 0000 0084 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0085 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0086 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0087 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0088 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0089 ICR1L=0x00;
	OUT  0x26,R30
; 0000 008A OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 008B OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 008C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 008D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 008E 
; 0000 008F // Timer/Counter 2 initialization
; 0000 0090 // Clock source: System Clock
; 0000 0091 // Clock value: Timer2 Stopped
; 0000 0092 // Mode: Normal top=0xFF
; 0000 0093 // OC2 output: Disconnected
; 0000 0094 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0095 TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0096 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0097 OCR2=0x00;
	OUT  0x23,R30
; 0000 0098 
; 0000 0099 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 009A TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 009B 
; 0000 009C // External Interrupt(s) initialization
; 0000 009D // INT0: Off
; 0000 009E // INT1: Off
; 0000 009F // INT2: Off
; 0000 00A0 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00A1 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00A2 
; 0000 00A3 // USART initialization
; 0000 00A4 // USART disabled
; 0000 00A5 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00A6 
; 0000 00A7 // Analog Comparator initialization
; 0000 00A8 // Analog Comparator: Off
; 0000 00A9 // The Analog Comparator's positive input is
; 0000 00AA // connected to the AIN0 pin
; 0000 00AB // The Analog Comparator's negative input is
; 0000 00AC // connected to the AIN1 pin
; 0000 00AD ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00AE SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00AF 
; 0000 00B0 // ADC initialization
; 0000 00B1 // ADC disabled
; 0000 00B2 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00B3 
; 0000 00B4 // SPI initialization
; 0000 00B5 // SPI disabled
; 0000 00B6 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00B7 
; 0000 00B8 // TWI initialization
; 0000 00B9 // TWI disabled
; 0000 00BA TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00BB 
; 0000 00BC //Inicialization vars
; 0000 00BD puntuacionj1 = 0;
	CLR  R4
	CLR  R5
; 0000 00BE puntuacionj2 = 0;
	CLR  R6
	CLR  R7
; 0000 00BF 
; 0000 00C0 //La raqueta del J1 inicia a la izquierda
; 0000 00C1 a1 = 0;
	RCALL SUBOPT_0x0
; 0000 00C2 b1 = 0;
; 0000 00C3 c1 = 1;
; 0000 00C4 d1 = 1;
; 0000 00C5 e1 = 1;
; 0000 00C6 
; 0000 00C7 //La raqueta del J2 inicia a la izquierda
; 0000 00C8 a2 = 0;
	RCALL SUBOPT_0x1
; 0000 00C9 b2 = 0;
; 0000 00CA c2 = 1;
; 0000 00CB d2 = 1;
; 0000 00CC e2 = 1;
; 0000 00CD 
; 0000 00CE xj1 = 1; //Solo se movera de 1 a 3
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 00CF xj2 = 1;
	RCALL SUBOPT_0x4
; 0000 00D0 
; 0000 00D1 j = 2; //Columna de inicio para la pelota
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x5
; 0000 00D2 i = 0; //fila de inicio
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
; 0000 00D3 
; 0000 00D4 x = 0;
	STS  _x,R30
	STS  _x+1,R30
; 0000 00D5 
; 0000 00D6 iterador = 0;
	RCALL SUBOPT_0x6
; 0000 00D7 factori = 1;
	RCALL SUBOPT_0x7
; 0000 00D8 factorj = 1;
	RCALL SUBOPT_0x8
; 0000 00D9 
; 0000 00DA 
; 0000 00DB while (1)
_0x4:
; 0000 00DC {
; 0000 00DD // Place your code here
; 0000 00DE muevepunto();//mueve el punto que representa la pelota
	RCALL _muevepunto
; 0000 00DF for(iterador = 0; iterador <= 200; iterador++){
	RCALL SUBOPT_0x6
_0x8:
	LDS  R26,_iterador
	LDS  R27,_iterador+1
	CPI  R26,LOW(0xC9)
	LDI  R30,HIGH(0xC9)
	CPC  R27,R30
	BRGE _0x9
; 0000 00E0 //Funciones para mover las barras
; 0000 00E1 muevej1der();
	RCALL _muevej1der
; 0000 00E2 muevej1izq();
	RCALL _muevej1izq
; 0000 00E3 muevej2der();
	RCALL _muevej2der
; 0000 00E4 muevej2izq();
	RCALL _muevej2izq
; 0000 00E5 }
	LDI  R26,LOW(_iterador)
	LDI  R27,HIGH(_iterador)
	RCALL SUBOPT_0x9
	RJMP _0x8
_0x9:
; 0000 00E6 
; 0000 00E7 //Se activan los displays de cada jugador
; 0000 00E8 activadorm1 = 0;
	CBI  0x18,4
; 0000 00E9 activadorm2 = 1;
	SBI  0x18,5
; 0000 00EA PORTA = tabla7segmentos[puntuacionj1];
	MOVW R30,R4
	RCALL SUBOPT_0xA
; 0000 00EB delay_ms(20);
	LDI  R26,LOW(20)
	RCALL SUBOPT_0xB
; 0000 00EC activadorm1 = 1;
	SBI  0x18,4
; 0000 00ED activadorm2 = 0;
	CBI  0x18,5
; 0000 00EE delay_ms(20);
	LDI  R26,LOW(20)
	RCALL SUBOPT_0xB
; 0000 00EF PORTA = tabla7segmentos[puntuacionj2];
	MOVW R30,R6
	RCALL SUBOPT_0xA
; 0000 00F0 
; 0000 00F1 delay_ms(100);
	RCALL SUBOPT_0xC
; 0000 00F2 
; 0000 00F3 //Envia datos
; 0000 00F4 PORTC = 0x01;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xD
; 0000 00F5 PORTD = 0xFF;
; 0000 00F6 
; 0000 00F7 if(j == 1){
	SBIW R26,1
	BRNE _0x12
; 0000 00F8 row2 = filas[1];
	RCALL SUBOPT_0xE
	BRNE _0x13
	CBI  0x12,1
	RJMP _0x14
_0x13:
	SBI  0x12,1
_0x14:
; 0000 00F9 row3 = filas[2];
	RCALL SUBOPT_0xF
	BRNE _0x15
	CBI  0x12,2
	RJMP _0x16
_0x15:
	SBI  0x12,2
_0x16:
; 0000 00FA row4 = filas[3];
	RCALL SUBOPT_0x10
	BRNE _0x17
	CBI  0x12,3
	RJMP _0x18
_0x17:
	SBI  0x12,3
_0x18:
; 0000 00FB row5 = filas[4];
	RCALL SUBOPT_0x11
	BRNE _0x19
	CBI  0x12,4
	RJMP _0x1A
_0x19:
	SBI  0x12,4
_0x1A:
; 0000 00FC row6 = filas[5];
	RCALL SUBOPT_0x12
	BRNE _0x1B
	CBI  0x12,5
	RJMP _0x1C
_0x1B:
	SBI  0x12,5
_0x1C:
; 0000 00FD delay_ms(200);
	RCALL SUBOPT_0x13
; 0000 00FE }
; 0000 00FF 
; 0000 0100 row1 = a1;
_0x12:
	MOV  R30,R8
	CPI  R30,0
	BRNE _0x1D
	CBI  0x12,0
	RJMP _0x1E
_0x1D:
	SBI  0x12,0
_0x1E:
; 0000 0101 row7 = a2;
	LDS  R30,_a2
	CPI  R30,0
	BRNE _0x1F
	CBI  0x12,6
	RJMP _0x20
_0x1F:
	SBI  0x12,6
_0x20:
; 0000 0102 delay_ms(100);
	RCALL SUBOPT_0xC
; 0000 0103 PORTC = 0x02;
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xD
; 0000 0104 PORTD = 0xFF;
; 0000 0105 
; 0000 0106 if(j == 2){
	SBIW R26,2
	BRNE _0x21
; 0000 0107 row2 = filas[1];
	RCALL SUBOPT_0xE
	BRNE _0x22
	CBI  0x12,1
	RJMP _0x23
_0x22:
	SBI  0x12,1
_0x23:
; 0000 0108 row3 = filas[2];
	RCALL SUBOPT_0xF
	BRNE _0x24
	CBI  0x12,2
	RJMP _0x25
_0x24:
	SBI  0x12,2
_0x25:
; 0000 0109 row4 = filas[3];
	RCALL SUBOPT_0x10
	BRNE _0x26
	CBI  0x12,3
	RJMP _0x27
_0x26:
	SBI  0x12,3
_0x27:
; 0000 010A row5 = filas[4];
	RCALL SUBOPT_0x11
	BRNE _0x28
	CBI  0x12,4
	RJMP _0x29
_0x28:
	SBI  0x12,4
_0x29:
; 0000 010B row6 = filas[5];
	RCALL SUBOPT_0x12
	BRNE _0x2A
	CBI  0x12,5
	RJMP _0x2B
_0x2A:
	SBI  0x12,5
_0x2B:
; 0000 010C delay_ms(200);
	RCALL SUBOPT_0x13
; 0000 010D }
; 0000 010E 
; 0000 010F row1 = b1;
_0x21:
	MOV  R30,R10
	CPI  R30,0
	BRNE _0x2C
	CBI  0x12,0
	RJMP _0x2D
_0x2C:
	SBI  0x12,0
_0x2D:
; 0000 0110 row7 = b2;
	LDS  R30,_b2
	CPI  R30,0
	BRNE _0x2E
	CBI  0x12,6
	RJMP _0x2F
_0x2E:
	SBI  0x12,6
_0x2F:
; 0000 0111 delay_ms(100);
	RCALL SUBOPT_0xC
; 0000 0112 PORTC = 0x04;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xD
; 0000 0113 PORTD = 0xFF;
; 0000 0114 
; 0000 0115 if(j == 3){
	SBIW R26,3
	BRNE _0x30
; 0000 0116 row2 = filas[1];
	RCALL SUBOPT_0xE
	BRNE _0x31
	CBI  0x12,1
	RJMP _0x32
_0x31:
	SBI  0x12,1
_0x32:
; 0000 0117 row3 = filas[2];
	RCALL SUBOPT_0xF
	BRNE _0x33
	CBI  0x12,2
	RJMP _0x34
_0x33:
	SBI  0x12,2
_0x34:
; 0000 0118 row4 = filas[3];
	RCALL SUBOPT_0x10
	BRNE _0x35
	CBI  0x12,3
	RJMP _0x36
_0x35:
	SBI  0x12,3
_0x36:
; 0000 0119 row5 = filas[4];
	RCALL SUBOPT_0x11
	BRNE _0x37
	CBI  0x12,4
	RJMP _0x38
_0x37:
	SBI  0x12,4
_0x38:
; 0000 011A row6 = filas[5];
	RCALL SUBOPT_0x12
	BRNE _0x39
	CBI  0x12,5
	RJMP _0x3A
_0x39:
	SBI  0x12,5
_0x3A:
; 0000 011B delay_ms(200);
	RCALL SUBOPT_0x13
; 0000 011C }
; 0000 011D 
; 0000 011E row1 = c1;
_0x30:
	MOV  R30,R12
	CPI  R30,0
	BRNE _0x3B
	CBI  0x12,0
	RJMP _0x3C
_0x3B:
	SBI  0x12,0
_0x3C:
; 0000 011F row7 = c2;
	LDS  R30,_c2
	CPI  R30,0
	BRNE _0x3D
	CBI  0x12,6
	RJMP _0x3E
_0x3D:
	SBI  0x12,6
_0x3E:
; 0000 0120 delay_ms(100);
	RCALL SUBOPT_0xC
; 0000 0121 PORTC = 0x08;
	LDI  R30,LOW(8)
	RCALL SUBOPT_0xD
; 0000 0122 PORTD = 0xFF;
; 0000 0123 
; 0000 0124 if(j == 4){
	SBIW R26,4
	BRNE _0x3F
; 0000 0125 row2 = filas[1];
	RCALL SUBOPT_0xE
	BRNE _0x40
	CBI  0x12,1
	RJMP _0x41
_0x40:
	SBI  0x12,1
_0x41:
; 0000 0126 row3 = filas[2];
	RCALL SUBOPT_0xF
	BRNE _0x42
	CBI  0x12,2
	RJMP _0x43
_0x42:
	SBI  0x12,2
_0x43:
; 0000 0127 row4 = filas[3];
	RCALL SUBOPT_0x10
	BRNE _0x44
	CBI  0x12,3
	RJMP _0x45
_0x44:
	SBI  0x12,3
_0x45:
; 0000 0128 row5 = filas[4];
	RCALL SUBOPT_0x11
	BRNE _0x46
	CBI  0x12,4
	RJMP _0x47
_0x46:
	SBI  0x12,4
_0x47:
; 0000 0129 row6 = filas[5];
	RCALL SUBOPT_0x12
	BRNE _0x48
	CBI  0x12,5
	RJMP _0x49
_0x48:
	SBI  0x12,5
_0x49:
; 0000 012A delay_ms(200);
	RCALL SUBOPT_0x13
; 0000 012B }
; 0000 012C 
; 0000 012D row1 = d1;
_0x3F:
	LDS  R30,_d1
	CPI  R30,0
	BRNE _0x4A
	CBI  0x12,0
	RJMP _0x4B
_0x4A:
	SBI  0x12,0
_0x4B:
; 0000 012E row7 = d2;
	LDS  R30,_d2
	CPI  R30,0
	BRNE _0x4C
	CBI  0x12,6
	RJMP _0x4D
_0x4C:
	SBI  0x12,6
_0x4D:
; 0000 012F delay_ms(100);
	RCALL SUBOPT_0xC
; 0000 0130 PORTC = 0x10;
	LDI  R30,LOW(16)
	RCALL SUBOPT_0xD
; 0000 0131 PORTD = 0xFF;
; 0000 0132 
; 0000 0133 if(j == 5){
	SBIW R26,5
	BRNE _0x4E
; 0000 0134 row2 = filas[1];
	RCALL SUBOPT_0xE
	BRNE _0x4F
	CBI  0x12,1
	RJMP _0x50
_0x4F:
	SBI  0x12,1
_0x50:
; 0000 0135 row3 = filas[2];
	RCALL SUBOPT_0xF
	BRNE _0x51
	CBI  0x12,2
	RJMP _0x52
_0x51:
	SBI  0x12,2
_0x52:
; 0000 0136 row4 = filas[3];
	RCALL SUBOPT_0x10
	BRNE _0x53
	CBI  0x12,3
	RJMP _0x54
_0x53:
	SBI  0x12,3
_0x54:
; 0000 0137 row5 = filas[4];
	RCALL SUBOPT_0x11
	BRNE _0x55
	CBI  0x12,4
	RJMP _0x56
_0x55:
	SBI  0x12,4
_0x56:
; 0000 0138 row6 = filas[5];
	RCALL SUBOPT_0x12
	BRNE _0x57
	CBI  0x12,5
	RJMP _0x58
_0x57:
	SBI  0x12,5
_0x58:
; 0000 0139 delay_ms(200);
	RCALL SUBOPT_0x13
; 0000 013A }
; 0000 013B 
; 0000 013C row1 = e1;
_0x4E:
	LDS  R30,_e1
	CPI  R30,0
	BRNE _0x59
	CBI  0x12,0
	RJMP _0x5A
_0x59:
	SBI  0x12,0
_0x5A:
; 0000 013D row7 = e2;
	LDS  R30,_e2
	CPI  R30,0
	BRNE _0x5B
	CBI  0x12,6
	RJMP _0x5C
_0x5B:
	SBI  0x12,6
_0x5C:
; 0000 013E 
; 0000 013F delay_ms(100);
	RCALL SUBOPT_0xC
; 0000 0140 
; 0000 0141 }
	RJMP _0x4
; 0000 0142 }
_0x5D:
	RJMP _0x5D
; .FEND
;void muevepunto(){
; 0000 0145 void muevepunto(){
_muevepunto:
; .FSTART _muevepunto
; 0000 0146 ai = i;
	RCALL SUBOPT_0x14
	STS  _ai,R30
	STS  _ai+1,R31
; 0000 0147 aj = j;
	LDS  R30,_j
	LDS  R31,_j+1
	RCALL SUBOPT_0x15
; 0000 0148 
; 0000 0149 i = i + factori;
	LDS  R30,_factori
	LDS  R31,_factori+1
	RCALL SUBOPT_0x16
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x17
; 0000 014A j = j + factorj;
	LDS  R30,_factorj
	LDS  R31,_factorj+1
	RCALL SUBOPT_0x18
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x5
; 0000 014B 
; 0000 014C //Rebotes solucion
; 0000 014D if(i == 6){
	RCALL SUBOPT_0x16
	SBIW R26,6
	BRNE _0x5E
; 0000 014E if((j==1&&a2==0)||(j==2&&b2==0)||(j==3&&c2==0)||(j==4&&d2==0)||(j==5&&e2==0)){
	RCALL SUBOPT_0x18
	SBIW R26,1
	BRNE _0x60
	LDS  R26,_a2
	LDS  R27,_a2+1
	SBIW R26,0
	BREQ _0x62
_0x60:
	RCALL SUBOPT_0x18
	SBIW R26,2
	BRNE _0x63
	LDS  R26,_b2
	LDS  R27,_b2+1
	SBIW R26,0
	BREQ _0x62
_0x63:
	RCALL SUBOPT_0x18
	SBIW R26,3
	BRNE _0x65
	LDS  R26,_c2
	LDS  R27,_c2+1
	SBIW R26,0
	BREQ _0x62
_0x65:
	RCALL SUBOPT_0x18
	SBIW R26,4
	BRNE _0x67
	LDS  R26,_d2
	LDS  R27,_d2+1
	SBIW R26,0
	BREQ _0x62
_0x67:
	RCALL SUBOPT_0x18
	SBIW R26,5
	BRNE _0x69
	LDS  R26,_e2
	LDS  R27,_e2+1
	SBIW R26,0
	BREQ _0x62
_0x69:
	RJMP _0x5F
_0x62:
; 0000 014F factori = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _factori,R30
	STS  _factori+1,R31
; 0000 0150 } else {
	RJMP _0x6C
_0x5F:
; 0000 0151 puntuacionj1++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0152 i = 1;
	RCALL SUBOPT_0x19
; 0000 0153 j = 3;
; 0000 0154 }
_0x6C:
; 0000 0155 }
; 0000 0156 
; 0000 0157 //rebote izq a der
; 0000 0158 if(j == 5){
_0x5E:
	RCALL SUBOPT_0x18
	SBIW R26,5
	BRNE _0x6D
; 0000 0159 j = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x5
; 0000 015A aj = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RCALL SUBOPT_0x15
; 0000 015B factorj = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _factorj,R30
	STS  _factorj+1,R31
; 0000 015C }
; 0000 015D 
; 0000 015E //rebote der a izq
; 0000 015F if(j == 1){
_0x6D:
	RCALL SUBOPT_0x18
	SBIW R26,1
	BRNE _0x6E
; 0000 0160 j = 1;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
; 0000 0161 aj = 1;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x15
; 0000 0162 factorj = 1;
	RCALL SUBOPT_0x8
; 0000 0163 }
; 0000 0164 
; 0000 0165 if(i == 0){
_0x6E:
	RCALL SUBOPT_0x14
	SBIW R30,0
	BRNE _0x6F
; 0000 0166 if((j==1&&a1==0)||(j==2&&b1==0)||(j==3&&c1==0)||(j==4&&d1==0)||(j==5&&e1==0)){
	RCALL SUBOPT_0x18
	SBIW R26,1
	BRNE _0x71
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BREQ _0x73
_0x71:
	RCALL SUBOPT_0x18
	SBIW R26,2
	BRNE _0x74
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BREQ _0x73
_0x74:
	RCALL SUBOPT_0x18
	SBIW R26,3
	BRNE _0x76
	CLR  R0
	CP   R0,R12
	CPC  R0,R13
	BREQ _0x73
_0x76:
	RCALL SUBOPT_0x18
	SBIW R26,4
	BRNE _0x78
	LDS  R26,_d1
	LDS  R27,_d1+1
	SBIW R26,0
	BREQ _0x73
_0x78:
	RCALL SUBOPT_0x18
	SBIW R26,5
	BRNE _0x7A
	LDS  R26,_e1
	LDS  R27,_e1+1
	SBIW R26,0
	BREQ _0x73
_0x7A:
	RJMP _0x70
_0x73:
; 0000 0167 factori = 1;
	RCALL SUBOPT_0x7
; 0000 0168 } else {
	RJMP _0x7D
_0x70:
; 0000 0169 puntuacionj2++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	SBIW R30,1
; 0000 016A i = 1;
	RCALL SUBOPT_0x19
; 0000 016B j = 3;
; 0000 016C }
_0x7D:
; 0000 016D }
; 0000 016E filas[i] = 0;
_0x6F:
	RCALL SUBOPT_0x14
	SUBI R30,LOW(-_filas)
	SBCI R31,HIGH(-_filas)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 016F filas[ai] = 1;
	LDS  R30,_ai
	LDS  R31,_ai+1
	SUBI R30,LOW(-_filas)
	SBCI R31,HIGH(-_filas)
	LDI  R26,LOW(1)
	STD  Z+0,R26
; 0000 0170 }
	RET
; .FEND
;void muevej1der(){
; 0000 0172 void muevej1der(){
_muevej1der:
; .FSTART _muevej1der
; 0000 0173 if(derj1 == 0){
	SBIC 0x16,1
	RJMP _0x7E
; 0000 0174 botonadj1 = 0;
	CLT
	RJMP _0xB2
; 0000 0175 } else {
_0x7E:
; 0000 0176 botonadj1 = 1;
	SET
_0xB2:
	BLD  R2,1
; 0000 0177 }
; 0000 0178 
; 0000 0179 if((botonpdj1 == 1)&& (botonadj1 == 0)){//Cambio de flanco de 1 a 0
	SBRS R2,0
	RJMP _0x81
	SBRS R2,1
	RJMP _0x82
_0x81:
	RJMP _0x80
_0x82:
; 0000 017A xj1++;
	LDI  R26,LOW(_xj1)
	LDI  R27,HIGH(_xj1)
	RCALL SUBOPT_0x9
; 0000 017B if(xj1 > 4){
	RCALL SUBOPT_0x1A
	SBIW R26,5
	BRLT _0x83
; 0000 017C xj1 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x3
; 0000 017D }
; 0000 017E if(xj1 == 1){
_0x83:
	RCALL SUBOPT_0x1A
	SBIW R26,1
	BRNE _0x84
; 0000 017F a1 = 0;
	RCALL SUBOPT_0x0
; 0000 0180 b1 = 0;
; 0000 0181 c1 = 1;
; 0000 0182 d1 = 1;
; 0000 0183 e1 = 1;
; 0000 0184 }
; 0000 0185 if(xj1 == 2){
_0x84:
	RCALL SUBOPT_0x1A
	SBIW R26,2
	BRNE _0x85
; 0000 0186 a1 = 1;
	RCALL SUBOPT_0x1B
; 0000 0187 b1 = 0;
	RCALL SUBOPT_0x1C
; 0000 0188 c1 = 0;
; 0000 0189 d1 = 1;
; 0000 018A e1 = 1;
; 0000 018B }
; 0000 018C if(xj1 == 3){
_0x85:
	RCALL SUBOPT_0x1A
	SBIW R26,3
	BRNE _0x86
; 0000 018D a1 = 1;
	RCALL SUBOPT_0x1B
; 0000 018E b1 = 1;
	RCALL SUBOPT_0x1D
; 0000 018F c1 = 0;
	RCALL SUBOPT_0x1E
; 0000 0190 d1 = 0;
; 0000 0191 e1 = 1;
; 0000 0192 }
; 0000 0193 if(xj1 == 4){
_0x86:
	RCALL SUBOPT_0x1A
	SBIW R26,4
	BRNE _0x87
; 0000 0194 a1 = 1;
	RCALL SUBOPT_0x1B
; 0000 0195 b1 = 1;
	RCALL SUBOPT_0x1D
; 0000 0196 c1 = 1;
	RCALL SUBOPT_0x1F
; 0000 0197 d1 = 0;
; 0000 0198 e1 = 0;
; 0000 0199 }
; 0000 019A delay_ms(40);
_0x87:
	RCALL SUBOPT_0x20
; 0000 019B }
; 0000 019C 
; 0000 019D if((botonpdj1 == 0) &&(botonadj1 == 1)){
_0x80:
	SBRC R2,0
	RJMP _0x89
	SBRC R2,1
	RJMP _0x8A
_0x89:
	RJMP _0x88
_0x8A:
; 0000 019E delay_ms(40);
	RCALL SUBOPT_0x20
; 0000 019F botonpdj1 = botonadj1;
	BST  R2,1
	BLD  R2,0
; 0000 01A0 }
; 0000 01A1 }
_0x88:
	RET
; .FEND
;void muevej1izq(){
; 0000 01A3 void muevej1izq(){
_muevej1izq:
; .FSTART _muevej1izq
; 0000 01A4 if(izqj1 == 0){
	SBIC 0x16,0
	RJMP _0x8B
; 0000 01A5 botonaij1 = 0;
	CLT
	RJMP _0xB3
; 0000 01A6 } else {
_0x8B:
; 0000 01A7 botonaij1 = 1;
	SET
_0xB3:
	BLD  R2,5
; 0000 01A8 }
; 0000 01A9 
; 0000 01AA if((botonpij1 == 1)&& (botonaij1 == 0)){//Cambio de flanco de 1 a 0
	SBRS R2,4
	RJMP _0x8E
	SBRS R2,5
	RJMP _0x8F
_0x8E:
	RJMP _0x8D
_0x8F:
; 0000 01AB xj1--;
	LDI  R26,LOW(_xj1)
	LDI  R27,HIGH(_xj1)
	RCALL SUBOPT_0x21
; 0000 01AC if(xj1 < 1){
	RCALL SUBOPT_0x1A
	SBIW R26,1
	BRGE _0x90
; 0000 01AD xj1 = 1;
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
; 0000 01AE }
; 0000 01AF if(xj1 == 1){
_0x90:
	RCALL SUBOPT_0x1A
	SBIW R26,1
	BRNE _0x91
; 0000 01B0 a1 = 0;
	RCALL SUBOPT_0x0
; 0000 01B1 b1 = 0;
; 0000 01B2 c1 = 1;
; 0000 01B3 d1 = 1;
; 0000 01B4 e1 = 1;
; 0000 01B5 }
; 0000 01B6 if(xj1 == 2){
_0x91:
	RCALL SUBOPT_0x1A
	SBIW R26,2
	BRNE _0x92
; 0000 01B7 a1 = 1;
	RCALL SUBOPT_0x1B
; 0000 01B8 b1 = 0;
	RCALL SUBOPT_0x1C
; 0000 01B9 c1 = 0;
; 0000 01BA d1 = 1;
; 0000 01BB e1 = 1;
; 0000 01BC }
; 0000 01BD if(xj1 == 3){
_0x92:
	RCALL SUBOPT_0x1A
	SBIW R26,3
	BRNE _0x93
; 0000 01BE a1 = 1;
	RCALL SUBOPT_0x1B
; 0000 01BF b1 = 1;
	RCALL SUBOPT_0x1D
; 0000 01C0 c1 = 0;
	RCALL SUBOPT_0x1E
; 0000 01C1 d1 = 0;
; 0000 01C2 e1 = 1;
; 0000 01C3 }
; 0000 01C4 if(xj1 == 4){
_0x93:
	RCALL SUBOPT_0x1A
	SBIW R26,4
	BRNE _0x94
; 0000 01C5 a1 = 1;
	RCALL SUBOPT_0x1B
; 0000 01C6 b1 = 1;
	RCALL SUBOPT_0x1D
; 0000 01C7 c1 = 1;
	RCALL SUBOPT_0x1F
; 0000 01C8 d1 = 0;
; 0000 01C9 e1 = 0;
; 0000 01CA }
; 0000 01CB delay_ms(40);
_0x94:
	RCALL SUBOPT_0x20
; 0000 01CC }
; 0000 01CD 
; 0000 01CE if((botonpij1 == 0) &&(botonaij1 == 1)){
_0x8D:
	SBRC R2,4
	RJMP _0x96
	SBRC R2,5
	RJMP _0x97
_0x96:
	RJMP _0x95
_0x97:
; 0000 01CF delay_ms(40);
	RCALL SUBOPT_0x20
; 0000 01D0 botonpij1 = botonaij1;
	BST  R2,5
	BLD  R2,4
; 0000 01D1 }
; 0000 01D2 }
_0x95:
	RET
; .FEND
;void muevej2der(){
; 0000 01D5 void muevej2der(){
_muevej2der:
; .FSTART _muevej2der
; 0000 01D6 if(derj2 == 0){
	SBIC 0x16,3
	RJMP _0x98
; 0000 01D7 botonadj2 = 0;
	CLT
	RJMP _0xB4
; 0000 01D8 } else {
_0x98:
; 0000 01D9 botonadj2 = 1;
	SET
_0xB4:
	BLD  R2,3
; 0000 01DA }
; 0000 01DB 
; 0000 01DC if((botonpdj2 == 1)&& (botonadj2 == 0)){//Cambio de flanco de 1 a 0
	SBRS R2,2
	RJMP _0x9B
	SBRS R2,3
	RJMP _0x9C
_0x9B:
	RJMP _0x9A
_0x9C:
; 0000 01DD xj2++;
	LDI  R26,LOW(_xj2)
	LDI  R27,HIGH(_xj2)
	RCALL SUBOPT_0x9
; 0000 01DE if(xj2 > 4){
	RCALL SUBOPT_0x22
	SBIW R26,5
	BRLT _0x9D
; 0000 01DF xj2 = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STS  _xj2,R30
	STS  _xj2+1,R31
; 0000 01E0 }
; 0000 01E1 if(xj2 == 1){
_0x9D:
	RCALL SUBOPT_0x22
	SBIW R26,1
	BRNE _0x9E
; 0000 01E2 a2 = 0;
	RCALL SUBOPT_0x1
; 0000 01E3 b2 = 0;
; 0000 01E4 c2 = 1;
; 0000 01E5 d2 = 1;
; 0000 01E6 e2 = 1;
; 0000 01E7 }
; 0000 01E8 if(xj2 == 2){
_0x9E:
	RCALL SUBOPT_0x22
	SBIW R26,2
	BRNE _0x9F
; 0000 01E9 a2 = 1;
	RCALL SUBOPT_0x23
; 0000 01EA b2 = 0;
	RCALL SUBOPT_0x24
; 0000 01EB c2 = 0;
; 0000 01EC d2 = 1;
; 0000 01ED e2 = 1;
; 0000 01EE }
; 0000 01EF if(xj2 == 3){
_0x9F:
	RCALL SUBOPT_0x22
	SBIW R26,3
	BRNE _0xA0
; 0000 01F0 a2 = 1;
	RCALL SUBOPT_0x23
; 0000 01F1 b2 = 1;
	RCALL SUBOPT_0x25
; 0000 01F2 c2 = 0;
	RCALL SUBOPT_0x26
; 0000 01F3 d2 = 0;
; 0000 01F4 e2 = 1;
; 0000 01F5 }
; 0000 01F6 if(xj2 == 4){
_0xA0:
	RCALL SUBOPT_0x22
	SBIW R26,4
	BRNE _0xA1
; 0000 01F7 a2 = 1;
	RCALL SUBOPT_0x23
; 0000 01F8 b2 = 1;
	RCALL SUBOPT_0x25
; 0000 01F9 c2 = 1;
	RCALL SUBOPT_0x27
; 0000 01FA d2 = 0;
; 0000 01FB e2 = 0;
; 0000 01FC }
; 0000 01FD delay_ms(40);
_0xA1:
	RCALL SUBOPT_0x20
; 0000 01FE }
; 0000 01FF 
; 0000 0200 if((botonpdj2 == 0) &&(botonadj2 == 1)){
_0x9A:
	SBRC R2,2
	RJMP _0xA3
	SBRC R2,3
	RJMP _0xA4
_0xA3:
	RJMP _0xA2
_0xA4:
; 0000 0201 delay_ms(40);
	RCALL SUBOPT_0x20
; 0000 0202 botonpdj2 = botonadj2;
	BST  R2,3
	BLD  R2,2
; 0000 0203 }
; 0000 0204 }
_0xA2:
	RET
; .FEND
;void muevej2izq(){
; 0000 0206 void muevej2izq(){
_muevej2izq:
; .FSTART _muevej2izq
; 0000 0207 if(izqj2 == 0){
	SBIC 0x16,2
	RJMP _0xA5
; 0000 0208 botonaij2 = 0;
	CLT
	RJMP _0xB5
; 0000 0209 } else {
_0xA5:
; 0000 020A botonaij2 = 1;
	SET
_0xB5:
	BLD  R2,7
; 0000 020B }
; 0000 020C 
; 0000 020D if((botonpij2 == 1)&& (botonaij2 == 0)){//Cambio de flanco de 1 a 0
	SBRS R2,6
	RJMP _0xA8
	SBRS R2,7
	RJMP _0xA9
_0xA8:
	RJMP _0xA7
_0xA9:
; 0000 020E xj2--;
	LDI  R26,LOW(_xj2)
	LDI  R27,HIGH(_xj2)
	RCALL SUBOPT_0x21
; 0000 020F if(xj2 < 1){
	RCALL SUBOPT_0x22
	SBIW R26,1
	BRGE _0xAA
; 0000 0210 xj2 = 1;
	RCALL SUBOPT_0x4
; 0000 0211 }
; 0000 0212 if(xj2 == 1){
_0xAA:
	RCALL SUBOPT_0x22
	SBIW R26,1
	BRNE _0xAB
; 0000 0213 a2 = 0;
	RCALL SUBOPT_0x1
; 0000 0214 b2 = 0;
; 0000 0215 c2 = 1;
; 0000 0216 d2 = 1;
; 0000 0217 e2 = 1;
; 0000 0218 }
; 0000 0219 if(xj2 == 2){
_0xAB:
	RCALL SUBOPT_0x22
	SBIW R26,2
	BRNE _0xAC
; 0000 021A a2 = 1;
	RCALL SUBOPT_0x23
; 0000 021B b2 = 0;
	RCALL SUBOPT_0x24
; 0000 021C c2 = 0;
; 0000 021D d2 = 1;
; 0000 021E e2 = 1;
; 0000 021F }
; 0000 0220 if(xj2 == 3){
_0xAC:
	RCALL SUBOPT_0x22
	SBIW R26,3
	BRNE _0xAD
; 0000 0221 a2 = 1;
	RCALL SUBOPT_0x23
; 0000 0222 b2 = 1;
	RCALL SUBOPT_0x25
; 0000 0223 c2 = 0;
	RCALL SUBOPT_0x26
; 0000 0224 d2 = 0;
; 0000 0225 e2 = 1;
; 0000 0226 }
; 0000 0227 if(xj2 == 4){
_0xAD:
	RCALL SUBOPT_0x22
	SBIW R26,4
	BRNE _0xAE
; 0000 0228 a2 = 1;
	RCALL SUBOPT_0x23
; 0000 0229 b2 = 1;
	RCALL SUBOPT_0x25
; 0000 022A c2 = 1;
	RCALL SUBOPT_0x27
; 0000 022B d2 = 0;
; 0000 022C e2 = 0;
; 0000 022D }
; 0000 022E delay_ms(40);
_0xAE:
	RCALL SUBOPT_0x20
; 0000 022F }
; 0000 0230 
; 0000 0231 if((botonpij2 == 0) &&(botonaij2 == 1)){
_0xA7:
	SBRC R2,6
	RJMP _0xB0
	SBRC R2,7
	RJMP _0xB1
_0xB0:
	RJMP _0xAF
_0xB1:
; 0000 0232 delay_ms(40);
	RCALL SUBOPT_0x20
; 0000 0233 botonpij2 = botonaij2;
	BST  R2,7
	BLD  R2,6
; 0000 0234 }
; 0000 0235 }
_0xAF:
	RET
; .FEND

	.DSEG
_filas:
	.BYTE 0x7
_d1:
	.BYTE 0x2
_e1:
	.BYTE 0x2
_a2:
	.BYTE 0x2
_b2:
	.BYTE 0x2
_c2:
	.BYTE 0x2
_d2:
	.BYTE 0x2
_e2:
	.BYTE 0x2
_xj1:
	.BYTE 0x2
_xj2:
	.BYTE 0x2
_i:
	.BYTE 0x2
_j:
	.BYTE 0x2
_ai:
	.BYTE 0x2
_aj:
	.BYTE 0x2
_x:
	.BYTE 0x2
_iterador:
	.BYTE 0x2
_factori:
	.BYTE 0x2
_factorj:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x0:
	CLR  R8
	CLR  R9
	CLR  R10
	CLR  R11
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
	STS  _d1,R30
	STS  _d1+1,R31
	STS  _e1,R30
	STS  _e1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:52 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	STS  _a2,R30
	STS  _a2+1,R30
	STS  _b2,R30
	STS  _b2+1,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _c2,R30
	STS  _c2+1,R31
	STS  _d2,R30
	STS  _d2+1,R31
	STS  _e2,R30
	STS  _e2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 48 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	STS  _xj1,R30
	STS  _xj1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x2
	STS  _xj2,R30
	STS  _xj2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	STS  _j,R30
	STS  _j+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _iterador,R30
	STS  _iterador+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x2
	STS  _factori,R30
	STS  _factori+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	RCALL SUBOPT_0x2
	STS  _factorj,R30
	STS  _factorj+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	SUBI R30,LOW(-_tabla7segmentos*2)
	SBCI R31,HIGH(-_tabla7segmentos*2)
	LPM  R0,Z
	OUT  0x1B,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xB:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(100)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xD:
	OUT  0x15,R30
	LDI  R30,LOW(255)
	OUT  0x12,R30
	LDS  R26,_j
	LDS  R27,_j+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	__GETB1MN _filas,1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	__GETB1MN _filas,2
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	__GETB1MN _filas,3
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	__GETB1MN _filas,4
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	__GETB1MN _filas,5
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(200)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	STS  _aj,R30
	STS  _aj+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	STS  _i,R30
	STS  _i+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x18:
	LDS  R26,_j
	LDS  R27,_j+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x17
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1A:
	LDS  R26,_xj1
	LDS  R27,_xj1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x2
	MOVW R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1C:
	CLR  R10
	CLR  R11
	CLR  R12
	CLR  R13
	RCALL SUBOPT_0x2
	STS  _d1,R30
	STS  _d1+1,R31
	RCALL SUBOPT_0x2
	STS  _e1,R30
	STS  _e1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x2
	MOVW R10,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	CLR  R12
	CLR  R13
	LDI  R30,LOW(0)
	STS  _d1,R30
	STS  _d1+1,R30
	RCALL SUBOPT_0x2
	STS  _e1,R30
	STS  _e1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x2
	MOVW R12,R30
	LDI  R30,LOW(0)
	STS  _d1,R30
	STS  _d1+1,R30
	STS  _e1,R30
	STS  _e1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(40)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x22:
	LDS  R26,_xj2
	LDS  R27,_xj2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x2
	STS  _a2,R30
	STS  _a2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(0)
	STS  _b2,R30
	STS  _b2+1,R30
	STS  _c2,R30
	STS  _c2+1,R30
	RCALL SUBOPT_0x2
	STS  _d2,R30
	STS  _d2+1,R31
	RCALL SUBOPT_0x2
	STS  _e2,R30
	STS  _e2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x25:
	RCALL SUBOPT_0x2
	STS  _b2,R30
	STS  _b2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(0)
	STS  _c2,R30
	STS  _c2+1,R30
	STS  _d2,R30
	STS  _d2+1,R30
	RCALL SUBOPT_0x2
	STS  _e2,R30
	STS  _e2+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x2
	STS  _c2,R30
	STS  _c2+1,R31
	LDI  R30,LOW(0)
	STS  _d2,R30
	STS  _d2+1,R30
	STS  _e2,R30
	STS  _e2+1,R30
	RET

;RUNTIME LIBRARY

	.CSEG
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
