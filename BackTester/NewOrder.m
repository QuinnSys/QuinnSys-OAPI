function OrderInfo = NewOrder(PairString,units,side,stopLoss,takeProfit,trailingStop)
%% Loading Globals and Checking Validity
global TestReport
global TestData
global TestTime
global TestAccount
global TestTrades
% Checking PairString is valid
if ~isfield(TestData,PairString)
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).Time = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        'Backtest Invalidated; NewOrder "PairString" Error';
    error('OAPI ERROR:\nRequested Instrument Not Available, Backtest Is Invalid','')
end
% Determining the relationship between the currency pair and the account's
% home currency
if strcmp(PairString(1:3),TestAccount.accountCurrency)
    homeSide = 'Base';
elseif strcmp(PairString(5:7),TestAccount.accountCurrency)
    homeSide = 'Quote';
else
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).Time = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        'Backtest Invalidated; Currency Conversion Error';
    error(sprintf(['OAPI ERROR:\n','The account currency: "%s"\n',...
        'is not represented in the pair: "%s"\n\n',...
        'The backtester currently only supports transactions in which the\n', ...
        'account''s home currency is the base or quote currency of the instrument\n\n',...
        'to accomodate this faculty further development is required\n',...
        'due to the complexity of the task and the historical data required,\n',...
        'this feature may be absent indefinitely to reduce complexity.'],...
        TestAccount.accountCurrency,PairString));
end
% Setting Transaction Price per Unit
if strcmp(side,'buy') && strcmp(homeSide,'Base')
    UnitPrice = 1;
    price     = TestData.(PairString)(TestTime).closeAsk;
elseif strcmp(side,'buy') && strcmp(homeSide,'Quote')
    UnitPrice = TestData.(PairString)(TestTime).closeAsk;
    price     = TestData.(PairString)(TestTime).closeAsk;
elseif strcmp(side,'sell') && strcmp(homeSide,'Base')
    UnitPrice = 1;
    price     = TestData.(PairString)(TestTime).closeBid;
elseif strcmp(side,'sell') && strcmp(homeSide,'Quote')
    UnitPrice = TestData.(PairString)(TestTime).closeBid;
    price     = TestData.(PairString)(TestTime).closeBid;
else
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).Time = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        'Backtest Failed; NewOrder "side" Error';
    error('OAPI ERROR:\n"side" argument malformed, side must be "buy" or "sell"','')
end
% Checking Liquidity
if (((str2double(units))*UnitPrice) * TestAccount.marginRate) > TestAccount.balance
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).Time = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        'Backtest Failed; NewOrder "Liquidity" Error';
    error('OAPI ERROR:\n"units" argument too large, trade size is greater than balance','')
end
% Checking Stops
ErrorFound = 0;
if strcmp(side,'sell')
    if str2double(stopLoss) <= TestData.(PairString)(TestTime).closeAsk
        ErrorFound = 1;
        LogString = 'Backtest failed; NewOrder "stopLoss" Error';
        ErrorString = 'OAPI ERROR:\n"stopLoss" is lower than askPrice';
    elseif str2double(takeProfit) >= TestData.(PairString)(TestTime).closeAsk
        ErrorFound = 1;
        LogString = 'Backtest failed; NewOrder "takeProfit" Error';
        ErrorString = 'OAPI ERROR:\n"takeProfit" is greater than askPrice';
    end
elseif strcmp(side,'buy')
    if str2double(stopLoss) >= TestData.(PairString)(TestTime).closeBid
        ErrorFound = 1;
        LogString = 'Backtest failed; NewOrder "stopLoss" Error';
        ErrorString = 'OAPI ERROR:\n"stopLoss" is greater than bidPrice';
    elseif str2double(takeProfit) <= TestData.(PairString)(TestTime).closeBid
        ErrorFound = 1;
        LogString = 'Backtest failed; NewOrder "takeProfit" Error';
        ErrorString = 'OAPI ERROR:\n"takeProfit" is less than bidPrice';
    end
end
if ErrorFound == 1;
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).testTime = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        LogString;
    error(ErrorString,'')
end
%% Updating Log
% Use comments to specify relevent fields to include in the report.
TestReport.LogNum = TestReport.LogNum + 1;
TestReport.Log(TestReport.LogNum).id   = TestReport.LogNum;
TestReport.Log(TestReport.LogNum).testTime = TestTime;
%TestReport.Log(TestReport.LogNum).time = TestData.(PairString)(TestTime).time;
TestReport.Log(TestReport.LogNum).action = 'NewOrder';
TestReport.Log(TestReport.LogNum).detail = ['NewOrder(',...
                                  '''',PairString,''',',...
                                       '''',units,''',',...
                                        '''',side,''',',...
                                    '''',stopLoss,''',',...
                                  '''',takeProfit,''',',...
                                 '''',trailingStop,'''',...
                                                        ')'];
%TestReport.Log(TestReport.LogNum).instrument   = PairString;
%TestReport.Log(TestReport.LogNum).units        = units;
%TestReport.Log(TestReport.LogNum).side         = side;
%TestReport.Log(TestReport.LogNum).stopLoss     = stopLoss;
%TestReport.Log(TestReport.LogNum).takeProfit   = takeProfit;
%TestReport.Log(TestReport.LogNum).trailingStop = trailingStop;
%TestReport.Log(TestReport.LogNum).price = price;
%% Opening Trade & Generating Output
%Replicating Oanda Output
OrderInfo.instrument = PairString;
OrderInfo.time       = TestData.(PairString)(TestTime).time;
OrderInfo.price      = price;
OrderInfo.tradeOpened.id = num2str(TestReport.LogNum);
OrderInfo.tradeOpened.units = str2double(units);
OrderInfo.tradeOpened.side = side;
OrderInfo.tradeOpened.takeProfit = str2double(takeProfit);
OrderInfo.tradeOpened.stopLoss = str2double(stopLoss);
OrderInfo.tradeOpened.trailingStop = str2double(trailingStop);
OrderInfo.tradesClosed = cell(0,1);
OrderInfo.tradeReduced = struct;

%% Recording Trade to Globals
%This global allows stops to work, profit to be calculated,
%trades to be modified, etc.
OpenOrder.id = TestReport.LogNum;
OpenOrder.Open = true;
OpenOrder.testTime = TestTime;
OpenOrder.time = TestData.(PairString)(TestTime).time;
OpenOrder.instrument = PairString;
OpenOrder.side = side;
OpenOrder.units = str2double(units);
OpenOrder.startPrice = price;
OpenOrder.takeProfit = str2double(takeProfit);
OpenOrder.stopLoss = str2double(stopLoss);
OpenOrder.trailingStop = str2double(trailingStop);
OpenOrder.cost = ((str2double(units))*UnitPrice) * TestAccount.marginRate;
OpenOrder.homeSide = homeSide;
OpenOrder.endPrice = price;
OpenOrder.Profit = 0;

TestTrades.Open = [TestTrades.Open , OpenOrder];
%% Updating Balance & AccountInfo
TestAccount.balance = (TestAccount.balance - OpenOrder.cost);
TestAccount.marginUsed = TestAccount.marginUsed + OpenOrder.cost;
TestAccount.marginAvail = (TestAccount.balance - TestAccount.marginUsed);
TestAccount.openTrades = TestAccount.openTrades + 1;

