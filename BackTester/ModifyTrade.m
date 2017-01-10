function TradeInfo = ModifyTrade(id,stopLoss,takeProfit,trailingStop)
%% Variable Initialization
global TestTrades
global TestReport
global TestData
global TestTime
global TestAccount
Open = TestTrades.Open;
Trade = 0;
for ii = 1:length(Open)
    if strcmp(id,num2str(Open(ii).id))
        Trade = Open(ii);
        TradeNum = ii;
    end
end
stopLoss = str2double(stopLoss);
takeProfit = str2double(takeProfit);
trailingStop = str2double(trailingStop);
%% Checking Trade Exists
if ~isstruct(Trade)
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).id   = TestReport.LogNum;
    TestReport.Log(TestReport.LogNum).testTime = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        'Backtest Failed; ModifyTrade "id" Error';
    error('OAPI ERROR:\n"id" argument malformed, id does not exist','')
end
instrument = Trade.instrument;
%% Checking Stops
ErrorFound = 0;
side = Trade.side;
if strcmp(side,'sell')
    if stopLoss <= TestData.(instrument)(TestTime).closeAsk && (~strcmp(num2str(stopLoss),'0'))
        ErrorFound = 1;
        LogString = 'Backtest failed; ModifyTrade "stopLoss" Error';
        ErrorString = 'OAPI ERROR:\n"stopLoss" is lower than bidPrice';
    elseif takeProfit >= TestData.(instrument)(TestTime).closeAsk && (~strcmp(num2str(takeProfit),'0'))
        ErrorFound = 1;
        LogString = 'Backtest failed; ModifyTrade "takeProfit" Error';
        ErrorString = 'OAPI ERROR:\n"takeProfit" is greater than bidPrice';
    end
elseif strcmp(side,'buy')
    if stopLoss >= TestData.(instrument)(TestTime).closeBid && (~strcmp(num2str(stopLoss),'0'))
        ErrorFound = 1;
        LogString = 'Backtest failed; ModifyTrade "stopLoss" Error';
        ErrorString = 'OAPI ERROR:\n"stopLoss" is greater than bidPrice';
    elseif takeProfit <= TestData.(instrument)(TestTime).closeBid && (~strcmp(num2str(takeProfit),'0'))
        ErrorFound = 1;
        LogString = 'Backtest failed; ModifyTrade "takeProfit" Error';
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
%% Trade Modification
if strcmp(Trade.side,'sell')
    %% Editing stopLoss
    if stopLoss ~= 0
        Trade.stopLoss = stopLoss;
    end
    %% Editing takeProfit
    if takeProfit ~= 0
        Trade.takeProfit = takeProfit;
    end
    %% Editing trailingStop
    if trailingStop ~= 0
        Trade.trailingStop = trailingStop;
    end
end
%% Generating Output
TradeInfo.id = num2str(id);
TradeInfo.units = Trade.units;
TradeInfo.side = Trade.side;
TradeInfo.instrument = instrument;
TradeInfo.time = Trade.time;
TradeInfo.price = Trade.startPrice;
TradeInfo.takeProfit = Trade.takeProfit;
TradeInfo.stopLoss = Trade.stopLoss;
TradeInfo.trailingStop = Trade.trailingStop;
if strcmp(Trade.side,'sell')
    if strcmp(instrument(1,5:7),'JPY')
        TradeInfo.trailingAmount = TestData.(instrument)(TestTime).closeAsk + (Trade.trailingStop / 100);
    else
        TradeInfo.trailingAmount = TestData.(instrument)(TestTime).closeAsk + (Trade.trailingStop / 10000);
    end
elseif strcmp(Trade.side,'buy')
    if strcmp(instrument(1,5:7),'JPY')
        TradeInfo.trailingAmount = TestData.(instrument)(TestTime).closeBid - (Trade.trailingStop / 100);
    else
        TradeInfo.trailingAmount = TestData.(instrument)(TestTime).closeBid + (Trade.trailingStop / 10000);
    end
end
%% Updating Globals
TestTrades.Open(TradeNum) = Trade;
%% Updating Log
% Use comments to specify relevent fields to include in the report.
TestReport.LogNum = TestReport.LogNum + 1;
TestReport.Log(TestReport.LogNum).id   = TestReport.LogNum;
TestReport.Log(TestReport.LogNum).testTime = TestTime;
%TestReport.Log(TestReport.LogNum).time = TestData.(instrument)(TestTime).time;
TestReport.Log(TestReport.LogNum).action = 'ModifyTrade';
TestReport.Log(TestReport.LogNum).detail = ['ModifyTrade(',...
                                          '''',id,''',',...
                                    '''',stopLoss,''',',...
                                  '''',takeProfit,''',',...
                                 '''',trailingStop,'''',...
                                                        ')'];
%TestReport.Log(TestReport.LogNum).instrument   = instrument;
%TestReport.Log(TestReport.LogNum).stopLoss     = stopLoss;
%TestReport.Log(TestReport.LogNum).takeProfit   = takeProfit;
%TestReport.Log(TestReport.LogNum).trailingStop = trailingStop;