function History = GetHistory(PairString,granularity,count)
History = GetHistory(api,PairString,granularity,count);
CandlePlot = input('CandleStick Chart?\n Y or N\n','s');
if CandlePlot == 'Y'
    MakePlot(History);
end
History = History.candles;
end