% require grid_WWLLN_8days (4D double 360 * 720 * 24 * 8)
% require grid_IMERG_8day (4D double 360 * 720 * 24 * 8)
load("8day_4D.mat");
DD = zeros(24,1,8);
NDD = zeros(24,1,8);

for day = 1:8
    for hour = 1:24
        lightning_index=find( grid_WWLLN_8days(:,:,hour,day) > 3);
        no_lightning_index=find( grid_WWLLN_8days(:,:,hour,day) < 1);
        
        hour_grid = grid_IMERG_8days(:,:,hour,day);
        
        DD(hour, 1, day) = length(find(hour_grid(lightning_index) > 10));
        NDD(hour, 1, day) = length(find(hour_grid(no_lightning_index) > 30));
    end
end

% This is for 8 day all add up plot
figure
plot(sum(DD, 3), "*-")
title("Cell covered with at least 2 lightning and 50 mm precptation")
xlabel("UT hours")
ylabel("Cell count")
yyaxis right
plot(sum(VOSTOK_hour_8days, 3), "*-")
ylabel("Electric Field (V/m)")
% 
% figure
% plot(sum(NDD, 3), "*-")
% title("Cell covered with no lightning and 50 mm precptation")
% xlabel("UT hours")
% ylabel("Cell count")
% yyaxis right
% plot(sum(VOSTOK_hour_8days, 3), "*-")
% ylabel("Electric Field (V/m)")

% This is for daily plot
% for day = 1:8
%     figure;
%     plot(DD(:,:,day), "*-");
%     title(strcat("Day ", num2str(day)));
%     xlabel("UT hours");
%     ylabel("Cell count");
%     yyaxis right;
%     plot(VOSTOK_hour_8days(:,:,day), "*-");
%     ylabel("Electric Field (V/m)");
% end