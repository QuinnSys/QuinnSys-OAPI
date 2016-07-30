% The LiveTrade function should be used only in the OAPI Bot folder
%% Simulated or LiveTrading Selection
Simulated = 1; % Set this to 1 test strategy as a simulation
TradeNow = 1;
% The TradeNow variable should be set to 1 to allow live trading
% During live trading this can be set to 0 in response to an event
% to cease trading under certain conditions.
TimeLock = 0;
% When TimeLock = 1 the strategy halts until a timer has set
% TimeLock to 0 allowing another iteration of the strategy.
% Do not use TimeLock in Simulation mode
ii = 0;
Timer_Obj = timer;
set(Timer_Obj,'executionMode','fixedRate','Period',5)
set(Timer_Obj,'TimerFcn','TimeLock = 0;ii = ii + 1;disp(ii)')
start(Timer_Obj)
%% Simulation Initialization
global SimData
SimData = [];
global SimTime
SimTime = 0;
EndTime = length(SimData) + 100;
% The values of SimTime here allow this strategy to begin new iterations
% after Trading has ended (e.g TradeNow becomes 0 while running)
%% Loop to progress through the data
ii = 0;
while (SimTime < EndTime && Simulated == 1) || (TradeNow == 1 && Simulated == 0)
    while TimeLock == 1
    % This loop waits for Timer_Obj to switch off TimeLock to continue the
    % iteration. e.g TimeLock = 0
    if checker == 1 % This is to indicate that the algorithm is waiting for the timer to allow another iteration
        disp('Waiting Loop')
        checker = 0;
    end
    end
    TimeLock = 1;
    disp('TimeLock on')
    disp('Iteration Ran')
    %% Strategy
    Prices1 = GetPrices('EUR_USD');
    Prices2 = GetPrices('EUR_CAD');
    checker = 1;
end
    stop(Timer_Obj)