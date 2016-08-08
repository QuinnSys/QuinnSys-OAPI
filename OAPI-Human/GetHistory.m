function History = GetHistory(PairString,granularity,count)
% Returns the historic price data for the specified pair
%% Input Organization
if ~ischar(count)
    count = num2str(count);
end
%% API Call
RawHistory = GetHistory(api,PairString,granularity,count);
%% Error Checking and Report Assingment
if isfield(RawHistory,'code')
    History = RawHistory;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(History.code),History.message);
    return
end
%% Output Assignment
History = RawHistory.candles;
%% Data Massaging
History = cell2mat(History);
%% Display for User
CandlePlot = input('CandleStick Chart?\n Y or N\n','s');
if CandlePlot == 'Y'
    MakePlot(History);
end
end