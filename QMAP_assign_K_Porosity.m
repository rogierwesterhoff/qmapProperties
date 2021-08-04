%% INPUT (PUT IN FUNCTION LATER)
%
% ---- start input parameters
cc
tic

alpha=600; % age scalefactor for permeability. Very arbitrary: needs research
outfolder ='c:\tmp\';
savefile = 'K_POROS_NZ_v1.4_incl_age.mat';
csv_output = 'K_POROS_NZ_v1.4_incl_age.csv';

shapename_qmap='QMAP_GEol_Units_Export_Output_NZTM.shp';
% classfilename='i:\GroundWater\Commercial\MfE GW Atlas 2017\Report2_Fluxes\Volume\K_values_per_rocktype_v20180821.xls';
classfilename='K_values_per_rocktype_v20190802.xls';

dogrid=true;
if dogrid
    savefile_grid = 'geology_K_poros_NZ_v1.4.mat';
    shapename_area='NZ_boundary_NZTM.shp';
    xres=250;yres=250;
end
% ---- end input parameters

load('porosity_age.mat') % porosity_age smoothing spline fit made by 'porosity_age.m')

S = shaperead(shapename_qmap,'Attributes',{'OBJECTID','MAIN_ROCK','SUB_ROCKS','ABS_MIN','ABS_MAX'});

%% GATHER GROUPARGS FOR MAIN_ROCK AND PLOT THE TOTAL AREA
ipercent=0;
mainRock=cell(size(S,1),1);
age=nan(size(S,1),1);
stratAge=cell(size(S,1),1);
subRock=cell(size(S,1),1);
subRockEncyclopedia={};
ID=nan(size(S,1),1);

disp('reading names of main and sub rock types in shape attributes ...')

for iS=1:size(S,1)
    percentage=100*iS/size(S,1);
    if percentage>ipercent
        disp([num2str(ipercent),'%'])
        ipercent=ipercent+5;
    end
    mainRock(iS)=regexprep(regexprep(cellstr(strtok(S(iS).MAIN_ROCK,',')),'''',''),';','');
    % only take the first word of subrock type. Check 'strtok' for options
    % possible improvement (todo): multiple words, like 'vitric tuff' and 'basaltic andesite' are now also cut.
    subRock(iS)=regexprep(regexprep(cellstr(strtok(S(iS).SUB_ROCKS,',')),'''',''),';','');
    %     [subRock(iS),remainder]=strtok(tmp1); % only first word. Remainder is the rest and can be used later
    subRockEncyclopedia=[subRockEncyclopedia;strsplit(char(subRock(iS)))'];
    % only take the first word of stratigraphic age. Check 'strtok' for options
    age(iS)=(S(iS).ABS_MIN+S(iS).ABS_MAX)/2;
    ID(iS)=S(iS).OBJECTID;
end

% manual fix for one unclassified object in QMAP:
age(3859)=106;
mainRock(3859)=cellstr('serpentinite');
subRock(3859)=cellstr('');

[counts1,mainrocktype]=grpstats(ID,mainRock,{'numel','gname'});
[counts2,subrocktype]=grpstats(ones(length(subRockEncyclopedia),1),subRockEncyclopedia,{'numel','gname'});

%% GATHER GROUPARGS FOR MAIN AND SECONDARY ROCK TYPE AND AGE AND LINK THEM TO HYDROLITHO-values

% CREATE SHAPEMASK
[~,~,raw]=xlsread(classfilename);
log_kappa=cell2mat(raw(2:end,2)); % log \kappa in m2
log_sigma=cell2mat(raw(2:end,3)); % log \sigma in m2
% K_mday=cell2mat(raw(2:end,4)); % K (m/day)
porosity = cell2mat(raw(2:end,7)); % effective porosity in m3/m3
clayFactor = cell2mat(raw(2:end,8)); % factor used for depth conversion
lut_name=raw(2:end,1);
lut_name=cellstr(regexprep(lut_name, '''',''));
lut_class_name_hydrolitho=cell2mat(raw(2:end,6));

% lut_class_name:
% 1='f.g. sedimentary'
% 2= 'crystalline and metasediments'
% 3= 'f.g. unconsolidated'
% 4= 'carbonate'
% 5= 'volcanic'
% 6= 'poorly sorted sedimentary'
% 7= 'poorly sorted unconsolidated'
% 8= 'c.g. sedimentary'
% 9= 'highly permeable volcanics (e.g. ignimbrite)'
% 10='c.g. unconsolidated'

log_kappa_main_S=nan(size(S));
log_sigma_main_S=nan(size(S));
porosity_main_S=nan(size(S));
clayFactor_main_S=nan(size(S));
log_kappa_sub_S=nan(size(S));
log_sigma_sub_S=nan(size(S));
porosity_sub_S=nan(size(S));
clayFactor_sub_S=nan(size(S));
lookup_por=nan(size(S));

disp('linking permeability and porosity to QMAP polygons...')

ipercent=0;
for iS=1:size(S,1)
    percentage=100*iS/size(S,1);
    if percentage>ipercent
        disp([num2str(ipercent),'%'])
        ipercent=ipercent+5;
    end
    
    for itype=1:length(mainrocktype)
        mainRock(iS)=manualfixrocktype(mainRock(iS));
        if strcmp(mainRock(iS),mainrocktype(itype))
            sel_main=strcmp(lut_name,mainrocktype(itype));
            if sum(sel_main)~=1
               error('no value found for main rock')
            end
            lookup_por(iS)=lut_class_name_hydrolitho(sel_main);
            log_kappa_main_S(iS)=log_kappa(sel_main);
            log_sigma_main_S(iS)=log_sigma(sel_main);
            porosity_main_S(iS)=porosity(sel_main);
            clayFactor_main_S(iS)=clayFactor(sel_main);
        end
    end
    
    C=strsplit(char(subRock(iS)));
    % manual fix of descriptions that are two words or wrongly spelled
    C=manualfixrocktype(C);
    allsubclasses=nan(length(C),1);
    kappa_allsubclasses=nan(length(C),1);
    sigma_allsubclasses=nan(length(C),1);
    porosity_allsubclasses=nan(length(C),1);
    clayFactor_allsubclasses=nan(length(C),1);
    for itype=1:length(subrocktype)
        if ~isempty(C)
            for iC=1:length(C)
                if strcmp(C(iC),subrocktype(itype))
                    sel_sub=strcmp(lut_name,subrocktype(itype));
                    if sum(sel_sub)~=1
                        %                         warning(['no value found for sub rock ',char(subrocktype(itype))])
                    else
                        allsubclasses(iC)=lut_class_name_hydrolitho(sel_sub);
                        kappa_allsubclasses(iC)=log_kappa(sel_sub);
                        sigma_allsubclasses(iC)=log_sigma(sel_sub);
                        porosity_allsubclasses(iC)=porosity(sel_sub);
                        clayFactor_allsubclasses(iC)=clayFactor(sel_sub);
                    end
                end
            end
        end
    end
    log_kappa_sub_S(iS)=nanmean(kappa_allsubclasses);
    log_sigma_sub_S(iS)=nanmean(sigma_allsubclasses);
    porosity_sub_S(iS)=nanmean(porosity_allsubclasses);
    clayFactor_sub_S(iS)=nanmean(clayFactor_allsubclasses);
end

weight_main=1;
weight_sub=0.5;

sel=~isfinite(log_kappa_sub_S)&isfinite(log_kappa_main_S);
log_kappa_sub_S(sel)=log_kappa_main_S(sel);

sel=~isfinite(log_sigma_sub_S)&isfinite(log_sigma_main_S);
log_sigma_sub_S(sel)=log_sigma_main_S(sel);

sel=~isfinite(porosity_sub_S)&isfinite(porosity_main_S);
porosity_sub_S(sel)=porosity_main_S(sel);

sel=~isfinite(clayFactor_sub_S)&isfinite(clayFactor_main_S);
clayFactor_sub_S(sel)=clayFactor_main_S(sel);

log_kappa_S = ((log_kappa_main_S*weight_main+log_kappa_sub_S*weight_sub)/(weight_main+weight_sub))...
    + log10(exp(-age/alpha));

log_sigma_S = log10(sqrt(((10.^log_sigma_main_S*weight_main+10.^log_sigma_sub_S*weight_sub)/(weight_main+weight_sub)).^2 ...
    + (exp(-age/alpha)).^2));

porosity_S = (porosity_main_S*weight_main + porosity_sub_S*weight_sub)/(weight_main+weight_sub);

clayFactor_S = (clayFactor_main_S*weight_main + clayFactor_sub_S*weight_sub)/(weight_main+weight_sub);

age(age<1.3)=1.3;
if lookup_por==3
    porosity_S=porosity_S.*f_carb(age);
else
    if lookup_por~=2 % everything except crystalline and metasediments
        porosity_S=porosity_S.*f_sil(age);
    end
end

save([outfolder,savefile],'log_kappa_S','log_sigma_S','porosity_S','clayFactor_S')

deltat=86400; %s/day
[K_m_day,sigma_K_m_day]=convert_kappa_to_K(log_kappa_S,log_sigma_S,deltat);

%% EXPORT TO CSV
% clearvars -except ID K_m_day porosity_S csv_output

% write to csv, including headers
headers=flatten({'ObID','Kmday','Porosity'});
c=num2cell(horzcat(ID,K_m_day,porosity_S));

if length(headers) ~= size(c,2)
    error('number of header entries must match the number of columns in the data')
end

c = vertcat(headers,c);
ds = cell2dataset(c);
export(ds,'file',[outfolder,csv_output],'delimiter',',')
toc

if dogrid
    %% GRID DATA (TIME-CONSUMING
    disp('rasterising (this is slow)...')
    
    info = shapeinfo(shapename_area);
    bbox= info.BoundingBox;%[leftx bottomy; rightx  topy]
    
    % corners of bounding box (tl,tr=top left,right bl,br=bottom left, right)
    x_tl=bbox(1,1);x_tr=bbox(2,1);y_tl=bbox(2,2);y_bl=bbox(1,2);
    xaxis=x_tl-xres:xres:x_tr+xres;
    yaxis=y_tl+yres:-yres:y_bl-yres;
    [xgrid,ygrid]=meshgrid(xaxis,yaxis);
    
    K_m_day_grid=nan(size(xgrid));
    sigma_K_m_day_grid=nan(size(xgrid));
    porosity_grid=nan(size(xgrid));
    clayFactor_grid=nan(size(xgrid));
    % log_kappa_grid=nan(size(xgrid));
    % log_sigma_grid=nan(size(xgrid));
    
    ipercent=0;
    for iS=1:size(S,1)
        percentage=100*iS/size(S,1);
        if percentage>ipercent
            disp([num2str(ipercent),'%'])
            ipercent=ipercent+5;
        end
        
        xs=S(iS).X;
        ys=S(iS).Y;
        %     [xs,ys,~,~]=fixpolygon(xs,ys);
        in=inpolygon(xgrid,ygrid,xs,ys);
        K_m_day_grid(in) = K_m_day(iS);
        sigma_K_m_day_grid(in) = sigma_K_m_day(iS);
        porosity_grid(in) = porosity_S(iS);
        clayFactor_grid(in) = clayFactor_S(iS);
        %     log_kappa_grid(in)=log_kappa_S(iS);
        %     log_sigma_grid(in)=log_sigma_S(iS);
    end
    
    save([outfolder,savefile_grid],'K_m_day_grid','sigma_K_m_day_grid','porosity_grid','clayFactor_grid','xaxis','yaxis');
end
