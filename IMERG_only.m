load("corrected_8day_4D.mat");
R_list = zeros(100, 10);
R_list_day = zeros(100, 10, 8);
for prec = 1:100
    output_str = strcat("prec",num2str(prec));
    mkdir("comb_figures_IMERG", output_str)
    for day = 1:8
        output = strcat("comb_figures_IMERG\", output_str, "\", output_str, "day", num2str(day), ".jpg");
        R_day = plot_1_day_IMERG(day, prec, grid_IMERG_8days, VOSTOK_hour_8days);
        R_list_day(prec, lightning, day) = R_day;
        print("-djpeg", output ,"-r600");
        close;
    end
    output = strcat("comb_figures_IMERG\", output_str, "\", output_str, "_combination", ".jpg");
    R = plot_8_day_IMERG(prec, grid_IMERG_8days, VOSTOK_hour_8days);
    R_list(prec, lightning) = R;
    print("-djpeg", output ,"-r600");
    close;
    prec
end