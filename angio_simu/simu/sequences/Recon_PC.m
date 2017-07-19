function ReconJemrisCartesianDataMain

% reconstructs data you just acquired.

clear all
addpath './sequences/ReconUtilities/';



%PARAMETERS--------------------
VENC=1000; %mm/s
invertVel=+1;   %To invert velocity sign



% set up paths, hopefully easy to change as needed.
basePathStart = '.'; %change to fit your own needs
localDir      = '';                       % local Jemris work area
basePath      = strcat([basePathStart,localDir]);      % make full path to here
params.path      = uigetdir(strcat([basePath]));


% flags to adjust actions.
control.saveJPG     = false; % option to save image in JPG folder
control.isJemris27  = true; %identifying software version




    params.seq        = 'name';
    %Read image size
    t=h5read(strcat([params.path,'/signals.h5']),'/signal/times');
    Dt=t(2)-t(1);
    N=1; while(t(N+1)-t(N)<10*Dt)  N=N+1; end;
    params.nX         = N;%461;%486;  %set this correctly
    params.nY         = size(t,1)/params.nX;%333;%436;  %set this correctly
    disp(params.nY);
    %Read channels number
    I=h5info(strcat([params.path,'/signals.h5']),'/signal/channels');
    params.channels   = size(I.Datasets,1);disp('Channels: ');disp(params.channels);
    % **** end adjust for each seq ***
    params.nRows      = params.nY;
    params.nCols      = params.nX;
    params.nSli       = 1;
    control.fullTitle = false;




params.dataName   = 'signals'; %data file name for Jemris 2.7
params.fileName = strcat([params.path,'/',params.dataName]); 
rawFileName = params.fileName;

% read the data, organize into complex matrix
params.fileName = strcat([rawFileName,'.h5']);
rawData              = ReadCartesianData_PhaseContrast(params,control);
rawDataP=rawData(1:(params.nY/2),:);
rawDataN=rawData((params.nY/2+1):params.nY,:);


 
% Cartesian recon: special re-ordering for EPI, FSE centric
for i=1:params.channels
imageP(:,:,i)               = ReconCartesianData(rawDataP(:,:,1,i),params,control);
imageN(:,:,i)               = ReconCartesianData(rawDataN(:,:,1,i),params,control);
end;
    


fh0=figure;
colormap(gray);
%Raw data
subplot(2,3,1);
imagesc(log(abs(rawDataP(:,:))));
title('K-SPACE','FontSize',12');
ylabel('POSITIVE','FontSize',12);
subplot(2,3,4);
imagesc(log(abs(rawDataN(:,:))));
ylabel('NEGATIVE','FontSize',12);

%Magnitude
subplot(2,3,2);
imagesc(abs(imageP));
title('MAGNITUDE','FontSize',12');
subplot(2,3,5);
imagesc(abs(imageN));

%Phase
imagePhase=angle(imageP);
subplot(2,3,3);
imagesc(imagePhase);
title('PHASE IMAGE','FontSize',12');
imagePhase=angle(imageN);
subplot(2,3,6);
imagesc(imagePhase);






%Phase image-------------------------------------------------

imagePhase=angle(imageN./imageP);

imagePhase=VENC*imagePhase/pi*invertVel; %Donne vitesses en mm/s pour division cplexe
fh1=figure;
%colormap(gray);
imagesc(imagePhase,[-VENC,VENC]);
xlabel('readout (pixels)','FontSize',12);
ylabel('phase (pixels)','FontSize',12);
title('VELOCITY MAP','FontSize',12');
colorbar;
if(control.saveJPG)
    saveas(fh1,strcat([params.path,'/PhaseImage']),'jpg');
end;



%Magnitude image (complex subtraction)----------------------------------------------------

imageMagn=abs(imageP-imageN);

figure;
imagesc(imageMagn);
colormap(gray);
colorbar;
xlabel('readout (pixels)','FontSize',12);
ylabel('phase (pixels)','FontSize',12);
title('COMPLEX SIGNAL DIFFERENCE','FontSize',12');



%Phase * Magnitude--------------------------------------------
imageMagn=abs(imageP).*abs(angle(imageN./imageP));

fh3=figure;
imagesc(imageMagn);%,[0 0.002]);
xlabel('readout (pixels)','FontSize',12);
ylabel('phase (pixels)','FontSize',12);
title('MAGNITUDE x PHASE','FontSize',12');
colormap(gray);
colorbar;






% *****************************************
% **** Manage Cartesian Reconstructions ***
% *****************************************
function image = ReconCartesianData(rawData,params,control)

    % Flip even numbered data lines for epi
    if(strcmp('EPI',params.seq))
        rawData = EpiFlipData(rawData);
    end;

    % shuffle data lines for centric ordered FSE
    if( strcmp(params.seq,'FSE') && strcmp(params.order,'centric') )
        rawData = ReorderFSEcentric(rawData,params);  
    end;

    
    % straight Cartesian recon
    image   = fliplr(conj(ift2(rawData)));

    
  
