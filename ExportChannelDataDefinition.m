% Names of signal stored in file
SignalNameDefinition_Yishen;

% Number of signals in row vector, the first colomn is time
NData = size(txtRawData.data,2)-1;

% Number of signal names
NNames = length(ExportChannel_SignalNames);

% Signal names must be more than signals (backward compability)
assert(NNames>=NData,'Channels are more than names in definition(ExportChannel)');

for iCounter = 2 : NData + 1
    cmdStr = [ExportChannel_SignalNames(iCounter-1), "=", "txtRawData.data(:,", num2str(iCounter), ");"];
    cmd = join(cmdStr);
    eval(cmd);
end