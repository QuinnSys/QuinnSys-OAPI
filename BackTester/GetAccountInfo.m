function AccountInfo = GetAccountInfo(accountId)
global TestAccount
if nargin == 0
    accountId = TestAccount.accountId;
end
AccountInfo = TestAccount;
AccountInfo.accountId = num2str(AccountInfo.accountId);
end
