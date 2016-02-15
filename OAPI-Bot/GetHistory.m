function History = GetHistory(PairString,granularity,count)
History = GetHistory(api,PairString,granularity,count);
History = History.candles;
end