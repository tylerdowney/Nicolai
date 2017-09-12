
addpath([pwd,'/unit_473_raw_data'])
[sdata] = load('ebd.mat'); % Load science data .dbd file
sc = sdata.sensor_lookup; % sensor names lookup array
sdata = sdata.data; % science data

idx=[sc.sci_m_present_time, sc.sci_water_pressure, ... 
    sc.sci_water_temp, sc.sci_water_cond, ...
    sc.sci_oxy4_calphase, sc.sci_oxy4_temp, ...
    sc.sci_pco2_temp, sc.sci_pco2_calphase];

sdata = sdata(1348:1934725,idx); % required data
[idx, ~] = find(isnan(sdata(:,1))); sdata(idx,:) = []; % can't work with not existing times

clear idx sc 