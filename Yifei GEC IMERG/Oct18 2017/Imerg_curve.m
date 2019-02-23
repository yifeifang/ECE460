clear all
gpmFiles = dir('*.HDF5');
gpmCount = numel(gpmFiles);

grid = zeros(1800, 3600);

one_min_group = zeros(144, 1);
hourly_group = zeros(24, 1);

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
    
    kk=find( (abs(ImergPrec) > 5000) | (ImergPrec==0) );
    ImergPrec(kk)= 0;
    sump = sum(sum(ImergPrec));
    hourly_group(ImergHr_S + 1) = hourly_group(ImergHr_S + 1) + sump;
    grid = grid + ImergPrec;
end

figure
plot(hourly_group)