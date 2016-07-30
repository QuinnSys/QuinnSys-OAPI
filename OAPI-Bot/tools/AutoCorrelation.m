function [ rk ] = AutoCorrelation( data, howManyR, priceType )
%AUTOCORRELATION Calculates the sample autocorrelation coefficients of a
% given time series. Only to be used with OANDA data formatting, which is 
% got as an input from eg. GetHistory function from the QuinnSys-OAPI.
%
% AUTHOR: ThomasWorking (https://github.com/ThomasWorking)
%
%   This is the same function as 'autocorr' in the Econometrics toolbox and
%   can be used with OANDA data.
%   These functions give the same results as far as I have tested. Any bugs
%   can be reported via the GitHub page at: 
%   https://github.com/QuinnSys/QuinnSys-OAPI
%
% INPUTS:
% data:
%           a 1-by-N cell containing N 1x1 structs. In the structs there
%           are the following fields: data{1, x}.time, data{1, x}.openBid,
%           data{1, x}.openAsk, data{1, x}.highBid, data{1, x}.highAsk,
%           data{1, x}.lowBid, data{1, x}.lowAsk, data{1, x}.closeBid,
%           data{1, x}.closeAsk, data{1, x}.volume, data{1, x}.complete
%
% howManyR: 
%           The amount of sample autocorrelation coefficients wanted.
%           Note that the first coefficient is not counted to this which
%           is always equal to one. With howManyR = 20 you get r0-r20 which
%           equals to 21 coefficients. This is the way how the autocorr
%           function from the Econometrics toolbox also works.
%
% priceType:
%           either one of these:
%           value 1: mean price (OHLC/4) from bid
%           value 2: mean price (OHLC/4) from ask
%           value 3: mean of closing bid and closing ask
%           value 4: closing bid
%           value 5: closing ask
%
% OUTPUT:
% rk:       the correlation coefficients
%
% EXAMPLE:
% rk = AutoCorrelation(GetHistory('EUR_USD', 'M1', '100'), 20, 1);
    
    % CODE:
    
    % extract the wanted data from the variable 'data'
    
    [openBid, openAsk, highBid, highAsk, lowBid, lowAsk, ... 
    closeBid, closeAsk] = DataExtract(data);
    
    % Calculate the correct price corresponding to the function parameter
    % given by the user
    
    switch priceType
        case 1
            % mean price bid
            data = (openBid + highBid + lowBid + closeBid)/4;
            data = data';
        case 2
            % mean price ask
            data = (openAsk + highAsk + lowAsk + closeAsk)/4;
            data = data';
        case 3
            % mean of closing bid and closing ask
            data = (closeBid + closeAsk)/2;
            data = data';
        case 4 
            % closing bid
            data = closeBid;
            data = data';
        case 5 
            % closing ask
            data = closeAsk;
            data = data';
        otherwise
            disp('incorrect value for priceType, using type 1')
            data = (openBid + highBid + lowBid + closeBid)/4;
            data = data';
    end
    
    % The mean (arithmetic average) of the series and the length
    % of the time series.
    m = mean(data);
    N = length(data);
    
    % Calculate the sample autocovariance coefficient at lag 0.
    % This is used to calculate the autocorrelation coefficients.
    c0 = 0;
    for t = 1:N
        c0 = c0 + ((data(t) - m)^2)/N;
    end
    
    % Calculate all the sample autocovariance coefficients to the
    % wanted degree of lag. Used to calculate autocorrelation coefficients.
    ck = 0; allC = -1;
    for k = 1:howManyR
        for j = 1:N-k
            ck = ck + ((data(j) - m)*(data(j+k) - m))/N;
        end
        
        % Just a rude check to populate the vector correctly
        if (allC == -1)
            allC = ck;
        else
            allC = [allC ck];
        end
        ck = 0;
    end
    
    % Calculate the autocorrelation coefficients
    rk = allC/c0;
    rk = [1 rk];

