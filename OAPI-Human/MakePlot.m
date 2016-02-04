function MakePlot(History)
for ii = 1:length(History.candles)
    CandleStruct = History.candles{ii};
    Candles(ii,1) = CandleStruct.highBid;
    Candles(ii,2) = CandleStruct.lowBid;
    Candles(ii,3) = CandleStruct.closeBid;
    Candles(ii,4) = CandleStruct.openBid;
end
candle(Candles(:,1),Candles(:,2),Candles(:,3),Candles(:,4))
axis tight
    