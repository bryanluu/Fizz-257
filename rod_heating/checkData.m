% Check the data vs simulation
% This allows us to map correctly a simulated time with our actual data
endTime = ElapsedTimeseconds(end);
timePoints = length(ElapsedTimeseconds);
dt = endTime/timePoints;

%======ADJUST PARAMETERS HERE======
fitParams = {'segments' };
guess = [ 10 ];

figure;
initialGuess = getTemperatureVector(0.075, endTime, dt, fitParams, guess);

hold on;
plot(ElapsedTimeseconds, T1, 'r');
plot(ElapsedTimeseconds, T2, 'g');
plot(ElapsedTimeseconds, T3, 'b');
plot(ElapsedTimeseconds, T4, 'k');
title('Initial Guess');
hold off;