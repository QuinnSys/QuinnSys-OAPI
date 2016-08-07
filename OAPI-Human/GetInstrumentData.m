function InstrumentData = GetInstruments;
accountId = api.accountId;
InstrumentData = GetInstruments(api,accountId);
if isfield(InstrumentData,'code')
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(InstrumentData.code),InstrumentData.message);
    return
end
InstrumentData = cell2mat(InstrumentData.instruments)';
end