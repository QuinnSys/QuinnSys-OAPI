function OpenOrders = GetOrders
accountId = api.accountId;
RawOrders = GetOrders(api,accountId);
if isfield(RawOrders,'code')
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(RawOrders.code),RawOrders.message);
    OpenOrders = RawOrders;
else
    OpenOrders = cell2mat(RawOrders.orders);
    for ii = 1:size(OpenOrders,2)
        OpenOrders(ii).id = num2str(OpenOrders(ii).id);
    end
end
end