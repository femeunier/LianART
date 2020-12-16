function rawdata = readQSM(filename)

delimiter = '\t';

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN,  'ReturnOnError', false);
rawdata = [dataArray{1:end-1}];
fclose(fileID);

end