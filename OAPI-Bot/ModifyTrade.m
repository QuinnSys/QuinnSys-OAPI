function TradeInfo = ModifyTrade(id,stopLoss,takeProfit,trailingStop)
% Modify the parameters of the specified trade
%% Input Organization
if ~ischar(id)
    id = num2str(id);
end
%% API Call
RawTradeInfo = ModifyTrade(api,id,stopLoss,takeProfit,trailingStop);
%% Error Checking and Report Assignment
if isfield(RawTradeInfo,'code')
    TradeInfo = RawTradeInfo;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(TradeInfo.code),TradeInfo.message);
    return
end
%% Output Assignment
TradeInfo = RawTradeInfo;
%% Data Massaging
TradeInfo.id = num2str(TradeInfo.id);
end