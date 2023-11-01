clc
clear all
% close all

%Program written by Andre Bauknecht, DLR Göttingen in 2012.

%Testprog for 3 column data, x,y,VIZR
%##########################################################################
%######################### Define Input-Parameters ########################
%##########################################################################
movie=1; %movie or snapshots
single=1; %single plot or multiplot?
testcase='R3'; %'R0'=no fuselage, 'R3'=HARTII fuselage
intend=90; % angular recording range, e.g. 90[°] or 360[°] (only for movie)

deg=90; %azimuth angle (only for snapshot)
%##########################################################################
%##########################################################################
%##########################################################################

%% Open coefficients from fitting
dir=['.\Data\',testcase]; %file in kartesian coordinates

if movie==1
    if single==1
        
        % fighandle=figure('Position',[100 100 1124 868],'Color',[1 1 1]);
        fighandle=figure('Position',[1 1 1280 1024],'Color',[1 1 1]);
        xlabel({'x'}); ylabel({'y'}); zlabel({'z'});daspect([4 4 2]); view([0 0]); 
        set(gca,'FontSize',20,'XTick',[-1 0 1 2 3 4],'YTick',[-1 0 1], 'ZTick',[-0.6 -0.3 0 0.3 0.6])
        % ColorSet= [0,1,0;0,1,1;0,0,1;1,0,0;];
        m=1;
        %frame(19) = struct('cdata',[],'colormap',[]);
        set(gca,'NextPlot','replaceChildren');    

        for j=0:5:intend-1
            for i=0+1*j:90:270+1*j
            if m>4
                m=1;
            end
                k=i;
                if k>359
                   k=mod(k,360);
                end    
            if k<10
            filea=[dir, strcat('\a000',num2str(k),'.dat')];
            fileb=[dir, strcat('\b000',num2str(k),'.dat')];
            filef=[dir, strcat('\f000',num2str(k),'.dat')];
            filer=[dir, strcat('\r000',num2str(k),'.dat')];
            elseif k<100
            filea=[dir, strcat('\a00',num2str(k),'.dat')];
            fileb=[dir, strcat('\b00',num2str(k),'.dat')];
            filef=[dir, strcat('\f00',num2str(k),'.dat')];    
            filer=[dir, strcat('\r00',num2str(k),'.dat')];    
            else
            filea=[dir, strcat('\a0',num2str(k),'.dat')];
            fileb=[dir, strcat('\b0',num2str(k),'.dat')];
            filef=[dir, strcat('\f0',num2str(k),'.dat')];        
            filer=[dir, strcat('\r0',num2str(k),'.dat')];        
            end
            [descr, a]=hdrload(filea);
            [descr, b]=hdrload(fileb);
            [descr, f]=hdrload(filef);
            [descr, r]=hdrload(filer);
            b(24:46,3)=b(23:-1:1,3);
            b(24:46,1:2)=b(46:-1:24,1:2);

            xlabel({'x/R'}); ylabel({'y/R'}); zlabel({'z/R'});daspect([4 4 2]); view([0 0]); 
            plot3(b(1:46,1),b(1:46,2),b(1:46,3),'LineWidth',2,'Color','k');axis([-1 4 -1 1 -0.6 0.6]), hold on;
%             quiver3(a(:,1),a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),'LineWidth',1,'AutoScaleFactor',0.5,'Color','k'),axis([-1 4 -1 1 -0.6 0.6])
%             plot3(f(:,1),f(:,2),f(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
%             plot3k(f(:,1:3),'Marker',{'.',8}),axis([-1 4 -1 1 -0.6 0.6]), hold on
            cline(f(:,1),f(:,2),f(:,3),f(:,3));axis([-1 4 -1 1 -0.6 0.6]), hold on; % 'Color', ColorSet(m,:)
%             cline(r(:,1),r(:,2),r(:,3),r(:,3));axis([-1 4 -1 1 -0.6 0.6]), hold on; % 'Color', ColorSet(m,:)
        %     plot3(r(:,1),r(:,2),r(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
            set(gca,'FontSize',20,'XTick',[-1 0 1 2 3 4],'YTick',[-1 0 1], 'ZTick',[-0.6 -0.3 0 0.3 0.6]);

            m=m+1;
            end
        hold off;
        frame(j/5+1)=getframe(1);
        end

    movie2avi(frame,['VI_HARTII_',testcase,'_BIG_side.avi'],'FPS',8);    
        
        
        
        
    else %single=0, multiplot;
        
        % fighandle=figure('Position',[100 100 1124 868],'Color',[1 1 1]);
        fighandle=figure('Position',[1 1 1280 1024],'Color',[1 1 1]);
        xlabel({'x'}); ylabel({'y'}); zlabel({'z'});daspect([4 4 2]); view([-28 20]); 
        set(gca,'FontSize',20,'XTick',[-1 0 1 2 3 4],'YTick',[-1 0 1], 'ZTick',[-0.5 0 0.5])
        % ColorSet= [0,1,0;0,1,1;0,0,1;1,0,0;];
        m=1;
        %frame(19) = struct('cdata',[],'colormap',[]);
        set(gca,'NextPlot','replaceChildren');    

        for j=0:5:intend-1
            for i=0+1*j:90:270+1*j
            if m>4
                m=1;
            end
                k=i;
                if k>359
                   k=mod(k,360);
                end    
            if k<10
            filea=[dir, strcat('\a000',num2str(k),'.dat')];
            fileb=[dir, strcat('\b000',num2str(k),'.dat')];
            filef=[dir, strcat('\f000',num2str(k),'.dat')];
        %     filer=[dir, strcat('\r000',num2str(k),'.dat')];
            elseif k<100
            filea=[dir, strcat('\a00',num2str(k),'.dat')];
            fileb=[dir, strcat('\b00',num2str(k),'.dat')];
            filef=[dir, strcat('\f00',num2str(k),'.dat')];    
        %     filer=[dir, strcat('\r00',num2str(k),'.dat')];    
            else
            filea=[dir, strcat('\a0',num2str(k),'.dat')];
            fileb=[dir, strcat('\b0',num2str(k),'.dat')];
            filef=[dir, strcat('\f0',num2str(k),'.dat')];        
        %     filer=[dir, strcat('\r0',num2str(k),'.dat')];        
            end
            [descr, a]=hdrload(filea);
            [descr, b]=hdrload(fileb);
            [descr, f]=hdrload(filef);
        %     [descr, r]=hdrload(filer);
            b(24:46,3)=b(23:-1:1,3);
            b(24:46,1:2)=b(46:-1:24,1:2);

        sub1=subplot(2,2,1,'Parent',fighandle);

            xlabel({'x/R'}); ylabel({'y/R'}); zlabel({'z/R'});daspect([4 4 2]); view([0 0]); 
            plot3(sub1,b(1:46,1),b(1:46,2),b(1:46,3),'LineWidth',2,'Color','k');axis([-1 4 -1 1 -0.5 0.5]), hold(sub1,'on');
        %     quiver3(sub1,a(:,1),a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),'LineWidth',1,'AutoScaleFactor',0.5,'Color',ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
        %     plot3(sub1,f(1,1),f(1,2),f(1,3),'Color', ColorSet(m,:),'Marker','o')
        %     plot3(sub1,f(:,1),f(:,2),f(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
            cline(f(:,1),f(:,2),f(:,3),f(:,3));axis([-1 4 -1 1 -0.5 0.5]), hold on; % 'Color', ColorSet(m,:)
        %     plot3(sub1,r(:,1),r(:,2),r(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
            set(gca,'FontSize',20,'XTick',[-1 0 1 2 3 4],'YTick',[-1 0 1], 'ZTick',[-0.5 0 0.5]);

        sub2=subplot(2,2,2,'Parent',fighandle);

            xlabel({'x/R'}); ylabel({'y/R'}); zlabel({'z/R'});daspect([4 4 2]); view([90 0]); 
            plot3(sub2,b(1:46,1),b(1:46,2),b(1:46,3),'LineWidth',2,'Color','k');axis([-1 4 -1 1 -0.5 0.5]), hold(sub2,'on');
        %     quiver3(sub2,a(:,1),a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),'LineWidth',1,'AutoScaleFactor',0.5,'Color',ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
        %     plot3(sub2,f(1,1),f(1,2),f(1,3),'Color', ColorSet(m,:),'Marker','o')
        %     plot3(sub2,f(:,1),f(:,2),f(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
            cline(f(:,1),f(:,2),f(:,3),f(:,3));axis([-1 4 -1 1 -0.5 0.5]), hold on; % 'Color', ColorSet(m,:)
        %     plot3(sub2,r(:,1),r(:,2),r(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
            set(gca,'FontSize',20,'XTick',[-1 0 1 2 3 4],'YTick',[-1 0 1], 'ZTick',[-0.5 0 0.5]);

        sub3=subplot(2,2,3,'Parent',fighandle);

            xlabel({'x/R'}); ylabel({'y/R'}); zlabel({'z/R'});daspect([4 4 4]); view([0 90]); 
            plot3(sub3,b(1:46,1),b(1:46,2),b(1:46,3),'LineWidth',2,'Color','k');axis([-1 4 -1 1 -1 1]), hold(sub3,'on');
        %     quiver3(sub3,a(:,1),a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),'LineWidth',1,'AutoScaleFactor',0.5,'Color',ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
        %     plot3(sub3,f(1,1),f(1,2),f(1,3),'Color', ColorSet(m,:),'Marker','o')
        %     plot3(sub3,f(:,1),f(:,2),f(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
            cline(f(:,1),f(:,2),f(:,3),f(:,3));axis([-1 4 -1 1 -1 1]), hold on; % 'Color', ColorSet(m,:)
        %     plot3(sub3,r(:,1),r(:,2),r(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
            set(gca,'FontSize',20,'XTick',[-1 0 1 2 3 4],'YTick',[-1 0 1], 'ZTick',[-1 0 1]);

        sub4=subplot(2,2,4,'Parent',fighandle);

            xlabel({'x/R'}); ylabel({'y/R'}); zlabel({'z/R'});daspect([4 4 2]); view([-28 20]); 
            plot3(sub4,b(1:46,1),b(1:46,2),b(1:46,3),'LineWidth',2,'Color','k');axis([-1 4 -1 1 -0.5 0.5]), hold(sub4,'on');
        %     quiver3(sub4,a(:,1),a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),'LineWidth',1,'AutoScaleFactor',0.5,'Color',ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
        %     plot3(sub4,f(1,1),f(1,2),f(1,3),'Color', ColorSet(m,:),'Marker','o')
        %     plot3(sub4,f(:,1),f(:,2),f(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
            cline(f(:,1),f(:,2),f(:,3),f(:,3));axis([-1 4 -1 1 -0.5 0.5]), hold on; % 'Color', ColorSet(m,:)
        %     plot3(sub4,r(:,1),r(:,2),r(:,3),'Color', ColorSet(m,:)),axis([-1 4 -1 1 -1 1])
            set(gca,'FontSize',20,'XTick',[-1 0 1 2 3 4],'YTick',[-1 0 1], 'ZTick',[-0.5 0 0.5]);

            m=m+1;
            end
        hold(sub1,'off'), hold(sub2,'off'), hold(sub3,'off'), hold(sub4,'off');
        frame(j/5+1)=getframe(1);
        end
    movie2avi(frame,['VI_HARTII_',testcase,'_BIG_all.avi'],'FPS',8);
    end %single






else % snapshot
    
    

fighandle=figure('Position',[1 1 1280 1024],'Color',[1 1 1]);
xlabel({'x/R'}); ylabel({'y/R'}); zlabel({'z/R'});daspect([1.5 1.5 1]); view([-28 20]); 
set(gca,'FontSize',36,'XTick',[-1 -0.5 0 0.5 1 1.5],'YTick',[-1 0 1], 'ZTick',[-0.25 0 0.25])
ColorSet= [0,1,0;0,1,1;0,0,1;1,0,0;];% ColorSet=zeros(4,3);
m=1;
%frame(19) = struct('cdata',[],'colormap',[]);
set(gca,'NextPlot','replaceChildren');    
    
for j=deg:90:deg+90
    for i=0+1*j:90:270+1*j
    if m>4
        m=1;
    end
        k=i;
        if k>359
           k=mod(k,360);
        end    
    if k<10
    filea=[dir, strcat('\a000',num2str(k),'.dat')];
    fileb=[dir, strcat('\b000',num2str(k),'.dat')];
%     filed=[dir, strcat('\d000',num2str(k),'.dat')];
    filef=[dir, strcat('\f000',num2str(k),'.dat')];
%     filer=[dir, strcat('\r000',num2str(k),'.dat')];
    elseif k<100
    filea=[dir, strcat('\a00',num2str(k),'.dat')];
    fileb=[dir, strcat('\b00',num2str(k),'.dat')];
%     filed=[dir, strcat('\d00',num2str(k),'.dat')];
    filef=[dir, strcat('\f00',num2str(k),'.dat')];    
%     filer=[dir, strcat('\r00',num2str(k),'.dat')];    
    else
    filea=[dir, strcat('\a0',num2str(k),'.dat')];
    fileb=[dir, strcat('\b0',num2str(k),'.dat')];
%     filed=[dir, strcat('\d0',num2str(k),'.dat')];
    filef=[dir, strcat('\f0',num2str(k),'.dat')];        
%     filer=[dir, strcat('\r0',num2str(k),'.dat')];        
    end
    [descr, a]=hdrload(filea);
    [descr, b]=hdrload(fileb);
    [descr, f]=hdrload(filef);
%     [descr, d]=hdrload(filed);
%     [descr, r]=hdrload(filer);
    b(24:46,3)=b(23:-1:1,3);
    b(24:46,1:2)=b(46:-1:24,1:2);
    
    xlabel({'x'}); ylabel({'y'}); zlabel({'z'});daspect([4 4 4]); view([0 0]); 
    plot3(b(1:46,1),b(1:46,2),b(1:46,3),'LineWidth',2,'Color','k'),axis([-1 4 -1 1 -1 1]), hold on
%     quiver3(a(:,1),a(:,2),a(:,3),a(:,4),a(:,5),a(:,6),'LineWidth',1,'AutoScaleFactor',0.5,'Color',ColorSet(m,:)),axis([-1 2 -1 1 -0.5 0.5])
    cline(f(:,1),f(:,2),f(:,3),f(:,3));axis([-1 4 -1 1 -1 1]), hold on % 'Color', ColorSet(m,:)
%     plot3k(f(:,1:3),'Marker',{'.',8}),axis([-1 1.5 -1 1 -0.25 0.25]), hold on
%     plot3(f(:,1),f(:,2),f(:,3),'Color', ColorSet(m,:)),axis([-1 2 -1 1 -0.5 0.5]), hold on
%     plot3(r(:,1),r(:,2),r(:,3),'Color', ColorSet(m,:)),axis([-1 2 -1 1 -0.5 0.5])
    set(gca,'FontSize',36,'XTick',[-1 0 1 2 3 4],'YTick',[-1 0 1], 'ZTick',[-1 0 1])
    xlabel({'x'}); ylabel({'y'}); zlabel({'z'});daspect([4 4 4]); %view([0 0]); 
    
    m=m+1;
    
    end

end
    hold off


% saveas(fighandle,'\home\zeppelin\bauk_an\S4\analytische Endergebnisse\Wirbelbahnen_R3_1.png','png')
view([0 0])
orient landscape
set(gcf,'renderer','painters');
print(gcf,'-dpdf',['.\Wirbelbahnen_',testcase,'_5.pdf'],'-r100')

view([-44 28]); 
orient landscape
% set(gcf,'renderer','painters');
print(gcf,'-dpdf',['.\Wirbelbahnen_',testcase,'_6.pdf'],'-r100')

end