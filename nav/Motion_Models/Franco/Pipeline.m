close all;
clear all;clc;
xo = 0;    % initial position of particle
yo = 0;
R = 1;
Vko= 5;
wko= 0.0;
to = 0.0;   
dt = 0.1;       
%%%%%%From
loco= [0,0];
%%%%%%To[x,theta]
locf= [100,10];
%%%%%%
loc = locf - loco;
tf = norm(loc)/Vko;
thetao = asin(loc(2)/loc(1)) ;
xslip=xo;yslip=yo;thetaslip=thetao;Vk=Vko;wk=wko;yP=yo;thetaP=thetao;
nsteps = ceil((tf-to)/dt);
Path1 = [xo,yo,thetao];
Path2 = Path1;
Path3 = Path1;
Path4 = Path1;
%Path1=true 
%Path2=w/slip
%Path3=w/noise


for i = 1:nsteps
    %noise
    nv = 0*randn*0.001;
    nw = randn*0.01;
    %slip
    sv = 0*randn*0.001;
    sw = randn*0.01;
    
  
    
    xtrue = Path1(i,1)+(Vk)*dt*cos(Path1(i,3));
    ytrue = Path1(i,2)+(Vk)*dt*sin(Path1(i,3));
    thetatrue = Path1(i,3) + (wk)*dt;
    
    Path1(i+1,:) = [xtrue,ytrue,thetatrue];
    
    xslip = Path2(i,1)+(Vk+sv)*dt*cos(Path2(i,3)) ;
    yslip = Path2(i,2)+(Vk+sv)*dt*sin(Path2(i,3)) ;
    thetaslip = Path2(i,3) + (wk+sw) *dt; 
 
    Path2(i+1,:) = [xslip,yslip,thetaslip];
    
    xnoise = xslip+ randn*0.01;
    ynoise = yslip+ randn*0.01;
    thetanoise = thetaslip+ randn*0.01; 

    Path3(i+1,:) = [xnoise,ynoise,thetanoise];
    
    
    
end
%figure(1);
%hold on;

%plot(Path1(:,1), Path1(:,2),'g');
%plot(Path2(:,1), Path2(:,2),'r');
%plot(Path3(:,1), Path3(:,2),'b');
Path1_3=pipe(Path1(:,1),Path1(:,2),R);
Path2_3=pipe(Path2(:,1),Path2(:,2),R);
figure(2); hold on;
[X,Y,Z] = cylinder(R,50);
Z(2, :) = 100;
surf(X,Y,Z, 'FaceAlpha', 0.05, 'EdgeColor', 'none');
plot3(Path1_3(:,1),Path1_3(:,2),Path1_3(:,3))
plot3(Path2_3(:,1),Path2_3(:,2),Path2_3(:,3))

