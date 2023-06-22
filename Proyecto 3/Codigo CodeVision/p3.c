/*******************************************************
This program was created by the CodeWizardAVR V3.51 
Automatic Program Generator
© Copyright 1998-2023 Pavel Haiduc, HP InfoTech S.R.L.
http://www.hpinfotech.ro

Project : 
Version : 
Date    : 14/05/2023
Author  : 
Company : 
Comments: 


Chip type               : ATmega8535
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128
*******************************************************/

// I/O Registers definitions
#include <mega8535.h>

// Declare your global variables here
#include <delay.h>

const char tabla7segmentos[10]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7c,0x07,0x7f,0x6f};
unsigned char filas[7] = {1,0,1,1,1,1,1};

#define col1 PORTC.0 //En video PORTD
#define col2 PORTC.1
#define col3 PORTC.2
#define col4 PORTC.3
#define col5 PORTC.4

#define row1 PORTD.0  //En video PORTC
#define row2 PORTD.1 
#define row3 PORTD.2 
#define row4 PORTD.3 
#define row5 PORTD.4 
#define row6 PORTD.5 
#define row7 PORTD.6

//Botones de movimiento //En video PORTA
#define izqj1 PINB.0
#define derj1 PINB.1
#define izqj2 PINB.2
#define derj2 PINB.3

//Activadores para los marcadores (multiplexar display)
#define activadorm1 PORTB.4 
#define activadorm2 PORTB.5

bit botonpdj1;
bit botonadj1;
bit botonpdj2;
bit botonadj2;
bit botonpij1;
bit botonaij1;
bit botonpij2;
bit botonaij2;

int puntuacionj1, puntuacionj2;
int a1, b1, c1, d1, e1;//Mover raqueta de j1
int a2, b2, c2, d2, e2;//Mover raqueta de j2
int xj1, xj2;//limites de cada jugador
int i, j;//movimiento
int ai, aj;//Posicion anterior
int x;
int iterador;
int factori, factorj;

//funciones
void muevej1der();
void muevej1izq();
void muevej2der();
void muevej2izq();
void muevepunto();

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRA=(0<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=T Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=P Bit2=P Bit1=P Bit0=P 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(0<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=T Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

//Inicialization vars
puntuacionj1 = 0;
puntuacionj2 = 0;

//La raqueta del J1 inicia a la izquierda 
a1 = 0;
b1 = 0;
c1 = 1;
d1 = 1;
e1 = 1;

//La raqueta del J2 inicia a la izquierda 
a2 = 0;
b2 = 0;
c2 = 1;
d2 = 1;
e2 = 1;

xj1 = 1; //Solo se movera de 1 a 3
xj2 = 1;

j = 2; //Columna de inicio para la pelota
i = 0; //fila de inicio

x = 0;

iterador = 0;
factori = 1;
factorj = 1;


while (1)
      {
      // Place your code here
        muevepunto();//mueve el punto que representa la pelota
        for(iterador = 0; iterador <= 200; iterador++){
            //Funciones para mover las barras
            muevej1der();
            muevej1izq();
            muevej2der();
            muevej2izq();
        }
        
        //Se activan los displays de cada jugador
        activadorm1 = 0;
        activadorm2 = 1;
        PORTA = tabla7segmentos[puntuacionj1];
        delay_ms(20);
        activadorm1 = 1;
        activadorm2 = 0;
        delay_ms(20);
        PORTA = tabla7segmentos[puntuacionj2];
        
        delay_ms(100);
        
        //Envia datos
        PORTC = 0x01;
        PORTD = 0xFF;
        
        if(j == 1){
            row2 = filas[1];
            row3 = filas[2];
            row4 = filas[3];
            row5 = filas[4];
            row6 = filas[5];
            delay_ms(200);
        }
        
        row1 = a1;
        row7 = a2;
        delay_ms(100);
        PORTC = 0x02;
        PORTD = 0xFF;
        
        if(j == 2){
            row2 = filas[1];
            row3 = filas[2];
            row4 = filas[3];
            row5 = filas[4];
            row6 = filas[5];
            delay_ms(200);
        }
        
        row1 = b1;
        row7 = b2;
        delay_ms(100);
        PORTC = 0x04;
        PORTD = 0xFF;
        
        if(j == 3){
            row2 = filas[1];
            row3 = filas[2];
            row4 = filas[3];
            row5 = filas[4];
            row6 = filas[5];
            delay_ms(200);
        }      
        
        row1 = c1;
        row7 = c2;
        delay_ms(100);
        PORTC = 0x08;
        PORTD = 0xFF;
        
        if(j == 4){
            row2 = filas[1];
            row3 = filas[2];
            row4 = filas[3];
            row5 = filas[4];
            row6 = filas[5];
            delay_ms(200);
        }
        
        row1 = d1;
        row7 = d2;
        delay_ms(100);
        PORTC = 0x10;
        PORTD = 0xFF;
        
        if(j == 5){
            row2 = filas[1];
            row3 = filas[2];
            row4 = filas[3];
            row5 = filas[4];
            row6 = filas[5];
            delay_ms(200);
        }
               
        row1 = e1;
        row7 = e2;
        
        delay_ms(100);
        
      }
}


void muevepunto(){
    ai = i;
    aj = j;
    
    i = i + factori;
    j = j + factorj;
    
    //Rebotes solucion
    if(i == 6){
        if((j==1&&a2==0)||(j==2&&b2==0)||(j==3&&c2==0)||(j==4&&d2==0)||(j==5&&e2==0)){
            factori = -1;
        } else {
            puntuacionj1++;
            i = 1;
            j = 3;
        }
    }
    
    //rebote izq a der
    if(j == 5){
        j = 5;
        aj = 5;
        factorj = -1;
    }
    
    //rebote der a izq
    if(j == 1){
        j = 1;
        aj = 1;
        factorj = 1;
    }
    
    if(i == 0){
        if((j==1&&a1==0)||(j==2&&b1==0)||(j==3&&c1==0)||(j==4&&d1==0)||(j==5&&e1==0)){
            factori = 1;
        } else {
            puntuacionj2++;
            i = 1;
            j = 3;
        }    
    }
    filas[i] = 0;
    filas[ai] = 1;    
}

void muevej1der(){
    if(derj1 == 0){
        botonadj1 = 0;
    } else {
        botonadj1 = 1;
    }
    
    if((botonpdj1 == 1)&& (botonadj1 == 0)){//Cambio de flanco de 1 a 0
        xj1++;
        if(xj1 > 4){
            xj1 = 4;
        }
        if(xj1 == 1){
            a1 = 0;
            b1 = 0;
            c1 = 1;
            d1 = 1;
            e1 = 1;
        }
        if(xj1 == 2){
            a1 = 1;
            b1 = 0;
            c1 = 0;
            d1 = 1;
            e1 = 1;
        }
        if(xj1 == 3){
            a1 = 1;
            b1 = 1;
            c1 = 0;
            d1 = 0;
            e1 = 1;
        }
        if(xj1 == 4){
            a1 = 1;
            b1 = 1;
            c1 = 1;
            d1 = 0;
            e1 = 0;
        }
        delay_ms(40);
    }
    
    if((botonpdj1 == 0) &&(botonadj1 == 1)){
        delay_ms(40);
        botonpdj1 = botonadj1;
    }
}

void muevej1izq(){
    if(izqj1 == 0){
        botonaij1 = 0;
    } else {
        botonaij1 = 1;
    }
    
    if((botonpij1 == 1)&& (botonaij1 == 0)){//Cambio de flanco de 1 a 0
        xj1--;
        if(xj1 < 1){
            xj1 = 1;
        }
        if(xj1 == 1){
            a1 = 0;
            b1 = 0;
            c1 = 1;
            d1 = 1;
            e1 = 1;
        }
        if(xj1 == 2){
            a1 = 1;
            b1 = 0;
            c1 = 0;
            d1 = 1;
            e1 = 1;
        }
        if(xj1 == 3){
            a1 = 1;
            b1 = 1;
            c1 = 0;
            d1 = 0;
            e1 = 1;
        }
        if(xj1 == 4){
            a1 = 1;
            b1 = 1;
            c1 = 1;
            d1 = 0;
            e1 = 0;
        }
        delay_ms(40);
    }
    
    if((botonpij1 == 0) &&(botonaij1 == 1)){
        delay_ms(40);
        botonpij1 = botonaij1;
    }    
}


void muevej2der(){
    if(derj2 == 0){
        botonadj2 = 0;
    } else {
        botonadj2 = 1;
    }
    
    if((botonpdj2 == 1)&& (botonadj2 == 0)){//Cambio de flanco de 1 a 0
        xj2++;
        if(xj2 > 4){
            xj2 = 4;
        }
        if(xj2 == 1){
            a2 = 0;
            b2 = 0;
            c2 = 1;
            d2 = 1;
            e2 = 1;
        }
        if(xj2 == 2){
            a2 = 1;
            b2 = 0;
            c2 = 0;
            d2 = 1;
            e2 = 1;
        }
        if(xj2 == 3){
            a2 = 1;
            b2 = 1;
            c2 = 0;
            d2 = 0;
            e2 = 1;
        }
        if(xj2 == 4){
            a2 = 1;
            b2 = 1;
            c2 = 1;
            d2 = 0;
            e2 = 0;
        }
        delay_ms(40);
    }
    
    if((botonpdj2 == 0) &&(botonadj2 == 1)){
        delay_ms(40);
        botonpdj2 = botonadj2;
    }
}

void muevej2izq(){
    if(izqj2 == 0){
        botonaij2 = 0;
    } else {
        botonaij2 = 1;
    }
    
    if((botonpij2 == 1)&& (botonaij2 == 0)){//Cambio de flanco de 1 a 0
        xj2--;
        if(xj2 < 1){
            xj2 = 1;
        }
        if(xj2 == 1){
            a2 = 0;
            b2 = 0;
            c2 = 1;
            d2 = 1;
            e2 = 1;
        }
        if(xj2 == 2){
            a2 = 1;
            b2 = 0;
            c2 = 0;
            d2 = 1;
            e2 = 1;
        }
        if(xj2 == 3){
            a2 = 1;
            b2 = 1;
            c2 = 0;
            d2 = 0;
            e2 = 1;
        }
        if(xj2 == 4){
            a2 = 1;
            b2 = 1;
            c2 = 1;
            d2 = 0;
            e2 = 0;
        }
        delay_ms(40);
    }
    
    if((botonpij2 == 0) &&(botonaij2 == 1)){
        delay_ms(40);
        botonpij2 = botonaij2;
    }
}

