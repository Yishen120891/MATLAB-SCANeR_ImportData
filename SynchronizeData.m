%% Synchronize ExportChannel and ModelHandler data

tsTXTRawData = timeseries(txtRawData.data(:,2:end), txtTime);
tsCSVRawData = timeseries(csvRawData.data(:,2:end), csvTime);

txtTs = txtTime(2) - txtTime(1);
csvTs = csvTime(2) - csvTime(1);

if txtTs >= csvTs
    Ts = txtTs;
else
    Ts = csvTs;
end

[tsSyncTXTRawData, tsSyncCSVRawData] = synchronize(tsTXTRawData, tsCSVRawData, 'Uniform', 'Interval', Ts);

time = tsSyncTXTRawData.Time;
txtRawData.data = [time, tsSyncTXTRawData.Data];
csvRawData.data = [time, tsSyncCSVRawData.Data];