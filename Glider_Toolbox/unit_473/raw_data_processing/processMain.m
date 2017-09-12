
clc, clearvars
clear

%% Science Data
getScienceData % careful!! select range of sensor data to exclude very beginning and end

%% Correct for Variable Sampling Rate and Skipped Recordings
getResampledData % resampled to 0.5 Hz (even time step)

%% Vehicle Data
getVehicleData % get lat, lon, pitch, heading data

%% Combine data sets
data = [sdata,vdata]; 

%% Check Data, Flag and Seperate Up - Downcasts 
getCheckedData
 
%% Generate Salinity and Density values
getSalinityDensity

%% get O2 data 
%

%% get pco2 data
getpco2

%% Combine Data
getOutputData
