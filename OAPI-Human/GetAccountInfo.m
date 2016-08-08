function AccountInfo = GetAccountInfo(accountId)
% Returns the account information for the supplied accountId
%% Input Organization
if nargin == 0
    accountId = api.accountId;
end
%% API Call
RawAccountInfo = GetAccountInfo(api,accountId);
%% Error Checking and Report Assignment
if isfield(RawAccountInfo,'code')
    AccountInfo = RawAccountInfo;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(AccountInfo.code),AccountInfo.message);
    return
end
%% OutPut Assignment
AccountInfo = RawAccountInfo;
%% Data Massaging
AccountInfo.accountId = num2str(AccountInfo.accountId);
end