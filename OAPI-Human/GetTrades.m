function OpenTrades = GetTrades(accountId)
if nargin == 0
    accountId = api.accountId;
end
RawTrades = GetTrades(api,accountId);
if ~isfield(RawTrades,'code')
    OpenTrades = cell2mat(RawTrades.trades);
    if ~isempty(OpenTrades)
        for ii = 1:size(OpenTrades,2)
            OpenTrades(ii).id = num2str(OpenTrades(ii).id);
        end
    end
end
end