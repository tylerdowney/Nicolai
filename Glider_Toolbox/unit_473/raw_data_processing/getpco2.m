
%% Foil coefficients for pco2 sensor (SN54) from Dasha's email

C0 = [-2.006047729174E+08,7.562678030578E+07,-3.745567366932E+06,0.000000000000E+00];
C1 = [2.674574449766E+07,-9.878567292047E+06,4.867514654527E+05,0.000000000000E+00];
C2 = [-1.482590353973E+06,5.372585467044E+05,-2.634132909837E+04,0.000000000000E+00];
C3 = [4.374486657227E+04,-1.557280482231E+04,7.598469706991E+02,0.000000000000E+00];
C4 = [-7.247084374209E+02,2.537350565734E+02,-1.232262518432E+01,0.000000000000E+00];
C5 = [6.392418092001E+00,-2.203493404552E+00,1.065250031126E-01,0.000000000000E+00];
C6 = [-2.345714238810E-02,7.968218554613E-03,-3.835014932393E-04,0.000000000000E+00];
C7 = [0.000000000000E+00,0.000000000000E+00,0.000000000000E+00,0.000000000000E+00];
C8 = [0.000000000000E+00,0.000000000000E+00,0.000000000000E+00,0.000000000000E+00];


%% pco2 calculation
flags = co2phase(ismember(co2phase(:,2),temperature(:,2)),2);
  
% Use in-situ temperature from CTD rather than sensor mounted temperature sensor
% (since it is less accurate and unstable in performance) temperature is in deg C
Ct0 = C0(1) + C0(2).*temperature(:,1) + C0(3).*temperature(:,1).^2 + C0(4).*temperature(:,1).^3;
Ct1 = C1(1) + C1(2).*temperature(:,1) + C1(3).*temperature(:,1).^2 + C1(4).*temperature(:,1).^3;
Ct2 = C2(1) + C2(2).*temperature(:,1) + C2(3).*temperature(:,1).^2 + C2(4).*temperature(:,1).^3;
Ct3 = C3(1) + C3(2).*temperature(:,1) + C3(3).*temperature(:,1).^2 + C3(4).*temperature(:,1).^3;
Ct4 = C4(1) + C4(2).*temperature(:,1) + C4(3).*temperature(:,1).^2 + C4(4).*temperature(:,1).^3;
Ct5 = C5(1) + C5(2).*temperature(:,1) + C5(3).*temperature(:,1).^2 + C5(4).*temperature(:,1).^3;
Ct6 = C6(1) + C6(2).*temperature(:,1) + C6(3).*temperature(:,1).^2 + C6(4).*temperature(:,1).^3;
Ct7 = C7(1) + C7(2).*temperature(:,1) + C7(3).*temperature(:,1).^2 + C7(4).*temperature(:,1).^3;
Ct8 = C8(1) + C8(2).*temperature(:,1) + C8(3).*temperature(:,1).^2 + C8(4).*temperature(:,1).^3;

logpco2 = Ct0 + Ct1.*co2phase(:,1) + Ct2.*(co2phase(:,1).^2) + Ct3.*(co2phase(:,1).^3) + Ct4.*(co2phase(:,1).^4) + Ct5.*(co2phase(:,1).^5) + Ct6.*(co2phase(:,1).^6) + Ct7.*(co2phase(:,1).^7) + Ct8.*(co2phase(:,1).^8);
logpco2(:) = logpco2; %  force column vector

Cfac = -0.653182962586425; % no idea what this is, but Robin had this in one of his scripts. 
%Cfac = -0.611;
%Cfac = 0.6;
%Cfac = 0.619094412330194;

% Convert between hecto pascals to micro atm.
pco2_hpa = 10.^(logpco2 + Cfac); 
pco2 = pco2_hpa.*(1000000/1013.25);

pco2 = [pco2, flags];

clear logpco2 pco2_hpa cfac Cfac Ct0 Ct1 Ct2 Ct3 Ct4 Ct5 Ct6 Ct7 Ct8 C0 C1 C2 C3 C4 C5 C6 C7 C8 flags

%% Correction Part (IGNORE)
% ------------ pco2 deployment -------------------------------------------
% temp_dep = 3; % recorded temperature on deployment site [change]
% phase_dep = 10; % recorded phase shift on deployment site [change]
% 
% logpco2_dep_record = 5000; % recorded partial dissolved pressure of co2 on deployment site
% time_dep_record = 5.55e7; % recorded time of deployment
% 
% temp_dep = [temp_dep^3,temp_dep^2,temp_dep^1,temp_dep^0]'; % 3rd order polynomial
% C_dep = [C0*temp_dep, C1*temp_dep, C2*temp_dep, C3*temp_dep, C4*temp_dep, ...
%     C5*temp_dep, C6*temp_dep, C7*temp_dep, C8*temp_dep];
% 
% phase_dep = [phase_dep^0,phase_dep^1,phase_dep^2,phase_dep^3, ...
%     phase_dep^4, phase_dep^5, phase_dep^6, phase_dep^6, phase_dep^8]'; % 8th degree polynomial to pco2
% logpco2_dep = C_dep*phase_dep; 
% 
% const_dep = logpco2_dep_record-logpco2_dep; % pco2 reading shift deployment
% 
% -------------- pco2 recovery -------------------------------------------
% 
% temp_rec = 1; % recorded temperature on recovery site [change]
% phase_rec = 50; % recorded phase shift on recovery site [change]
% 
% logpco2_rec_recorded = 6000; % recorded partial dissolved pressure of co2 on recovery site
% time_rec_recorded = 5.56e7; % recorded time of recovery
% 
% temp_rec = [temp_rec^3,temp_rec^2,temp_rec^1,temp_rec^0]'; % 3rd order polynomial
% C_dep = [C0*temp_rec, C1*temp_rec, C2*temp_rec, C3*temp_rec, C4*temp_rec, ...
%     C5*temp_rec, C6*temp_rec, C7*temp_rec, C8*temp_rec];
% 
% phase_rec = [phase_rec^0,phase_rec^1,phase_rec^2,phase_rec^3, ...
%     phase_rec^4, phase_rec^5, phase_rec^6, phase_rec^6, phase_rec^8]'; % 8th degree polynomial to pco2
% 
% logpco2_rec = C_rec*phase_rec; 
% 
% const_rec = logpco2_rec_record-logpco2_rec; % pco2 reading shift deployment
% 
% ---------- correction coefficient --------------------------------------
% 
% mission_time = linspace(time_dep_recorded,time_rec_recorded,2);
% corr_const = linspace(const_dep,const_rec,2);
