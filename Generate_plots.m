R_list = zeros(100, 10);
R_list_day = zeros(100, 10, 8);
for prec = 1:100
    for lightning = 1:10
        output_str = strcat("prec",num2str(prec),"lightning",num2str(lightning));
        mkdir("comb_figures", output_str)
        for day = 1:8
            output = strcat("comb_figures\", output_str, "\", output_str, "day", num2str(day), ".jpg");
            R_day = plot_1_day(day, prec, lightning);
            R_list_day(prec, lightning, day) = R_day;
            print("-djpeg", output ,"-r600");
            close;
        end
        output = strcat("comb_figures\", output_str, "\", output_str, " combination", ".jpg");
        R = plot_8_day(prec, lightning);
        R_list(prec, lightning) = R;
        print("-djpeg", output ,"-r600");
        close;
    end
end