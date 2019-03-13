for day = 1:8
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,3,1); 
    plot(IMERG_hour_8days(:,:,day), "*-");
    title(strcat('IMERG day ', num2str(day)));
    
    subplot(1,3,2);
    plot(WWLLN_hour_8days(:,:,day), "*-");
    title(strcat('WWLLN day ', num2str(day)));
    
    subplot(1,3,3);
    plot(VOSTOK_hour_8days(:,:,day), "*-");
    title(strcat('VOSTOK day ', num2str(day)));
    
    output = strcat("8day_figures\",num2str(day),".jpg");
    print("-djpeg", output ,"-r600");
    
    close;
end