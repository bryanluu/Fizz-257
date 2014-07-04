function temperatureAtDistance = getTemperatureVector( varargin )
% First input is your distance
% Next two inputs are Time and dt
% The rest are just your parameter name and value pairs

distanceIndex = getDistanceIndex(varargin{1});

if length(varargin) == 1
    tempMatrix = getTemperatureGradient;
else
    tempMatrix = getTemperatureGradient(varargin{2:end});
end

temperatureAtDistance = tempMatrix(:, distanceIndex);


end