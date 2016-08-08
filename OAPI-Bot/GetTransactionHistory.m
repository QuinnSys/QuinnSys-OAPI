function TransactionHistory = GetTransactionHistory(instrument)
% Return the transaction history for the default account
% Run with no input to retreive all transactions
%% Input Organization
%% API Call
if nargin == 1
    RawTransactionHistory = GetTransactionHistory(api,instrument);
else
    RawTransactionHistory = GetTransactionHistory(api);
end
if isfield(RawTransactionHistory,'code')
    TransactionHistory = RawTransactionHistory;    
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(TransactionHistory.code),TransactionHistory.message);
    return
end
%% Output Assignment
TransactionHistory = RawTransactionHistory.transactions;
%% Data Massaging
transactions = TransactionHistory;
clear TransactionHistory
%Pre-allocating for speed
NumTrans = length(transactions);
TransactionHistory(NumTrans) = struct(...
    'id',[],    ...
    'accountId',[], ...
    'time',[],  ...
    'type',[],  ...
    'instrument',[],    ...
    'units',[], ...
    'side',[],   ...
    'price',[], ...
    'takeProfitPrice',[],   ...
    'stopLossPrice',[], ...
    'trailingStopLossDistance',[],  ...
    'pl',[],    ...
    'interest',[],  ...
    'accountBalance',[],    ...
    'tradeOpened',[],   ...
    'tradeId',[] );
ii = 0;
% Loop to Create Struct Array of Transactions
for io = NumTrans:-1:1 %replace with (1:NumTrans) to reverse order
ii = ii+1;
%% Entering values of ubiquitus fields
    TransactionHistory(io).id           = num2str(transactions{1,ii}.id);
    TransactionHistory(io).accountId    = num2str(transactions{1,ii}.accountId);
    TransactionHistory(io).time                 = transactions{1,ii}.time;
    TransactionHistory(io).type                 = transactions{1,ii}.type;
%% Field Checking: 'instrument'    
    if isfield(transactions{1,ii},'side')
        TransactionHistory(io).instrument           = transactions{1,ii}.instrument;
    else
        TransactionHistory(io).instrument           = [];
    end
%% Field Checking: 'units'
    if isfield(transactions{1,ii},'units')
        TransactionHistory(io).units                = transactions{1,ii}.units;
    else
        TransactionHistory(io).units                = [];
    end
%% Field Checking: 'side'    
    if isfield(transactions{1,ii},'side')
        TransactionHistory(io).side                 = transactions{1,ii}.side;
    else
        TransactionHistory(io).side                 = [];
    end
%% Field Checking: 'price'
    if isfield(transactions{1,ii},'price')
        TransactionHistory(io).price                = transactions{1,ii}.price;
    else
        TransactionHistory(io).price                = [];
    end
%% Field Checking: 'takeProfitPrice'
    if isfield(transactions{1,ii},'takeProfitPrice')
        TransactionHistory(io).takeProfitPrice      = transactions{1,ii}.takeProfitPrice;
    else
        TransactionHistory(io).takeProfitPrice      = [];
    end
%% Field Checking: 'stopLossPrice'
    if isfield(transactions{1,ii},'stopLossPrice')
        TransactionHistory(io).stopLossPrice        = transactions{1,ii}.stopLossPrice;
    else
        TransactionHistory(io).stopLossPrice        = [];
    end
%% Field Checking: 'trailingStopDistance'
    if isfield(transactions{1,ii},'trailingStopLossDistance')
        TransactionHistory(io).trailingStopLossDistance = transactions{1,ii}.trailingStopLossDistance;
    else
        TransactionHistory(io).trailingStopLossDistance = [];
    end
%% Field Checking: 'pl'
    if isfield(transactions{1,ii},'pl')
        TransactionHistory(io).pl                   = transactions{1,ii}.pl;
    else
        TransactionHistory(io).pl                   = [];
    end
%% Field Checking: 'interest'
    if isfield(transactions{1,ii},'interest')
        TransactionHistory(io).interest             = transactions{1,ii}.interest;
    else
        TransactionHistory(io).interest             = [];
    end
%% Field Checking: 'accountBalance'
    if isfield(transactions{1,ii},'accountBalance')
        TransactionHistory(io).accountBalance       = transactions{1,ii}.accountBalance;
    else
        TransactionHistory(io).accountBalance       = [];
    end
%% Field Checking: 'tradeOpened;
    if isfield(transactions{1,ii},'tradeOpened')
        TransactionHistory(io).tradeOpened          = transactions{1,ii}.tradeOpened;
        TransactionHistory(io).tradeOpened.id       = num2str(TransactionHistory(io).tradeOpened.id);
    else
        TransactionHistory(io).tradeOpened          = [];
    end
%% Field Checking: 'tradeId'
    if isfield(transactions{1,ii},'tradeId')
        TransactionHistory(io).tradeId              = num2str(transactions{1,ii}.tradeId);
    else
        TransactionHistory(io).tradeId              = [];
    end
%% Field Checking: 'orderId'
    if isfield(transactions{1,ii},'orderId')
        TransactionHistory(io).orderId              = num2str(transactions{1,ii}.orderId);
    else
        TransactionHistory(io).orderId              = [];
    end
%% Field Checking: 'reason'
    if isfield(transactions{1,ii},'reason')
        TransactionHistory(io).reason               = transactions{1,ii}.reason;
    else
        TransactionHistory(io).orderId              = [];
    end
end