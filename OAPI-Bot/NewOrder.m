function OrderInfo = NewOrder(PairString,units,side,stopLoss,takeProfit,trailingStop)
% Open a new order and return it's details
%% Input Organization
%% API Call
RawOrderInfo = NewOrder(api,PairString,units,side,stopLoss,takeProfit,trailingStop);
%% Error Checking and Report Assignment
if isfield(RawOrderInfo,'code')
    OrderInfo = RawOrderInfo;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(OrderInfo.code),OrderInfo.message);
    return
end
%% Output Assignment
OrderInfo = RawOrderInfo;
%% Data Massaging
OrderInfo.tradeOpened.id = num2str(OrderInfo.tradeOpened.id);
end
