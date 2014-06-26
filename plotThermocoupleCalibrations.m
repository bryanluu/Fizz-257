function plotThermocoupleCalibrations
% Thermocouple Checker

V = linspace(0,5,500);

figure;
hold on;
title('Thermocouple Calibrated Temperature vs. Voltage');
xlabel('Voltage (V)');
ylabel('Temperature (\circ C)');
plot(V, A0(V), 'r-');
plot(V, A1(V), 'b-');
plot(V, A2(V), 'g-');
plot(V, A3(V), 'k-');



end

function temp = A0(voltage)
    temp = 22.84*voltage - 6.2214;
end

function temp = A1(voltage)
    temp = 20.772*voltage - 0.8809;
end

function temp = A2(voltage)
    temp = 21.621*voltage - 7.1351;
end

function temp = A3(voltage)
    temp = 21.3*voltage - 0.795;
end