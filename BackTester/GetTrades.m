function OpenTrades = GetTrades(accountId)
global TestAccount
global TestTrades
global TestData
global TestTime
if nargin == 0
    accountId = TestAccount.accountId;
end
%% Generating Output
for ii = 1:length(TestTrades.Open)
    Trade = TestTrades.Open(ii);
    OpenTrade.id = num2str(Trade.id);
    OpenTrade.units = Trade.units;
    OpenTrade.side = Trade.side;
    OpenTrade.instrument = Trade.instrument;
    OpenTrade.time = Trade.time;
    OpenTrade.price = Trade.startPrice;
    OpenTrade.takeProfit = Trade.takeProfit;
    OpenTrade.stopLoss = Trade.stopLoss;
    OpenTrade.trailingStop = Trade.trailingStop;
    if strcmp(Trade.side,'sell')
        if strcmp(Trade.instrument(1,5:7),'JPY')
            OpenTrade.trailingAmount = TestData.(Trade.instrument)(TestTime).closeAsk + (Trade.trailingStop / 100);
        else
            OpenTrade.trailingAmount = TestData.(Trade.instrument)(TestTime).closeAsk + (Trade.trailingStop / 10000);
        end
    elseif strcmp(Trade.side,'buy')
        if strcmp(instrument(1,5:7),'JPY')
            OpenTrade.trailingAmount = TestData.(Trade.instrument)(TestTime).closeBid - (Trade.trailingStop / 100);
        else
            OpenTrade.trailingAmount = TestData.(Trade.instrument)(TestTime).closeBid + (Trade.trailingStop / 10000);
        end
    end
    OpenTrades(ii) = OpenTrade;
end
end

