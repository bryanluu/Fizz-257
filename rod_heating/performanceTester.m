tic;
fine = getTemperatureGradient(5000, 0.1, 'emissivity', 0.3680, 'c', 406.9863, 'hConvection', 3.3027, 'segments', 50);
disp('With Timestep of 0.1, 50 segments');
disp(toc);

timePoints = 5000/0.1;
        
timeVector = linspace(0, 5000, timePoints);

timePoints = length(ElapsedTimeseconds);
endTime = ElapsedTimeseconds(end);
dt = endTime/timePoints;

tic;
coarse = getTemperatureGradient(5000, 1, 'emissivity', 0.3680, 'c', 406.9863, 'hConvection', 3.3027, 'segments', 10);
disp('With Timestep of 1, 10 segments');
disp(toc);

figure;

plot(timeVector, fine(:,end/2), 'r');

hold on

timePoints = 5000/1;
        
timeVector = linspace(0, 5000, timePoints);

plot(timeVector, coarse(:,end/2), 'b');

