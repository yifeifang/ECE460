%IMERG data daily sum of total precip, Carnegia Curve diurnal variation 

clear

load('newWorld.mat'); % Map

%find number of data files
   gpmFiles = dir('*.HDF5');
   gpmCount = numel(gpmFiles);

% %output filename
% filename='LanOct22ImergWWLLN.gif';
%   
% 
% lonmin=-85;
% lonmax=-71; 
% latmin=15;
% latmax=30;

%Colorscale
jetMap=jet(256);
invertedJet=jetMap(end:-1:1,:);

for ii=1:gpmCount

%for ii=1:2
    
    gpmFileCurr=gpmFiles(ii); 
    ImergFileName=gpmFileCurr.name;
    
    %Find start time of hdf5 file
    ImergYr_S=str2num(ImergFileName(22:25));
    ImergMth_S=str2num(ImergFileName(26:27));
    ImergDay_S=str2num(ImergFileName(28:29));
    ImergHr_S=str2num(ImergFileName(32:33));
    ImergMin_S=str2num(ImergFileName(34:35));
    ImergSec_S=str2num(ImergFileName(36:37));
    ImergStartTime=datenum(ImergYr_S,ImergMth_S, ImergDay_S, ImergHr_S, ImergMin_S, ImergSec_S); 
    
    %Find start time of hdf5 file
    ImergHr_E=str2num(ImergFileName(40:41));
    ImergMin_E=str2num(ImergFileName(42:43));
    ImergSec_E=str2num(ImergFileName(44:45));
    ImergEndTime=datenum(ImergYr_S,ImergMth_S, ImergDay_S, ImergHr_E, ImergMin_E, ImergSec_E); 

    ImergLat = h5read(ImergFileName,'/Grid/lat');
    ImergLon = h5read(ImergFileName,'/Grid/lon');
    ImergPrec = h5read(ImergFileName,'/Grid/precipitationCal');

    ImergLat=ImergLat';
    ImergLon=ImergLon';

    LonMx=repmat(ImergLon,length(ImergLat),1); %grid for density maps (change vectors into grid arrays)
    LatMx=repmat(ImergLat,length(ImergLon),1);
    LatMx=LatMx';

    time_stamp=datenum(ImergYr_S,ImergMth_S, ImergDay_S, ImergHr_S, ImergMin_S + 15, ImergSec_S); 
    dateString=datestr(time_stamp);
    
    kk=find( (abs(ImergPrec) > 50) | (ImergPrec < 0) | (abs(LatMx) > 60) );
    ImergPrec(kk)=NaN;
    
    sample_size=numel(ImergPrec)-length(kk);
     

    total_precip(ii)=sum(ImergPrec(:),'omitnan');
    time_precip(ii)=time_stamp;

end

[Y,M,D,H,MN,S] = datevec(time_precip);
time_plot=H+MN/60;
figure
plot(time_plot,total_precip,'*k-')
            