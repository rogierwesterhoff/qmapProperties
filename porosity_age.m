cc
xlsfilename='I:\GroundWater\Research\NIWA_NationalHydrologyProgram\Data\Porosity_permeability_data.xlsx';
[num,txt,raw]=xlsread(xlsfilename,'Porosity_Age');

age_Ma=cell2mat(raw(3:12,2));
Por_Siliclastic=cell2mat(raw(3:12,3));
Por_Carbonates=cell2mat(raw(3:12,4));

% % smoothing spline fit of y to x. Use as f(x) 

f_sil=fit([0;age_Ma],[1;Por_Siliclastic/nanmax(Por_Siliclastic)],'smoothingspline');

selc=isfinite(Por_Carbonates);
f_carb=fit(age_Ma(selc),Por_Carbonates(selc)/nanmax(Por_Carbonates),'smoothingspline');
save porosity_age.mat f_sil f_carb 
x_age = 1:500;


%INCLUDE PERMEABILITY
close all
f=600;
z=0:500;
scalefactor_perm=exp(-z/f);

figure
plot(f_sil(x_age),x_age,'LineWidth',2); hold on
plot(f_carb(x_age),x_age,'LineWidth',2);
plot(scalefactor_perm,z,'LineWidth',4,'Color',[159/255 91/255 205/255])
ax=gca;
ax.FontSize=14;
legend({'\phi Siliclastic','\phi Carbonates','K'},'Location','Best','FontSize',12);
xlabel('Age scale factor')
ylabel ('Age (Ma)')
xlim([0 1])
ylim([0 500])
axis ij