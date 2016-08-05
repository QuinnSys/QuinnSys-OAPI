function Prices = GetPrices(PairString)
Prices = GetPrices(api,PairString);
if isfield(Prices,'code')
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(Prices.code),Prices.message);
else
    Prices = Prices.prices{1,1};
end
end