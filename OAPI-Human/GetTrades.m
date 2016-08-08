function OpenTrades = GetTrades(accountId)
% Returns all open trades for the specified account
%% Input Organization
if nargin == 0
    accountId = api.accountId;
end
%% API Call
RawTrades = GetTrades(api,accountId);
%% Error Checking and Report Assignment
if isfield(RawTrades,'code')
    OpenTrades = RawTrades;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(OpenTrades.code),OpenTrades.message);
    return
end
%% Output Assignment
OpenTrades = RawTrades.trades;
%% Data Massaging
OpenTrades = cell2mat(OpenTrades);
if ~isempty(OpenTrades)
    for ii = 1:size(OpenTrades,2)
        OpenTrades(ii).id = num2str(OpenTrades(ii).id);
    end
end