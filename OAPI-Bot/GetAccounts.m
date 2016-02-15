%Returns a List of Available OANDA Accounts for the Supplied Token
function Account = GetAccounts
ListAccounts = GetAccounts(api);
ListAccounts = ListAccounts.accounts;
AccsNo = length(ListAccounts);
for ii = 1:AccsNo
eval(['Account' num2str(ii) ' = ListAccounts{ii}']);
end
end