

figure(i);

endTime = ElapsedTimeseconds(end);
timePoints = floor(endTime/0.1);
shift = (timePoints/length(ElapsedTimeseconds));

fitParams = {'emissivity', 'c', 'hConvection'};

func = @(x) sum((subsref(getTemperatureGradient(5000,0.1,fitParams{1}, x(1),fitParams{2}, x(2),fitParams{3}, x(3)),struct('type','()','subs',{{1:10:50000,1}}))-T1(1:5000,:)).^2+...
                (subsref(getTemperatureGradient(5000,0.1,fitParams{1}, x(1),fitParams{2},x(2),fitParams{3},x(3)),struct('type','()','subs',{{1:10:50000,17}}))-T2(1:5000,:)).^2+...
                (subsref(getTemperatureGradient(5000,0.1,fitParams{1},x(1),fitParams{2},x(2),fitParams{3},x(3)),struct('type','()','subs',{{1:10:50000,33}}))-T3(1:5000,:)).^2);
            
             %(subsref(getTemperatureGradient(1500,0.1,x(1),x(2),x(3)),struct('type','()','subs',{{1000:5:15000,17}}))-T2(200:3000,:)).^2+...


x0 = [0.1,900,15];

[params,fval] = fminsearch(func,x0);

i = i+1;

hold on;
plot(Time./2,T1,'k');
plot(Time./2,T2,'k');
plot(Time./2,T3,'k');
