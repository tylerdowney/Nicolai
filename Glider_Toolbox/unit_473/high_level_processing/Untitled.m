i = 10;
var = pco2(:,i);
idx = pco2_flag(:,i) == 0;
scatter(range(idx,i),salinity(idx,i),5,pco2(idx,i),'filled')%,5,o2phase(idx,1),'filled')
% view(gca,[225 ,-59])

% temp_corr = fofonoffcorrect(temperature(:,1),time,2*ones(length(time),1));
