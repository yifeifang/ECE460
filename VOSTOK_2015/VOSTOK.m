VOSTOKFiles = dir('*.log');
VOSTOKFilesCount = numel(VOSTOKFiles);
VOSTOK_hour_8days = zeros(24, 1, 8);

for ii=1:VOSTOKFilesCount
    name = VOSTOKFiles(ii).name;
    fprintf(strcat("Processing ", name, " file\n"));
    fileID = fopen(name);
    if fileID > 0
        VOSTOK_data = textscan(fileID,'%n %q %n %n %n %n','Delimiter',',','EmptyValue',-Inf,'HeaderLines',10);
        fclose(fileID);
    end

    field = VOSTOK_data{4}; % extract field_strength field
    field = field / 30000;  % convert to V/m

    VOSTOK_hour = zeros(24, 1);

    for i = 1:length(field)
        hour = str2double(VOSTOK_data{2}{i}(12:13));
        VOSTOK_hour(hour + 1) = VOSTOK_hour(hour + 1) + field(i);
    end

    VOSTOK_hour = VOSTOK_hour / 360;
    VOSTOK_hour_8days(:,:,ii) = VOSTOK_hour;
end
