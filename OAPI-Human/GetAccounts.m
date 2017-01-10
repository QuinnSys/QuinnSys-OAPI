function Account = GetAccounts
%Returns a List of Available OANDA Accounts for the Supplied Token
%% Input Organization
%% API Call
RawAccounts = GetAccounts(api);
%% Error Checking and Report Assignment
if isfield(RawAccounts,'code')
    Account = RawAccounts;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(Account.code),Account.message);
    return
end
%% OutPut Assignment
ListAccounts = RawAccounts.accounts;
AccsNo = length(ListAccounts);
for ii = 1:AccsNo
eval(['Account' num2str(ii) ' = ListAccounts{ii}']);
end
AccNo = input('Choose an Account? (enter just the number or 0)\n');
if AccNo ~= 0
    Account = ListAccounts{AccNo};
end
%% Data Massaging
Account.accountId = num2str(Account.accountId);
end