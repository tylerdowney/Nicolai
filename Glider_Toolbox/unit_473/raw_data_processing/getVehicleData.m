addpath([pwd,'/unit_473_raw_data'])
[gdata] = load('dbd.mat'); % Load glider data .dbd file
gl = gdata.sensor_lookup; % sensor names lookup array
gdata = gdata.data; % glider data

% get sensor name data
idx=[gl.m_present_time, gl.m_gps_lat, gl.m_gps_lon, gl.m_pitch, gl.m_heading ];
gdata = gdata(:,idx); 

%% Calculate glider position

newdata=gdata*0;
for i=2:5
    ind=find( isnan(gdata(:,i))==0 &gdata(:,i)<100000);
    de=floor( abs(gdata(ind,i)/100) );
    dm= ( abs(gdata(ind,i)) - de*100)/60;
    temp=sign(gdata(ind,i)).*(de+dm);
    newdata(ind,i)=temp;
end
gdata(:,2:5) = newdata(:,2:5);
[idx, ~] = find(isnan(gdata(:,2)) | gdata(:,2)==0);
gdata(idx,:)=[];

%% Add vehicle data to total data set with merged time series

lat = interp1(gdata(:,1),gdata(:,2),sdata(:,1)); % lat synchro with science_time
lon = interp1(gdata(:,1),gdata(:,3),sdata(:,1)); % lon synchro with science_time
pitch = interp1(gdata(:,1),gdata(:,4),sdata(:,1)); 
heading = interp1(gdata(:,1),gdata(:,5),sdata(:,1));

vdata = [lat, lon, pitch, heading];

clear de dm gdata gl i idx ind newdata temp lat lon pitch heading
