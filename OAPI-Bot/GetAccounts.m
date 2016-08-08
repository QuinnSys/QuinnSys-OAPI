function AccountList = GetAccounts
%Returns a list of available OANDA accounts for the supplied token.
%% Input Organization
%% Api Call
RawAccounts = GetAccounts(api);
%% Error Checking and Report Assignment
if isfield(RawAccounts,'code')
    AccountList = RawAccounts;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(AccountList.code),AccountList.message);
    return
end
AccountCells = RawAccounts.accounts;
%% OutPut Assignment
AccNum = length(AccountCells);
AccountList(AccNum) = struct(...
    'accountId',[],...
    'accountName',[],...
    'accountCurrency',[],...
    'marginRate',[],...
    'accountPropertyName',[]);
% Loop to Create Struct Array of Accounts
for ii = 1:AccNum
    AccountList(ii).accountId = num2str(AccountCells{1,ii}.accountId);
    AccountList(ii).accountName = AccountCells{1,ii}.accountName;
    AccountList(ii).accountCurrency = AccountCells{1,ii}.accountCurrency;
    AccountList(ii).marginRate = AccountCells{1,ii}.marginRate;
    if isfield(AccountCells{1,ii},'accountPropertyName')
        AccountList(ii).accountPropertyName = AccountCells{1,ii}.accountPropertyName;
    end
end
%% Data Massaging
end