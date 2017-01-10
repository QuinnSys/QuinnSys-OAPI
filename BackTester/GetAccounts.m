function AccountList = GetAccounts
global TestAccount
for ii = 1:length(TestAccount)
    AccountList(ii).accountId = num2str(TestAccount(ii).accountId);
    AccountList(ii).accountName = TestAccount(ii).accountName;
    AccountList(ii).accountCurrency = TestAccount(ii).accountCurrency;
    AccountList(ii).marginRate = TestAccount(ii).marginRate;
    AccountList(ii).accountPropertyName = [];
end

