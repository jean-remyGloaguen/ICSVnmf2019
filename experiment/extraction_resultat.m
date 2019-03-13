clear all
close all

imageSetting = figureOption('loadFig',1,'imageLoadPath','E:\PC_ifsttar\Bitbucket\explanes-nmf\NonNegAmb\report\figures',...
    'imageSavePath','D:\gloaguen\Documents\2019 - ISCV\paper\figures','saveFig',0,'ylabel','$MAE$ (dB)',...
    'text','latex','fontSize',38,'legendString',{'-12 dB','-6 dB','~0 dB','~6 dB','12 dB'},...
    'xTickLabel',{'an.','hu.','tr.'},'ylim',[-2 10],...
    'format','pdf','overwrite',1,'dim',[29 21]);
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imageSetting = figureExtract(imageSetting,'nameLoad','ambiance_ti_bar');
% 
% ydata = cell2mat(imageSetting.dataCollect{1}.ydata(:));
% std_ydata = [2.67 1.37 0.64 0.66 0.70; 
%     2.54 1.01 0.60 0.47 0.35; 
%     2.82 1.63 0.89 1.21 1.17];
% 
% 
% figure
% hBar = bar([1 2 3],[ydata(:,2)'; ydata(:,4)'; ydata(:,5)']);
% for k1 = 1:size(ydata,1)
%     ctr(k1,:) = bsxfun(@plus, hBar(1).XData, [hBar(k1).XOffset]');
%     ydt(k1,:) = hBar(k1).YData;
% end
% hold on
% errorbar(ctr, ydt, std_ydata', 'k.')
% hold off
% figureDesign(imageSetting,'saveFig',1,'name','mae_ambiance_bar_ICSV');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 imageSetting = figureOption('imageLoadPath','E:\PC_ifsttar\Bitbucket\exampleArticle\manuscrit',...
    'imageSavePath','D:\gloaguen\Documents\2019 - ISCV\paper\figures','ylabel','D(\mathbf{W_0} \Vert \mathbf{W''})',...
    'xlabel','$K$','lineWidth',2.5,'text','latex','fontSize',32,'dim',[29 21],'format','pdf','overwrite',1,'xlim',[0 200],...
    'ylim',[0 1],'legendString',{'-12 dB','-6 dB','~0 dB','~6 dB','~12 dB'},'yTick',[0 0.2 0.4 0.6 0.8 1],'visible','off');

amb = {'animals','human','transportation'};
ambianceLeg = {'an.','hu.','tr.'};

TIR = {'-12','0','12'};

ind = 1;
for jj = 1:length(TIR)
    ydata_temp = zeros(length(amb),200);
    for ii = 1:length(amb)
        imageSetting = figureExtract(imageSetting,'loadFig',1,'nameLoad',strcat('dist_',amb{ii},'_',TIR{jj}));
        
        ydata = imageSetting.dataCollect{1}.ydata{1};
        xdata = imageSetting.dataCollect{1}.xdata{1};
        legendString{ind} = strcat(TIR{jj},' dB - ',32, ambianceLeg{ii});
        ind = ind+1;
        
        figure(100)
        plot(xdata,ydata), hold on 
    end
end
plot([0 200], [0.42 0.42])

setting = figureOption('saveFig',1,'imageSavePath','D:\gloaguen\Documents\2019 - ISCV\paper\figures',...
    'ylabel','$D(\mathbf{W_0} \vert \vert \mathbf{W})$','legendPosition','eastoutside','overwrite',1,...
    'imageLoadPath','D:\gloaguen\BitBucket\NMF\test_NMF\images', 'text','latex','name','distance_D_ICSV',...
    'fontSize',36,'format','pdf','ylim',[0 1],'legendString',[legendString {'t = 0.42'}],'color',[{1 2 3 1 2 3 1 2 3} {'k'}],...
    'lineStyle',[{'-'} {'-'} {'-'} {':'} {':'} {':'} {'-.'} {'-.'} {'-.'} {'--'}],'xlabel','k');
figureDesign(setting)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% setting = figureOption('xlim',[0.5 15.5],'xTick',[3.5 8.5 13.5 18.5 23.5],'xTickLabel',{'an.','hu.','tr.'},...
%         'color',[1 2 3 4 5 1 2 3 4 5 1 2 3 4 5 5 4 3 2 1],'text','latex','ylim',[-5 13],...
%         'ylabel','$\Delta_{L_{eq}}$ (dB)','saveFig',1,'overwrite',1,'fontSize',38,'format','pdf',...
%         'imageSavePath','D:\gloaguen\Documents\2019 - ISCV\paper\figures');
%     
% 
% amb = {'animals','human','transportation'};
% met = {'supervised','semi-supervised','thresholded'};
% tir = {'-12','-6','0','6','12'};
% 
% for jj = 3
%     method = met{jj};
%     Diff = zeros(25,length(amb)*length(tir));
% 
%     figure
%     for kk = 1:length(tir)        % par TIR
%         for ii = 1:length(amb)        % par amb
%             ambiance = amb{ii};
%             file = load(strcat('D:\gloaguen\BitBucket\exampleArticle\data\mae_',method,'_',ambiance,'_',tir{kk},'.mat'));
%             Diff(:,length(tir)*(ii-1)+kk) = file.data(:,1)-file.data(:,2);
%         end
%     end
% %     boxplot([Diff rand(25,length(tir))],[1:5*6 31:35]), hold on
%     boxplot([Diff rand(25,length(tir))],[1:length(tir)*length(amb) length(tir)*length(amb)+1:length(tir)*length(amb)+5]), hold on
%     hLegend = legend(findall(gca,'Tag','Box'), {'-12 dB', '-6 dB', '~0 dB', '~6 dB', '12 dB'});
%     figureDesign(setting,'name',['boxplot_amb_nmf_' method]);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imageSetting = figureOption('loadFig',0,'imageLoadPath','E:\PC_ifsttar\Bitbucket\explanes-nmf\NonNegAmb\report\figures',...
%     'imageSavePath','D:\gloaguen\Documents\2019 - ISCV\paper\figures','ylabel','$MAE$ (dB)','xlabel','seuil $t_h$',...
%     'text','latex','fontSize',40,...
%     'legendString',{'alerte','animaux','climat','humains','transport','m\''ecanique'},'marker','x','markerSize',12,'lineStyle','--',...
%     'xTickLabel',[0.30 0.35 0.40 0.45 0.50],'xTick',[1 6 11 16 21],'ylim',[0 13],'xlim',[1 25],...
%     'name',{'ambiance_maeExpand_tir-12','ambiance_maeExpand_tir0','ambiance_maeExpand_tir12'},'format','pdf','overwrite',1,'dim',[35 21]);
% 
% % figureDesign(imageSetting,'saveFig',1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% amb = {'an.','hu.','tr.'};
% TIR = {'-12','0','12'};
% diff = [1.84-2.89 1.25-1.13 1.01-0.98; 4.54-3.65 0.71-0.72 0.82-0.86; 6.45-5.28 1.18-1.04 0.99-1.03;];
% 
% for jj = 1:length(TIR)
%     ydata_temp = zeros(length(amb),200);
%     imageSetting = figureExtract(imageSetting,'loadFig',1,'nameLoad',strcat('ambiance_maeExpand_tir',TIR{jj}));
%         
%         ydata(1,:) = imageSetting.dataCollect{1}.ydata{2}+diff(1,jj);
%         ydata(2,:) = imageSetting.dataCollect{1}.ydata{4}+diff(2,jj);
%         ydata(3,:) = imageSetting.dataCollect{1}.ydata{5}+diff(3,jj);
%         
%         legendString{3*(jj-1)+1} = strcat(TIR{jj},' dB - ',32, amb{1});
%         legendString{3*(jj-1)+2} = strcat(TIR{jj},' dB - ',32, amb{2});
%         legendString{3*(jj-1)+3} = strcat(TIR{jj},' dB - ',32, amb{3});
%        
%         xdata = imageSetting.dataCollect{1}.xdata{1};
%         figure(100)
%         plot(xdata,ydata), hold on 
% end
% plot([12 12],[0 12]), hold on 
% legendString{10} = 't = 0.42';
% 
% setting = figureOption('saveFig',1,'imageSavePath','D:\gloaguen\Documents\2019 - ISCV\paper\figures',...
%     'ylabel','$MAE$ (dB)','legendPosition','eastoutside','overwrite',1,'name','error_mae_amb',...
%     'imageLoadPath','D:\gloaguen\BitBucket\NMF\test_NMF\images', 'text','latex','ylim',[0 12],...
%     'fontSize',36,'format','pdf','color',[{1 2 3 1 2 3 1 2 3} {'k'}],'xlim',[1 31],...
%     'lineStyle',[{'-'} {'-'} {'-'} {':'} {':'} {':'} {'-.'} {'-.'} {'-.'} {'--'}],'xlabel','threshold $t$',...
%     'xTick',[1 6:5:41],'xTickLabel',[0.3 0.35:0.05:0.70],'legendString',legendString);
% 
% figureDesign(setting)