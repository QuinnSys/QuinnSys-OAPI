function DataOut = DataMassage(DataIn)
DataOut.Rates = DataIn.data(1:end,1:4);
Seconds = '00.000000Z';
DataOut.Time = cell(size(DataIn.textdata,1),1);
for ii = 1:size(DataIn.textdata,1)
Year = DataIn.textdata{ii,1}(1,1:4);
Month = DataIn.textdata{ii,1}(1,6:7);
Day = DataIn.textdata{ii,1}(1,9:10);
Hour = DataIn.textdata{ii,2}(1,1:2);
Minute = DataIn.textdata{ii,2}(1,4:5);
DataOut.Time{ii,1} = [Year,'-',Month,'-',Day,'T',Hour,':',Minute,':',Seconds;];
end
end