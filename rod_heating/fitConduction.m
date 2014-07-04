

figure(i);
func = @(x) sum((subsref(getTemperatureGradient(4660,0.1,x(1),x(2),x(3),x(4)),struct('type','()','subs',{{1:10:46600,1}}))-T1(1:4660,:)).^2+...
                (subsref(getTemperatureGradient(4660,0.1,x(1),x(2),x(3),x(4)),struct('type','()','subs',{{1:10:46600,25}}))-T3(1:4660,:)).^2+...
                (subsref(getTemperatureGradient(4660,0.1,x(1),x(2),x(3),x(4)),struct('type','()','subs',{{1:10:46600,37}}))-T4(1:4660,:)).^2);
            
options = optimset('TolFun',1e10);

x0 = [900,12,205,5];

[params,fval] = fminsearch(func,x0,options);

i = i+1;

hold on;
plot(Time,T1,'k');
plot(Time,T3,'k');
plot(Time,T4,'k');
