% Time synchronization

% main Science clock
presentTime = sdata(:,1);
dt = 1/0.50; % 0.50 Hz resampling frquency suggested by Bishop et al, 2008
[~ , newTime] = resample(presentTime,presentTime,dt); % resampled time series

% resample variables ** using interp1 instead of resample 
pressure = sdata(:,2); id = find(~isnan(pressure) & pressure>0);
pressure = interp1(presentTime(id),pressure(id),newTime,'linear');
ctd_temp = sdata(:,3); %diff_temp = [0;diff(ctd_temp)];
id = find(~isnan(ctd_temp) & ctd_temp~=0 ); % abs(diff_temp)<3*nanstd(diff_temp)+nanmean(diff_temp));
ctd_temp = interp1(presentTime(id),ctd_temp(id),newTime,'linear');
ctd_cond = sdata(:,4); id = find(~isnan(ctd_cond) & ctd_cond>0.01 );
ctd_cond = interp1(presentTime(id),ctd_cond(id),newTime,'linear');
o2_calphase = sdata(:,5); id = find(~isnan(o2_calphase) & o2_calphase~=0);
o2_calphase = interp1(presentTime(id),o2_calphase(id),newTime,'linear');
o2_temp = sdata(:,6); id = find(~isnan(o2_temp) & o2_temp~=0);
o2_temp = interp1(presentTime(id),o2_temp(id),newTime,'linear');
co2_temp = sdata(:,7); id = find(~isnan(co2_temp) & co2_temp~=0);
co2_temp = interp1(presentTime(id),co2_temp(id),newTime,'linear');
co2_calphase = sdata(:,8); id = find(~isnan(co2_calphase) & co2_calphase~=0);
co2_calphase = interp1(presentTime(id),co2_calphase(id),newTime,'linear');

sdata = [newTime , pressure.*10 , ctd_temp , ctd_cond , o2_temp , o2_calphase , co2_temp , co2_calphase];
% **NOTE converted to dB


clear presentTime id dt diff_temp newTime pressure ctd_temp ctd_cond o2_temp o2_calphase co2_temp co2_calphase