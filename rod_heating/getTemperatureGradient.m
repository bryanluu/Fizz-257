function temperature = getTemperatureGradient(time, dt)
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


% Initialize Parameters
parameters = struct;
timePoints = [];

setParameters();

initialConditions();

calculateTemperatureGradient;

plot(temperature(:, getDistanceIndex(0)), 'r');
hold on;
plot(temperature(:, getDistanceIndex(0.075)), 'g');
plot(temperature(:, getDistanceIndex(0.15)), 'b');
plot(temperature(:, getDistanceIndex(0.225)), 'k');
xlabel('Time (s)');
ylabel('Temperature (Celsius)');



%% Function Definitions
    function setParameters()
        % ===== Setting parameters and stuff
        % K of Aluminum is 205 W/(m*K)
        parameters.kappa = 205;
        
        % Convection constant for Aluminum
        parameters.hConvection = 1;
        
        % For Aluminum, at 25 Celsius, 900 J/kgC
        parameters.specificHeatCapacity = 900;
        
        % For Aluminum, at 2700 kg/m^3
        parameters.density = 2700;
        
        % Radius is 22.5 mm = 0.0225m
        parameters.radius = 0.0225;
        parameters.crossArea = parameters.radius^2 * pi;
        
        % 1 foot
        parameters.rodLength = 0.3048;
        
        parameters.segments = 50;
        
        parameters.roomTemp = 20;
        
        timePoints = time/dt;

    end

    function initialConditions()
        temperature = ones(timePoints, parameters.segments) * parameters.roomTemp;
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


end

