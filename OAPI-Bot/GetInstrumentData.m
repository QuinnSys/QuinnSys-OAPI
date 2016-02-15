function InstrumentData = GetInstruments(accountId);
if nargin == 0
accountId = api.accountId;
end
InstrumentData = GetInstruments(api,accountId);
InstrumentData = (InstrumentData.instruments)';
end