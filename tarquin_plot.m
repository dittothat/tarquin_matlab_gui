function tarquin_plot(data_struct,vox_location,plot_what,varargin)
% Jeff Stout MIT 20170523
% generate a data_struct using tarquin_read_fitcsv
% ppm_limits currently set to 0.2-4ppm
% plot_what is (1x6) zeros and ones: [plot_fit,plot_NAA,plot_tCho,plot_Cr,plot_Lac,plot_GSH];

% find voc_location in data structure
for idx=1:length(data_struct)
    if sum(vox_location==data_struct(idx).location)==3;
        break
    end
end
if idx==length(data_struct)
warning('Voxel selection not valid');
end
Vox=data_struct(idx);


% data to plot
range_ppm=[0.2 4];
ppm=Vox.data(:,1);
select_ppm=ppm>range_ppm(1)&ppm<range_ppm(2);
ppm=Vox.data(select_ppm,1);
data=Vox.data(select_ppm,2);
fit=Vox.data(select_ppm,3);
baseline=Vox.data(select_ppm,4);

if nargin==3
    figure(1)
    ax1=subplot(2,1,1);
    ax2=subplot(2,1,2);
elseif nargin==5
    ax1=varargin{1};
    ax2=varargin{2};
else
    error('handles to plots not specified properly')
end


plot(ax1,ppm,data-baseline,'-k')
ax1.XDir='Reverse';
ax1.XGrid='on';
ax1.XTick=[0 0.5 1 1.3 1.4 2 2.5 3 3.5 4];

% plot selected metabolites and fit
hold(ax1,'on')
metab=[3,26,28,7,16,12];
for i=1:6
    if plot_what(i)==1
        if i==1
            plot(ax1,ppm,Vox.data(select_ppm,metab(i)),'-r')
        else
%             plot(ax1,ppm,Vox.data(select_ppm,metab(i))-Vox.data(select_ppm,4),'-g')
            plot(ax1,ppm,Vox.data(select_ppm,metab(i)),'-g') % baseline settings are a little weird, try this
        end
    end
end
    hold(ax1,'off')

plot(ax2,ppm,data-baseline-fit,'-k')
ax2.XDir='Reverse';
ax2.XMinorTick='on';
ax2.XGrid='on';
ax2.XMinorGrid='on';

title(ax2,'Residual','FontSize',12)
title(ax1,'Data and Fit','FontSize',12)
xlabel(ax2,'ppm','FontSize',12)

if nargin==2
set(ax1,'Position',[0.1300    0.4    0.7750    0.5])
set(ax2,'Position',[0.1300    0.1100    0.7750    0.2])
set(1,'Position',[107   563   560   420])
end

% code below for master title
% ax3 = axes('Position',[0 0 1 1],'Visible','off');
% axes(ax3) % sets ax1 to current axes
% h=text(.05,0.18,'Average GM Signal Intensity (Arb. Units)','FontSize',12)
% set(h, 'rotation', 90)
% print('CSF_data_fit_plot','-dtiffn','-r300')
% saveas(1,'CSF_data_fit_plot2','tiffn')



end


% assumes this metabolite order:
% {'PPMScale';'Data';'Fit';'Baseline';'Ala';'Asp';'Cr';'-CrCH2';'GABA';'Glc';'Gln';'Glth';'Glu';'GPC';'Ins';'Lac';'Lip09';'Lip13a';'Lip13b';'Lip20';'MM09';'MM12';'MM14';'MM17';'MM20';'NAA';'NAAG';'PCh';'PCr';'Scyllo';'Tau'}