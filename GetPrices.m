function Prices = GetPrices(PairString)
global SimData
global SimTime
Prices.instrument = PairString;
Prices.time = char(SimData.(PairString).Time(SimTime,1));
Prices.bid = SimData.(PairString).Rates(SimTime,4); %Bid/ask prices not included in dataset
Prices.ask = SimData.(PairString).Rates(SimTime,4); %'4' returns close price for both.
end