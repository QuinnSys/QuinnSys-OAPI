function SPrices = StreamPrices(PairString,time,output)
if nargin == 2
    output = 'data';
end
SPrices = [];
SPricesT = [];
ii = 0;
tic
if strcmp(output,'plot')
    h = animatedline('Color','r');
    g = animatedline('Color','g');
end
if time ~= 0
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
elseif time == 0
    while 1
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