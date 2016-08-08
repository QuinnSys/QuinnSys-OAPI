function Prices = GetPrices(PairString)
% Returns the current bid and ask prices of the specified instrument
%% Input Organization
%% API Call
RawPrices = GetPrices(api,PairString);
%% Error Checking and Report Assignment
if isfield(RawPrices,'code')
    Prices = RawPrices;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(Prices.code),Prices.message);
    return
end
%% Output Assignment
Prices = RawPrices.prices{1,1};
%% Data Massaging
end