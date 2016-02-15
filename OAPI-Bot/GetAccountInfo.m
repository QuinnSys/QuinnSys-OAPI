function AccountInfo = GetAccountInfo(accountId)
if nargin == 0
    Account = GetAccounts;
    accountId = num2str(Account.accountId);
end
AccountInfo = GetAccountInfo(api,accountId);