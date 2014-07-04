function temperature = getTemperatureGradient(varargin)
% getTemperatureGradient returns the temperature gradient matrix of copper
% rod, with a plot of temperature vs. time at the specified distance x
% from the left end of the rod.
%
% The heating conditions is specified by heatingRodTimeStep.m, using the
% given time step dt.
%
% Each row of the temperature matrix is a snapshot of the rod's temperature
% at the time. The row is geographically mapped; i.e. the leftmost cell
% holds the temperature of the leftmost segment of the rod.
%
% The rod parameters can be specified with parameters:
%
%     parameters.rodlength    % Length of the rod
%     parameters.kappa        % Kappa value for the rod material
%     parameters.c            % Specific Heat Capacity of rod material
%     parameters.density      % Density of the rod material
%     parameters.crossArea    % Cross sectional area of rod
%
%
%   getTemperatureGradient(T, dt, fitParamName, guessValue, ...)
%
% returns the temperature gradient, with the specified parameter, given by
% fitParamName, modified to guessValue. Any number of fit parameters can be
% specified in this format (name, guessValue) after T and dt.

if isempty(varargin)
    time = 5000;
    dt = 0.1;
else
    time = varargin{1};
    dt = varargin{2};
end

% Initialize Parameters
parameters = struct;
timePoints = [];
timeVector = [];

setParameters();

initialConditions();

calculateTemperatureGradient();

plot(timeVector, temperature(:, getDistanceIndex(0)), 'r.');
hold on;
plot(timeVector, temperature(:, getDistanceIndex(0.075)), 'g.');
plot(timeVector, temperature(:, getDistanceIndex(0.15)), 'b.');
plot(timeVector, temperature(:, getDistanceIndex(0.225)), 'k.');
xlabel('Time (s)','fontsize',14);
ylabel('Temperature (Celsius)','fontsize',14);
hold off;




%% Function Definitions
    function setParameters()
        % ===== Setting parameters and stuff
        % K of Aluminum is 205 W/(m*K)
        parameters.kappa = 205;
        
        % Convection constant for Aluminum
        parameters.hConvection = 12;
        
        % For Aluminum, at 25 Celsius, 900 J/kgC
        parameters.c = 900;
        
        % For Aluminum, at 2700 kg/m^3
        parameters.density = 2700;
        
        % Diameter is 22.5 mm = 0.0225m
        parameters.radius = 0.0225/2;
        parameters.crossArea = parameters.radius^2 * pi;
        
        % 1 foot
        parameters.rodLength = 0.225;
        
        parameters.segments = 50;
        
        parameters.roomTemp = 20;
        
        parameters.emissivity = 0.03;
        
        parameters.power = 5;
        
        timePoints = time/dt;
        
        timeVector = linspace(0, time, timePoints);
        
        setFitParams();
        
    end

    function initialConditions()
        temperature = ones(timePoints, parameters.segments) * 0;%*parameters.roomTemp;
    end

    function calculateTemperatureGradient()
        % Skips the first row of data
        for t=2:timePoints
            lastRodState = temperature(t-1,:);
            
            rodState = heatingRodTimeStep(lastRodState, ...
                dt, parameters);
            
            temperature(t, :)  = rodState;
        end
        
    end

    function distanceIndex = getDistanceIndex(x)
        % Calculates the index of the specified distance x
        if x<=0
            distanceIndex = 1;
        elseif x>=parameters.rodLength
            distanceIndex = parameters.segments;
        else
            distanceIndex = round((x/parameters.rodLength)*parameters.segments);
        end
    end

    function setFitParams()
        if length(varargin) > 2
            varNum = 3;
            while(varNum < length(varargin))
                
                varName = varargin{varNum};
                
                if ~isa(varName, 'char')
                    errordlg(['Input variable ' num2str(varNum) ' must be a string! Way to be scrub! Continuing...'], ...
                        'Input Error', 'modal');
                    
                    varNum = varNum + 1;
                    continue;
                end
                
                if ~isfield(parameters, varName)
                    errordlg([varName ' is not a valid parameter! Way to be scrub! Continuing...'], ...
                        'Input Error', 'modal');

                    varNum = varNum + 1;
                    continue;
                end
                
                varNum = varNum + 1;
                varValue = varargin{varNum};
                if ~isa(varValue, 'double')
                    errordlg([varName ' needs it''s value after it! Way to be scrub! Continuing...'], ...
                        'Input Error', 'modal');
                    
                    varNum = varNum + 1;
                    continue;
                end
                parameters = setfield(parameters, varName, varValue);
                varNum = varNum + 1;
            end
        end
    end


end

