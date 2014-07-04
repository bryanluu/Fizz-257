
figure(i);
func = @(x) sum((subsref(getTemperatureGradient(1500,0.1,x(1),x(2),x(3)),struct('type','()','subs',{{1000:5:15000,1}}))-temps.c1(200:3000,:)).^2+...
                (subsref(getTemperatureGradient(1500,0.1,x(1),x(2),x(3)),struct('type','()','subs',{{1000:5:15000,17}}))-temps.c2(200:3000,:)).^2+...
                (subsref(getTemperatureGradient(1500,0.1,x(1),x(2),x(3)),struct('type','()','subs',{{1000:5:15000,33}}))-temps.c3(200:3000,:)).^2);
            
x0 = [900,205,15];


[params,fval] = fminsearch(func,x0);

i = i+1;

hold on;
plot(temps.cTime./2,temps.c1,'k');
plot(temps.cTime./2,temps.c2,'k');
plot(temps.cTime./2,temps.c3,'k');
