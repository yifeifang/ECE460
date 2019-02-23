gpmFiles = dir('*.HDF5');
gpmCount = numel(gpmFiles);
R = georefcells();
R.LatitudeLimits = [-90, 90];
R.LongitudeLimits = [-180, 180];
R.RasterSize = [1800, 3600];
% grid = zeros(1800, 3600);
grid_IMERG = zeros(180 * 2, 360 * 2, 24);
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
    
    kk=find( (abs(ImergPrec) > 500) | (ImergPrec==0) );
    ImergPrec(kk)= 0;
    
%     grid = grid + ImergPrec;
    
    for i = 1:length(ImergLat)
        for j = 1:length(ImergLon)
            index_lat = round((round(ImergLat(i), 1) + 90) * 2) + 1;
            index_lon = round((round(ImergLon(j), 1) + 180) * 2) + 1;
            if index_lat == 361
                index_lat = 360;
            end
            if index_lon == 721
                index_lon = 720;
            end
            grid_IMERG(index_lat,index_lon,ImergHr_E + 1) = grid_IMERG(index_lat,index_lon,ImergHr_E + 1) + ImergPrec(i,j);
        end
    end
end

% figure
% axesm eckert4; 
% framem; gridm;
% axis off
% 
% geoshow(log(grid), R , 'DisplayType', 'texturemap');
% geoshow('landareas.shp', 'FaceColor', 'none', 'EdgeColor', 'white');
% hcb = colorbar('southoutside');
% set(get(hcb,'Xlabel'),'String','whole day precipitation')
% 
% R_grid = georefcells();
% R_grid.LatitudeLimits = [-90, 90];
% R_grid.LongitudeLimits = [-180, 180];
% R_grid.ColumnsStartFrom = 'south';
% R_grid.RasterSize = [360, 720];
% 
% figure
% axesm eckert4; 
% framem; gridm;
% axis off
% 
% geoshow(log(grid_half), R_grid , 'DisplayType', 'texturemap');
% geoshow('landareas.shp', 'FaceColor', 'none', 'EdgeColor', 'white');
% hcb = colorbar('southoutside');
% set(get(hcb,'Xlabel'),'String','whole day precipitation')
% 
