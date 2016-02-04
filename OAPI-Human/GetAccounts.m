%Returns a List of Available OANDA Accounts for the Supplied Token
function Account = GetAccounts
ListAccounts = GetAccounts(api);
ListAccounts = ListAccounts.accounts;
AccsNo = length(ListAccounts);
for ii = 1:AccsNo
eval(['Account' num2str(ii) ' = ListAccounts{ii}']);
end
AccNo = input('Choose an Account? (enter just the number or 0)\n');
if AccNo ~= 0
    Account = ListAccounts{AccNo};
end
end