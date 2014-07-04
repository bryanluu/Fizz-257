function distanceIndex = getDistanceIndex(x)
% Calculates the index of the specified distance x

segments = 10;
rodLength = 0.3048;

if x<=0
    distanceIndex = 1;
elseif x>=rodLength
    distanceIndex = segments;
else
    distanceIndex = round((x/rodLength)*segments);
end
end
