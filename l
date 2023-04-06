#include<reg52.h>
#include <intrins.h>
#define uchar unsigned char
#define uint unsigned int
#define Disdata P2 //
uint ReadTemperature();
void convdata();

 void xianshi();
void sound();
void czhi();
void sdong();
void show();
void restzhi();
void datadisp();//
void jingque();
sbit SD=P0^0;
sbit SET=P0^1;
sbit Jian=P0^2;
sbit Jia=P0^3;
sbit Md=P0^4;
sbit p05=P0^5;
sbit p06=P0^6;
sbit p07=P0^7;
sbit CS=P3^0;
sbit Clk=P3^1;
sbit DATI=P3^2;
sbit DATO=P3^2;
sbit DQ=P3^3;
sbit Ledzc=P3^4;
sbit Ledrbj=P3^5;
sbit Ledybj=P3^6;
sbit Fmbj=P3^7;
uchar led_mod[]
={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90,0xBF,0xff};
uchar led_com[]={0x08,0x04,0x02,0x01,0x00};
uchar tg=0;tflag;//
unsigned char dat0=0x00;
unsigned char CH=0x00;
unsigned char dis[]={0, 0, 0};
uchar disdata[]={0,10,0,0,0,0};
uchar shezhi[]={0,0,0,0};
uchar jque[]={0,0,0,0,0};
int sign=0,js,qo,temp,ywu,ybz;
int Time=65000; //
int pbi=500,ts=0,ys=0,is=0,ll;
uint tuxian=30,yuxian=3,temp0;
void Delay(uint i)
{
while( i-- );
}
void delayt(uint time)
{
int j;
for(;time>0;time--)
for(j=0;j<100;j++);  
}
void Init_DS18B20(void)
{ 
uint x=0;
DQ=1;
Delay(10);
DQ=0;
Delay(80);
DQ=1;
Delay(10);
x=DQ;
Delay(20);
}
unsigned char ReadOneChar(void)   
{
uint i=0;
uint dat=0;
for (i=8;i>0;i--)
{
DQ=0;
dat>>=1;
DQ=1;
if(DQ);//
dat|=0x80;
Delay(4);
}
return(dat);
}
void WriteOneChar(uint dat)  
{
uint i=0;
for (i=8; i>0; i--)
{
DQ=0;
DQ=dat&0x01;
Delay(5);
DQ=1;
dat>>=1;
}
}
void Tmpchange(void)  
{
Init_DS18B20();
WriteOneChar(0xCC);
WriteOneChar(0x44);
}
uint ReadTemperature(void)
{
uint a=0;
uint b=0;
uint t=0;
float tt=0;
Tmpchange();
Init_DS18B20();
WriteOneChar(0xCC);
WriteOneChar(0xBE);
a=ReadOneChar();
b=ReadOneChar();
t=b;
t<<=8;
t=t|a;
if(t<0x0fff)
tflag=0;
else
{t=~t+1;
tflag=1;
}  
t=t*(0.0625*10);
return(t);
} 
unsigned char adc0832(unsigned char CH)
{
unsigned char i,test,adval;
adval=0x00;
test=0x00;
Clk=0;
DATI=1;
_nop_();
CS=0;
_nop_();
Clk=1;
_nop_();
if ( CH==0x00 )
{
Clk=0;
DATI=1;
_nop_();
Clk=1;
_nop_();
Clk=0;
DATI=0;
_nop_();
Clk=1;
_nop_();
}
else
{
Clk=0;
DATI=1;
_nop_();
Clk=1;
_nop_();
Clk=0;
DATI=1;
_nop_();
Clk=1;
_nop_();
}
Clk=0;
DATI=1;
for( i=0;i < 8;i++ )
{
_nop_();
adval <<=1;
Clk=1;
_nop_();
Clk=0;
if (DATO)
adval |=0x01;
else
adval |=0x00;
}
for (i=0; i < 8; i++)
{
test >>=1;
if (DATO)
test |=0x80;
else
test |=0x00;
_nop_();
Clk=1;
_nop_();
Clk=0;
}
dat0=test;
_nop_();
CS=1;
DATO=1;
Clk=1;
return dat0;
} 
void datadisp(uint y,uint t)
{
ywu=(y%10000)/1000*1000+(y%1000)/100*100+(y%100)/10*10+y%10;
{
if(ywu>=0)disdata[0]=0;
if(ywu>5)disdata[0]=1;
if(ywu>20)disdata[0]=2;
if(ywu>40)disdata[0]=3;
if(ywu>80)disdata[0]=4;
if(ywu>120)disdata[0]=5;
}
temp0=t;
{
disdata[2]=(t%1000)/100; 
disdata[3]=(t%100)/10; 
}
temp=disdata[2]*10+disdata[3];
}  
void xianshi()
{
int key=0;
if(pbi>=0){show();pbi--;}
else
for(;key<=3;key++)
{
Disdata=~(led_mod[11]);
P1=~led_com[key];  
Disdata=~(led_mod[disdata[key]]);
Delay(50);
}
}
void show()      
{
int key=0;
for(;key<=3;key++)
{
Disdata=~(led_mod[11]);
P1=~led_com[key];   
Disdata=~(led_mod[shezhi[key]]); 
Delay(50);
}
}
void disjque()
{
int key=0;
for(;key<=3;key++)
{
Disdata=~(led_mod[11]);
P1=~led_com[key];   
if(tg==1 && key==2)Disdata=~(led_mod[jque[key]]^0x80);
else Disdata=~(led_mod[jque[key]]);
Delay(50);
}
}
void jingque()
{
if(Jia==0)   
{
jque[0]=11;
if(yuxian==0){jque[1]=11;jque[2]=11;jque[3]=0;}
if(yuxian==1){jque[1]=11;jque[2]=11;jque[3]=5;}
if(yuxian==2){jque[1]=11;jque[2]=2;jque[3]=0;}
if(yuxian==3){jque[1]=11;jque[2]=4;jque[3]=0;}
if(yuxian==4){jque[1]=11;jque[2]=8;jque[3]=0;}
if(yuxian==5){jque[1]=1;jque[2]=2;jque[3]=0;}
while(Jia==0)disjque();
while(Jia!=0)
{
jque[3]=ywu%10;jque[2]=(ywu%100)/10;
jque[1]=(ywu%1000)/100;jque[0]=(ywu%10000)/1000;
if(jque[0]==0){jque[0]=11;if(jque[1]==0)jque[1]=11;if(jque[2]==0)jque[2]=11;}
disjque();
}
while(Jia==0)disjque();
}
if(Jian==0)  
{
jque[0]=11;jque[1]=11;jque[2]=tuxian/10;jque[3]=tuxian%10;
while(Jian==0)disjque();
tg=1;   
while(Jian!=0) 
{
if(tflag==0)jque[0]=(temp0%10000)/1000;
else jque[0]=10;   
jque[1]=(temp0%1000)/100;
jque[2]=(temp0%100)/10;  
jque[3]=temp0%10; 
if(jque[0]==0){jque[0]=11;if(jque[1]==0)jque[1]=11;}
disjque();
} 
while(Jian==0)disjque();
tg=0;
} 
}
void sound()
{
Fmbj=1;
Fmbj=0;
delayt(3);
Fmbj=1;
}
void Baoj()
{
if(pbi-50>=0){ll=0;Ledzc=0;Ledrbj=1;Ledybj=1;Md=1;}
else ll=1;
while(ll)
{
if(temp>=tuxian || sign==1 || ywu>=ybz)
{
Md=0;     
{
p05=0;p06=1;p07=1;Delay(15);sound();
p05=1;p06=0;p07=1;Delay(15);sound();
p05=1;p06=1;p07=0;Delay(15);sound();
p05=1;p06=1;p07=1;Delay(5);
}
if(sign==0)
{
Ledzc=1;
if(temp>=tuxian){Ledrbj=0;Md=0;}else{Ledrbj=1;}
if(disdata[0]>=yuxian){Ledybj=0;Md=0;}else{Ledybj=1;}
}
if(sign==1)
{        
Ledzc=1;Ledrbj=1;Ledybj=0;Delay(15);sound();
Ledzc=1;Ledrbj=0;Ledybj=1;Delay(15);sound();
Ledzc=0;Ledrbj=1;Ledybj=1;Delay(15);sound();
Ledzc=1;Ledrbj=1;Ledybj=1;Delay(5);
} 
}
else{Ledzc=0;Ledrbj=1;Ledybj=1;Md=1;}
ll=0;
}
} 
void czhi(void)
{
js=1000;ys=js;ts=js;
while(SET==0)show();
while((ys>0)&&(ts>0))
{
shezhi[1]=11;shezhi[2]=11;shezhi[3]=11;
while(ys>0)
{
while(SET==0)show();
ys=js;show();
while(Jian==0){if(yuxian==0)break;show();yuxian--;delayt(300);shezhi[0]=yuxian;}
while(Jia==0) {if(yuxian==9)break;show();yuxian++; delayt(300);shezhi[0]=yuxian;}
while(SET!=0 && Jia!=0 && Jian!=0) {show();ys--;if(ys<=0){ys=0;ts=0;break;}}
if(SET==0){ys=0;ts=js;delayt(250);if(SET==0){ys=0;ts=0;}}
}
restzhi();shezhi[0]=11;shezhi[1]=11;
while(ts>0)
{ 
ts=js;show();
while(Jian==0)
{if(tuxian==0)break;show();tuxian--;delayt(300);shezhi[2]=tuxian/10;shezhi[3]=tuxian/1-tuxian
/10*10;}
while(Jia==0)
{if(tuxian==99)break;show();tuxian++;
delayt(300);shezhi[2]=tuxian/10;shezhi[3]=tuxian/1-tuxian/10*10;}
while(SET!=0 && Jia!=0 && Jian!=0) {show();ts--;if(ts<=0){ts=0;ys=0;break;}}
if(SET==0){ts=0;ys=js;delayt(250);if(SET==0){ys=0;ts=0;}}
}
ts=js;restzhi();  
}
while(SET==0)show();
}
void sdong()        
{
while(SD==0){sign=0;xianshi();}
delayt(350);
while(SD==0){sign=1;xianshi();}
}                   
void restzhi()      
{
shezhi[0]=yuxian;shezhi[1]=10;shezhi[2]=tuxian/10;shezhi[3]=tuxian/1-tuxian/10*10;
if(yuxian==0)ybz=0;
if(yuxian==1)ybz=5;
if(yuxian==2)ybz=20;
if(yuxian==3)ybz=40;
if(yuxian==4)ybz=80;
if(yuxian==5)ybz=120;
}
void init() 
{
TMOD=0x01;
TH0=-(Time)/256;
TL0=-(Time)%256;
ET0=1;
TR0=1;
EA=1;
}
void sysrest()          
{
int qq=80;
Ledzc=0;Ledrbj=1;Ledybj=1;Fmbj=1;Md=1;
for(;qq>=0;qq--)xianshi();
restzhi();
init();
}
void timer0(void) interrupt 3 {
TR0=0;
is++;
if(is==16){datadisp(dat0=adc0832(CH),ReadTemperature());is=0;}
Baoj();
TH0=-(Time)/256;
TL0=-(Time)%256;
TR0=1;
}  
void main()
{
sysrest();
 while(1)
{
 xianshi();
 if(SD==0)sdong();
 if(SET==0)czhi();
 if(Jia==0 || Jian==0)jingque();
}
}
