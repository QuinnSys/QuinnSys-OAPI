function Simulator()
global TestTrades
if isempty(TestTrades.Open)
    return
end
global TestReport
global TestData
global TestTime
global TestAccount
%% Variable Simplification
Open = TestTrades.Open;
Instruments = fieldnames(TestData);
for ii = 1:length(Instruments)
    Data.(Instruments{ii}) = TestData.(Instruments{ii})(TestTime);
end
clear Instruments
%% Updating stops, Marking trades for closure, Recording profits
LogUpdate = false;
ClosedTrades = 0;
for ii = 1:length(Open)
    instrument = Open(ii).instrument;
%% Sell-side trade analysis
    if strcmp(Open(ii).side,'sell')
        %% Moving TrailingStop
        if strcmp(instrument(1,5:7),'JPY')
            if Open(ii).stopLoss <= Data.(instrument).lowAsk + (Open(ii).trailingStop / 100)
                Open(ii).stopLoss = Data.(instrument).lowAsk + (Open(ii).trailingStop / 100);
            end
        else
            if Open(ii).stopLoss <= Data.(instrument).lowAsk + (Open(ii).trailingStop / 10000)
                Open(ii).stopLoss = Data.(instrument).lowAsk + (Open(ii).trailingStop / 10000);
            end
        end
        %% Precision Check
        if Data.(instrument).lowAsk <= (Open(ii).takeProfit) && Data.(instrument).highAsk >= (Open(ii).stopLoss)
            TestReport.LogNum = TestReport.LogNum + 1;
            TestReport.Log(TestReport.LogNum).id   = Open(ii).id;
            TestReport.Log(TestReport.LogNum).TestTime = TestTime;
            TestReport.Log(TestReport.LogNum).detail = ...
                ['Failure: Live behaviour could not be determined. Worst case scenario selected',...
                ' Greater precision data is required to determine if the trade closed due to',...
                ' "stopLoss reached" or "takeProfit reached"'];
        end
    %% Closures
        if Data.(instrument).highAsk >= Open(ii).stopLoss
        %% StopLoss Closure
            Open(ii).endPrice = Open(ii).stopLoss;
            Open(ii).Open = false;
            ClosedTrades = ClosedTrades + 1;
            LogUpdate = true;
            Profit = (Open(ii).startPrice - Open(ii).endPrice) * Open(ii).units;
            Detail = 'stopLoss Reached';
            if strcmp(Open(ii).homeSide,'Quote')
                Open(ii).Profit = Profit;
            elseif strcmp(Open(ii).homeSide,'Base')
                Open(ii).Profit = Profit ./ Open(ii).endPrice;
            end
        elseif Data.(instrument).lowAsk <= Open(ii).takeProfit
        %% TakeProfit Closure
            Open(ii).endPrice = Open(ii).takeProfit;
            Open(ii).Open = false;
            ClosedTrades = ClosedTrades + 1;
            LogUpdate = true;
            Profit = (Open(ii).startPrice - Open(ii).endPrice) * Open(ii).units;
            Detail = 'takeProfit Reached';
            if strcmp(Open(ii).homeSide,'Quote')
                Open(ii).Profit = Profit;
            elseif strcmp(Open(ii).homeSide,'Base')
                Open(ii).Profit = Profit ./ Open(ii).endPrice;
            end
        end
        %% Updating Log with closure and skipping to next iteration
        if LogUpdate
        % Use comments to specify relevent fields to include in the report.
            TestReport.LogNum = TestReport.LogNum + 1;
            TestReport.Log(TestReport.LogNum).id   = Open(ii).id;
            TestReport.Log(TestReport.LogNum).TestTime = TestTime;
            TestReport.Log(TestReport.LogNum).action = 'Trade Closed';
            TestReport.Log(TestReport.LogNum).detail = Detail;
        %   TestReport.Log(TestReport.LogNum).profit = Open(ii).Profit;  
            LogUpdate = false;
            continue
        end
        %% Updating price and profit for open trades
        Open(ii).endPrice  = Data.(instrument).closeAsk;
        Profit = (Open(ii).startPrice - Open(ii).endPrice) * Open(ii).units;
        if strcmp(Open(ii).homeSide,'Quote')
            Open(ii).Profit = Profit;
        elseif strcmp(Open(ii).homeSide,'Base')
            Open(ii).Profit = Profit ./ Open(ii).endPrice;
        end
        continue
    end
%% Buy-side analysis    
    if strcmp(Open(ii).side,'buy')
        %% Moving TrailingStop        
        if strcmp(instrument(1,5:7),'JPY')
            if Open(ii).stopLoss >= Data.(instrument).highBid - (Open(ii).trailingStop / 100)
                Open(ii).stopLoss = Data.(instrument).highBid - (Open(ii).trailingStop / 100);
            end
        else
            if Open(ii).stopLoss >= Data.(instrument).highBid - (Open(ii).trailingStop / 10000)
                Open(ii).stopLoss = Data.(instrument).highBid - (Open(ii).trailingStop / 10000);
            end
        end
        %% Precision Check
        if Data.(instrument).highBid >= (Open(ii).takeProfit) && Data.(instrument).lowBid <= (Open(ii).stopLoss)
            TestReport.LogNum = TestReport.LogNum + 1;
            TestReport.Log(TestReport.LogNum).id   = Open(ii).id;
            TestReport.Log(TestReport.LogNum).TestTime = TestTime;
            TestReport.Log(TestReport.LogNum).detail = ...
                ['Failure: Live behaviour could not be determined. Worst case scenario selected',...
                ' Greater precision data is required to determine if the trade closed due to',...
                ' "stopLoss reached" or "takeProfit reached"'];
        end
    %% Closures
        if Data.(instrument).lowBid <= Open(ii).stopLoss
        %% StopLoss Closure
            Open(ii).endPrice = Open(ii).stopLoss;
            Open(ii).Open = false;
            ClosedTrades = ClosedTrades + 1;
            LogUpdate = true;
            Profit = (Open(ii).endPrice - Open(ii).startPrice) * Open(ii).units;
            Detail = 'stopLoss Reached';
            if strcmp(Open(ii).homeSide,'Quote')
                Open(ii).Profit = Profit;
            elseif strcmp(Open(ii).homeSide,'Base')
                Open(ii).Profit = Profit ./ Open(ii).endPrice;
            end
        elseif Data.(instrument).highBid >= Open(ii).takeProfit
        %% TakeProfit Closure
            Open(ii).endPrice = Open(ii).takeProfit;
            Open(ii).Open = false;
            ClosedTrades = ClosedTrades + 1;
            LogUpdate = true;
            Profit = (Open(ii).endPrice - Open(ii).startPrice) * Open(ii).units;
            Detail = 'takeProfit Reached';
            if strcmp(Open(ii).homeSide,'Quote')
                Open(ii).Profit = Profit;
            elseif strcmp(Open(ii).homeSide,'Base')
                Open(ii).Profit = Profit ./ Open(ii).endPrice;
            end
        end
        %% Updating Log with closure and skipping to next iteration
        if LogUpdate
        % Use comments to specify relevent fields to include in the report.
            TestReport.LogNum = TestReport.LogNum + 1;
            TestReport.Log(TestReport.LogNum).id   = Open(ii).id;
            TestReport.Log(TestReport.LogNum).TestTime = TestTime;
            TestReport.Log(TestReport.LogNum).action = 'Trade Closed';
            TestReport.Log(TestReport.LogNum).detail = Detail;
        %   TestReport.Log(TestReport.LogNum).profit = Open(ii).Profit;  
            LogUpdate = false;
            continue
        end
        %% Updating price and profit for open trades
        Open(ii).endPrice  = Data.(instrument).closeAsk;
        Profit = (Open(ii).endPrice - Open(ii).startPrice) * Open(ii).units;
        if strcmp(Open(ii).homeSide,'Quote')
            Open(ii).Profit = Profit;
        elseif strcmp(Open(ii).homeSide,'Base')
            Open(ii).Profit = Profit ./ Open(ii).endPrice;
        end
        continue
    end
end
%% Closing Trades, Updating Globals, Account Balance, etc.
OpenTrades = length(Open) - ClosedTrades;
reProfits = 0;
unProfits = 0;
for ii = length(Open):-1:1
    if Open(ii).Open == false
        TestTrades.Closed = [TestTrades.Closed; Open(ii)];
        reProfits = reProfits + Open(ii).Profit;
        Open(ii) = [];
    elseif Open(ii).Open == true
        unProfits = unProfits + Open(ii).Profit;
    end
end
TestAccount.balance = TestAccount.balance + reProfits;
TestAccount.realizedPl = TestAccount.realizedPl + reProfits;
TestAccount.unrealizedPl = unProfits;
TestAccount.openTrades = length(Open);
%% Calculating Margins, Executing Margin Calls
MarginUsed = 0;
for ii = 1:length(Open)
    MarginUsed = MarginUsed + Open(ii).cost - Open(ii).Profit;
end
TestAccount.marginUsed = MarginUsed;
TestAccount.marginAvail = TestAccount.balance - MarginUsed;
if TestAccount.marginAvail <= 0
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).Time = TestTime;
    TestReport.Log(TestReport.LogNum).detail = 'Margin Call, Backtest Terminated';
    error('\nMargin Call Unacceptable, Trading Halted','')
end
%% Updating Global
TestTrades.Open = Open;