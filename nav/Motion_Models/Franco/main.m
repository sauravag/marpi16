clc; clear; close all;

duration = 1000; %secs
dt = 0.1; %time step

R = 1; %Pipe radius in meters

x = zeros(3,duration/dt); %initial state vector [theta, phi, z]
u = [1.0; 0.001]; %control vector [v, phi]
w_control_zero = [0; 0]; %control noise [n_v, n_phi]
w_additive_zero = [0; 0; 0]; %additive noise [n_theta, n_phi, n_z]

w_control = [0; 0]; %control noise [n_v, n_phi]
w_additive = [0; 0; 0]; %additive noise [n_theta, n_phi, n_z]

orientation_sensor_noise = 0; % noise in heading sensor

x_est = x;

for t = 1: duration / dt
    x(:,t+1) = pipe_motion_model(x(:,t), u, w_control_zero, w_additive_zero, dt, R);
  
    w_control = [randn*0.01; 0];
    orientation_sensor_noise = randn*deg2rad(0.1);
    
    x_est(:,t+1) = pipe_motion_model(x_est(:,t), u, w_control, w_additive, dt, R);
    x_est(2,t+1) = x_est(2,t+1)  + orientation_sensor_noise;
end

figure(1)
hold on;

%Cylider to Model the Pipe
[X,Y,Z] = cylinder(R,50);
Z(2, :) = 100;
surf(X,Y,Z, 'FaceAlpha', 0.05, 'EdgeColor', 'none');

plot3(R*cos(x(1,:)), R*sin(x(1,:)), x(3,:),'g') %True Path
xlabel('X'); ylabel('Y'); zlabel('Z');

plot3(R*cos(x_est(1,:)), R*sin(x_est(1,:)), x_est(3,:),'r') %Oddemetry Path
hold off;
title('Trajectory')
legend('Pipe','Truth','Estimate')

figure(2)
subplot(3,1,1)
plot(x(1,:)-x_est(1,:))
title('Theta');
xlabel('Time Steps'); ylabel('Error');

subplot(3,1,2)
plot(x(2,:)-x_est(2,:))
title('Phi');
xlabel('Time Steps'); ylabel('Error');

subplot(3,1,3)
plot(x(3,:)-x_est(3,:))
title('Z');
xlabel('Time Steps'); ylabel('Error');

