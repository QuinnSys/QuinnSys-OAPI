% Get transaction history, instrument is optional
function TransactionHistory = GetTransactionHistory(instrument)
if nargin == 1
TransactionHistory = GetTransactionHistory(api,instrument);
else
    TransactionHistory = GetTransactionHistory(api);
end
TransactionHistory = TransactionHistory.transactions;
end
