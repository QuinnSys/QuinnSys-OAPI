function TradeBook = GetTrades
accountId = api.accountId;
TradeBook = GetTrades(api,accountId);
if isstruct(TradeBook)
    TradeBook = TradeBook.trades;
end
end