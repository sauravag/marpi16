close all;
clear all;clc;
%%%
do3d= 1;
%%%
xo = 0;    % initial position of particle
yo = 0;
R = 5;
Vko= 5;
wko= 0.0;
to = 0.0;   
dt = 0.1;       
%%%%%%From
loco= [0,0];
%%%%%%To
locf= [100,0];
%%%%%%
loc = locf - loco;
tf = norm(loc)/Vko;
thetao = asin(loc(2)/loc(1)) ;
xslip=xo;yslip=yo;thetaslip=thetao;Vk=Vko;wk=wko;yP=yo;thetaP=thetao;
nsteps = ceil((tf-to)/dt);
Path1 = [xo,yo,thetao;xo,yo,thetao];
Path2 = Path1;
Path3 = Path1;
Path4 = Path1;
Path5 = Path1;
Path6 = Path1;
%Path1=true 
%Path2=w/slip
%Path3=w/noise

%PID Factor 
P = .5;
I = 3;
D = 1;

for i = 2:nsteps+1
    %noise
    nv = randn*0.01;
    nw = randn*0.01;
    %slip
    sv = 0*randn*0.001;
    sw = randn*0.1;
    
    Cp = P*-(Path3(i,2)-Path1(i,2));
    Ci = I*-((Path3(i-1,2)-Path1(i-1,2))-(Path3(i,2)-Path1(i,2)))*dt;
    Cd = D*((Path3(i-1,2)-Path1(i-1,2))-(Path3(i,2)-Path1(i,2)))/dt;
    C = Cp+Ci+Cd;
    Cmax = pi/4;
    if C > Cmax
        C = Cmax;
    elseif C < -Cmax
        C = -Cmax;
    else
    end
    
    xtrue = Path1(i,1)+(Vk)*dt*cos(Path1(i,3));
    ytrue = Path1(i,2)+(Vk)*dt*sin(Path1(i,3));
    thetatrue = Path1(i,3) + (wk)*dt;
    
    Path1(i+1,:) = [xtrue,ytrue,thetatrue];
    
    xslip = Path2(i,1)+(Vk+sv)*dt*cos(Path2(i,3)) ;
    yslip = Path2(i,2)+(Vk+sv)*dt*sin(Path2(i,3)) ;
    thetaslip = Path2(i,3) + (wk+sw+C) *dt; 
 
    Path2(i+1,:) = [xslip,yslip,thetaslip];
    
    xnoise = xslip+ nv;
    ynoise = yslip+ nv;
    thetanoise = thetaslip+ nw; 

    Path3(i+1,:) = [xnoise,ynoise,thetanoise];
    
    xslip = Path4(i,1)+(Vk+sv)*dt*cos(Path4(i,3)) ;
    yslip = Path4(i,2)+(Vk+sv)*dt*sin(Path4(i,3)) ;
    thetaslip = Path4(i,3) + (wk+sw) *dt; 
 
    Path4(i+1,:) = [xslip,yslip,thetaslip];
end
figure(1);
hold on;
plot(Path1(:,1), Path1(:,2),'g');
plot(Path2(:,1), Path2(:,2),'r');
plot(Path3(:,1), Path3(:,2),'b');
plot(Path4(:,1), Path4(:,2),'c');

if do3d
Path1_3=pipe(Path1(:,1),Path1(:,2),R);
Path2_3=pipe(Path2(:,1),Path2(:,2),R);
Path3_3=pipe(Path3(:,1),Path3(:,2),R);
Path4_3=pipe(Path4(:,1),Path4(:,2),R);
figure(2); hold on; view([135,30]);
[X,Y,Z] = cylinder(R,50);
Z(2, :) = 100;
surf(X,Y,Z, 'FaceAlpha', 0.05, 'EdgeColor', 'none');
plot3(Path1_3(:,1),Path1_3(:,2),Path1_3(:,3),'g')
plot3(Path2_3(:,1),Path2_3(:,2),Path2_3(:,3),'r')
plot3(Path3_3(:,1),Path3_3(:,2),Path3_3(:,3),'b')
plot3(Path4_3(:,1),Path4_3(:,2),Path4_3(:,3),'c')
end
