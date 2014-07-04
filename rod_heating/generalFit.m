
% This allows us to map correctly a simulated time with our actual data
endTime = ElapsedTimeseconds(end);
timePoints = length(ElapsedTimeseconds);
dt = endTime/timePoints;


%======ADJUST PARAMETERS HERE======
fitParams = {'emissivity', 'hConvection', 'c'};
guess = [0, 12.5, 900];
% the program automagically adjusts number of fit variables and stuff


    
errorVectorT1 = @(x) (getTemperatureVector(0, endTime,dt,fitParams, x) - T1);
errorVectorT2 = @(x) (getTemperatureVector(0, endTime,dt,fitParams, x) - T2);
errorVectorT3 = @(x) (getTemperatureVector(0, endTime,dt,fitParams, x) - T3);

errorLeastSquares = @(x) sum( errorVectorT1(x).^2 + ...
                                errorVectorT2(x).^2 + ...
                                errorVectorT3(x).^3);
            




initialGuess = getTemperatureVector(0, endTime, dt, fitParams, guess);
hold on;
plot(ElapsedTimeseconds, T1, 'r');
plot(ElapsedTimeseconds, T2, 'b');
plot(ElapsedTimeseconds, T3, 'g');
title('Initial Guess');

figure;



disp(['=========FIT STARTING: ' datestr(now) '============'])

disp('Looking for ');
for paramNum = 1:length(fitParams)
    disp([fitParams{paramNum} ', with guess ' num2str(guess(paramNum))]);
end

disp(['Guess Error: ' num2str(errorLeastSquares(guess))]);

start = tic;

disp('...');

[params,fval] = fminsearch(errorLeastSquares,guess);

for paramNum = 1:length(fitParams)
    disp([fitParams{paramNum} ': ' num2str(params(paramNum))]);
end

disp(['Fit Error: ' num2str(fval)]);

disp(['Time Elapsed: ' num2str(toc(start))]);

disp(['=========FINISHED: ' datestr(now) '===========']);

hold on;
plot(ElapsedTimeseconds, T1, 'r');
plot(ElapsedTimeseconds, T2, 'b');
plot(ElapsedTimeseconds, T3, 'g');
title('Fitted Curve');


