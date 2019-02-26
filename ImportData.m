%% Import SCANeR data

clear variables

%% File name configuration
ScenarioNames;
RawDataFolder = '../SCANeR_RawData/';
txtFileName = [RawDataFolder ScenarioName '.txt'];
csvFileName = [RawDataFolder ScenarioName '.csv'];

%% Import .txt file (ExportChannel data)
if exist(txtFileName,'file')
    % set flag
    bTXT = 1;
    % import txt data
    txtSeperator = '\t';
    txtStartRowNo = 1;
    txtRawData = importdata(txtFileName, txtSeperator, txtStartRowNo);
    % Record time
    txtTime = txtRawData.data(:,1);

    fprintf('Info: %s imported successfully.\n', txtFileName);
else
    %set flag
    bTXT = 0;
    warning('%s not found. Import skipped.', txtFileName);
end

%% Import .csv file (MODELHANDLER data)
if exist(csvFileName, 'file')
    % set flag
    bCSV = 10;
    % import csv data
    csvSeperator = ';';
    csvStartRowNo = 2;
    csvRawData = importdata(csvFileName, csvSeperator, csvStartRowNo); 
    % Record time
    csvTime = csvRawData.data(:,1);
    
    fprintf('Info: %s imported successfully.\n', csvFileName);
else
    %set flag
    bCSV = 0;
    warning('%s not found. Import skipped.', csvFileName);
end

%% Handling according to flags
switch(bCSV+bTXT)
    case 1
        % Only txt data
        time = txtTime;
        ExportChannelDataDefinition;
    case 10
        % Only csv data
        time = csvTime;
        ModelhandlerDataDefinition;
    case 11
        % Both data
        SynchronizeData;
        ExportChannelDataDefinition;
        ModelhandlerDataDefinition;
    otherwise
        error('No data files.');
end


%% Save and copy .mat file to program folder
matFileName = [ScenarioName '.mat'];
save(matFileName, 'time');
if exist('SCRIPT','var')
    save(matFileName, 'SCRIPT', '-append');
end
if exist('SHM','var')
    save(matFileName, 'SHM', '-append');
end
if exist('NETWORK','var')
    save(matFileName, 'NETWORK', '-append');
end
if exist('DriverModel','var')
    save(matFileName, 'DriverModel', '-append');
end
if exist('MODELHANDLER','var')
    save(matFileName, 'MODELHANDLER', '-append');
end
  
destinationFolder = '../SCANeR_matData';
copyfile(matFileName, destinationFolder);
delete(matFileName)
    
fprintf('Info: data saved to .mat file and copied to %s.\n', destinationFolder);

%% End
clear variables