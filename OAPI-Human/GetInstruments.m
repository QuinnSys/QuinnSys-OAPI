function Instruments = GetInstruments(accountId)
if nargin == 0
    Account = GetAccounts;
    accountId = Account.accountId;
end
accountId = api.accountId;
InstrumentData = GetInstruments(api,accountId);
InstrumentData = (InstrumentData.instruments)';
Instruments = cell(length(InstrumentData),1);
for ii = 1:length(InstrumentData)
    Instruments{ii} = InstrumentData{ii}.instrument;
end
Instruments;
end 