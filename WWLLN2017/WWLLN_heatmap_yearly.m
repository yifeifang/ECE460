%clear; clear all;
% Loading data
fprintf("loading data....\n");
%wp2 = plot(world(:,1),world(:,2),'k-','LineWidth',1.0); %hold on;

WWLLNFiles = dir('*.loc');
WWLLNFilesCount = numel(WWLLNFiles);
grid_WWLLN_yearly = zeros(180 * 2, 360 * 2, 24);

for ii=1:WWLLNFilesCount
    name = WWLLNFiles(ii).name;
    fprintf(strcat("Processing ", name, " file\n"));
    fileID = fopen(name);
    if fileID > 0
        WWLLN = textscan(fileID,'%s %q %n %n %n %n','Delimiter',',','EmptyValue',-Inf);
        fclose(fileID);
    end
    % no clue why I need to do this
    today = strcat(WWLLN{1,1}{1,1}(1:4),"_",WWLLN{1,1}{1,1}(6:7),"_",WWLLN{1,1}{1,1}(9:10));
    
    latitude = WWLLN{3};     % get the latitute from WWLLN data
    longitude = WWLLN{4};    % get the longitude from WWLLN data

    grid_WWLLN = zeros(180 * 2, 360 * 2, 24);  % half degree by half degree grid

    latitude = round(latitude, 1);     % round to half a degree precision
    longitude = round(longitude, 1);   % round to half a degree precision

    latitude = latitude + 90;       % range now from 0 - 180
    longitude = longitude + 180;    % range now from 0 - 360

    latitude = latitude * 2;
    longitude = longitude * 2;

    latitude = floor(latitude) + 1;
    longitude = floor(longitude) + 1;

    kk=latitude == 361;   % if raw data is exactly 90 then it will be map to 361
    latitude(kk) = 360;
    kk=longitude == 721;
    longitude(kk) = 720;
    if(max(latitude) > 360 || min(latitude) < 0 || max(longitude) > 720 || min(longitude) < 0)
        fprintf(strcat("out of range Error occurs skip day ",today, "\n"));
        fprintf("max latitude");
        max(latitude)
        fprintf("min latitude");
        min(latitude)
        fprintf("max longitude");
        max(longitude)
        fprintf("min longitude");
        min(longitude)
        continue;
    end
    % for i = 579814:606313
    %     grid(latitude(i),longitude(i)) = grid(latitude(i),longitude(i)) + 1;
    % end
    for i = 1:length(latitude)
        time = WWLLN{1,2}(i);
        hour = str2double(time{1}(1:2));
        grid_WWLLN(latitude(i),longitude(i),hour + 1) = grid_WWLLN(latitude(i),longitude(i),hour + 1) + 1;
        grid_WWLLN_yearly(latitude(i),longitude(i),hour + 1) = grid_WWLLN_yearly(latitude(i),longitude(i),hour + 1) + 1;
    end
    
    hourly_group = zeros(24, 1);
    
    for i = 1:24
        hourly_group(i) = sum(sum(grid_WWLLN(:,:,i)));
    end
    
    plot(hourly_group, "-*");
    output = strcat("figures\",today,"_hourly_group.jpg");
    print("-djpeg", output ,"-r600")
    close
    clear WWLLN;
end
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