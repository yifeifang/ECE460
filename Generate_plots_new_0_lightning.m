load("correct_4D_4_15.mat");
load("area_mask.mat");
R_list = zeros(100);
R_list_day = zeros(100, 8);
lightning = 0;
for prec = 1:100
    output_str = strcat("prec",num2str(prec),"lightning",num2str(lightning));
    mkdir("comb_figures_0_lightning", output_str)
    for day = 1:8
        output = strcat("comb_figures_0_lightning\", output_str, "\", output_str, "day", num2str(day), ".jpg");
        R_day = plot_1_day_area_0_lightning(day, prec, lightning, grid_WWLLN_8days, grid_IMERG_8days, VOSTOK_hour_8days, area_mask);
        R_list_day(prec, day) = R_day;
        print("-djpeg", output ,"-r600");
        close;
    end
    output = strcat("comb_figures_0_lightning\", output_str, "\", output_str, " combination", ".jpg");
    R = plot_8_day_area_0_lightning(prec, lightning, grid_WWLLN_8days, grid_IMERG_8days, VOSTOK_hour_8days, area_mask);
    R_list(prec) = R;
    print("-djpeg", output ,"-r600");
    close;
    prec
end