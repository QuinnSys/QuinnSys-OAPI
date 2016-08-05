function Instruments = GetInstruments
accountId = api.accountId;
InstrumentData = GetInstruments(api,accountId);
if isfield(InstrumentData,'code')
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(InstrumentData.code),InstrumentData.message);
    Instruments = InstrumentData;
    return
end
InstrumentData = (InstrumentData.instruments)';
Instruments = cell(length(InstrumentData),1);
for ii = 1:length(InstrumentData)
    Instruments{ii} = InstrumentData{ii}.instrument;
end
Instruments;
end 