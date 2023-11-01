% This code creates a random dot pattern for BOS measurements. The program
% uses ghostscript executable, the path to which is specified in the
% program header. Even without ghostscript, the program will output a
% postscript file.
%
% The program will add dots at random positions in the specified area, if
% they are not too close to previously positioned dots. The process ends if
% either the maximum specified point number or the maximum iteration number
% is reached. If these factors are set too low, the dot pattern will be
% sparse. If they are set too high, the program will take very long to
% finish. Some decent factors for these parameters are specified in the
% sample table below the input field.
%
% Written by Andre Bauknecht, DLR Goettingen, 2015-04-09. Tested with
% Matlab R2014a.
%
% v2: split region into subregions to increase overall speed. More
% documentation of the code.


clc
clear all
close all
tic

%##########################################################################
%############################## INPUT FIELD ###############################
%##########################################################################

scale=1;            %dots per mm, normally should not be changed.
width=1000;         %in mm (should be at least 100mm for usage of subzones)
height=700;         %in mm (should be at least 100mm for usage of subzones)
maxpoints=600000;   %maximum number of points, must be larger than "blocks". If this is set too low, the pattern will contain too few dots.
maxit=4e7;          %maxium number of iterations. You should make sure this is set slightly higher than necessary to fill the area with dots.
maxitperpoint=100;  %maximum number of iterations to find one point. Normally should not be changed.
diameter=0.7;       %dot diameter in mm
densfact=0.8;       %density factor, determines minimum distance between dots [low dot density=0.1, high dot density=1] (distance between neighboring dots has to be >diameter/densfact)
blocks=20000;       %final dots are output in blocks in the postscript file. Specifies the number of points per output block (<=50000)
subzones=1;         %1: divide area into subzones to increase evaluation speed, 0: no subzones
subzonesize=50;     %size of the square subzones in mm
outputpath=strcat(pwd,'\'); %savepath for export
addscale=0;         %if set to 1, this will add a border with a scale around the dot pattern, adding 10mm on each edge.
ghostscriptpath='C:\"Program Files (x86)"\gs\gs8.64\bin\gswin32.exe'; %path to ghostscript executable, only necessary for automatic conversion from ps to pdf. If this file is not found, no pdf is produced.

%##########################################################################
%############################# SAMPLE TABLE ###############################
%##########################################################################

%former patterns:
%--------------------------------------------------------------------------
% w         h           diam.(mm)   dens. factor    nb. points    
%--------------------------------------------------------------------------
% 500       500         0.8         0.8             140k
% 500       500         1.0         0.8             90k
% 550       550         0.8         0.8             169k
% 550       550         1.0         0.8             108k
% 550       550         1.1         0.8             90k
%--------------------------------------------------------------------------
% 980       680         5.0         0.8              10k
% 980       680         4.0         0.8              16k
% 980       680         3.0         0.8              31k
% 980       680         2.5         0.8              41k
% 980       680         2.0         0.8              65k
% 980       680         1.5         0.8             114k
% 980       680         1.4         0.8             132k
% 980       680         1.3         0.8             152k
% 980       680         1.2         0.8             176k
% 980       680         1.1         0.8             206k
% 980       680         1.0         0.8             245k
% 980       680         0.9         0.8             295k
% 980       680         0.8         0.8             360k
% 980       680         0.5         0.8             960k
% 980       680         0.3         0.8            2680k
%--------------------------------------------------------------------------



if ~exist('filename','var')
    temp=sprintf('%3.1f', diameter);
    filename=[num2str(width) 'mm_' num2str(height) 'mm_d' temp 'mm.ps'];
end

    
%% without subzones (old version)
if subzones~=1
    dump=zeros(ceil(maxpoints/100),2); %initialize dump vector
    h=round(height*scale);
    w=round(width*scale);
    rand('twister',sum(100.*clock));

    points=zeros(maxpoints,2); %initialize results vector
    it=0; %initialize iteration counter

    %store first point
    x = 0 + (width).*rand(1,1);
    % rand('twister',sum(100.*clock));
    y = 0 + (height).*rand(1,1);
    points(1,:)=[x,y];
    curpt=1;

    %calculate remaining points
    while (curpt<maxpoints)&&(it<maxit)&&(it/curpt<=maxitperpoint)
    x = 0 + (width).*rand(1,1);
    % rand('twister',sum(100.*clock));
    y = 0 + (height).*rand(1,1);

    distancevector=min(sqrt((points(1:curpt,1)-x.*ones(curpt,1)).^2+(points(1:curpt,2)-y.*ones(curpt,1)).^2));

        if distancevector>diameter/densfact
            curpt=curpt+1;
            points(curpt,:)=[x,y];
        end    

    it=it+1;  
    if mod(curpt,100)==0
        clc
        disp(['Points calculated: ', num2str(curpt),'       Iteration Number: ', num2str(it)])
        dump(curpt/100,:)=[curpt it];
    end    

    end

    %sorting resulting points
    endresult=sortrows(-points);
    endresult=-endresult;
    endresult(curpt+1:end,:)=[];

    %separating results into blocks of "blocks" points each
    last=mod(curpt,blocks);%last block, smaller than "blocks"
    nmax=round((curpt-last)/blocks);
    if nmax~=0
        endresults=zeros(blocks,2,nmax+1);
        for j=1:nmax
            endresults(:,:,j)=endresult((j-1)*blocks+1:j*blocks,:,1  );
        % assignin('base',['endresult',num2str(j)],endresult( (j-1)*50000+1:j*50000,:  ));
        end
        endresults(1:last,:,j+1)=endresult(j*blocks+1:end,:,1);
    else
        endresults=endresult;
    end
    % assignin('base',['endresult',num2str(j+1)],endresult(  j*50000+1:end,:));
    scatter(endresult(:,1),endresult(:,2),'.k')
    figure; plot(dump(:,2),dump(:,1),'.b'); xlabel('Iterations'); ylabel('Points found');
end

%% with subzones (new version)
if subzones==1
    h=round(height*scale);
    w=round(width*scale);
    % number of subzones in h and w
    hsub=ceil(h/subzonesize);
    wsub=ceil(w/subzonesize);
    sub=1:hsub*wsub; %vector of subregions
    % vectors of corresponding x and y coordinates
    for i=1:hsub %loop in h
        for j=1:wsub %loop in w
            xsub(j+(i-1)*wsub)=(j-1)*subzonesize;
            ysub(j+(i-1)*wsub)=(i-1)*subzonesize;
        end
    end
    
    rand('twister',sum(100.*clock)); %reset random numbers

    points=zeros(ceil(maxpoints/hsub/wsub/50)*100,2*hsub*wsub); %initialize results vector
    dump=zeros(ceil(maxpoints/hsub/wsub/50),2); %initialize dump vector
    curpt=ones(1,size(sub,2));
    it=0; %initialize iteration counter

    %store first point in each subzone
    for i=sub
        if xsub(i)<subzonesize*(wsub-1)&&ysub(i)<subzonesize*(hsub-1) %all normal subzones except smaller ones at border
            x = 0 + (subzonesize).*rand(1,1);
            y = 0 + (subzonesize).*rand(1,1);
        elseif xsub(i)>=subzonesize*(wsub-1)&&ysub(i)<subzonesize*(hsub-1) %subzones at right image border
            x = 0 + (mod(width,subzonesize)).*rand(1,1);
            y = 0 + (subzonesize).*rand(1,1);
        elseif ysub(i)>=subzonesize*(hsub-1)&&xsub(i)<subzonesize*(wsub-1) %subzones at lower image border
            x = 0 + (subzonesize).*rand(1,1);
            y = 0 + (mod(height,subzonesize)).*rand(1,1);
        else %subzones at lower right image border
            x = 0 + (mod(width,subzonesize)).*rand(1,1);
            y = 0 + (mod(height,subzonesize)).*rand(1,1);
        end
        points(1,i*2-1:i*2)=[xsub(i)+x ysub(i)+y];
    end

    %calculate remaining points in loop
    while (sum(curpt)<maxpoints)&&(it<maxit)&&(it/sum(curpt)<=maxitperpoint)
        x = 0 + (width).*rand(1,1);
        % rand('twister',sum(100.*clock));
        y = 0 + (height).*rand(1,1);

        %find correct subzone
        cursub=ceil(x/subzonesize)+(ceil(y/subzonesize)-1)*wsub;
        distancevector=min(sqrt((points(1:curpt(cursub),cursub*2-1)-x.*ones(curpt(cursub),1)).^2+(points(1:curpt(cursub),cursub*2)-y.*ones(curpt(cursub),1)).^2));

        %compute distance to closest point in subzone
        if distancevector>diameter/densfact
            %check if point is too close to edge
            if abs(mod(x,subzonesize)-subzonesize/2)>=subzonesize/2-diameter/densfact||abs(mod(y,subzonesize)-subzonesize/2)>=subzonesize/2-diameter/densfact
                %point is too close to border of subzone, check neighboring subzones too
                count=1;
                for i=[max(1,cursub-1) min(sub(end),cursub+1) max(1,cursub-wsub) min(sub(end),cursub+wsub) max(1,cursub-1-wsub) max(1,cursub+1-wsub) min(sub(end),cursub-1+wsub) min(sub(end),cursub+1+wsub)]
                    distancevector(count)=min(sqrt((points(1:curpt(i),i*2-1)-x.*ones(curpt(i),1)).^2+(points(1:curpt(i),i*2)-y.*ones(curpt(i),1)).^2));
                    count=count+1;
                end
                clear count
                if min(distancevector)>diameter/densfact %found point also does not conflict with neighboring subzones
                    curpt(cursub)=curpt(cursub)+1;
                    points(curpt(cursub),cursub*2-1:cursub*2)=[x,y];
                end
            else
                curpt(cursub)=curpt(cursub)+1;
                points(curpt(cursub),cursub*2-1:cursub*2)=[x,y];
            end
        end    
        
        
        it=it+1;  
        %output current status every 100 points
        if mod(sum(curpt),100)==0
            clc
            disp(['Points calculated: ', num2str(sum(curpt)),'       Iteration Number: ', num2str(it)])
            dump(sum(curpt)/100,:)=[sum(curpt) it];
        end    
    end
    
    figure;plot(points(:,1:2:end-1),points(:,2:2:end),'.k'); hold on; axis equal tight
    for i=1:hsub-1;line([0 width],[i*subzonesize i*subzonesize]);end
    for i=1:wsub-1;line([i*subzonesize i*subzonesize],[0 height]);end
    
    figure; plot(dump(:,2),dump(:,1),'.b'); xlabel('Iterations'); ylabel('Points found');
    
    %sorting resulting points
    temp=points(points(:,1)~=0,1:2);
    for i=sub(2:end)
        temp=[temp;points(points(:,i*2-1)~=0,i*2-1:i*2)];
    end
    endresult=sortrows(-temp); clear temp
    endresult=-endresult;

    %separating results into blocks of "blocks" points each
    last=mod(size(endresult,1),blocks);%last block, smaller than "blocks"
    nmax=round((size(endresult,1)-last)/blocks);
    if nmax~=0
        endresults=zeros(blocks,2,nmax+1);
        for j=1:nmax
            endresults(:,:,j)=endresult((j-1)*blocks+1:j*blocks,:,1  );
        end
        endresults(1:last,:,j+1)=endresult(j*blocks+1:end,:,1);
    else
        endresults=endresult;
    end
end

%% Saving results to specified file

if addscale==1

fid=fopen([outputpath,filename], 'w'); %, 'a+')
fprintf(fid,'%s \n', '%!PS-Adobe-2.0');
fprintf(fid,'%s \n', ['%%Title: ',filename]);
fprintf(fid,'%s \n', ['%%CreationDate: ',date]);
fprintf(fid,'%s \n', '%%Creator: Andre Bauknecht');
fprintf(fid,'%s \n', ['%%BoundingBox: 0 0 ', num2str(w+20),' ', num2str(h+20)]);
fprintf(fid,'%s \n', 'matrix currentmatrix /originmat exch def');
fprintf(fid,'%s \n', '/umatrix {originmat matrix concatmatrix setmatrix} def');
fprintf(fid,'%s \n', '[2.8346456692913390 0 0 2.8346456692913390 0 0] umatrix');
fprintf(fid,'%s \n', '%%Pages: 0');
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', '%% PARAMETERS:');
fprintf(fid,'%s \n', ['%% Size(w,h,d): ',num2str(width),'+20 mm x ',num2str(height),'+20 mm']);
fprintf(fid,'%s \n', ['%% DotDiameter: ', num2str(diameter),' mm, Number of Dots: ', num2str(sum(curpt))]);
fprintf(fid,'%s \n', ['%% DotDensity: ', num2str(densfact)]);
fprintf(fid,'%s \n', '%%EndComments');
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', '0 10 translate   % shift from border');
fprintf(fid,'%s \n', '10 0 translate   % shift from border');
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', 'newpath');
fprintf(fid,'%s \n', '1 setlinewidth');
fprintf(fid,'%s \n', '0 setgray');
%frame
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', ['0 0 moveto 0 ', num2str(height),' rlineto']);
fprintf(fid,'%s \n', ['0 0 moveto ', num2str(width),' 0 rlineto']);
fprintf(fid,'%s \n', [num2str(width),' 0 moveto 0 ',num2str(height),' rlineto']);
fprintf(fid,'%s \n', ['0 ',num2str(height),' moveto ',num2str(width),' 0 rlineto stroke']);

fprintf(fid,'%s \n', '');

%left handside markers
for i=0:10:height
    if mod(i,100)>0
        fprintf(fid,'%s \n', ['0 ',num2str(i) ,' moveto -5 0 rlineto stroke']);
    else
        fprintf(fid,'%s \n', ['0 ',num2str(i) ,' moveto -10 0 rlineto stroke']);
    end
end   
%right handside markers
for i=0:10:height
    if mod(i,100)>0
        fprintf(fid,'%s \n', [num2str(width),' ',num2str(i) ,' moveto 5 0 rlineto stroke']);
    else
        fprintf(fid,'%s \n', [num2str(width),' ',num2str(i) ,' moveto 10 0 rlineto stroke']);
    end
end    
%bottom markers
for i=0:10:width
    if mod(i,100)>0
        fprintf(fid,'%s \n', [num2str(i),' 0 moveto 0 -5 rlineto stroke']);
    else
        fprintf(fid,'%s \n', [num2str(i),' 0 moveto 0 -10 rlineto stroke']);
    end
end    
%top markers
for i=100:10:width
    if mod(i,100)>0
        fprintf(fid,'%s \n', [num2str(i),' ',num2str(height),' moveto 0 5 rlineto stroke']);
    else
        fprintf(fid,'%s \n', [num2str(i),' ',num2str(height),' moveto 0 10 rlineto stroke']);
    end
end    
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', '');
%print actual results
for j=1:nmax
fprintf(fid,'%s \n', '[');
fprintf(fid,'[%6.3f  %6.3f] \n',endresults(:,:,j)');
fprintf(fid,'%s \n', [']	{ {} forall ', num2str(diameter/2) ,' 0 360 arc fill} bind forall']);
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', '');
end
fprintf(fid,'%s \n', '[');
fprintf(fid,'[%6.3f  %6.3f] \n',endresults(1:last,:,nmax+1)');
fprintf(fid,'%s \n', [']	{ {} forall ', num2str(diameter/2) ,' 0 360 arc fill} bind forall']);

fprintf(fid,'%s \n', '/Times-Bolt findfont 6 scalefont setfont');
fprintf(fid,'%s \n', 'newpath');
fprintf(fid,'%s \n', ['-8 ',num2str(height+3),' moveto']);
fprintf(fid,'%s \n', ['(w',num2str(width),', h',num2str(height),', d',num2str(diameter),'mm, D',num2str(densfact),', N',num2str(sum(curpt)),') show']);
fprintf(fid,'%s \n', 'showpage');

fclose(fid);

% convert to pdf
if exist(regexprep(ghostscriptpath,'"',''),'file')
    system([ghostscriptpath ' -sDEVICE=pdfwrite -r100 -g' num2str(round((width+20)/25.4*100)) 'x' num2str(round((height+20)/25.4*100)) ' -dPDFFitPage -o PDF_' filename(1:end-2) 'pdf ' filename])
end



else %addscale=0
    
fid=fopen([outputpath,filename], 'w'); %, 'a+')
fprintf(fid,'%s \n', '%!PS-Adobe-2.0');
fprintf(fid,'%s \n', ['%%Title: ',filename]);
fprintf(fid,'%s \n', ['%%CreationDate: ',date]);
fprintf(fid,'%s \n', '%%Creator: Andre Bauknecht');
fprintf(fid,'%s \n', ['%%BoundingBox: 0 0 ', num2str(w),' ', num2str(h)]);
fprintf(fid,'%s \n', 'matrix currentmatrix /originmat exch def');
fprintf(fid,'%s \n', '/umatrix {originmat matrix concatmatrix setmatrix} def');
fprintf(fid,'%s \n', '[2.8346456692913390 0 0 2.8346456692913390 0 0] umatrix');
fprintf(fid,'%s \n', '%%Pages: 0');
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', '%% PARAMETERS:');
fprintf(fid,'%s \n', ['%% Size(w,h,d): ',num2str(width),' mm x ',num2str(height),' mm']);
fprintf(fid,'%s \n', ['%% DotDiameter: ', num2str(diameter),' mm, Number of Dots: ', num2str(sum(curpt))]);
fprintf(fid,'%s \n', ['%% DotDensity: ', num2str(densfact)]);
fprintf(fid,'%s \n', '%%EndComments');
fprintf(fid,'%s \n', '');
% fprintf(fid,'%s \n', '0 10 translate   % shift from border');
% fprintf(fid,'%s \n', '10 0 translate   % shift from border');
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', 'newpath');
fprintf(fid,'%s \n', '0.2 setlinewidth');
fprintf(fid,'%s \n', '0 setgray');
%frame
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', ['0 0 moveto 0 ', num2str(height),' rlineto']);
fprintf(fid,'%s \n', ['0 0 moveto ', num2str(width),' 0 rlineto']);
fprintf(fid,'%s \n', [num2str(width),' 0 moveto 0 ',num2str(height),' rlineto']);
fprintf(fid,'%s \n', ['0 ',num2str(height),' moveto ',num2str(width),' 0 rlineto stroke']);

fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', '');
%print actual results
for j=1:nmax
fprintf(fid,'%s \n', '[');
fprintf(fid,'[%6.3f  %6.3f] \n',endresults(:,:,j)');
fprintf(fid,'%s \n', [']	{ {} forall ', num2str(diameter/2) ,' 0 360 arc fill} bind forall']);
fprintf(fid,'%s \n', '');
fprintf(fid,'%s \n', '');
end
fprintf(fid,'%s \n', '[');
fprintf(fid,'[%6.3f  %6.3f] \n',endresults(1:last,:,nmax+1)');
fprintf(fid,'%s \n', [']	{ {} forall ', num2str(diameter/2) ,' 0 360 arc fill} bind forall']);

% fprintf(fid,'%s \n', '/Times-Bolt findfont 6 scalefont setfont');
% fprintf(fid,'%s \n', 'newpath');
% fprintf(fid,'%s \n', ['-8 ',num2str(height+3),' moveto']);
% fprintf(fid,'%s \n', ['(w',num2str(width),', h',num2str(height),', d',num2str(diameter),'mm, D',num2str(densfact),', N',num2str(sum(curpt)),') show']);
fprintf(fid,'%s \n', 'showpage');
fclose(fid);

% convert to pdf
if exist(regexprep(ghostscriptpath,'"',''),'file')
    system([ghostscriptpath ' -sDEVICE=pdfwrite -r100 -g' num2str(round((width)/25.4*100)) 'x' num2str(round((height)/25.4*100)) ' -dPDFFitPage -o PDF_' filename(1:end-3) '_borderless.pdf ' filename])
end


end



%% output times
dump = fix(mod(toc, [0, 3600, 60]) ./ [3600, 60, 1]);
houry=round(dump(1));miny=round(dump(2));secy=round(dump(3));clear dump;
if miny==0
    fprintf(1,'%s %i sec.\n','Total computation time:',secy);
elseif houry==0
    fprintf(1,'%s %i min %i sec.\n','Total computation time:',miny,secy);
else
    fprintf(1,'%s %i hr %i min %i sec.\n','Total computation time:',houry,miny,secy);
end