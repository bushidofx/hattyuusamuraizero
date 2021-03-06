//+------------------------------------------------------------------+
//|                                          bushido_commonutils.mqh |
//|                                                         bushitya |
//|                                                                  |
//|  武士道共通ライブラリヘッダファイル                              |
//|                                                                  |
//|  (注意)bushido_commonutils.ex4をlibrariesファイルに              |
//|        格納しておくこと                                          |
//+------------------------------------------------------------------+
#property copyright "bushitya"
#property link      "https://sites.google.com/site/memomemoru/home"
#property strict

#include	<stdlib.mqh>
#include	<stderror.mqh>
#include <WinUser32.mqh>

//+------------------------------------------------------------------+
//| 買い注文関数                                                     |
//| エラー発生時にアラート                                           |
//| エラーメッセージをデバックログに出力                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       lotsize: ロット数                                          |
//|       slippage:スリップページ                                    |
//|       magicnum:マジックナンバー                                  |
//|       comment:コメント                                           |
//| 返値　注文番号                                                   |
//+------------------------------------------------------------------+
int OpenBuyOrder(string symbol, double lotsize, double slippage, double magicnum, string comment = "Buy Order")
{
	while(IsTradeContextBusy())
	{
		Sleep(10);
	}

	// 買い注文
	int ticket = OrderSend(symbol, OP_BUY, lotsize, MarketInfo(symbol, MODE_ASK),
							slippage,0,0,comment,magicnum,0,Green);

	if(ticket == -1)
	{
		int errorCode = GetLastError();
		string errdesc = ErrorDescription(errorCode);

		string errAlert = StringConcatenate("Open Buy Order - Error ",errorCode,": ",errdesc);
		Alert(errAlert);

		string errlog = StringConcatenate("Bid: ", MarketInfo(symbol, MODE_BID), " Ask:", MarketInfo(symbol, MODE_ASK),
											" Lots: ", lotsize);
		Print(errlog);
	}

	return(ticket);
}

//+-------------------------------------------------------------------+
//| 売り注文関数                                                      |
//| エラー発生時にアラート                                            |
//| エラーメッセージをデバックログに出力                              |
//|                                                                   |
//| 引数  symbol:  通貨情報                                           |
//|       lotsize: ロット数                                           |
//|       slippage:スリップページ                                     |
//|       magicnum:マジックナンバー                                   |
//|       comment:コメント                                            |
//| 返値　注文番号                                                   |
//+-------------------------------------------------------------------+
int OpenSellOrder(string symbol, double lotsize, double slippage, double magicnum, string comment = "Sell Order")
{
	while(IsTradeContextBusy())
	{
		Sleep(10);
	}

	// 売り注文
	int ticket = OrderSend(symbol, OP_SELL, lotsize, MarketInfo(symbol, MODE_BID),
							slippage,0,0,comment,magicnum,0,Red);

	if(ticket == -1)
	{
		int errorCode = GetLastError();
		string errdesc = ErrorDescription(errorCode);

		string errAlert = StringConcatenate("Open Sell Order - Error ",errorCode,": ",errdesc);
		Alert(errAlert);

		string errlog = StringConcatenate("Bid: ", MarketInfo(symbol, MODE_BID), " Ask:", MarketInfo(symbol, MODE_ASK),
											" Lots: ", lotsize);
		Print(errlog);
	}

	return(ticket);
}

//+------------------------------------------------------------------+
//| 買い注文関数(リミット＆ストップ指定）                            |
//| エラー発生時にアラート                                           |
//| エラーメッセージをデバックログに出力                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       lotsize: ロット数                                          |
//|       slippage:スリップページ                                    |
//|       stopLoss: ストップロス                                     |
//|       takeProfit: 利益確定                                       |
//|       magicnum:マジックナンバー                                  |
//|       comment:コメント                                           |
//| 返値　注文番号                                                   |
//+------------------------------------------------------------------+
int OpenBuyOrderWithLimitStop(string symbol, double lotsize, double slippage, double stopLoss, 
                                 double takeProfit, double magicnum, string comment = "Buy Order") 
{
	while(IsTradeContextBusy())
	{
		Sleep(10);
	}

	// 買い注文
	int ticket = OrderSend(symbol, OP_BUY, lotsize, MarketInfo(symbol, MODE_ASK),
							slippage,stopLoss,takeProfit,comment,magicnum,0,Green);

	if(ticket == -1)
	{
		int errorCode = GetLastError();
		string errdesc = ErrorDescription(errorCode);

		string errAlert = StringConcatenate("Open Buy Order - Error ",errorCode,": ",errdesc);
		Alert(errAlert);

		string errlog = StringConcatenate("Bid: ", MarketInfo(symbol, MODE_BID), " Ask:", MarketInfo(symbol, MODE_ASK),
											" Lots: ", lotsize," StopLoss: ", stopLoss," TakeProfit: ", takeProfit);
		Print(errlog);
	}

	return(ticket);
}

//+-------------------------------------------------------------------+
//| 売り注文関数(リミット＆ストップ指定）                             |                                                      
//| エラー発生時にアラート                                            |
//| エラーメッセージをデバックログに出力                              |
//|                                                                   |
//| 引数  symbol:  通貨情報                                           |
//|       lotsize: ロット数                                           |
//|       slippage:スリップページ                                     |
//|       stopLoss: ストップロス                                      |
//|       takeProfit: 利益確定                                        |
//|       magicnum:マジックナンバー                                   |
//|       comment:コメント                                            |
//| 返値　注文番号                                                  　|
//+-------------------------------------------------------------------+
int OpenSellOrderWithLimitStop(string symbol, double lotsize, double slippage,double stopLoss, 
                                 double takeProfit, double magicnum, string comment = "Sell Order") 
{
	while(IsTradeContextBusy())
	{
		Sleep(10);
	}

	// 売り注文
	int ticket = OrderSend(symbol, OP_SELL, lotsize, MarketInfo(symbol, MODE_BID),
							slippage,stopLoss,takeProfit,comment,magicnum,0,Red);

	if(ticket == -1)
	{
		int errorCode = GetLastError();
		string errdesc = ErrorDescription(errorCode);

		string errAlert = StringConcatenate("Open Sell Order - Error ",errorCode,": ",errdesc);
		Alert(errAlert);

		string errlog = StringConcatenate("Bid: ", MarketInfo(symbol, MODE_BID), " Ask:", MarketInfo(symbol, MODE_ASK),
											" Lots: ", lotsize," StopLoss: ", stopLoss," TakeProfit: ", takeProfit);
		Print(errlog);
	}

	return(ticket);
}

//+------------------------------------------------------------------+
//| 買い（指値）注文関数                                             |
//| エラー発生時にアラート                                           |
//| エラーメッセージをデバックログに出力                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       lotsize: ロット数                                          |
//|       argPendingPrice: ペンディングプライス                      |
//|       argStopLoss: ストップロス                                  |
//|       argTakeProfit: 利確ポイント                                |
//|       slippage:スリップページ                                    |
//|       magicnum:マジックナンバー                                  |
//|       expiration: 有効期限                                       |
//|       comment:コメント                                           |
//| 返値　注文番号                                                   |
//+------------------------------------------------------------------+
int OpenBuyLimitOrder(string symbol, double lotsize, double pendingPrice, double stopLoss, 
                     double takeProfit, double slippage, double magicnum, datetime expiration, string comment = "Buy Limit Order")
{
	while(IsTradeContextBusy())
	{
		Sleep(10);
	}

	// 買い注文
	int ticket = OrderSend(symbol, OP_BUYLIMIT, lotsize, pendingPrice, slippage,stopLoss,takeProfit,comment,magicnum,expiration,Green);

	if(ticket == -1)
	{
		int errorCode = GetLastError();
		string errdesc = ErrorDescription(errorCode);

		string errAlert = StringConcatenate("Open Buy Limit Order - Error ",errorCode,": ",errdesc);
		Alert(errAlert);

		string errlog = StringConcatenate("Ask: ", MarketInfo(symbol, MODE_ASK), " Lots:", lotsize, " Price:", pendingPrice,
											" Stop: ",stopLoss," Profit: ",takeProfit," Expiration: ", TimeToStr(expiration));
		Print(errlog);
	}

	return(ticket);
}

//+------------------------------------------------------------------+
//| 売り（指値）注文関数                                             |
//| エラー発生時にアラート                                           |
//| エラーメッセージをデバックログに出力                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       lotsize: ロット数                                          |
//|       argPendingPrice: ペンディングプライス                      |
//|       argStopLoss: ストップロス                                  |
//|       argTakeProfit: 利確ポイント                                |
//|       slippage:スリップページ                                    |
//|       magicnum:マジックナンバー                                  |
//|       expiration: 有効期限                                       |
//|       comment:コメント                                           |
//| 返値　注文番号                                                   |
//+------------------------------------------------------------------+
int OpenSellLimitOrder(string symbol, double lotsize, double pendingPrice, double stopLoss, 
                     double takeProfit, double slippage, double magicnum, datetime expiration, string comment = "Sell Limit Order")
{
	while(IsTradeContextBusy())
	{
		Sleep(10);
	}

	// 売り注文
	int ticket = OrderSend(symbol, OP_SELLLIMIT, lotsize, pendingPrice,
							slippage,stopLoss,takeProfit,comment,magicnum,expiration,Red);

	if(ticket == -1)
	{
		int errorCode = GetLastError();
		string errdesc = ErrorDescription(errorCode);

		string errAlert = StringConcatenate("Open Sell Limit Order - Error ",errorCode,": ",errdesc);
		Alert(errAlert);

		string errlog = StringConcatenate("Bid: ", MarketInfo(symbol, MODE_BID), " Lots:", lotsize, " Price:", pendingPrice,
											" Stop: ",stopLoss," Profit: ",takeProfit," Expiration: ", TimeToStr(expiration));
		Print(errlog);
	}

	return(ticket);
}

//+------------------------------------------------------------------+
//| 買いポジション決済関数                                           |
//| エラー発生時にアラート                                           |
//| エラーメッセージをデバックログに出力                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       closeTicket: 注文番号                                      |
//|       slippage:スリップページ                                    |
//| 返値　成功であればtrue                                           |
//+------------------------------------------------------------------+
bool CloseBuyOrder(string symbol, int closeTicket, double slippage)
{
   bool closed=false;
   OrderSelect(closeTicket, SELECT_BY_TICKET);

   if(OrderCloseTime() == 0)
   {
      double closeLots = OrderLots();
      
      while(IsTradeContextBusy())
      {
         Sleep(10);
      }
      
      double closePrice = MarketInfo(symbol, MODE_BID);
      closed = OrderClose(closeTicket, closeLots, closePrice, slippage, Green);
      
      if(closed == false)
      {
        int errorCode = GetLastError();
		  string errdesc = ErrorDescription(errorCode);

    	  string errAlert = StringConcatenate("Close Buy Order - Error ",errorCode,": ",errdesc);
		  Alert(errAlert);

	     string errlog = StringConcatenate("Ticket: ", closeTicket, "Bid: ", MarketInfo(symbol, MODE_BID));
	  	  Print(errlog);
     } 
   }
   
   return(closed);
}

//+------------------------------------------------------------------+
//| 売りポジション決済関数                                           |
//| エラー発生時にアラート                                           |
//| エラーメッセージをデバックログに出力                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       closeTicket: 注文番号                                      |
//|       slippage:スリップページ                                    |
//| 返値　成功であればtrue                                           |
//+------------------------------------------------------------------+
bool CloseSellOrder(string symbol, int closeTicket, double slippage)
{
   bool closed=false;
   OrderSelect(closeTicket, SELECT_BY_TICKET);
   
   if(OrderCloseTime() == 0)
   {
      double closeLots = OrderLots();
      
      while(IsTradeContextBusy())
      {
         Sleep(10);
      }
      
      double closePrice = MarketInfo(symbol, MODE_ASK);
      closed = OrderClose(closeTicket, closeLots, closePrice, slippage, Red);
      
      if(closed == false)
      {
        int errorCode = GetLastError();
		  string errdesc = ErrorDescription(errorCode);

    	  string errAlert = StringConcatenate("Close Sell Order - Error ",errorCode,": ",errdesc);
		  Alert(errAlert);

	     string errlog = StringConcatenate("Ticket: ", closeTicket, "Ask: ", MarketInfo(symbol, MODE_ASK));
	  	  Print(errlog);
     } 
   }
   
   return(closed);
}

//+------------------------------------------------------------------+
//| 全ポジション決済関数                                             |
//| エラー発生時にアラート                                           |
//| エラーメッセージをデバックログに出力                             |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       slippage:スリップページ                                    |
//|       MAGICMA:マジックナンバー                                    |
//| 返値　成功であればtrue                                           |
//+------------------------------------------------------------------+
bool CloseAllOrders(string symbol, int MAGICMA,  double slippage)
{
   bool closed=false;
   for(int counter=0; counter<=OrdersTotal()-1;counter++)
   {
      OrderSelect(counter, SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol 
         && (OrderType() == OP_BUY || OrderType() == OP_SELL))
      {
         if(OrderCloseTime() == 0)
         {
            double closeLots = OrderLots();
      
            while(IsTradeContextBusy())
            {
             Sleep(10);
            }
            
            double closePrice;
            if(OrderType() == OP_BUY)
            {
               closePrice = MarketInfo(symbol, MODE_BID);
            }else if(OrderType() == OP_SELL)
            {
               closePrice = MarketInfo(symbol, MODE_ASK);
            }
            
            closed = OrderClose(OrderTicket(), closeLots, closePrice, slippage, Green);
            
            if(closed == false)
            {
               int errorCode = GetLastError();
		         string errdesc = ErrorDescription(errorCode);

    	         string errAlert = StringConcatenate("Close Order - Error ",errorCode,": ",errdesc);
		         Alert(errAlert);

	            string errlog = StringConcatenate("Ticket: ", counter);
	  	         Print(errlog);
            } 
          }
      }
      
   }
   
   return(closed);
}

//+------------------------------------------------------------------+
//| 注文数を算出する                                                 |
//| 買い注文があれば買い注文数を返す    　　　                 　　　|
//| 買い注文がなければ売り注文数を返す                               |
//|                                                                  |
//| 引数  symbol:  通貨情報                                          |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　注文数                                                     |
//+------------------------------------------------------------------+
int CalculateCurrentOrders(string symbol, int MAGICMA)
  {
   int buys=0,sells=0;
   //----
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) 
      {
         break;
      }
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
      {
         if(OrderType()==OP_BUY)
         {  
            buys++;
         }
         if(OrderType()==OP_SELL)
         { 
            sells++;
         }
      }
   }

   //---- return orders volume
   if(buys>0)
   { 
      return(buys);
   }
   else
   {       
      return(-sells);
   }
  }


//+------------------------------------------------------------------+
//| ロット数を算出する                                               |
//| 余剰証拠金からレバレッジと損失ロット数により算出                 |
//|                                                                  |
//| 引数  lots: 　ロット数                                           |
//|       MaximumRisk: 最大リスク（レバレッジ)                       |
//|       DecreaseFactor: 損失許容ロット数                           |
//| 返値　ロット数                                                   |
//+------------------------------------------------------------------+
double LotsOptimized(double lots, double MaximumRisk, double DecreaseFactor)
  {
   double lot=lots;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
   double currencyTotal;
   
   if(PipsPointSymbol(Symbol()) == 0.0001)
   {
      currencyTotal = 1000;
   }
   else
   {
      currencyTotal = 100000;
   }
   
   //---- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/currencyTotal,1);
   
   //---- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1;i>=0;i--)
      {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false) 
         { 
            Print("Error in history!"); 
            break; 
         }
         
         if(OrderSymbol()!=Symbol() || OrderType()>OP_SELL) 
         {
            continue;
         }
         //----
         if(OrderProfit()>0)
         { 
            break;
         }
         if(OrderProfit()<0) 
         {
            losses++;
         }
      }
      if(losses>1 && DecreaseFactor>losses ) 
      {
         lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
      }
   }
   //---- return lot size
   if(lot<0.1) 
   {
      lot=0.1;
   }
   double maxLot   = MarketInfo(Symbol(),MODE_MAXLOT);
   if(lot > maxLot) {
      lot = maxLot;
   }
      
   return(lot);
  }

//+------------------------------------------------------------------+
//| 1pipあたりの通貨単位を返す                                       |
//|                                                                  |
//| 引数  symbol: 　通貨情報                                         |
//| 返値　1pipあたりの通貨単位                                       |
//+------------------------------------------------------------------+
double PipsPointSymbol(string symbol)
{
   double calcPoint;
   
   int calsDigits = MarketInfo(symbol, MODE_DIGITS);
   
   if(calsDigits == 2 || calsDigits == 3)
   {
      calcPoint = 0.01;
   }
   else if(calsDigits == 4 || calsDigits == 5)
   {
      calcPoint = 0.0001;
   }
   
   return(calcPoint);
}

//+------------------------------------------------------------------+
//| 買い注文数を返す                                                 |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　注文数                                                     |
//+------------------------------------------------------------------+
int BuyMarketCount(string symbol, int MAGICMA)
{
   int orderCount=0;
   
   for(int counter=0; counter<=OrdersTotal()-1;counter++)
   {
      OrderSelect(counter, SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol && OrderType() == OP_BUY)
      {
         orderCount++;
      }
   }
   return(orderCount);
}

//+------------------------------------------------------------------+
//| 売り注文数を返す                                                 |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　注文数                                                     |
//+------------------------------------------------------------------+
int SellMarketCount(string symbol, int MAGICMA)
{
   int orderCount=0;
   
   for(int counter=0; counter<=OrdersTotal()-1;counter++)
   {
      OrderSelect(counter, SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol && OrderType() == OP_SELL)
      {
         orderCount++;
      }
   }
   return(orderCount);
}

//+------------------------------------------------------------------+
//| 勝ちトレード数を返す                                             |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　勝ちトレード数                                             |
//+------------------------------------------------------------------+
int WinTradeCount(string symbol, int MAGICMA)
{
   int winCount=0;
   
   for(int counter=0; counter<=OrdersHistoryTotal() -1;counter++)
   {
      OrderSelect(counter, SELECT_BY_POS,MODE_HISTORY);
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol)
      {
         if(OrderProfit() > 0)
         {
            winCount++;
         }
      }
   }
   return(winCount);
}

//+------------------------------------------------------------------+
//| 売りトレード数を返す                                             |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　売りトレード数                                             |
//+------------------------------------------------------------------+
int LoseTradeCount(string symbol, int MAGICMA)
{
   int loseCount=0;
   
   for(int counter=0; counter<=OrdersHistoryTotal() -1;counter++)
   {
      OrderSelect(counter, SELECT_BY_POS,MODE_HISTORY);
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol)
      {
         if(OrderProfit() < 0)
         {
            loseCount++;
         }
      }
   }
   return(loseCount);
}

//+------------------------------------------------------------------+
//| 買いポジションのストップロスのチャート値を返す                   |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       stopLoss: ストップロス(PIPS)                               |
//| 返値　チャート値                                                 |
//+------------------------------------------------------------------+
double BuyStopLoss(string symbol, double stopLoss)
{
   double buyStopLoss = 0;
   
   if(stopLoss > 0)
   {
      buyStopLoss = Ask - (stopLoss * PipsPointSymbol(symbol));
   }
   
   return(buyStopLoss);
} 

//+------------------------------------------------------------------+
//| 売りポジションのストップロスのチャート値を返す                   |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       stopLoss: ストップロス(PIPS)                               |
//| 返値　チャート値                                                 |
//+------------------------------------------------------------------+
double SellStopLoss(string symbol, double stopLoss)
{
   double sellStopLoss = 0;
   
   if(stopLoss > 0)
   {
      sellStopLoss = Bid + (stopLoss * PipsPointSymbol(symbol));
   }
   
   return(sellStopLoss);
} 

//+------------------------------------------------------------------+
//| 買いポジションのリミットのチャート値を返す                       |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       takeProfit: 利確ポイント(PIPS)                             |
//| 返値　チャート値                                                 |
//+------------------------------------------------------------------+
double BuyTakeProfit(string symbol, double takeProfit)
{
   double buyLimit = 0;
   
   if(takeProfit > 0)
   {
      buyLimit = Ask + (takeProfit * PipsPointSymbol(symbol));
   }
   
   return(buyLimit);
} 

//+------------------------------------------------------------------+
//| 売りポジションのリミットのチャート値を返す                       |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       takeProfit: 利確ポイント(PIPS)                             |
//| 返値　チャート値                                                 |
//+------------------------------------------------------------------+
double SellTakeProfit(string symbol, double takeProfit)
{
   double sellLimit = 0;
   
   if(takeProfit > 0)
   {
      sellLimit = Bid  -  (takeProfit * PipsPointSymbol(symbol));
   }
   
   return(sellLimit);
} 

//+------------------------------------------------------------------+
//| 買いポジションのエントリーにPIPSを加算　　                       |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       price: プライス　　　　　　　・                            |
//|       bufferPips: 加算するPIPS　　　　　　　　                   |
//| 返値　加算した値                                                 |
//+------------------------------------------------------------------+
double BufferBuyPrice(string symbol,double price, double bufferPips)
{
   double point = PipsPointSymbol(symbol);
   
   return (price + point * bufferPips); 
}

//+------------------------------------------------------------------+
//| 売りポジションのエントリーにPIPSを減算　　                       |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       price: プライス　　　　　　　・                            |
//|       bufferPips: 減算するPIPS　　　　　　　　                   |
//| 返値　減算した値                                                 |
//+------------------------------------------------------------------+
double BufferSellPrice(string symbol,double price, double bufferPips)
{
   double point = PipsPointSymbol(symbol);
   
   return (price - point * bufferPips); 
}

//+------------------------------------------------------------------+
//| 同じ時間にエントリーしたポジションの有無をチェック　　           |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　同じ時間にエントリーしたポジションがあったらtrue           |
//+------------------------------------------------------------------+
bool CheckSameEntry(string symbol,int MAGICMA)
{
   bool result = false;
   
   for(int counter=0; counter<=OrdersTotal()-1;counter++)
   {
      OrderSelect(counter, SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol 
         && (OrderType() == OP_SELL || OrderType() == OP_BUY))
      {
         if(OrderOpenTime() == Time[0])
         {
            result = true;
            break;
         }
      }
   }
   
   return(result);
}

//+------------------------------------------------------------------+
//| 同じ時間にエントリーしたポジションの有無をチェック　　           |
//| 決済履歴を含めて検索                                             |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　同じ時間にエントリーしたポジション・決済履歴があったらtrue |
//+------------------------------------------------------------------+
bool CheckSameEntryWithHistory(string symbol,int MAGICMA)
{
   bool result = false;
   
   for(int counter=0; counter<=OrdersTotal()-1;counter++)
   {
      OrderSelect(counter, SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol 
         && (OrderType() == OP_SELL || OrderType() == OP_BUY))
      {
         if(OrderOpenTime() == Time[0])
         {
            result = true;
            break;
         }
      }
   }
   
   if(result == false)
   {
      for(int counter2=0; counter2<=OrdersHistoryTotal()-1;counter2++)
      {
         OrderSelect(counter2, SELECT_BY_POS,MODE_HISTORY);
         if(OrderMagicNumber() == MAGICMA && OrderSymbol() == symbol)
         {
            if(OrderOpenTime() == Time[0])
            {
               result = true;
               break;
            }
         }
      }
   }
   
   return(result);
}

//+------------------------------------------------------------------+
//| 自動売買OKかを判定                                　　           |
//| 自動売買がOKであればtrueを返す                                   |
//|                                                                  |
//| 引数  period: 時間足                                             |
//| 返値　自動売買OKならtrue                                         |
//+------------------------------------------------------------------+
bool IsTradingAllowed(int period)
{
   bool result  = true;
   
   //---- check for history and trading
   if(IsTradeAllowed()==false)
   {
      Print("Trade is not allowed.");
      result = false;
   }
   
   if(Period() != period)
   {
      Print("Period is not " + period);
      
      int ret = MessageBox("時間軸が" + period + "ではありません。操作を続行しますか？",
                              "Question",MB_YESNO|MB_ICONQUESTION);
      
      if(ret == IDNO)
      {
         result = false;
      }
   }
   
   return (result);
}

//+------------------------------------------------------------------+
//| 現在の時刻が指定した開始時刻から終了時刻までの範囲かをチェック   |
//|                                                                  |
//| 引数  statLocalTime: 開始時刻                                    |
//| 引数  stopLocalTime: 終了時刻                                    |
//| 返値　現在の時刻が範囲内であればtrue   　　                      |
//+------------------------------------------------------------------+
bool checkTime(string startLocalTime, string stopLocalTime)
{
   int current = TimeHour(TimeLocal())*60+TimeMinute(TimeLocal());
   
   if(current >=GetMinute(startLocalTime) && current < GetMinute(stopLocalTime) ) 
   {
      return(true);
   }
   
   if( (GetMinute(startLocalTime) > GetMinute(stopLocalTime)) 
    && (current >=GetMinute(startLocalTime) || current <GetMinute(stopLocalTime) )) 
   {
      return(true);
   }

   return(false);
}

int GetMinute(string time)
{
   int split= StringFind(time,":");
   int h = StrToInteger(StringSubstr(time,0,split+1));
   int m = StrToInteger(StringSubstr(time,split+1,2)); 
   return(h*60 + m);
}

//+------------------------------------------------------------------+
//| 現在の時刻が最初の時刻かをチェック                               |
//| 最初のバーであることをチェック                                   |
//|                                                                  |
//| 引数  prevtime: 時刻（static intであること）                     |
//| 返値　最初の時刻であればtrue           　　                      |
//+------------------------------------------------------------------+
bool CheckFirstTime(int prevtime)
{
   if(Time[0]==prevtime)
   {
      return(false);
   }
   
   prevtime=Time[0];
   
   return (true);
}

//+------------------------------------------------------------------+
//| 買い注文の合計ロット数を取得                               |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　合計ロット数           　　                      |
//+------------------------------------------------------------------+
double GetBuyTotalLots(string symbol,int MAGICMA)
{
   // オープンポジションの合計ロット数
   double lots = 0.0;
   for(int i=0; i<=OrdersTotal()-1; i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) 
         break;
      if(OrderSymbol() != symbol) 
         continue;
      if(OrderMagicNumber() != MAGICMA) 
         continue;
      if(OrderType() == OP_BUY) 
         lots += OrderLots();
   }

   return lots;
}

//+------------------------------------------------------------------+
//| 売り注文の合計ロット数を取得                               |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　合計ロット数           　　                      |
//+------------------------------------------------------------------+
double GetSellTotalLots(string symbol,int MAGICMA)
{
   // オープンポジションの合計ロット数
   double lots = 0.0;
   for(int i=0; i<=OrdersTotal()-1; i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) 
         break;
      if(OrderSymbol() != symbol) 
         continue;
      if(OrderMagicNumber() != MAGICMA) 
         continue;
      if(OrderType() == OP_SELL) 
         lots += OrderLots();
   }

   return lots;
}

//+------------------------------------------------------------------+
//| 買い注文の平均レートを算出                               |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　平均レート           　　                      |
//+------------------------------------------------------------------+
double GetBuyAverateRate(string symbol,int MAGICMA)
{
   double ave = 0.0;
   int count=0;
   for(int i=0; i<=OrdersTotal()-1; i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) 
         break;
      if(OrderSymbol() != symbol) 
         continue;
      if(OrderMagicNumber() != MAGICMA) 
         continue;
      if(OrderType() == OP_BUY) 
      {
         count++;
         ave += OrderOpenPrice();
      }
   }

   return (count==0) ? 0 : ave/count;
}

//+------------------------------------------------------------------+
//| 売り注文の平均レートを算出                               |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　平均レート           　　                      |
//+------------------------------------------------------------------+
double GetSellAverateRate(string symbol,int MAGICMA)
{
   double ave = 0.0;
   int count=0;
   for(int i=0; i<=OrdersTotal()-1; i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) 
         break;
      if(OrderSymbol() != symbol) 
         continue;
      if(OrderMagicNumber() != MAGICMA) 
         continue;
      if(OrderType() == OP_SELL) 
      {
         count++;
         ave += OrderOpenPrice();
      }
   }

   return (count==0) ? 0 : ave/count;
}

//+------------------------------------------------------------------+
//| 買い注文の平均損益PIPSを算出                               |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　平均レート           　　                      |
//+------------------------------------------------------------------+
double GetBuyTotalPIPS(string symbol,int MAGICMA)
{
   double sum = 0.0;
   int count=0;

   for(int i=0; i<=OrdersTotal()-1; i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) 
         break;
      if(OrderSymbol() != symbol) 
         continue;
      if(OrderMagicNumber() != MAGICMA) 
         continue;
      if(OrderType() == OP_BUY)
      {
         sum += Bid - OrderOpenPrice();
         count++;
      }
   }

   return (count==0) ? 0 : (sum/count) / PipsPointSymbol(symbol);
}

//+------------------------------------------------------------------+
//| 売り注文の平均損益PIPSを算出                               |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　平均レート           　　                      |
//+------------------------------------------------------------------+
double GetSellTotalPIPS(string symbol,int MAGICMA)
{
   double sum = 0.0;
   int count=0;

   for(int i=0; i<=OrdersTotal()-1; i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) 
         break;
      if(OrderSymbol() != symbol) 
         continue;
      if(OrderMagicNumber() != MAGICMA) 
         continue;
      if(OrderType() == OP_SELL) 
      {
         sum += OrderOpenPrice() - Ask;
         count++;
      }
   }
   
   return (count==0) ? 0 : (sum/count) / PipsPointSymbol(symbol);
}


//+------------------------------------------------------------------+
//| 買い注文の合計損益を算出                               |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　平均レート           　　                      |
//+------------------------------------------------------------------+
double GetBuyTotalProfit(string symbol,int MAGICMA)
{
   double sum = 0.0;

   for(int i=0; i<=OrdersTotal()-1; i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) 
         break;
      if(OrderSymbol() != symbol) 
         continue;
      if(OrderMagicNumber() != MAGICMA) 
         continue;
      if(OrderType() == OP_BUY) 
         sum += OrderProfit();
   }

   return sum;
}

//+------------------------------------------------------------------+
//| 売り注文の合計損益を算出                               |
//|                                                                  |
//| 引数  symbol: 　通貨情報                  　                     |
//|       MAGICMA: マジックナンバー                                  |
//| 返値　平均レート           　　                      |
//+------------------------------------------------------------------+
double GetSellTotalProfit(string symbol,int MAGICMA)
{
   double sum = 0.0;

   for(int i=0; i<=OrdersTotal()-1; i++)
   {
      if(OrderSelect(i, SELECT_BY_POS) == false) 
         break;
      if(OrderSymbol() != symbol) 
         continue;
      if(OrderMagicNumber() != MAGICMA) 
         continue;
      if(OrderType() == OP_SELL) 
         sum += OrderProfit();
   }

   return sum;
}