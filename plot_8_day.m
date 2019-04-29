function R = plot_8_day(prec_threshold, lightning_treshold, grid_WWLLN_8days, grid_IMERG_8days, VOSTOK_hour_8days)
% require grid_WWLLN_8days (4D double 360 * 720 * 24 * 8)
% require grid_IMERG_8day (4D double 360 * 720 * 24 * 8)
% load("corrected_8day_4D.mat");
DD = zeros(24,1,8);
% NDD = zeros(24,1,8);

for day = 1:8
    for hour = 1:24
        lightning_index=find( grid_WWLLN_8days(:,:,hour,day) > lightning_treshold);
%         no_lightning_index=find( grid_WWLLN_8days(:,:,hour,day) < lightning_treshold);
        
        hour_grid = grid_IMERG_8days(:,:,hour,day);
        
        DD(hour, 1, day) = length(find(hour_grid(lightning_index) > prec_threshold));
%         NDD(hour, 1, day) = length(find(hour_grid(no_lightning_index) > prec_threshold));
    end
end

% This is for 8 day all add up plot
figure
yyaxis left
%errorbar(mean(DD, 3), std(DD, 0, 3), "b*-")
plot(mean(DD, 3), "b*-")
xlabel("UT hours")
ylabel("Cell count")
yyaxis right
%errorbar(mean(VOSTOK_hour_8days, 3), std(VOSTOK_hour_8days, 0, 3), "r*-")
plot(mean(VOSTOK_hour_8days, 3), "r*-")
ylabel("Electric Field (V/m)")

hold on

yyaxis left
x = 1 : 24;
x2 = [x, fliplr(x)];
curve1 = mean(DD, 3) + std(DD, 0, 3);
curve1 = curve1';
curve2 = mean(DD, 3) - std(DD, 0, 3);
curve2 = curve2';
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, 'b', 'FaceAlpha', 0.15, 'linestyle', 'none')

yyaxis right
curve1 = mean(VOSTOK_hour_8days, 3) + std(VOSTOK_hour_8days, 0, 3);
curve1 = curve1';
curve2 = mean(VOSTOK_hour_8days, 3) - std(VOSTOK_hour_8days, 0, 3);
curve2 = curve2';
inBetween = [curve1, fliplr(curve2)];
fill(x2, inBetween, 'r', 'FaceAlpha', 0.15, 'linestyle', 'none')

R = corrcoef(mean(DD, 3), mean(VOSTOK_hour_8days, 3));
R = R(1,2);

title_str = strcat("Cell covered with at least ", num2str(lightning_treshold), " and ", num2str(prec_threshold), " mm/hr preceptation and R = ", num2str(R));
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