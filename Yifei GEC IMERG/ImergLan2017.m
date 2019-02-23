%first attempt at plotting Imerg data

clear

stormName='Lan';

load('newWorld.mat'); % Map

cd('Oct22 2017')

%find number of data files
   gpmFiles = dir('*.HDF5');
   gpmCount = numel(gpmFiles);

%output filename
filename='LanOct22ImergWWLLN.gif';
   
%ImergFileName='3B-HHR.MS.MRG.3IMERG.20170909-S093000-E095959.0570.V05B.HDF5';

% hr_min=9.5;
% hr_max=10;

lonmin=120;
lonmax=140; 
latmin=6;
latmax=24;

%Colorscale
jetMap=jet(256);
invertedJet=jetMap(end:-1:1,:);
        
        %load wwlln data
        wwlln_file_name=['WPAC_17_25_Lan_WWLLN_Locations.txt'];
        fid = fopen(wwlln_file_name, 'r');
        data_storm=fscanf(fid,'%g %g %g %g %g %g %g %g %g %g\n', [10 inf]);
        data_storm=data_storm';
       
        year_cg_all=data_storm(:,1);
        month_cg_all=data_storm(:,2);
        day_cg_all=data_storm(:,3);
        hr_cg_all=data_storm(:,4);
        min_cg_all=data_storm(:,5);
        sec_cg_all=data_storm(:,6);
        lat_cg_all=data_storm(:,7);
        long_cg_all=data_storm(:,8);
        distance_EW=data_storm(:,9);
        distance_NS=data_storm(:,10);
        dist_center=(distance_EW.^2 + distance_NS.^2).^0.5;
        date_cg_all=datenum(year_cg_all,month_cg_all,day_cg_all,hr_cg_all,min_cg_all,sec_cg_all);
         
        cg_EW=distance_EW;
        cg_NS=distance_NS;

% %grid storm-centered MW data
% EW_range=[-180:0.1:180]; %EW bins
% NS_range=[-90:0.1:90]; %NS bins
% EWMx=repmat(EW_range,length(NS_range),1); %grid for density maps (change vectors into grid arrays)
% NSMx=repmat(NS_range,length(EW_range),1);
% NSMx=NSMx';

for ii=1:gpmCount

%for ii=1:2
    
    gpmFileCurr=gpmFiles(ii); 
    ImergFileName=gpmFileCurr.name;
    
    %Find start time of hdf5 file
    ImergYr_S=str2num(ImergFileName(22:25));
    ImergMth_S=str2num(ImergFileName(26:27));
    ImergDay_S=str2num(ImergFileName(28:29));
    ImergHr_S=str2num(ImergFileName(32:33));
    ImergMin_S=str2num(ImergFileName(34:35));
    ImergSec_S=str2num(ImergFileName(36:37));
    ImergStartTime=datenum(ImergYr_S,ImergMth_S, ImergDay_S, ImergHr_S, ImergMin_S, ImergSec_S); 
    
    %Find start time of hdf5 file
    ImergHr_E=str2num(ImergFileName(40:41));
    ImergMin_E=str2num(ImergFileName(42:43));
    ImergSec_E=str2num(ImergFileName(44:45));
    ImergEndTime=datenum(ImergYr_S,ImergMth_S, ImergDay_S, ImergHr_E, ImergMin_E, ImergSec_E); 

    ImergLat = h5read(ImergFileName,'/Grid/lat');
    ImergLon = h5read(ImergFileName,'/Grid/lon');
    ImergPrec = h5read(ImergFileName,'/Grid/precipitationCal');

    ImergLat=ImergLat';
    ImergLon=ImergLon';

    LonMx=repmat(ImergLon,length(ImergLat),1); %grid for density maps (change vectors into grid arrays)
    LatMx=repmat(ImergLat,length(ImergLon),1);
    LatMx=LatMx';

    time_stamp=datenum(ImergYr_S,ImergMth_S, ImergDay_S, ImergHr_S, ImergMin_S + 15, ImergSec_S); 
    dateString=datestr(time_stamp);

   
   %k1=find( (flashTimeAll < day_max) & (flashTimeAll >= day_min) ); %find GLM data in time interval
   k2=find( (date_cg_all < ImergEndTime) & (date_cg_all >= ImergStartTime) ); %find WWLN data in time interval


%plot sample counts
            %colormap(jet)            
            figure1=figure('Color',[1 1 1]);
            %subplot(3,1,1)
            % axes1 = axes('Parent',figure1,...
            %         'Position',[0.131 0.539 2*0.336 0.378]);

                axes1 = axes('Parent',figure1,...
                    'Position',[0.131 0.1 2*0.336 2*0.378]);

            hold(axes1,'on');
            ax = gca;
            ax.Box = 'on';
           
            kk=find( (abs(ImergPrec) > 500) | (ImergPrec==0) );
            ImergPrec(kk)=NaN;
            
            ph=pcolorCentered_old(LonMx',LatMx',ImergPrec');
            caxis([0 15]);    
         
            axis([lonmin lonmax latmin latmax]);
            hold on;
            
            wp2=plot(world(:,1),world(:,2),'k-','LineWidth',1.0); hold on;
            hold on
            scatter2 = scatter(long_cg_all(k2),lat_cg_all(k2),16,[ .7 .7 .7],'filled','LineWidth',.05, 'MarkerEdgeColor','r');
            
            %eqp=plot([0,360],[0,0],'k-','LineWidth',1.0); hold on;
            
            %wp2=plot(world(:,1),world(:,2),'k-','LineWidth',1.0); hold on;
            %eqp=plot([0,360],[0,0],'k-','LineWidth',1.0); hold on;
            %daspect([1 1 1])
            
            %colormap(jet)
            
            %add labels
            xlabel('Longitude','FontSize',12);
            ylabel('Latitude','FontSize',12);
            set(gca,'XTick',[floor(lonmin):2:ceil(lonmax)],'YTick',[-90:2:90],'Layer','top');
            set(gca,'Color',[0.8 0.8 0.8]);
            grid on
 
            cb = colorbar('peer',axes1,'Position',...
                     [0.85 0.1 0.015 2*0.378],...
                        'FontSize',12);
            set(get(cb,'YLabel'),'String', 'Precip (mm/hr)','FontSize',12)
            
            %title([stormName,dateString,' GLM(red) WWLLN(green)'])
            title([stormName,dateString,' IMERG + WWLLN(red)'])
            %drawnow;
            
          % Capture the plot as an image 
          frame = getframe(figure1); 
          im = frame2im(frame); 
          [imind,cm] = rgb2ind(im,256); 
          % Write to the GIF File 
          if ii == 1 
              imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
          else 
              imwrite(imind,cm,filename,'gif','WriteMode','append'); 
          end 
             %hold off
        close(gcf)
end
            