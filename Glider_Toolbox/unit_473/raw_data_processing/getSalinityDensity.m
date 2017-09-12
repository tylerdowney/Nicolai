path = pwd;
addpath([path(1:end-29),'\SeaWater_Toolbox'])

flags = conductivity(ismember(conductivity(:,2),temperature(:,2)),2);

salinity = sw_salt(conductivity(:,1).*10/42.914,temperature(:,1),pressure); % salinity, PSU
salinity = [salinity, flags];

theta = sw_ptmp(salinity(:,1),temperature(:,1),pressure,0); % potential temperature wrt 0 db (SS)
theta = [theta, flags];


sigma = sw_pden(salinity,theta,pressure,0); % density SW, kg/m^3 wrt 0 db (SS)
sigma = [sigma, flags];

depth = sw_dpth(pressure); % depth, m 

clear path