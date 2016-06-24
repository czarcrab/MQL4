//+------------------------------------------------------------------+
//|                                              keltner-channel.mq4 |
//|        ©2011 Best-metatrader-indicators.com. All rights reserved |
//|                        http://www.best-metatrader-indicators.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011 Best-metatrader-indicators.com."
#property link      "http://www.best-metatrader-indicators.com"

#property indicator_chart_window
// This will be using 3 indicators one for upper KC, one for lower KC and one for mean with style dashdot
#property indicator_buffers 3

#property indicator_color1 Tomato
#property indicator_color2 DodgerBlue
#property indicator_color3 Tomato
//---- input parameters
extern int period = 10;
//----
double u[], m[], l[];
string Copyright="\xA9 WWW.BEST-METATRADER-INDICATORS.COM";  
string MPrefix="FI";
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   // buffer of uppper
   SetIndexBuffer(0, u);
   SetIndexStyle(0, DRAW_LINE,STYLE_SOLID, 2);
   SetIndexShift(0, 0);
   SetIndexDrawBegin(0, 0);
//----
   // buffer of middle
   SetIndexBuffer(1, m);
   SetIndexStyle(1, DRAW_LINE, STYLE_DASHDOT);
   SetIndexShift(1, 0);
   SetIndexDrawBegin(1, 0);
//----
   // buffer of lower
   SetIndexBuffer(2, l);
   SetIndexStyle(2, DRAW_LINE,STYLE_SOLID, 2);
   SetIndexShift(2, 0);
   SetIndexDrawBegin(2, 0);
//---- name for DataWindow label
   SetIndexLabel(0, "KCUp(" + period + ")");    
   SetIndexLabel(1, "KCMid(" + period + ")"); 
   SetIndexLabel(2, "KCLow(" + period + ")"); 
//----
   // Obstructive
   //DL("001", Copyright, 5, 20,Gold,"Arial",10,0); 
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   ClearObjects(); 
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start() 
  {
   int limit;
   double avg;   
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0) 
       return(-1);
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars;
//----
   for(int x = 0; x < limit; x++) 
     {
      m[x] = iMA(NULL, 0, period, 0, MODE_SMA, PRICE_TYPICAL, x);
      avg = findAvg(period, x);
      u[x] = m[x] + avg;
      l[x] = m[x] - avg;
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+  
double findAvg(int period, int shift) 
  {
   double sum = 0;
   for(int x = shift; x < (shift + period); x++) 
     {     
       sum += High[x] - Low[x];
     }
   sum = sum / period;
   return(sum);
  }  
  
//+------------------------------------------------------------------+
//| DL function                                                      |
//+------------------------------------------------------------------+
 void DL(string label, string text, int x, int y, color clr, string FontName = "Arial",int FontSize = 12, int typeCorner = 1)
 
{
   string labelIndicator = MPrefix + label;   
   if (ObjectFind(labelIndicator) == -1)
   {
      ObjectCreate(labelIndicator, OBJ_LABEL, 0, 0, 0);
  }
   
   ObjectSet(labelIndicator, OBJPROP_CORNER, typeCorner);
   ObjectSet(labelIndicator, OBJPROP_XDISTANCE, x);
   ObjectSet(labelIndicator, OBJPROP_YDISTANCE, y);
   ObjectSetText(labelIndicator, text, FontSize, FontName, clr);
  
}  

//+------------------------------------------------------------------+
//| ClearObjects function                                            |
//+------------------------------------------------------------------+
void ClearObjects() 
{ 
  for(int i=0;i<ObjectsTotal();i++) 
  if(StringFind(ObjectName(i),MPrefix)==0) { ObjectDelete(ObjectName(i)); i--; } 
}
//+------------------------------------------------------------------+



