function TransactionInfo = GetTransactionInfo(id)
% Returns the information for a specified transaction
%% Input Organization
%% API Call
RawTransactionInfo = GetTransactionInfo(api,id);
%% Error Checking and Report Assignment
if isfield(RawTransactionInfo,'code')
    TransactionInfo = RawTransactionInfo;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(TransactionInfo.code),TransactionInfo.message);
    return
end
%% Output Assignment
TransactionInfo = RawTransactionInfo;
%% Data Massaging
TransactionInfo.accountId = num2str(TransactionInfo.accountId);
TransactionInfo.id = num2str(TransactionInfo.id);
if isfield(TransactionInfo,'tradeOpened')
    TransactionInfo.tradeOpened.id = num2str(TransactionInfo.tradeOpened.id);
end
end