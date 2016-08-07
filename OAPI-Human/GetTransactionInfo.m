function TransactionInfo = GetTransactionInfo(id)
TransactionInfo = GetTransactionInfo(api,id);
if isfield(TransactionInfo,'code')
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(TransactionInfo.code),TransactionInfo.message);
else
    TransactionInfo.accountId = num2str(TransactionInfo.accountId);
    TransactionInfo.id = num2str(TransactionInfo.id);
    if isfield(TransactionInfo,'tradeOpened')
        TransactionInfo.tradeOpened.id = num2str(TransactionInfo.tradeOpened.id);
    end
end
end