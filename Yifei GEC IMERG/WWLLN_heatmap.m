%clear; clear all;
% Loading data
fprintf("loading data....\n");
load('newworld.mat');                   % load in the world map
WWLLN = load('A20171018.loc');          % load in the WWLLN data
%wp2 = plot(world(:,1),world(:,2),'k-','LineWidth',1.0); %hold on;

fileID = fopen('A20171018.loc');
if fileID > 0
    WWLLN_time = textscan(fileID,'%{yyyy/mm/dd}D %q %n %n %n %n','Delimiter',',','EmptyValue',-Inf);
    fclose(fileID);
end

latitude = WWLLN(:,3);     % get the latitute from WWLLN data
longitude = WWLLN(:,4);    % get the longitude from WWLLN data

grid_WWLLN = zeros(180 * 2, 360 * 2, 24);  % half degree by half degree grid

latitude = round(latitude, 1);     % round to half a degree precision
longitude = round(longitude, 1);   % round to half a degree precision

latitude = latitude + 90;       % range now from 0 - 180
longitude = longitude + 180;    % range now from 0 - 360

latitude = latitude * 2;
longitude = longitude * 2;

latitude = floor(latitude) + 1;
longitude = floor(longitude) + 1;

kk=find(latitude == 361);   % if raw data is exactly 90 then it will be map to 361
latitude(kk) = 360;
kk=find(longitude == 721);
longitude(kk) = 720;
% for i = 579814:606313
%     grid(latitude(i),longitude(i)) = grid(latitude(i),longitude(i)) + 1;
% end
for i = 1:length(latitude)
    time = WWLLN_time{1,2}(i);
    hour = str2double(time{1}(1:2));
    min = str2double(time{1}(4:5));
    grid_WWLLN(latitude(i),longitude(i),hour + 1) = grid_WWLLN(latitude(i),longitude(i),hour + 1) + 1;
end

lat_index = 1:360;
lon_index = 1:720;

%heatmap(grid(180:281, 142:224));
%h = heatmap(grid);
%h.GridVisible = 'off';
%h.Colormap = hot;

% figure
% axesm eckert4; 
% framem; gridm;
% axis off
% R = georefcells();
% R.LatitudeLimits = [-90, 90];
% R.LongitudeLimits = [-180, 180];
% R.ColumnsStartFrom = 'south';
% R.RasterSize = [360, 720];
% 
% geoshow(log(grid), R , 'DisplayType', 'texturemap');
% %contourfm(grid, R, 'LineStyle', 'none')
% geoshow('landareas.shp', 'FaceColor', 'none', 'EdgeColor', 'white');
% hcb = colorbar('southoutside');
% set(get(hcb,'Xlabel'),'String','lightning count')