% This script will run continuously, reading from the Serial Port from the
% Arduino.


% Open the serial output from Arduino
arduino = serial('COM9', 'BaudRate', 9600);



try

% Close any remaining open serial ports
fclose(instrfind);


% Open arduino serial stream
fopen(arduino);

if ~isvalid(arduino)
    error('Arduino is invalid!');
end

% Choose Data Output File
[dataFile, folder] = uiputfile('data.csv');

% Quit if pressed Cancel
if dataFile == 0
    return;
end

% Open output data File
dataFileID = fopen(fullfile(folder, dataFile), 'w');



% Print headers to the file
fprintf(dataFileID, '%s,%s\n', 'Temperature (Celsius)', 'Elapsed Time (seconds)');


cycleNum = 1000;
inputData = [0; 0; 0];
last2YPoints = [0, 0];
last2XPoints = [0, 0];
count = 1;


hold on;
grid on;
xlabel('Time (seconds)');
ylabel('Voltage (V)');

% Runs while the stream is still going.
while isvalid(arduino)
    % Format is: analogInput, voltage, time (milliseconds)
    inputData = fscanf(arduino, '%d, %f, %f');
    
    analogInput = inputData(1)
    voltage = inputData(2)
    milliSeconds = inputData(3);
    
    lastData = inputData;
    
    secondsElapsed = milliSeconds/1.0e3
    
    temperature = voltage*100
    
    % Assign the last points to the current plotting points
    last2YPoints(1) = last2YPoints(2);
    last2XPoints(1) = last2XPoints(2);
    
    last2YPoints(2) = voltage;
    last2XPoints(2) = secondsElapsed;
    
    % Print to file
    fprintf(dataFileID, '%f,%f\n', voltage, secondsElapsed);
    
    plot(last2XPoints, last2YPoints,'x-');
    drawnow;
end

catch fileError
    disp(fileError.message);
end

fclose(arduino);
fclose(dataFileID);