% plot T-S data as a set of subplots with the physical data on top
% and anomaly graphs on the bottom in which the mean of each quantity is
% subtracted from the entire set i.e.: 
% temperature-mean(temperature),...etc.

for j = 26:26
    id = theta_flag(:,j) == 0;
    grid_plotter(salinity(id,j),theta(id,j),sigma(id,j),j,MeanSigma-1000,output_path,...
            'XName','Salinity PSU',...
            'YName','Temperature',...
            'ZName','Sigma',...
            'ZUnits','kg/m^3',...
            'ZvalueFill','off',...
            'Smoothing','off',...
            'SmoothingSize',15,...
            'Contours','on',...
            'ContourLevels',[27.1 27.3 27.6],...
            'Scatter','on');
      
end