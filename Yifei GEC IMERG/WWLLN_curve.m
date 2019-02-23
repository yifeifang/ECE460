clear all

one_min_group = zeros(1440, 1);
hourly_group = zeros(24, 1);

% fileID = fopen('A20171018.loc');
% if fileID > 0
%     WWLLN = textscan(fileID,'%{yyyy/mm/dd}D %q %n %n %n %n','Delimiter',',','EmptyValue',-Inf);
%     fclose(fileID);
% end
% 
% % WWLLN{1,1}(1) access like this
% 
% for i = 1:length(WWLLN{1,2})
%     time = WWLLN{1,2}(i);
%     hour = str2double(time{1}(1:2));
%     min = str2double(time{1}(4:5));
%     one_min_group(hour * 60 + min + 1) = one_min_group(hour * 60 + min + 1) + 1;
%     hourly_group(hour + 1) = hourly_group(hour + 1) + 1;
% end

fileID = fopen('A20171022.loc');
if fileID > 0
    WWLLN = textscan(fileID,'%{yyyy/mm/dd}D %q %n %n %n %n','Delimiter',',','EmptyValue',-Inf);
    fclose(fileID);
end

% WWLLN{1,1}(1) access like this

for i = 1:length(WWLLN{1,2})
    time = WWLLN{1,2}(i);
    hour = str2double(time{1}(1:2));
    min = str2double(time{1}(4:5));
    one_min_group(hour * 60 + min + 1) = one_min_group(hour * 60 + min + 1) + 1;
    hourly_group(hour + 1) = hourly_group(hour + 1) + 1;
end

figure
plot(hourly_group)

figure
plot(movmean(one_min_group,100))
