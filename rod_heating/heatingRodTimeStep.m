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
heatFromLeft = 0;

heatFromRight = conductiveHeatIntoFrom(lastRodState(1), lastRodState(2), parameters.kappa, parameters.crossArea, dx);


% cylindrical surface area + side cross section
convectionArea = 2*pi*parameters.radius*dx + parameters.crossArea;
heatLostToConvection = convectiveHeatLostFromTo(lastRodState(1), parameters.roomTemp, parameters.hConvection, convectionArea);

totalHeat = heatFromLeft + heatFromRight - heatLostToConvection;

tempIncrease = totalHeat*dt/(parameters.specificHeatCapacity*dm);
newRodState(1) = lastRodState(1) + tempIncrease;


    
%% Middle segments (excluding end points)
for segment = 2:(segments-1)
    %offset to exclude the first data point, which represents left side
    %of rod
    heatFromLeft = conductiveHeatIntoFrom(lastRodState(segment), lastRodState(segment-1), parameters.kappa, parameters.crossArea, dx);
    heatFromRight = conductiveHeatIntoFrom(lastRodState(segment), lastRodState(segment+1), parameters.kappa, parameters.crossArea, dx);
    
    % cylindrical surface area + side cross section
    convectionArea = 2*pi*parameters.radius*dx;
    heatLostToConvection = convectiveHeatLostFromTo(lastRodState(segment), parameters.roomTemp, parameters.hConvection, convectionArea);

    totalHeat = heatFromLeft + heatFromRight - heatLostToConvection;

    tempIncrease = totalHeat*dt/(parameters.specificHeatCapacity*dm);
    
    newRodState(segment) = lastRodState(segment) + tempIncrease;
end


%% Rightmost Segment

heatFromLeft = conductiveHeatIntoFrom(lastRodState(end), lastRodState(end-1), parameters.kappa, parameters.crossArea, dx);

heatFromRight = 0;


% cylindrical surface area + side cross section
convectionArea = 2*pi*parameters.radius*dx + parameters.crossArea;
heatLostToConvection = convectiveHeatLostFromTo(lastRodState(end), parameters.roomTemp, parameters.hConvection, convectionArea);

totalHeat = heatFromLeft + heatFromRight - heatLostToConvection;

tempIncrease = totalHeat*dt/(parameters.specificHeatCapacity*dm);
newRodState(end) = lastRodState(end) + tempIncrease;


end

function H = conductiveHeatIntoFrom(temp, otherTemp, kappa, contactArea, contactDistance)
    H = (-kappa*contactArea/contactDistance)*(temp - otherTemp);
end

function H = convectiveHeatLostFromTo(temp, roomTemp, convectionConstant, contactArea)
    H = convectionConstant*contactArea*(temp - roomTemp);
end

function H = radiationHeatLossFrom(temp, contactArea, emissivity)
    stefan_boltzmann = 5.6703E-8;
    H = contactArea*emissivity*stefan_boltzmann*(temp^4);
end
