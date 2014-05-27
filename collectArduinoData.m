function data = collectArduinoData
%Simply run this function to begin reading from the Arduino Serial Stream.

try
    % Choose Data Output File
    [dataFile, folder] = uiputfile('data.csv');
    
    % Quit if pressed Cancel
    if dataFile == 0
        return;
    end
    
    % Open the serial output from Arduino
    arduino = serial('COM9', 'BaudRate', 9600);
    
    dataFileID = initializeExperiment;
    
    numOfInputPorts = 6;
    
    last2DataPoints = [];
    last2TimePoints = [];
    portLabels = {};
    
    prepareInputs(numOfInputPorts);
    
    % Take the first couple of points to make a legend
    inputData = sampleDataPoints(numOfInputPorts);
    legend(portLabels);
    if length(inputData) ~= (2*numOfInputPorts + 1)
        errordlg('YO! Make sure to configure that Arduino to take in the appropriate number of inputs.');
        endExperiment;
    end
    
    % Runs while the stream is still going.
    while isvalid(arduino)
        sampleDataPoints(numOfInputPorts);
    end
    
catch fileError
    disp(fileError.message);
    endExperiment;
end



%% Subfunction Definitions
    function dataFileID = initializeExperiment
        % Close any remaining open serial ports
        fclose(instrfind);
        
        % Open arduino serial stream
        fopen(arduino);
        
        if ~isvalid(arduino)
            error('Arduino is invalid!');
        end
        
        % Open output data File
        dataFileID = fopen(fullfile(folder, dataFile), 'w');
        
        disp('==========EXPERIMENT START==========');
        disp(['Output file: ' fullfile(folder, dataFile)]);
        disp(['Started on: ' date]);
    end

    function prepareInputs(numOfInputPorts)
        % Creates a matrix with numOfInputPorts rows, with 2 cells
        % representing the last two data points
        last2DataPoints = zeros(numOfInputPorts, 2);
        last2TimePoints = [0, 0];
        
        
        
        % Print headers to the file
        fprintf(dataFileID, '%s,', 'Elapsed Time (seconds)');
        
        for inputIndex = 1:numOfInputPorts
            portLabels{inputIndex} = ['A' num2str(inputIndex-1)];
            fprintf(dataFileID, '%s,', ...
                ['Temperature ' num2str(inputIndex) ' (Celsius)']);
        end
        
        % Finish header line
        fprintf(dataFileID, '\n');
        
        
        % Prepare the plot
        hold on;
        grid on;
        xlabel('Time (seconds)');
        ylabel('Temperature (\circ C)');
    end


% Takes in a single serial line of data and interprets it
    function inputData = sampleDataPoints(numOfInputPorts)
        inputData = fscanf(arduino, '%f,');
        
        % Read Time Point
        milliSeconds = inputData(1);
        secondsElapsed = milliSeconds/1.0e3;
        
        % Cycle last 2 time points
        last2TimePoints(1) = last2TimePoints(2);
        last2TimePoints(2) = secondsElapsed;
        
        % Write time to file
        fprintf(dataFileID, '%f,', secondsElapsed);
        
        % Display Time
        disp(['---TIME (seconds): ' num2str(secondsElapsed) '---']);
        
        for inputIndex = 1:numOfInputPorts
            analogInput(inputIndex) = inputData(inputIndex*2);
            temperature(inputIndex) = inputData(inputIndex*2 + 1);
            
            % Cycle last 2 points
            last2DataPoints(inputIndex, 1) = last2DataPoints(inputIndex, 2);
            last2DataPoints(inputIndex, 2) = temperature(inputIndex);
            
            % Plot the points
            plot(last2TimePoints, last2DataPoints(inputIndex, :), getPortColor(inputIndex));
            
            % Write data points to file
            fprintf(dataFileID, '%f,', temperature(inputIndex));
            
            % Display Info
            disp(['Temperature ' num2str(inputIndex) ': ' num2str(temperature(inputIndex))]);
        end
        
        % Finish the line
        fprintf(dataFileID, '\n');
        
        drawnow;
    end

    function endExperiment
        fclose('all');
        fclose(instrfind);
    end

end


function lineStyle = getPortColor(inputIndex)
switch inputIndex
    case 1
        lineStyle = 'bx-';
    case 2
        lineStyle = 'gx-';
    case 3
        lineStyle = 'rx-';
    case 4
        lineStyle = 'cx-';
    case 5
        lineStyle = 'mx-';
    case 6
        lineStyle = 'yx-';
    case 7
        lineStyle = 'kx-';
    case 8
        lineStyle = 'wx-';
end
end
