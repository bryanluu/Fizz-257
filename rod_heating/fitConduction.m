

figure(i);
func = @(x) sum((subsref(getTemperatureGradient(1500,0.1,x(1),x(2),x(3)),struct('type','()','subs',{{1000:5:15000,1}}))-T1(200:3000,:)).^2+...
                (subsref(getTemperatureGradient(1500,0.1,x(1),x(2),x(3)),struct('type','()','subs',{{1000:5:15000,33}}))-T3(200:3000,:)).^2);
            
             %(subsref(getTemperatureGradient(1500,0.1,x(1),x(2),x(3)),struct('type','()','subs',{{1000:5:15000,17}}))-T2(200:3000,:)).^2+...


x0 = [900,205,15];

[params,fval] = fminsearch(func,x0);

i = i+1;

hold on;
plot(Time./2,T1,'k');
plot(Time./2,T2,'k');
plot(Time./2,T3,'k');
