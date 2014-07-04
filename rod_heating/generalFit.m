
% This allows us to map correctly a simulated time with our actual data
endTime = ElapsedTimeseconds(end);
timePoints = length(ElapsedTimeseconds);
dt = endTime/timePoints;


%======ADJUST PARAMETERS HERE======
fitParams = {'emissivity'};
guess = [0.1];
% the program automagically adjusts number of fit variables and stuff


% func = @(x) sum((subsref(getTemperatureGradient(endTime,dt,fitParams{1}, x(1),fitParams{2}, x(2),fitParams{3}, x(3)),struct('type','()','subs',{{1:10:50000,1}}))-T1(1:5000,:)).^2+...
%                 (subsref(getTemperatureGradient(endTime,dt,fitParams{1}, x(1),fitParams{2},x(2),fitParams{3},x(3)),struct('type','()','subs',{{1:10:50000,17}}))-T2(1:5000,:)).^2+...
%                 (subsref(getTemperatureGradient(endTime,dt,fitParams{1},x(1),fitParams{2},x(2),fitParams{3},x(3)),struct('type','()','subs',{{1:10:50000,33}}))-T3(1:5000,:)).^2);
%             
errorVectorT1 = @(x) (getTemperatureVector(0, endTime,dt,fitParams, x) - T1);
errorVectorT2 = @(x) (getTemperatureVector(0, endTime,dt,fitParams, x) - T2);
errorVectorT3 = @(x) (getTemperatureVector(0, endTime,dt,fitParams, x) - T3);

errorLeastSquares = @(x) sum( errorVectorT1(x).^2 + ...
                                errorVectorT2(x).^2 + ...
                                errorVectorT3(x).^3);
            
             %(subsref(getTemperatureGradient(1500,0.1,x(1),x(2),x(3)),struct('type','()','subs',{{1000:5:15000,17}}))-T2(200:3000,:)).^2+...




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

start = tic;

disp('...');

[params,fval] = fminsearch(errorLeastSquares,guess);

for paramNum = 1:length(fitParams)
    disp([fitParams{paramNum} ': ' num2str(params(paramNum))]);
end

disp(['Time Elapsed: ' num2str(toc(start))]);

disp(['=========FINISHED: ' datestr(now) '===========']);

hold on;
plot(ElapsedTimeseconds, T1, 'r');
plot(ElapsedTimeseconds, T2, 'b');
plot(ElapsedTimeseconds, T3, 'g');
title('Fitted Curve');


% hold on;
% plot(Time./2,T1,'k');
% plot(Time./2,T2,'k');
% plot(Time./2,T3,'k');
