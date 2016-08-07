function AccountInfo = GetAccountInfo(accountId)
if nargin == 0
    accountId = api.accountId;
end
AccountInfo = GetAccountInfo(api,accountId);
if isfield(AccountInfo,'code')
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(AccountInfo.code),AccountInfo.message);
    return
end
AccountInfo.accountId = num2str(AccountInfo.accountId);
end