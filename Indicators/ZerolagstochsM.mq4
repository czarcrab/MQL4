//+------------------------------------------------------------------+
//|                                               ZerolagstochsM.mq4 |
//|                 Copyright © 1.09.2006, MetaQuotes Software Corp. |
//|                                                perky_z@yahoo.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2004, MetaQuotes Software Corp."
#property link      "perky_z@yahoo.com"

#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

extern int smoothing = 15;
extern int prevbars = 100;
//---- input parameters
double stok1, stok2, stok3, stok4, stok5, mov, stoksmoothed;
int shift, loopbegin;
bool first = true;
//---- buffers
double TrendBuffer[];
double LoBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicator buffers
    SetIndexBuffer(0, TrendBuffer);
    SetIndexBuffer(1, LoBuffer);
//----   
    SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2);
    SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 2);
//---- name for DataWindow and indicator subwindow label
    IndicatorShortName("ZeroLagStocsM" + "(" + smoothing + ")");
    SetIndexLabel( 0, "TrZLStocsM");
    SetIndexLabel( 1, "LoZLStocsM");
//----
    return(0);
  }
//+------------------------------------------------------------------+
//|  Zero Lag Stocs                                                  |
//+------------------------------------------------------------------+
int start()
  {
   // initial checkings
   // check for additional bars loading or total reloading
   if(Bars < prevbars)  
       return(0);      // not enough bars for counting
   int counted_bars = IndicatorCounted();
   if(counted_bars > 0) 
       counted_bars--;
   int limit = Bars - counted_bars;
   if(counted_bars==0) limit-=2;
// current bar is to be recounted too
    for(shift = limit; shift >= 0 ; shift--)
	     {
        stok1 = iStochastic(NULL, 0, 8, 3, 3, MODE_SMA, NULL, MODE_MAIN, shift)*0.05;
        stok2 = iStochastic(NULL, 0, 89, 21, 3, MODE_SMA, NULL, MODE_MAIN, shift)*0.43;
        stok3 = iStochastic(NULL, 0, 55, 13, 3, MODE_SMA, NULL, MODE_MAIN, shift)*0.26;
        stok4 = iStochastic(NULL, 0, 34, 8, 3, MODE_SMA, NULL, MODE_MAIN, shift)*0.16;
        stok5 = iStochastic(NULL, 0, 21, 5, 3, MODE_SMA, NULL, MODE_MAIN, shift)*0.10;
        mov   = stok1 + stok2 + stok3 + stok4 + stok5;
        stoksmoothed = mov / smoothing + LoBuffer[shift+1]*(smoothing - 1) / smoothing;
	       TrendBuffer[shift] = mov;
	       LoBuffer[shift] =	stoksmoothed;
	     }
	   return(0);
	 }
//+------------------------------------------------------------------+
	    

