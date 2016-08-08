function InstrumentData = GetInstrumentData(accountId)
% Returns the displayName, pip size and maxTradeUnits of all instruments
% tradable by the selected accountId
%% Input Organization
if nargin == 0
    accountId = api.accountId;
end
%% API Call
RawInstrumentData = GetInstruments(api,accountId);
%% Error Checking and Report Assignment
if isfield(RawInstrumentData,'code')
    InstrumentData = RawInstrumentData;
    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(InstrumentData.code),InstrumentData.message);
    return
end
%% OutPut Assignment
InstrumentData = RawInstrumentData.instruments;
%% Data Massaging
InstrumentData = cell2mat(InstrumentData);
end