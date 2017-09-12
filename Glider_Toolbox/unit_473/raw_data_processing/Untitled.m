% var = temperature;
% idx = var(1:5000000,2) == 0;
% plot3(lat(idx),lon(idx),var(idx,1))%,5,o2phase(idx,1),'filled')
% view(gca,[225 ,-59])

temp_corr = fofonoffcorrect(temperature(:,1),time,2*ones(length(time),1));
