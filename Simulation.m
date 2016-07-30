%% Simulated or LiveTrading Selection
Simulated = 1; % Set this to 1 test strategy as a simulation
TradeNow = 0;
% The TradeNow variable should be set to 1 to allow live trading
% During live trading this can be set to 0 in response to an event
% to cease trading under certain conditions.
%% Simulation Initialization
global SimData
SimData.EUR_USD = DataMassage(importdata('DAT_MT_EURUSD_M1_201601.csv'));
SimData.EUR_CAD = DataMassage(importdata('DAT_MT_EURCAD_M1_201601.csv'));
global SimTime
SimTime = 0;
SimInstruments = fieldnames(SimData);
DataSizes = zeros(1,size(SimInstruments,1));
for ii = 1:size(SimInstruments,1)
    DataSizes(ii) = size(SimData.(SimInstruments{ii}).Time,1);
end
EndTime = min(DataSizes);
clear DataSizes;clear ii;clear SimInstruments;
%% Loop to progress through the data
while (SimTime < EndTime && Simulated == 1) || (TradeNow == 1 && Simulated == 0)
    SimTime = SimTime + 1;
%% Strategy
    Prices1 = GetPrices('EUR_USD');
    Prices2 = GetPrices('EUR_CAD');
end
beep
fprintf('Simulation Complete\n')