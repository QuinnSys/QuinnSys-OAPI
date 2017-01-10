function TradeInfo = CloseTrade(id)
if ischar(id)
    id = str2double(id);
end
global TestReport
global TestData
global TestTime
global TestAccount
global TestTrades
TradeExists = false;
for ii = 1:length(TestTrades.Open)
    if TestTrades.Open(ii).id == id
        TradeExists = true;
        instrument = TestTrades.Open(ii).instrument;
        Trades = length(TestTrades.Open);
        break
    end
end
if TradeExists == false
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).id   = TestReport.LogNum;
    TestReport.Log(TestReport.LogNum).testTime = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        'Backtest Failed; CloseTrade "id" Error';
    error('OAPI ERROR:\n"id" argument malformed, id does not exist','')
end
%% Sell Side Closure
if strcmp(TestTrades.Open(ii).side,'sell')
    side = 'sell';
    TestTrades.Open(ii).endPrice = TestData.(instrument)(TestTime).closeAsk;
    TestTrades.Open(ii).Open = false;
    Profit = (TestTrades.Open(ii).startPrice - TestTrades.Open(ii).endPrice) * TestTrades.Open(ii).units;
    Detail = 'Sell Trade Closed';
    if strcmp(TestTrades.Open(ii).homeSide,'Quote')
        TestTrades.Open(ii).Profit = Profit;
    elseif strcmp(TestTrades.Open(ii).homeSide,'Base')
        TestTrades.Open(ii).Profit = Profit ./ TestTrades.Open(ii).endPrice;
    end
end
%% Buy Side Closure        
if strcmp(TestTrades.Open(ii).side,'buy')
    side = 'buy';
    TestTrades.Open(ii).endPrice = TestData.(instrument)(TestTime).closeBid;
    TestTrades.Open(ii).Open = false;
    Profit = (TestTrades.Open(ii).endPrice - TestTrades.Open(ii).startPrice) * TestTrades.Open(ii).units;
    Detail = 'Buy Trade Closed';
    if strcmp(TestTrades.Open(ii).homeSide,'Quote')
        TestTrades.Open(ii).Profit = Profit;
    elseif strcmp(TestTrades.Open(ii).homeSide,'Base')
        TestTrades.Open(ii).Profit = Profit ./ TestTrades.Open(ii).endPrice;
    end
end
%% Producing Output
TradeInfo.id = num2str(id);
TradeInfo.price = TestTrades.Open(ii).endPrice;
TradeInfo.profit = TestTrades.Open(ii).Profit;
TradeInfo.instrument = instrument;
TradeInfo.side = side;
TradeInfo.time = TestData.(instrument)(TestTime).time;
%% Updating Log with closure
% Use comments to specify relevent fields to include in the report.
TestReport.LogNum = TestReport.LogNum + 1;
TestReport.Log(TestReport.LogNum).id   = id;
TestReport.Log(TestReport.LogNum).testTime = TestTime;
TestReport.Log(TestReport.LogNum).action = 'Trade Closed';
TestReport.Log(TestReport.LogNum).detail = Detail;
TestReport.Log(TestReport.LogNum).profit = TestTrades.Open(ii).Profit;  
%% Closing Trade
reProfits = 0;
unProfits = 0;
for ii = Trades:-1:1
    if TestTrades.Open(ii).Open == false
        TestTrades.Closed = [TestTrades.Closed; TestTrades.Open(ii)];
        reProfits = reProfits + TestTrades.Open(ii).Profit;
        TestTrades.Open(ii) = [];
    elseif TestTrades.Open(ii).Open == true
        unProfits = unProfits + TestTrades.Open(ii).Profit;
    end
end
TestAccount.balance = TestAccount.balance + reProfits;
TestAccount.realizedPl = TestAccount.realizedPl + reProfits;
TestAccount.unrealizedPl = unProfits;
%% Calculating Margins
MarginUsed = 0;
for ii = 1:(Trades - 1)
    MarginUsed = MarginUsed + TestTrades.Open(ii).cost - TestTrades.Open(ii).Profit;
end
TestAccount.marginUsed = MarginUsed;
TestAccount.marginAvail = TestAccount.balance - MarginUsed;
TestAccount.openTrades = length(TestTrades.Open);
