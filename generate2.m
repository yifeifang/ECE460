IMERG_with_lightning_8days = zeros(24, 1, 8);
IMERG_with_out_lightning_8days = zeros(24, 1, 8);
for day = 1:8
    for hour = 1:24
        with_lightning_index=find( grid_IMERG_8days(:,:,hour,day) > 1);
        with_out_lightning_index=find( grid_IMERG_8days(:,:,hour,day) < 1);
        
        hour_grid = grid_IMERG_8days(:,:,hour,day);
        
        IMERG_with_lightning_8days(hour, 1, day) = sum(sum(hour_grid(with_lightning_index)));
        IMERG_with_out_lightning_8days(hour, 1, day) = sum(sum(hour_grid(with_out_lightning_index)));
    end
end

for day = 1:8
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1); 
    plot(IMERG_with_lightning_8days(:,:,day), "*-");
    title(strcat('IMERG_with_lightning_8days ', num2str(day)));

    subplot(1,2,2);
    plot(IMERG_with_out_lightning_8days(:,:,day), "*-");
    title(strcat('IMERG_with_out_lightning_8days ', num2str(day)));

    output = strcat("8day_figures\",num2str(day),".jpg");
    print("-djpeg", output ,"-r600");

    close;
end