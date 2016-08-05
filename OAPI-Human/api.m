classdef api
       properties (Constant)
%% Customize these options as necessary
           accountId = input('Enter the account number\n','s');
           %The account you want to access
           token = input('Enter your security token\n','s');
           %Oandas security token/API key
           server = EnvSelec
           %the URL to which the requests will be ammended
           %live    : 'https://api-fxtrade.oanda.com/'
           %practice: 'https://api-fxpractice.oanda.com/'
           %sandbox : 'https://api-sandbox.oanda.com/'
%% You probably shouldn't edit these:
           Auth_Header = http_createHeader('Authorization',['Bearer ',api.token]);
           Patch_Header = http_createHeader('X-HTTP-Method-Override','PATCH');
           Delete_Header = http_createHeader('X-HTTP-Method-Override','DELETE');
       end
       methods
%% GetAccounts        return the accounts associated with the supplied token
           function ListAccounts = GetAccounts(api)
            Request = 'v1/accounts';
            ListAccounts = loadjson(urlread2([api.server,Request],'GET','',api.Auth_Header));
           end
%% GetAccountInfo     return the information associated with the selected account
            function AccountInfo = GetAccountInfo(api,accountId)
                Request = ['v1/accounts/',accountId];
                AccountInfo = loadjson(urlread2([api.server,Request],'GET','',api.Auth_Header));
            end
%% GetTransactionHistory
            function TransactionHistory = GetTransactionHistory(api,instrument)
                if nargin ==2
                    Request = ['v1/accounts/',api.accountId,'/transactions?instrument=',instrument];
                else
                    Request = ['v1/accounts/',api.accountId,'/transactions'];
                end
                TransactionHistory = loadjson(urlread2([api.server,Request],'GET','',api.Auth_Header));
                if isfield(TransactionHistory,'code')
                    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(TransactionHistory.code),TransactionHistory.message);
                else
                    for ii = 1:length(TransactionHistory)
                        TransactionHistory.transactions{ii}.id = num2str(TransactionHistory.transactions{ii}.id);
                    end
                end
            end
%% GetTransactionInfo
            function TransactionInfo = GetTransactionInfo(api,id)
                Request = ['v1/accounts/',api.accountId,'/transactions/',id];
                TransactionInfo = loadjson(urlread2([api.server,Request],'GET','',api.Auth_Header));
            end
%% GetInstruments         return the tradable pairs for a particular account
            function Instruments = GetInstruments(api,accountId)
                Request = ['v1/instruments?accountId=',accountId];
                Instruments = loadjson(urlread2([api.server,Request],'GET','',api.Auth_Header));
            end
%% GetOrders
            function RawOrders = GetOrders(api,accountId)
                Request = ['v1/accounts/',accountId,'/orders'];
                RawOrders = loadjson(urlread2([api.server,Request],'Get','',api.Auth_Header));
            end
%% GetTrades         
            function RawTrades = GetTrades(api,accountId)
                Request = ['v1/accounts/',accountId,'/trades'];
                RawTrades = loadjson(urlread2([api.server,Request],'GET','',api.Auth_Header));
                if isfield(RawTrades,'code')
                    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(RawTrades.code),RawTrades.message);
                elseif isempty(RawTrades.trades)
                    fprintf('There are no open trades to return\n')
                end
            end
%% GetHistory
            function History = GetHistory(api,PairString,granularity,count)
                Request = ['v1/candles?instrument=',PairString,'&count=',count,'&granularity=',granularity];
                History = loadjson(urlread2([api.server,Request],'GET','',api.Auth_Header));
            end
%% StreamPrices, doesn't work, the StreamPrices function uses GetPrices above
            function SPrices = StreamPrices(api,PairString)
                Request = ['v1/prices?accountId=',api.accountId,'&instruments=',PairString];
                SPrices = loadjson(urlread2([api.stream,Request],'GET','',api.Auth_Header));
            end
%% GetPrices        return the current prices for a particular pair, e.g EUR_USD
            function Prices = GetPrices(api,PairString)
               Request = ['v1/prices?instruments=',PairString];
               Prices = loadjson(urlread2([api.server,Request],'GET','',api.Auth_Header));
           end
%% NewOrder      Only supports market orders
            function TheOrder = NewOrder(api,PairString,units,side,stopLoss,takeProfit,trailingStop)
                Request = ['v1/accounts/',api.accountId,'/orders'];
                Body = ['instrument=',PairString,'&units=',units,'&side=',side,'&type=market', ...
                    '&stopLoss=',stopLoss,'&takeProfit=',takeProfit,'&trailingStop=',trailingStop];
                TheOrder = loadjson(urlread2([api.server,Request],'POST',Body,api.Auth_Header));
                if isfield(TheOrder,'code')
                    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(TheOrder.code),TheOrder.message);
                else
                    TheOrder.tradeOpened.id = num2str(TheOrder.tradeOpened.id);
                end
            end
%% ModifyTrade
            function TradeInfo = ModifyTrade(api,id,stopLoss,takeProfit,trailingStop)
                Request = ['v1/accounts/',api.accountId,'/trades/',id];
                Body_Exists = 0;
                Body = [];
                if ~ischar(stopLoss)
                    stopLoss = num2str(stopLoss);
                end
                if ~ischar(takeProfit)
                    takeProfit = num2str(takeProfit);
                end
                if ~ischar(trailingStop)
                    trailingStop = num2str(trailingStop);
                end
                if ~strcmp(stopLoss,'0')
                    Body = ['stopLoss=',stopLoss];
                    Body_Exists = 1;
                end
                if ~strcmp(takeProfit,'0')
                    if Body_Exists == 1
                        Body = [Body,'&'];
                    end
                    Body = [Body,'takeProfit=',takeProfit];
                    Body_Exists = 1;
                end
                if ~strcmp(trailingStop,'0')
                    if Body_Exists == 1
                        Body = [Body,'&'];
                    end
                    Body = [Body,'trailingStop=',trailingStop];
                end
                Headers = [api.Auth_Header;api.Patch_Header];
                TradeInfo = loadjson(urlread2([api.server,Request],'POST',Body,Headers));
                if isfield(TradeInfo,'code')
                    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(TradeInfo.code),TradeInfo.message);
                else
                    TradeInfo.id = num2str(TradeInfo.id);
                end
            end
%% CloseTrade
            function TradeInfo = CloseTrade(api,id)
                Request = ['v1/accounts/',api.accountId,'/trades/',id];
                Headers = [api.Auth_Header;api.Delete_Header];
                TradeInfo = loadjson(urlread2([api.server,Request],'DELETE','',Headers));
                if isfield(TradeInfo,'code')
                    fprintf('OANDA ERROR:\ncode: %s\n%s\n',num2str(TradeInfo.code),TradeInfo.message);
                else
                    TradeInfo.id = num2str(TradeInfo.id);
                end
            end
       end
end
       