%% Calculating the Heat Flow through a Rod discretely
% heatingRodTimeStep calculates the the heat flow discretely through a rod,
% where lastRodState is an array containing the temperature through the rod
% at a certain time. dt is the duration of the time step.
% The rod parameters can be specified with parameters:
% 
%     parameters.rodlength    % Length of the rod
%     parameters.kappa        % Kappa value for the rod material
%     parameters.c            % Specific Heat Capacity of rod material
%     parameters.density      % Density of the rod material
%     parameters.crossArea    % Cross sectional area of rod
% 

function newRodState = heatingRodTimeStep( lastRodState, dt, parameters )    

%% Discrete Variables

segments = length(lastRodState);
% Length of the small segment, measured from the centers
dx = parameters.rodLength/segments;
% Mass of small segment
dm = parameters.crossArea*dx*parameters.density;


%% Initializations
newRodState = lastRodState;


%% Leftmost Segment
    
% 5W coming in from left, 5J/s * dt = Joules gained in that time
heatFromLeft = (100/15)*dt;

tempDiffRight = lastRodState(1)-lastRodState(2);
heatFromRight = (-parameters.kappa*parameters.crossArea)*(dt/dx)*tempDiffRight;

heatIntoSegment = heatFromLeft + heatFromRight;

totalHeat = heatIntoSegment;

tempIncrease = totalHeat/(parameters.specificHeatCapacity*dm);
newRodState(1) = lastRodState(1) + tempIncrease;


    
%% Middle segments (excluding end points)
for segment = 2:(segments-1)
    %offset to exclude the first data point, which represents left side
    %of rod

    doubleDiffTerm = lastRodState(segment-1) - 2*lastRodState(segment) + lastRodState(segment+1);


    tempIncrease = (parameters.kappa*dt*doubleDiffTerm)/(parameters.density*parameters.specificHeatCapacity*dx^2);

    newRodState(segment) = lastRodState(segment) + tempIncrease;
end


%% Rightmost Segment

% Constant temperature at end
tempEnd = parameters.roomTemp;
newRodState(end) = tempEnd;


end

