function OpenOrders = GetOrders(accountId)
% Returns all open orders for the specified account
%% Input Organization
if nargin == 0
    accountId = api.accountId;
end
if ~ischar(accountId)
    accountId = num2str(accountId);
end
%% API Call
RawOrders = GetOrders(api,accountId);
%% Error Checking and Report Assignment
if isfield(RawOrders,'code')
    OpenOrders = RawOrders;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(OpenOrders.code),OpenOrders.message);
    return
end
%% Output Assignment
OpenOrders = RawOrders.orders;
%% Data Massaging
OpenOrders = cell2mat(OpenOrders);
for ii = 1:size(OpenOrders,2)
    OpenOrders(ii).id = num2str(OpenOrders(ii).id);
end
end