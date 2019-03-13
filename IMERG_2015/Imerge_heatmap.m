fun = @(block_struct) sum(sum(block_struct.data));
subfolders = dir('15*');
subfoldersCount = numel(subfolders);
IMERG_hour_8days = zeros(24, 1, 8);

grid_IMERG_8days = zeros(180 * 2, 360 * 2, 24, 8);
for folder_index = 1:subfoldersCount
    fprintf(strcat("Processing ", num2str(folder_index), " file\n"));
    oldFolder = cd(subfolders(folder_index).name);
    
    gpmFiles = dir('*.HDF5');
    gpmCount = numel(gpmFiles);
    
    grid_IMERG = zeros(180 * 2, 360 * 2, 24);
    for ii=1:gpmCount
        gpmFileCurr=gpmFiles(ii); 
        ImergFileName=gpmFileCurr.name;

        ImergHr_E=str2double(ImergFileName(40:41));
        ImergPrec = h5read(ImergFileName,'/Grid/precipitationCal');

        kk=find( (abs(ImergPrec) > 500) | (ImergPrec==0) );
        ImergPrec(kk)= 0;

        %GridedPrec = GridedPrec + blockproc(ImergPrec,[5 5], fun);

        %IMERG_hour_8days(ImergHr_E + 1,:,folder_index) =
        %sum(sum(ImergPrec));   % still important
        
        grid_IMERG(:,:,ImergHr_E + 1) = grid_IMERG(:,:,ImergHr_E + 1) + blockproc(ImergPrec,[5 5], fun);
    end
    
    grid_IMERG_8days(:, :, :, folder_index) = grid_IMERG;
    cd (oldFolder);
end
