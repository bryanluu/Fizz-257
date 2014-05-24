function data = collectArduinoData
%Simply run this function to begin reading from the Arduino Serial Stream.

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
fprintf(dataFileID, '%s,%s,%s,%s,%s\n', 'Elapsed Time (seconds)', 'Voltage 1', ...
    'Voltage 2', 'Voltage 3', 'Voltage 4');


inputData = [0; 0; 0];
last2YPoints = [0, 0; 0, 0; 0, 0; 0, 0];
last2XPoints = [0, 0];
count = 1;


hold on;
grid on;
xlabel('Time (seconds)');
ylabel('Voltage (V)');


% Runs while the stream is still going.
while isvalid(arduino)
    % Format is: time (milliseconds), analogInput, voltage, 
    inputData = fscanf(arduino, '%f, %d, %f, %d, %f, %d, %f, %d, %f');
    
    milliSeconds = inputData(1);
    secondsElapsed = milliSeconds/1.0e3
    
    analogInput(1) = inputData(2)
    voltage(1) = inputData(3)
    
    analogInput(2) = inputData(4)
    voltage(2) = inputData(5)
    
    analogInput(3) = inputData(6)
    voltage(3) = inputData(7)
    
    analogInput(4) = inputData(8)
    voltage(4) = inputData(9)
    
    temperature = voltage*100
    
    % Assign the last points to the current plotting points
    last2YPoints(:,1) = last2YPoints(:,2);
    last2XPoints(1) = last2XPoints(2);
    
    last2YPoints(:,2) = voltage;
    last2XPoints(2) = secondsElapsed;
    
    % Print to file
    fprintf(dataFileID, '%f,%f,%f,%f,%f\n', secondsElapsed, ...
        voltage(1), voltage(2), voltage(3), voltage(4));
    
    % Red - A0, Blue - A1, Green - A2, Black - A3
    plot(last2XPoints, last2YPoints(1,:),'rx-');
    plot(last2XPoints, last2YPoints(2,:),'bx-');
    plot(last2XPoints, last2YPoints(3,:),'gx-');
    plot(last2XPoints, last2YPoints(4,:),'kx-');
    drawnow;
end

catch fileError
    disp(fileError.message);
end

fclose(arduino);
fclose(dataFileID);


end

