data = [time,pressure,depth,theta,salinity,sigma,pco2,pitch,heading,lat,lon];

path = pwd;
path = [path(1:end-20),'\raw_data_output\'];
save([path,'GliderData.mat'],'data')