Nx_gly=0; %Pr simu4 et simu5
Nx_eau=0; %Pr simu1 et simu2 et simu3
Nx_bld=112305+499*8609;


Nx0=Nx_gly;
Nx1=Nx_gly+Nx_eau;
Nx2=Nx_gly+Nx_eau+Nx_bld;


DB=zeros(Nx1,1,1);
M0=zeros(Nx1,1,1);
T1=zeros(Nx1,1,1);
T2=zeros(Nx1,1,1);
T2s=zeros(Nx1,1,1);


%Dynamic spins
%GLYCERINE
M0(1:Nx0,:,:)=1;
T1(1:Nx0,:,:)=144; %T1 eau+glycerine = 1154 ms, T1 Eau+Glycerine+Gado = 144 ms
T2(1:Nx0,:,:)=2;   %T2 eau+glycerine = 192 ms, T1 Eau+Glycerine+Gado = 86 ms
T2s(1:Nx0,:,:)=2;
DB(1:Nx0,:,:)=0;
OFFSET=[0 0 0];
RES=1;

%Static spins
%EAU PURE
M0(Nx0+1:Nx1,:,:)=1;
T1(Nx0+1:Nx1,:,:)=2885; %T1 eau liquide  2885 ms
T2(Nx0+1:Nx1,:,:)=2;
T2s(Nx0+1:Nx1,:,:)=2;
DB(Nx0+1:Nx1,:,:)=0;
OFFSET=[0 0 0];
RES=1;

%Dynamic spins
%SANG
M0(Nx1+1:Nx2,:,:)=1;
T1(Nx1+1:Nx2,:,:)=1584; %T1 Veineux 1584 ms  Arteriel 1664 ms
T2(Nx1+1:Nx2,:,:)=2;  %T2 275 ms
T2s(Nx1+1:Nx2,:,:)=2;
DB(Nx1+1:Nx2,:,:)=0;
OFFSET=[0 0 0];
RES=1;


save('MySample.mat','M0','T1','T2','T2s','OFFSET','RES','DB');
sample=load('MySample.mat');
writeSample(sample);
