//+------------------------------------------------------------------+
//|                                             bushido_trailing.mqh |
//|                                                          busitya |
//|                    https://sites.google.com/site/memomemoru/home |
//|                                                                  |
//|  武士道トレーリングヘッダファイル                             　 |
//|                                                                  |
//|  (注意)bushido_trailing.ex4をlibrariesファイルに        　・     |
//|        格納しておくこと                                          |
//+------------------------------------------------------------------+
#property copyright "busitya"
#property link      "https://sites.google.com/site/memomemoru/home"
#property strict

#include	<stdlib.mqh>
#include	<stderror.mqh>
#include <bushido_commonutils.mqh>

//+------------------------------------------------------------------+
//| 武士道トレール                                                   |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       trailingStop: トレーリングストップ                         |
//|       minProfit:最小利益                                         |
//|       MAGICMA:マジックナンバー                                   |
//+------------------------------------------------------------------+
void TrailingStop(string symbol, int trailingStop, int minProfit, int MAGICMA)
{
   if(BuyMarketCount(symbol,MAGICMA) > 0 &&  trailingStop > 0)
   {
      BuyTrailingStop(symbol, trailingStop, minProfit, MAGICMA);
   }
   
   if(SellMarketCount(symbol,MAGICMA) > 0 &&  trailingStop > 0)
   {
      SellTrailingStop(symbol, trailingStop, minProfit, MAGICMA);
   }
}

//+------------------------------------------------------------------+
//| 武士道トレール                                                   |
//| HLバンドを使用して損切りラインを決定                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       trailingStop: トレーリングストップ                         |
//|       minProfit:最小利益                                         |
//|       MAGICMA:マジックナンバー                                   |
//+------------------------------------------------------------------+
void TrailingStopWithHLBand(string symbol, int period, int MAGICMA)
{
   if(BuyMarketCount(symbol,MAGICMA) > 0)
   {
      BuyTrailingStopWithHLBand(symbol, period, MAGICMA);
   }
   
   if(SellMarketCount(symbol,MAGICMA) > 0)
   {
      SellTrailingStopWithHLBand(symbol, period, MAGICMA);
   }
}

//+------------------------------------------------------------------+
//| 武士道トレール                                                   |
//| ATRを使用して損切りラインを決定                                  |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       period:  ATRの期間                                         |
//|       multi:   倍数                                              |
//|       MAGICMA:マジックナンバー                                   |
//+------------------------------------------------------------------+
void TrailingStopWithATR(string symbol, int period, double multi,int MAGICMA)
{
   if(BuyMarketCount(symbol,MAGICMA) > 0)
   {
      BuyTrailingStopWithATR(symbol,period,multi,MAGICMA);
   }
   
   if(SellMarketCount(symbol,MAGICMA) > 0)
   {
      SellTrailingStopWithATR(symbol,period,multi,MAGICMA);
   }
}

//+------------------------------------------------------------------+
//| 買い注文のトレール                                               |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       trailingStop: トレーリングストップ                         |
//|       minProfit:最小利益                                         |
//|       MAGICMA:マジックナンバー                                   |
//+------------------------------------------------------------------+
void BuyTrailingStop(string symbol, int trailingStop, int minProfit, int MAGICMA)
{
   for(int counter=0; counter <= OrdersTotal()-1 ; counter++)
   {
      OrderSelect(counter, SELECT_BY_POS);
      
      // 最大損切り価格と最小利食い価格の計算
      double maxStopLoss = MarketInfo(symbol, MODE_BID) - (trailingStop * PipsPointSymbol(symbol));
      maxStopLoss = NormalizeDouble(maxStopLoss, MarketInfo(OrderSymbol(), MODE_DIGITS));    
      double currentStop = NormalizeDouble(OrderStopLoss(), MarketInfo(OrderSymbol(), MODE_DIGITS));
      
      double pipsProfit = MarketInfo(symbol, MODE_BID) - OrderOpenPrice();
      double symbolminProfit = minProfit * PipsPointSymbol(symbol);
      
      // 損切り価格の変更
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol && OrderType() == OP_BUY 
            && currentStop < maxStopLoss && pipsProfit >= symbolminProfit)
      {
         bool tailed = OrderModify(OrderTicket(), OrderOpenPrice(), maxStopLoss, OrderTakeProfit(),0);
         
         if(tailed == false)
         {
            int errorCode = GetLastError();
	         string errdesc = ErrorDescription(errorCode);

		      string errAlert = StringConcatenate("Buy Trailing Stop - Error ",errorCode,": ",errdesc);
	        	Alert(errAlert);

		      string errlog = StringConcatenate("Bid: ", MarketInfo(symbol, MODE_BID), " Ticket:", OrderTicket(), 
											" Stop: ",OrderStopLoss()," Tail: ",maxStopLoss);
	        	Print(errlog);
	      }
	   }
   }    
}

//+------------------------------------------------------------------+
//| 売り注文のトレール                                               |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       trailingStop: トレーリングストップ                         |
//|       minProfit:最小利益                                         |
//|       MAGICMA:マジックナンバー                                   |
//+------------------------------------------------------------------+
void SellTrailingStop(string symbol, int trailingStop, int minProfit, int MAGICMA)
{
   for(int counter=0; counter <= OrdersTotal()-1 ; counter++)
   {
      OrderSelect(counter, SELECT_BY_POS);
      
      // 最大損切り価格と最小利食い価格の計算
      double maxStopLoss = MarketInfo(symbol, MODE_ASK) + (trailingStop * PipsPointSymbol(symbol));
      maxStopLoss = NormalizeDouble(maxStopLoss, MarketInfo(OrderSymbol(), MODE_DIGITS));    
      double currentStop = NormalizeDouble(OrderStopLoss(), MarketInfo(OrderSymbol(), MODE_DIGITS));
      
      double pipsProfit = OrderOpenPrice() - MarketInfo(symbol, MODE_ASK);
      double symbolminProfit = minProfit * PipsPointSymbol(symbol);
      
      // 損切り価格の変更
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol && OrderType() == OP_SELL 
            && (currentStop > maxStopLoss || currentStop == 0) && pipsProfit >= symbolminProfit)
      {
         bool tailed = OrderModify(OrderTicket(), OrderOpenPrice(), maxStopLoss, OrderTakeProfit(),0);
         
         if(tailed == false)
         {
            int errorCode = GetLastError();
	         string errdesc = ErrorDescription(errorCode);

		      string errAlert = StringConcatenate("Sell Trailing Stop - Error ",errorCode,": ",errdesc);
	        	Alert(errAlert);

		      string errlog = StringConcatenate("Ask: ", MarketInfo(symbol, MODE_ASK), " Ticket:", OrderTicket(), 
											" Stop: ",OrderStopLoss()," Tail: ",maxStopLoss);
	        	Print(errlog);
	      }
	   }
   }    
}

//+------------------------------------------------------------------+
//| 買い注文のトレール                                               |
//| HLバンドを使用して損切りラインを決定                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       period:  HLBandの期間                                      |
//|       MAGICMA:マジックナンバー                                   |
//+------------------------------------------------------------------+
void BuyTrailingStopWithHLBand(string symbol, int period, int MAGICMA)
{
   // HLBandの算出
   double LL = iCustom(symbol, 0, "bushido_HLBand", period, 2, 1);
      
   for(int counter=0; counter <= OrdersTotal()-1 ; counter++)
   {
      OrderSelect(counter, SELECT_BY_POS);
      
      // 損切り価格の変更
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol && OrderType() == OP_BUY)
      {
         bool tailed = OrderModify(OrderTicket(), OrderOpenPrice(), LL, OrderTakeProfit(),0);
         
         if(tailed == false)
         {
            int errorCode = GetLastError();
	         string errdesc = ErrorDescription(errorCode);

		      //string errAlert = StringConcatenate("Buy Trailing Stop With HLBand- Error ",errorCode,": ",errdesc);
	        	//Alert(errAlert);

		      string errlog = StringConcatenate("Bid: ", MarketInfo(symbol, MODE_BID), " Ticket:", OrderTicket(), 
											" Stop: ",OrderStopLoss()," Tail: ",LL);
	        	Print(errlog);
	      }
	   }
   }    
}

//+------------------------------------------------------------------+
//| 売り注文のトレール                                               |
//| HLバンドを使用して損切りラインを決定                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       period:  HLBandの期間                                      |
//|       MAGICMA:マジックナンバー                                   |
//+------------------------------------------------------------------+
void SellTrailingStopWithHLBand(string symbol, int period, int MAGICMA)
{
   double spread = Ask - Bid;
            
   // HLBandの算出
   double HH = iCustom(symbol, 0, "bushido_HLBand", period, 1, 1) + spread;
      
   for(int counter=0; counter <= OrdersTotal()-1 ; counter++)
   {
      OrderSelect(counter, SELECT_BY_POS);
      
      // 損切り価格の変更
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol && OrderType() == OP_SELL)
      {
         bool tailed = OrderModify(OrderTicket(), OrderOpenPrice(), HH, OrderTakeProfit(),0);
         
         if(tailed == false)
         {
            int errorCode = GetLastError();
	         string errdesc = ErrorDescription(errorCode);

		      //string errAlert = StringConcatenate("Sell Trailing Stop With HLBand- Error ",errorCode,": ",errdesc);
	        //	Alert(errAlert);

		      string errlog = StringConcatenate("Ask: ", MarketInfo(symbol, MODE_ASK), " Ticket:", OrderTicket(), 
											" Stop: ",OrderStopLoss()," Tail: ",HH);
	        	Print(errlog);
	      }
	   }
   }    
}

//+------------------------------------------------------------------+
//| 買い注文のトレール                                               |
//| ATRを使用して損切りラインを決定                                  |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       period:  ATRの期間                                         |
//|       multi:   倍数                                              |
//|       MAGICMA:マジックナンバー                                   |
//+------------------------------------------------------------------+
void BuyTrailingStopWithATR(string symbol, int period, double multi,int MAGICMA)
{ 
   bool tailed = false;

   // ATRの算出
   double atr = iATR(NULL,0,period,1) * multi;
   double LL  = High[1] - atr;
      
   for(int counter=0; counter <= OrdersTotal()-1 ; counter++)
   {
      OrderSelect(counter, SELECT_BY_POS);
      
      // 損切り価格の変更
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol && OrderType() == OP_BUY)
      {
         if(LL > OrderStopLoss())
         {
            tailed = OrderModify(OrderTicket(), OrderOpenPrice(), LL, OrderTakeProfit(),0);
         }
         
         if(tailed == false)
         {
            int errorCode = GetLastError();
	         string errdesc = ErrorDescription(errorCode);

		      string errAlert = StringConcatenate("Buy Trailing Stop With ATR- Error ",errorCode,": ",errdesc);
	        	Alert(errAlert);

		      string errlog = StringConcatenate("Bid: ", MarketInfo(symbol, MODE_BID), " Ticket:", OrderTicket(), 
											" Stop: ",OrderStopLoss()," Tail: ",LL);
	        	Print(errlog);
	      }
	   }
   }    
}

//+------------------------------------------------------------------+
//| 売り注文のトレール                                               |
//| ATRを使用して損切りラインを決定                                  |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       period:  ATRの期間                                         |
//|       multi:   倍数                                              |
//|       MAGICMA:マジックナンバー                                   |
//+------------------------------------------------------------------+
void SellTrailingStopWithATR(string symbol, int period, double multi,int MAGICMA)
{
   bool tailed = false;
   double spread = Ask - Bid;
            
   // HLBandの算出
   double atr = iATR(NULL,0,period,1) * multi;
   double HH  = Low[1] + atr + spread;
      
   for(int counter=0; counter <= OrdersTotal()-1 ; counter++)
   {
      OrderSelect(counter, SELECT_BY_POS);
      
      // 損切り価格の変更
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol && OrderType() == OP_SELL)
      {
         if(HH < OrderStopLoss() || OrderStopLoss() == 0)
         {
            tailed = OrderModify(OrderTicket(), OrderOpenPrice(), HH, OrderTakeProfit(),0);
         }
         
         if(tailed == false)
         {
            int errorCode = GetLastError();
	         string errdesc = ErrorDescription(errorCode);

		      string errAlert = StringConcatenate("Sell Trailing Stop With ATR- Error ",errorCode,": ",errdesc);
	        	Alert(errAlert);

		      string errlog = StringConcatenate("Ask: ", MarketInfo(symbol, MODE_ASK), " Ticket:", OrderTicket(), 
											" Stop: ",OrderStopLoss()," Tail: ",HH);
	        	Print(errlog);
	      }
	   }
   }    
}