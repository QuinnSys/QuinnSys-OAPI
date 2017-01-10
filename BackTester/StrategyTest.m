tic;
%% Account Initialization
% All the details for the backtest account must be entered here.
% By default the only account has accountId: 1
global TestAccount
TestAccount = struct('accountId',1);
TestAccount.accountName  = 'BackTest';
TestAccount.balance      = 100000;
TestAccount.unrealizedPl = 0;
TestAccount.realizedPl   = 0;
TestAccount.marginUsed   = 0;
TestAccount.marginAvail  = 100000;
TestAccount.openTrades   = 0;
TestAccount.openOrders   = 0;
TestAccount.marginRate   = 0.01;
TestAccount.accountCurrency = 'EUR';

% TestTrades is the global that stores all details for open and completed
% trades and orders.
% TestTransAxe.Open stores Open trades to monitor profits, StopLosses, etc.
% TestTransAxe.History stores all actions to produce GetTransactionHistory outputs.
% TestTransAxe.Closed stores finished trades to calculate realized P/L.
global TestTrades
TestTrades.Open = struct('id',{},'Open',{},'testTime',{},...
    'time',{},'instrument',{},'side',{},'units',{},...
    'startPrice',{},'takeProfit',{},'stopLoss',{},'trailingStop',{},...
    'cost',{},'homeSide',{},'endPrice',{},'Profit',{});
TestTrades.Closed = TestTrades.Open;
%% Simulation Initialization
% WARNING USER INPUT REQUIRED
% GRANULARITY MUST MATCH THAT OF THE DATA
granularity = 'M1';
% The global "TestReport" stores important information that the 
% strategy is not allowed to access.
global TestReport
TestReport.granularity = granularity;
TestReport.LogNum      = 0;

% TestTime keeps a record of how far through the backtest data the
% simulation has reached
global TestTime
TestTime = 0;

% Here the backtest data is loaded into the global variable "TestData" so they can be
% accessed by the backtesters counterpart functions.
DataList = dir('Data');
global TestData
for ii = 3:(size(DataList,1))
    Data = load(['Data\',(DataList(ii).name)]);
    TestData.(DataList(ii).name(1:7)) = Data.(DataList(ii).name(1:7));
end;
% The following lines determine the maximum number TestTime can reach (FinishTime),
% before the simulation must end.
InstrumentList = fieldnames(TestData);
DataLengths = zeros(size(InstrumentList,1),1);  %Pre-allocating for speed
for ii = 1:size(InstrumentList,1)
    DataLengths(ii,1) = size(TestData.(InstrumentList{ii,1}),2);
end
TestReport.FinishTime = min(DataLengths);
%% Displaying information for user
clc
fprintf(['________________________\n '...
    'Available Instruments : \n'])
for ii = 1:size(InstrumentList,1)
    fprintf('                            %s\n',InstrumentList{ii,1})
end
fprintf(['\n\n', ...
    'Backtest Data Periods   :   %.0f \n', ...
    'Time to Initialize Data :   %.2fs\n', ...
    '\nInitialization Complete \n' ...
    '_________________________________\n\n'], ...
    min(DataLengths),toc)
%% Clearing old variables
clear DataList; clear Data;clear granularity;
clear DataLengths;clear ii;clear InstrumentList;
%% Loop to progress the the backtest data
while TestTime < TestReport.FinishTime
TestTime = TestTime + 1;

%% Strategy
if TestTime == 11
    HistoryEUR_USD = GetHistory('EUR_USD','M1','7')
    HistoryEUR_JPY = GetHistory('EUR_JPY','M1','10')
end
if TestTime == 14
    PricesEUR_JPY = GetPrices('EUR_JPY')
    OrderInfo = NewOrder('EUR_JPY','4123','sell',num2str(PricesEUR_JPY.bid+0.1),num2str(PricesEUR_JPY.ask-0.2),'11')
end
if TestTime == 17
    PricesEUR_USD = GetPrices('EUR_USD')
    OrderInfo = NewOrder('EUR_USD','4123','sell',num2str(PricesEUR_USD.bid+0.001),num2str(PricesEUR_USD.ask-0.002),'14')
end
if TestTime == 21
    TradeInfo = CloseTrade(TestTrades.Open(1).id)
end
if TestTime == 26
    AccountInfo = GetAccountInfo(TestAccount.accountId)
end
if TestTime == 28
    AccountList = GetAccounts
end
if TestTime == 31
    OpenTrades = GetTrades
end
if TestTime == 35
    TradeInfo = ModifyTrade(num2str(TestTrades.Open(1).id),'0','0','27')
end
%% Simulator
% This section calculates profits on open trades, executes margin calls,
% closes trades that hit stops, etc. Separating the Simulator into it's own
% function has improved readability significantly.
% "TestData.(TestTrades.Open(ii).instrument)(TestTime).closeAsk"
% Is now written in the following way: 
% Data.instrument.closeAsk;
Simulator
%SimPlot(20,2);
%pause(1)
end
%% Reporting
fprintf('\nSimulation Complete\n')
beep