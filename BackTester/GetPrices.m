function Prices = GetPrices(PairString)
%% Loading Globals and Checking Validity
global TestReport
global TestData
global TestTime
if ~isfield(TestData,PairString)
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).TestTime = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        'Backtest Invalidated; GetPrices "PairString" Error';
    error('OAPI ERROR:\nRequested Instrument Not Available, Backtest Is Invalid','')
end
%% Retrieving Prices
Prices.instrument = PairString;
Prices.time = char(TestData.(PairString)(TestTime).time);
Prices.bid  = TestData.(PairString)(TestTime).closeBid;
Prices.ask  = TestData.(PairString)(TestTime).closeAsk;
%% Updating Log
% Use comments to specify relevent fields to include in the report.
TestReport.LogNum = TestReport.LogNum + 1;
TestReport.Log(TestReport.LogNum).id   = TestReport.LogNum;
TestReport.Log(TestReport.LogNum).testTime = TestTime;
TestReport.Log(TestReport.LogNum).action = 'GetPrices';
TestReport.Log(TestReport.LogNum).detail = ['GetPrices(',...
                                    '''',PairString,'''',...
                                                         ')'];
%TestReport.Log(TestReport.LogNum).Instrument   = PairString;
end