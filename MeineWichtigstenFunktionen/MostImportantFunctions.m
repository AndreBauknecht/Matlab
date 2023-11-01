% important functions for matlab
%
% created by André Bauknecht, last edited: 30.07.2014



%%
%##########################################################################
%########################### BASIC OPERATIONS #############################
%##########################################################################

%% Pad string with zeros
        % if you have a number or string that you want to pad with a number of
        % zeros in the front:
        paddedstring = sprintf('%05d', unpaddedstring); %5 is the total number of digits

%% Generate vector between two values with certain number of elements
        % generates a vector with n elements between a and b
        vector=linspace(a,b,n);
        
%% Generate matrix data from vectors
        % generate meshed data from two vectors for plotting:
        [Y,X]=meshgrid(y,x); %Y,X 2D matrices. y,x 1D vectors
        % reshape e.g. a vector to a matrix:
        A=reshape(sizex,sizey,B); %B vector, A matrix of size sizex/sizey
        
%% Output computation time in command window
        % at the beginning of the programm, type 'tic'. At a later instant,
        % the time is output with the output text specified in 'text'
        outputtimes(toc,'text');
        
%%        
%##########################################################################
%############################# INPUT/OUTPUT ###############################
%##########################################################################
        
%% Check if directory exists, if not, create it (checkcreatedir.m)
        direxist = exist(strcat(path,'dirname'),'dir');
        if direxist<1
            mkdir(path,'dirname');
        end
        
        % alternative:
        checkcreatedir(path, folder);

%% Load txt/dat data with header (hdrload.m)
        [header,data]=hdrload('folderpath_filename.dat');
        
%% Load image
        % check if image really exists and load it
        file='folderpath_filename.png';
        if exist(file, 'file')
            A=imread(file);
        end
        
%% GUI for selecting multiple files / directories (uigetfile_n_dir.m)
        path=uigetfile_n_dir('initial_folderpath','Description of GUI');
        
%% Output graphic in good quality
        % an open figure with the handle gcf is output to a file:
        set(gcf,'renderer','opengl');
        print(gcf,'-dpdf','folderpath_filename.pdf,'-r500'); %pdf with 600dpi
        print(gcf,'-dpng','folderpath_filename.png,'-r200'); %png with 200dpi
        % output to eps:
        set(gcf,'renderer','painters')
        print(gcf,'-depsc2','folderpath_filename.eps') % vector graphic
        
%% Output data to txt/dat file
        %output vectors/matrices to text file with the following format
        fid = fopen('folderpath_filename.dat','w'); %open for writing
        for k=1:5
            fprintf(fid,'%i,% 7.4f,% 7.4f\n',integer,floatnumber,floatnumber); %output line by line
        end
        fclose('all');
        %output to Command Window:
        fprintf(1,'Text');
    
%% Export data for tecplot (mat2tecplot.m)
        % function to generate tecplot-format output. For example:
        tdata.Nvar=3;
        tdata.varnames={'x','y','z'};
        for k=1:5 %multiple ZONES
            for i=1:10 %multiple points
                tdata.lines(k).x(1,i)=data(i,1);
                tdata.lines(k).y(1,i)=data(i,2);
                tdata.lines(k).z(1,i)=data(i,3);
            end
        end
        mat2tecplot(tdata,'myline3D.plt')
        
%%        
%##########################################################################
%########################## PLOTTING / IMAGES #############################
%##########################################################################
          
%% Manually select points within a figure        
        [x,y]=ginput(1);
        
%%        
%##########################################################################
%############################# DATA FITTING ###############################
%##########################################################################
          
%% Create linear fit of surface in 3D (createLinFit.m)
        % createFit generates linear fit of the surface Z, filling up
        % outliers and NaNs
        [fitresult, ~] = createLinFit(X, Y, Z); %Z is fitted linearly
        % evaluate the generated fit:
        Zfit=feval(fitresult,X,Y);
        
%% Find maximum of curve with Gauss Peakfit (gausspeakfit.m)
        % compute maximum of 2D correlationmap with subpixel accuracy
        [shifty,shiftx]=gausspeakfit(cormap); %shift in cells, to calculate exact
        % position of maximum (X,Y), it has to be multiplied with the cellwidth
        X=X+shiftx*dX; %dX [mm] cell size in mm
        