% The timestamp that OANDA sends with their data is not considered a valid
% timestamp within requests, this function converts the received timestamp
% to a sendable timestamp.
function TimeOut = TimeFix(TimeIn)
Date = TimeIn(1,1:10);
Hour = TimeIn(1,12:13);
Min  = TimeIn(1,15:16);
Sec  = TimeIn(1,18:19);
TimeOut = [Date,'T',Hour,'%3A',Min,'%3A',Sec,'Z'];
end
