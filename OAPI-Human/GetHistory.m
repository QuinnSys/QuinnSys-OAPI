function History = GetHistory(PairString,granularity,count)
History = GetHistory(api,PairString,granularity,count);
if isfield(History,'code')
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(History.code),History.message);
else
    History = cell2mat(History.candles);
    CandlePlot = input('CandleStick Chart?\n Y or N\n','s');
    if CandlePlot == 'Y'
        MakePlot(History);
    end
end
end