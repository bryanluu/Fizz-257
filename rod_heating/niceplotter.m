%======ADJUST PARAMETERS HERE======
fitParams = {'segments' };
values = [9];


errorVectorT1 = @(x) (getTemperatureVector(0, endTime,dt,fitParams, x) - T1);
errorVectorT2 = @(x) (getTemperatureVector(0.075, endTime,dt,fitParams, x) - T2);
errorVectorT3 = @(x) (getTemperatureVector(0.15, endTime,dt,fitParams, x) - T3);
errorVectorT4 = @(x) (getTemperatureVector(0.225, endTime, dt, fitParams, x) - T4);
errorLeastSquares = @(x) sum(errorVectorT1(x).^2 + ...
                                errorVectorT2(x).^2 + ...
                                errorVectorT3(x).^2);

errorSquared = errorLeastSquares(values)

averageError = sqrt(errorSquared)/length(ElapsedTimeseconds)

sim = getTemperatureVector(0.225, endTime,dt,fitParams, values);
sim2 = getTemperatureVector(0.075, endTime,dt,fitParams, values);
sim3 = getTemperatureVector(0.15, endTime,dt,fitParams, values);
% plot(ElapsedTimeseconds, sim, 'k-')
xlabel('Time (seconds)');
ylabel('Temperature (\circ C)');

hold on

% plot(ElapsedTimeseconds, sim2, 'g-')
% plot(ElapsedTimeseconds, sim3, 'b-')

plot(ElapsedTimeseconds(1:5:end), T1(1:5:end), 'r--')
plot(ElapsedTimeseconds(1:5:end), T2(1:5:end), 'g--')
plot(ElapsedTimeseconds(1:100:end), T3(1:100:end), 'b--')
plot(ElapsedTimeseconds(1:100:end), T4(1:100:end), 'k--')
grid on