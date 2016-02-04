function InstrumentData = GetInstruments(accountId);
if nargin == 0
    Account = GetAccounts;
    accountId = Account.accountId;
end
accountId = api.accountId;
InstrumentData = GetInstruments(api,accountId);
InstrumentData = (InstrumentData.instruments)';
end