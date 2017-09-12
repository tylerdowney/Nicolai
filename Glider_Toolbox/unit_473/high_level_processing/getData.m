clear; clc

path = pwd;
path = [path(1:end-22),'/raw_data_output/'];
load([path,'GliderData.mat'])
data = data(1545905:10484974,:);

clear path