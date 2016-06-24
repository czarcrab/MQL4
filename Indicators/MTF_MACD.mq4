//+------------------------------------------------------------------+
//|                                                     MTF MACD.mq4 |
//+------------------------------------------------------------------+
#property copyright "mqlservice.co.uk"
#property link      "http://mqlservice.co.uk/"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Gray
#property indicator_color2 Red
//---- input parameters
extern int    TimeFrame=0;
extern int    FastEMA=12;   
extern int    SlowEMA=26;   
extern int    Signal=9;  
extern int    AppliedPrice=0;  
extern int    Shift=0;

extern string     note0="Applied price 0-CLOSE | 1-OPEN | 2-HIGH | 3-LOW |";
extern string     note1="            | 4-MEDIAN | 5-TYPICAL | 6-WEIGHTED |";
extern string     note2 = "Time Frame 0=current time frame";
extern string     note3 = "1=M1, 5=M5, 15=M15, 30=M30";
extern string     note4 = "60=H1, 240=H4, 1440=D1";
extern string     note5 = "10080=W1, 43200=MN1";
//---- buffers
double MainBuffer[];
double SignalBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   int    draw_begin=MathMax(FastEMA,SlowEMA);
   string short_name="MTF MACD Price ";
   //---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM,0,2);
   SetIndexBuffer(0,MainBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,SignalBuffer);
   Print("MTF MACD.mq4, Ver.#2");
   Print("Copyright © 2009/05/26  MQL Service UK   http://mqlservice.co.uk/");
   switch(AppliedPrice){
      case 1 : short_name=short_name+"| OPEN "; break; 
      case 2 : short_name=short_name+"| HIGH "; break;  
      case 3 : short_name=short_name+"| LOW "; break;  
      case 4 : short_name=short_name+"| MEDIAN "; break;    
      case 5 : short_name=short_name+"| TYPICAL "; break;    
      case 6 : short_name=short_name+"| WEIGHTED "; break;     
      default :
         AppliedPrice=PRICE_CLOSE; short_name=short_name+"| CLOSE "; break; 
   }
   if(TimeFrame<Period()) TimeFrame=Period();
   string TFName="";
   switch(TimeFrame)
   {
      case 1 : TFName="M1"; break;
      case 5 : TFName="M5"; break;
      case 15 : TFName="M15"; break;
      case 30 : TFName="M30"; break;
      case 60 : TFName="H1"; break;
      case 240 : TFName="H4"; break;
      case 1440 : TFName="D1"; break;
      case 10080 : TFName="W1"; break;
      case 43200 : TFName="MN1"; break;
      default : TFName="Chart"; TimeFrame=Period(); break;
   }

   short_name=StringConcatenate(short_name," (TF "+TFName+","+FastEMA+","+SlowEMA+","+Signal+")");
   IndicatorShortName(short_name);
   SetIndexDrawBegin(0,draw_begin);
   SetIndexDrawBegin(1,draw_begin);
   SetIndexLabel(0,"Main");
   SetIndexLabel(1,"Signal");
   IndicatorDigits(6);
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
   //----
   
   //----
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
  int limit, iChart, iTF, delta=0;
  datetime TimeArray[];
  if(TimeFrame>Period()) delta=MathCeil(TimeFrame/Period());
  int counted_bars=IndicatorCounted();
  //---- check for possible errors
  if(counted_bars<0) return(-1);
  //---- the last counted bar will be recounted
  if(counted_bars>0) counted_bars--;
  limit=Bars-counted_bars+delta;

  ArrayCopySeries(TimeArray,MODE_TIME,Symbol(),TimeFrame); 
   
  iTF=0;
  for(iChart=0; iChart<limit; iChart++)
  {
      while(Time[iChart]<TimeArray[iTF]) iTF++;
      MainBuffer[iChart]=EMPTY_VALUE;
      SignalBuffer[iChart]=EMPTY_VALUE;
      MainBuffer[iChart]=iMACD(Symbol(),TimeFrame,FastEMA,SlowEMA,Signal,AppliedPrice,MODE_MAIN,iTF+Shift);
      SignalBuffer[iChart]=iMACD(Symbol(),TimeFrame,FastEMA,SlowEMA,Signal,AppliedPrice,MODE_SIGNAL,iTF+Shift);
  }
  return(0);
}

//+------------------------------------------------------------------+