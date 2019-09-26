%% Import SCANeR data

clear variables

%% File name configuration
ScenarioNames = {'Exp1_Road1','Exp1_Road2', 'Exp2_NoFog-No_Assistance', 'Exp2_NoFog-Assistance', 'Exp2_Foggy-No_Assistance', 'Exp2_Foggy-Assistance'};
NScenarios = length(ScenarioNames);
Experimenters = {'RL', 'PL', 'CL', 'JP', 'FPB', 'PM', 'DS', 'EL', 'VG', 'BS', 'VJ', 'ES', 'JJL', 'PG', 'JM', 'AC2'};
NExperimenters = length(Experimenters);
RawDataFolder = '../SCANeR_RawData/';

for i = 1 : NExperimenters
    
    mkdir('../SCANeR_matData', Experimenters{i});
    for j = 1 : NScenarios
        
        txtFileName = [RawDataFolder Experimenters{i} '/' ScenarioNames{j} '.txt'];
        csvFileName = [RawDataFolder Experimenters{i} '/' ScenarioNames{j} '.csv'];

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
                TXTDataDefinition;
            case 10
                % Only csv data
                time = csvTime;
                CSVDataDefinition;
            case 11
                % Both data
                SynchronizeData;
                TXTDataDefinition;
                CSVDataDefinition;
            otherwise
                error('No data files.');
        end


        %% Save and copy .mat file to program folder
        matFileName = [ScenarioNames{j} '.mat'];
        save(matFileName, 'time');
        if exist('txt_data','var')
            save(matFileName, 'txt_data', '-append');
        end
        if exist('csv_data','var')
            save(matFileName, 'csv_data', '-append');
        end

        destinationFolder = ['../SCANeR_matData/' Experimenters{i} '/' matFileName];
        copyfile(matFileName, destinationFolder);
        delete(matFileName)

        fprintf('Info: data saved to .mat file and copied to %s.\n', destinationFolder);

    end
end

%% End
clear variables