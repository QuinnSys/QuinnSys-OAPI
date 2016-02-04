function OrderBook = NewOrder(PairString,units,side,stopLoss,takeProfit,trailingStop)
TheOrder = NewOrder(api,PairString,units,side,stopLoss,takeProfit,trailingStop);
if ~exist('OrderBook','var')
    OrderBook = [];
end
pos = length(OrderBook) + 1;
OrderBook{pos} = TheOrder;
end