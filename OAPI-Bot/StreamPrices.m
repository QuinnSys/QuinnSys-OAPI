function SPrices = StreamPrices(PairString,time)
SPrices = [];
SPricesT = [];
ii = 0;
tic
while toc < time
    SPricesT = [SPricesT,GetPrices(api,PairString)];
    ii = ii+1;
    SPrice = SPricesT(ii).prices{1,1};
    SPrices = [SPrices,SPrice];
    if strcmp(output,'plot')
        addpoints(h,ii,SPrice.bid)
        addpoints(g,ii,SPrice.ask)
        drawnow
    end
end
end