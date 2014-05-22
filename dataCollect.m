% This script will run continuously, reading from the Serial Port from the
% Arduino.

% Open the serial output from Arduino
arduino = serial('COM9', 'BaudRate', 9600);

% Choose Data Output File
[dataFile, folder] = uiputfile('data.csv');

% Quit if press Cancel
if dataFile == 0
    return;
end

try

% Close any remaining open serial ports
fclose(instrfind);


% Open output data File
dataFileID = fopen(fullfile(folder, dataFile), 'w');

fopen(arduino);

fprintf(dataFileID, '%s,%s\n', 'Temperature (Celsius)', 'Elapsed Time (seconds)');

if ~isvalid(arduino)
    error('Invalid Serial Object');
end

% Runs while the stream is still going.
cycleNum = 1000;
inputData = [0; 0; 0];
last2YPoints = [0, 0];
last2XPoints = [0, 0];
count = 1;

hold on;
grid on;
xlabel('Time (seconds)');
ylabel('Temperature (\circ C)');

while true
    % Format is: analogInput, voltage, time
    inputData = fscanf(arduino, '%d, %f, %f');
    
    analogInput = inputData(1)
    voltage = inputData(2)
    microSeconds = inputData(3);
    
    lastData = inputData;
    
    secondsElapsed = microSeconds/1.0e6
    
    temperature = voltage*100
    
    % Assign the last points to the current plotting points
    last2YPoints(1) = last2YPoints(2);
    last2XPoints(1) = last2XPoints(2);
    
    last2YPoints(2) = temperature;
    last2XPoints(2) = secondsElapsed;
    
    % Print to file
    fprintf(dataFileID, '%f,%f\n', temperature, secondsElapsed);
    
    plot(last2XPoints, last2YPoints,'x-');
    drawnow;
end

catch fileError
    disp(fileError.message);
end

fclose(arduino);
fclose(dataFileID);