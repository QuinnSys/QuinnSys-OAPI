function History = GetHistory(PairString,granularity,count)
%% Loading Globals
global TestReport
global TestData
global TestTime

%% Checking Validity
if ~strcmp(granularity,TestReport.granularity)
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).Time = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        'Backtest Invalidated; GetHistory "granularity" Error';
    error('OAPI ERROR:\nRequested Granularity Not Available, Backtest Is Invalid','')
end
count = str2double(count);
if count > TestTime
    count = TestTime;
end
if ~isfield(TestData,PairString)
    TestReport.LogNum = TestReport.LogNum + 1;
    TestReport.Log(TestReport.LogNum).Time = TestTime;
    TestReport.Log(TestReport.LogNum).detail = ...
        'Backtest Invalidated; GetHistory "PairString" Error';
    error('OAPI ERROR:\nRequested Instrument Not Available, Backtest Is Invalid','')
end
%% Retrieving History
Start = (TestTime-count+1);
End   = TestTime;
History = TestData.(PairString)(Start:End);
%% Updating Log
% Use comments to specify relevent fields to include in the report.
TestReport.LogNum = TestReport.LogNum + 1;
TestReport.Log(TestReport.LogNum).id   = TestReport.LogNum;
TestReport.Log(TestReport.LogNum).testTime = TestTime;
%TestReport.Log(TestReport.LogNum).time = TestData.(PairString)(TestTime).time;
TestReport.Log(TestReport.LogNum).action = 'GetHistory';
TestReport.Log(TestReport.LogNum).detail = ['GetHistory(',...
                                    '''',PairString,''',',...
                                   '''',granularity,''',',...
                                 '''',num2str(count),'''',...
                                                          ')'];
%TestReport.Log(TestReport.LogNum).Instrument   = PairString;
%TestReport.Log(TestReport.LogNum).granularity  = granularity;
%TestReport.Log(TestReport.LogNum).count        = count;
end