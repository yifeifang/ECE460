function R = plot_1_day(day, prec_threshold, lightning_treshold, grid_WWLLN_8days, grid_IMERG_8days, VOSTOK_hour_8days, area_mask)
% require grid_WWLLN_8days (4D double 360 * 720 * 24 * 8)
% require grid_IMERG_8day (4D double 360 * 720 * 24 * 8)
%load("corrected_8day_4D.mat");
DD = zeros(24,1);
%NDD = zeros(24,1,8);

for hour = 1:24
    lightning_index=find( grid_WWLLN_8days(:,:,hour,day) >= lightning_treshold);
%     no_lightning_index=find( grid_WWLLN_8days(:,:,hour,day) < lightning_treshold);

    hour_grid = grid_IMERG_8days(:,:,hour,day);

    DD(hour, 1) = sum(sum(area_mask(find(hour_grid(lightning_index) > prec_threshold))));
%     NDD(hour, 1) = length(find(hour_grid(no_lightning_index) > prec_threshold));
end

% This is for 8 day all add up plot
figure
yyaxis left
%errorbar(mean(DD, 3), std(DD, 0, 3), "b*-")
plot(DD, "b*-")
xlabel("UT hours")
ylabel("Area in KM^2")
yyaxis right
%errorbar(mean(VOSTOK_hour_8days, 3), std(VOSTOK_hour_8days, 0, 3), "r*-")
plot(VOSTOK_hour_8days(:,:,day), "r*-")
ylabel("Electric Field (V/m)")

R = corrcoef(DD, VOSTOK_hour_8days(:,:,day));
R = R(1,2);

title_str = strcat("Cell covered with at least ", num2str(lightning_treshold), " and ", num2str(prec_threshold), " mm/hr precipitation and R = ", num2str(R));
title(title_str)
end
% fill example
% x = 1 : 24;
% curve1 = mean(DD, 3) + std(DD, 0, 3);
% curve1 = curve1';
% curve2 = mean(DD, 3) - std(DD, 0, 3);
% curve2 = curve2';
% plot(x, curve1, 'r', 'LineWidth', 2);
% hold on;
% plot(x, curve2, 'b', 'LineWidth', 2);
% x2 = [x, fliplr(x)];
% inBetween = [curve1, fliplr(curve2)];
% fill(x2, inBetween, 'g');