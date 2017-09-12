% Split data set into up-/downcasts
idx_down = find([0;diff(data(:,2))]>0); idx_up = (setdiff(1:length(data(:,1)),idx_down))';
downcasts = data(idx_down,:);
upcasts = data(idx_up,:);
 
%% Downcast Data %%
% Check data for very linear trends
% Correct Temperature and Conductivity according to Foffonof et al.
% Use Tau = 2 seconds
%% Define the data index
idx_sep_downcast = [1;find([0;diff(downcasts(:,2))]<0)];

% Time, Pressure, o2 & co2 Temperature, lat, lon, pitch & heading
cnt = 1;
for i = 1:length(idx_sep_downcast)-1
    downcast_time{cnt} = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,1);%#ok<SAGROW>
    downcast_pressure{cnt} = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,2);%#ok<SAGROW>
    downcast_o2temp{cnt} = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,5);%#ok<SAGROW>
    downcast_co2temp{cnt} = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,7);%#ok<SAGROW>
    downcast_lat{cnt} = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,9);%#ok<SAGROW>
    downcast_lon{cnt} = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,10);%#ok<SAGROW>
    downcast_pitch{cnt} = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,11);%#ok<SAGROW>
    downcast_heading{cnt} = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,12);%#ok<SAGROW>
    cnt = cnt+1;
end

% Temperature
cnt = 1;
for i = 1:length(idx_sep_downcast)-1
    cast_length=idx_sep_downcast(i+1)-idx_sep_downcast(i); % get length of cast    
    y = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,2); x = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,3);
    ci = polyfit(x,y,1); y2 = polyval(ci,x); Rsq = 1 - sum((y - y2).^2)/sum((y - mean(y)).^2);    
    if Rsq<0.85 
        downcast_temperature{cnt} = [downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,3),zeros(cast_length,1)]; %#ok<SAGROW>       
    else 
        downcast_temperature{cnt} = [downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,3),ones(cast_length,1)]; %#ok<SAGROW>
    end
    cnt = cnt+1;
end

% Conductivity
cnt = 1;
for i = 1:length(idx_sep_downcast)-1
    cast_length=idx_sep_downcast(i+1)-idx_sep_downcast(i); % get length of a upcast 
    y = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,2); x = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,4);
    ci = polyfit(x,y,1); y2 = polyval(ci,x); Rsq = 1 - sum((y - y2).^2)/sum((y - mean(y)).^2);    
    if Rsq<0.75 
        downcast_conductivity{cnt} = [downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,4),zeros(cast_length,1)];%#ok<SAGROW>; %#ok<SAGROW>       
    else 
        downcast_conductivity{cnt} = [downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,4),ones(cast_length,1)]; %#ok<SAGROW>
    end
    cnt = cnt+1;  
end

% Co2 phase data
cnt = 1;
for i = 1:length(idx_sep_downcast)-1
    cast_length=idx_sep_downcast(i+1)-idx_sep_downcast(i); % get length of cast 
    y = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,2); x = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,8);
    ci = polyfit(x,y,1); y2 = polyval(ci,x); Rsq = 1 - sum((y - y2).^2)/sum((y - mean(y)).^2);
    if Rsq<0.75 
        downcast_co2phase{cnt} = [downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,8),zeros(cast_length,1)]; %#ok<SAGROW>       
    else 
        downcast_co2phase{cnt} = [downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,8),ones(cast_length,1)]; %#ok<SAGROW>
    end
    cnt = cnt+1;
end

% o2 phase data
cnt = 1;
for i = 1:length(idx_sep_downcast)-1
    cast_length=idx_sep_downcast(i+1)-idx_sep_downcast(i); % get length of cast 
    y = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,2); x = downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,6);
    ci = polyfit(x,y,1); y2 = polyval(ci,x); Rsq = 1 - sum((y - y2).^2)/sum((y - mean(y)).^2);
    if Rsq<0.85 
        downcast_o2phase{cnt} = [downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,6),zeros(cast_length,1)]; %#ok<SAGROW>       
    else 
        downcast_o2phase{cnt} = [downcasts(idx_sep_downcast(i):idx_sep_downcast(i+1)-1,6),ones(cast_length,1)]; %#ok<SAGROW>
    end
    cnt = cnt+1;
end

%% Upcast Data %%
% Check data for very linear trends
% Correct Temperature and Conductivity according to Foffonof et al.
% Use Tau = 2 seconds
%% Define the data index
idx_sep_upcast = [1;find([0;diff(upcasts(:,2))]>0)]; 

% Time, Pressure, o2 & co2 Temperature, lat, lon, pitch & heading
cnt = 1;
for i = 1:length(idx_sep_upcast)-1
    upcast_time{cnt} = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,1);%#ok<SAGROW>
    upcast_pressure{cnt} = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,2);%#ok<SAGROW>
    upcast_o2temp{cnt} = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,5);%#ok<SAGROW>
    upcast_co2temp{cnt} = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,7);%#ok<SAGROW>
    upcast_lat{cnt} = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,9);%#ok<SAGROW>
    upcast_lon{cnt} = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,10);%#ok<SAGROW>
    upcast_pitch{cnt} = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,11);%#ok<SAGROW>
    upcast_heading{cnt} = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,12);%#ok<SAGROW>
    cnt = cnt+1;
end

% Temperature
cnt = 1;
for i = 1:length(idx_sep_upcast)-1
    cast_length=idx_sep_upcast(i+1)-idx_sep_upcast(i); % get length of a upcast 
    y = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,2); x = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,3);
    ci = polyfit(x,y,1); y2 = polyval(ci,x); Rsq = 1 - sum((y - y2).^2)/sum((y - mean(y)).^2);    
    if Rsq<0.85 
        upcast_temperature{cnt} = [upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,3),zeros(cast_length,1)]; %#ok<SAGROW>       
    else 
        upcast_temperature{cnt} = [upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,3),ones(cast_length,1)]; %#ok<SAGROW>
    end
    cnt = cnt+1;
end

% Conductivity
cnt = 1;
for i = 1:length(idx_sep_upcast)-1
    cast_length=idx_sep_upcast(i+1)-idx_sep_upcast(i); % get length of a upcast 
    y = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,2); x = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,4);
    ci = polyfit(x,y,1); y2 = polyval(ci,x); Rsq = 1 - sum((y - y2).^2)/sum((y - mean(y)).^2);    
    if Rsq<0.75 
        upcast_conductivity{cnt} = [upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,4),zeros(cast_length,1)];%#ok<SAGROW>; %#ok<SAGROW>       
    else 
        upcast_conductivity{cnt} = [upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,4),ones(cast_length,1)]; %#ok<SAGROW>
    end
    cnt = cnt+1;  
end

% Co2 phase data
cnt = 1;
for i = 1:length(idx_sep_upcast)-1
    cast_length=idx_sep_upcast(i+1)-idx_sep_upcast(i); % get length of a upcast 
    y = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,2); x = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,8);
    ci = polyfit(x,y,1); y2 = polyval(ci,x); Rsq = 1 - sum((y - y2).^2)/sum((y - mean(y)).^2);    
    if Rsq<0.75 
        upcast_co2phase{cnt} = [upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,8),zeros(cast_length,1)]; %#ok<SAGROW>       
    else 
        upcast_co2phase{cnt} = [upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,8),ones(cast_length,1)]; %#ok<SAGROW>
    end
    cnt = cnt+1;
end

% o2 phase data
cnt = 1;
for i = 1:length(idx_sep_upcast)-1
   cast_length=idx_sep_upcast(i+1)-idx_sep_upcast(i); % get length of a upcast 
    y = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,2); x = upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,6);
    ci = polyfit(x,y,1); y2 = polyval(ci,x); Rsq = 1 - sum((y - y2).^2)/sum((y - mean(y)).^2);    
    if Rsq<0.85 
        upcast_o2phase{cnt} = [upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,6),zeros(cast_length,1)]; %#ok<SAGROW>       
    else 
        upcast_o2phase{cnt} = [upcasts(idx_sep_upcast(i):idx_sep_upcast(i+1)-1,6),ones(cast_length,1)]; %#ok<SAGROW>
    end
    cnt = cnt+1;
end

clear cnt cast_length x y ci y2 Rsq sdata vdata idx_down idx_sep_downcast idx_up i upcasts downcasts data

%% Combine processed data  
time = [vertcat(upcast_time{:});vertcat(downcast_time{:})];
pressure = [vertcat(upcast_pressure{:}); vertcat(downcast_pressure{:})];
temperature = [vertcat(upcast_temperature{:});vertcat(downcast_temperature{:})];
conductivity = [vertcat(upcast_conductivity{:});vertcat(downcast_conductivity{:})];
o2phase = [vertcat(upcast_o2phase{:});vertcat(downcast_o2phase{:})];
o2temp = [vertcat(upcast_o2temp{:});vertcat(downcast_o2temp{:})];
co2phase = [vertcat(upcast_co2phase{:});vertcat(downcast_co2phase{:})];
co2temp = [vertcat(upcast_co2temp{:});vertcat(downcast_co2temp{:})];
pitch = [vertcat(upcast_pitch{:});vertcat(downcast_pitch{:})];
heading = [vertcat(upcast_heading{:});vertcat(downcast_heading{:})];
lat = [vertcat(upcast_lat{:});vertcat(downcast_lat{:})];
lon = [vertcat(upcast_lon{:});vertcat(downcast_lon{:})];

data = [time, pressure, temperature, conductivity, o2temp, ...
    o2phase, co2temp, co2phase, lat, lon, pitch, heading];

clearvars time pressure temperature conductivity o2phase o2temp ...
    co2phase co2temp pitch heading lat lon upcast_time ...
    downcast_co2phase downcast_co2temp downcast_conductivity ...
    downcast_heading downcast_lat downcast_lon downcast_o2phase ...
    downcast_o2temp downcast_pitch downcast_pressure ...
    downcast_temperature downcast_time upcast_co2phase upcast_co2temp ...
    upcast_conductivity upcast_heading upcast_lat upcast_lon ...
    upcast_o2phase upcast_o2temp upcast_pitch upcast_pressure ...
    upcast_temperature sdata vdata idx_down idx_up cnt i ...
    idx_sep_downcast idx_sep_upcast cast_length x y ci y2 Rsq ...
    upcasts downcasts

% Sort data using time
data = sortrows(data,1);
time = data(:,1);
pressure = data(:,2);
temperature = data(:,3:4);
conductivity = data(:,5:6);
o2temp = data(:,7);
o2phase = data(:,8:9);
co2temp = data(:,10);
co2phase = data(:,11:12);
lat = data(:,13);
lon = data(:,14);
pitch = data(:,15);
heading = data(:,16);

clear data