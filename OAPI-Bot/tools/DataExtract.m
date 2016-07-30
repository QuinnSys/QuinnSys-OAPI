function [ openBid, openAsk, highBid, highAsk, lowBid, lowAsk, ... 
    closeBid, closeAsk, volume] = DataExtract( oandaData )
%DATAEXTRACT extracts data from OANDA response.
%   [ openBid, openAsk, highBid, highAsk, lowBid, lowAsk, ... 
%    closeBid, closeAsk, volume] = DataExtract( oandaData );

    matrixData = cell2mat(oandaData);
    cellData = struct2cell(matrixData);
    
    openBidTemp = cell2mat(cellData(2,1,:));
    openBid = reshape(openBidTemp, length(openBidTemp), 1);
    
    openAskTemp = cell2mat(cellData(3,1,:));
    openAsk = reshape(openAskTemp, length(openAskTemp), 1);
    
    highBidTemp = cell2mat(cellData(4,1,:));
    highBid = reshape(highBidTemp, length(highBidTemp), 1);
    
    highAskTemp = cell2mat(cellData(5,1,:));
    highAsk = reshape(highAskTemp, length(highAskTemp), 1);
    
    lowBidTemp = cell2mat(cellData(6,1,:));
    lowBid = reshape(lowBidTemp, length(lowBidTemp), 1);
    
    lowAskTemp = cell2mat(cellData(7,1,:));
    lowAsk = reshape(lowAskTemp, length(lowAskTemp), 1);
    
    closeBidTemp = cell2mat(cellData(8,1,:));
    closeBid = reshape(closeBidTemp, length(closeBidTemp), 1);
    
    closeAskTemp = cell2mat(cellData(9,1,:));
    closeAsk = reshape(closeAskTemp, length(closeAskTemp), 1);
    
    volumeTemp = cell2mat(cellData(10,1,:));
    volume = reshape(volumeTemp, length(volumeTemp), 1);
end

