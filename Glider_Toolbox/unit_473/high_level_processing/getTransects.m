%% Seperate data by transect #
lat = data(:,15);
lon = data(:,16);
time = data(:,1);

% apply movign avg. filter
windowSize = 1; 
b = (1/windowSize)*ones(1,windowSize);
lat_filt = filter(b,1,lat);
lon_filt = filter(b,1,lon);

% find transect switches
[~,locs1] = findpeaks(lat_filt,'MinPeakWidth',4000);
lat_filt_inverted = -lat_filt;
[~,locs2] = findpeaks(lat_filt_inverted,'MinPeakWidth',2500);

idx = sort(unique([locs1;locs2;length(lat)]));
time_gaps = time(idx);
idx = idx((diff(time_gaps)>0.5));
idx = [1;idx;length(lat)];

hold on
plot(time,lat_filt,'k','LineWidth',1)
plot(time(locs1),lat_filt(locs1),'rv','MarkerFaceColor','r')
plot(time(locs2),lat_filt(locs2),'rs','MarkerFaceColor','b')
plot(time(idx),lat_filt(idx),'or','MarkerFaceColor','g')
ylabel('latitude decimal deg')
xlabel('unix time')

diff_idx = max(diff(idx));

lat = NaN(max(diff_idx),length(idx));
lon = NaN(max(diff_idx),length(idx));
range = NaN(max(diff_idx),length(idx));

time = NaN(max(diff_idx),length(idx)); % time of transect divided by column
depth = NaN(max(diff_idx),length(idx));

theta = NaN(max(diff_idx),length(idx));
theta_flag = NaN(max(diff_idx),length(idx));

salinity = NaN(max(diff_idx),length(idx));
salinity_flag = NaN(max(diff_idx),length(idx));

sigma = NaN(max(diff_idx),length(idx));
sigma_flag = NaN(max(diff_idx),length(idx));

pco2 = NaN(max(diff_idx),length(idx));
pco2_flag = NaN(max(diff_idx),length(idx));

heading = NaN(max(diff_idx),length(idx));
pitch = NaN(max(diff_idx),length(idx));

% Seperate by transects 

for j = 1:length(idx)-1
    time(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,1); % UNIX time 
    depth(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,2); % depth, m
    
    theta(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,4); % pot.temperature, Deg. C
    theta_flag(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,5); % flag
    
    salinity(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,6); % salinity, PSU
    salinity_flag(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,7); % flag
    
    sigma(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,8)-1000; % pot.density, kg/m3
    sigma_flag(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,10); % sigma

    pco2(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,11); % pco2 uatn
    pco2_flag(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,12); % flag
    
    pitch(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,13); % pitch deg
    heading(1:(idx(j+1)-idx(j)),j)=data(idx(j):idx(j+1)-1,14); % heading deg
    
    lat(1:(idx(j+1)-idx(j)),j)=lat_filt(idx(j):idx(j+1)-1,1); % latitude in decimal degress
    lon(1:(idx(j+1)-idx(j)),j)=lon_filt(idx(j):idx(j+1)-1,1); % longitiude in decimal degrees
end

%% Delete data not resembling transects
% 
% time = time(:,[2:12,16,17,20,21]);
% press = press(:,[2:12,16,17,20,21]);
% temp = temp(:,[2:13,17,18,21,22]);
% salinity = salinity(:,[1:12,16,17,20,21]);
% density = density(:,[1:12,16,17,20,21]);
% depth = depth(:,[1:12,16,17,20,21]);
% 
% o2_conc = o2_conc(:,[1:12,16,17,20,21]);
% o2_sat = o2_sat(:,[1:12,16,17,20,21]);
% 
% lat = lat(:,[1:12,16,17,20,21]);
% lon = lon(:,[1:12,16,17,20,21]);

%% Calculate Range
path = pwd;
path = [path(1:end-31),'/SeaWater_Toolbox'];
addpath(path)

for j = 1:length(lat(1,:))
    range(:,j) = compute_range(lat(:,j),lon(:,j),0);
end

% distmax = max(range); % store result of range covered for analytical purp.

%% Mean values of data set for anomaly comparisons
idx = data(:,5) == 0;
MeanTheta = nanmean(data(idx,4));

idx = data(:,10) == 0;
MeanSigma = nanmean(data(idx,8));

idx = data(:,7) == 0;
MeanSalinity = nanmean(data(idx,6));

idx = data(:,12) == 0;
Meanpco2 = nanmean(data(idx,11));

clear path idx lat_filt lon_filt time_gaps windowSize locs1 locs2 idx2 diff_time b diff_idx lat_filt_inverted obsph j path xl distmax endDate startDate formatIn DateString 
