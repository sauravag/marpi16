clc; clear; close all;

% fix seed
rng(100)

%% Setup
duration = 50; %secs
motionModel = PancakeRobot();
observationModel = GravityHeadingSensor();

x = zeros(3,duration/motionModel.dt); %initial state vector [theta, phi, z]
x_est = x;
P_est = 1e-2*eye(3);

u = [1.0; 0.01]; %control vector [v, phi]

%% run
for t = 1: duration / motionModel.dt      
    
    % process noise
    w = motionModel.generateProcessNoise(x(:,t),u);

    % true state propagation
    x(:,t+1) = motionModel.evolve(x(:,t),u,w);
    
    % observation noise
    v = observationModel.generateObservationNoise(x);
    
    % sensor observation
    z = observationModel.getObservation(x,v);
    
    % Prediction Step
    
    % predicted state       
    zeronoise = motionModel.zeroNoise; % zero process noise
    x_prd = motionModel.evolve(x_est(:,t), u, zeronoise);
    
    % Predicted Covariance
    F = motionModel.getStateTransitionJacobian(x_est(:,t), u);
    L = motionModel.getProcessNoiseJacobian(x_est(:,t));
    P_prd = F*P_est*F' + L*motionModel.Q_w*L';
    
    % Update Step
    
    % Innovation
    y = observationModel.computeInnovation(x_prd,z);
    
    % Innovation covariance
    H = observationModel.getObservationJacobian(x_prd);   
    R = observationModel.R_v;
    M = observationModel.getObservationNoiseJacobian(x_prd);    
    S = H*P_prd*H' + M*R*M';
    
    % Kalman Gain
    Kg = P_prd*H'*inv(S);
    
    x_est(:,t+1) = x_prd + Kg*y;
    P_est = (eye(3) - Kg*H)*P_prd;
end

%% Plot
figure(1)
hold on;

R = motionModel.R;

%Cylider to Model the Pipe
[X,Y,Z] = cylinder(R,50);
Z(2, :) = 100;
surf(X,Y,Z, 'FaceAlpha', 0.05, 'EdgeColor', 'none');

plot3(R*cos(x(2,:)), R*sin(x(2,:)), x(3,:),'g') %True Path
xlabel('X'); ylabel('Y'); zlabel('Z');

plot3(R*cos(x_est(2,:)), R*sin(x_est(2,:)), x_est(3,:),'r') %Oddemetry Path
hold off;
title('Trajectory')
legend('Pipe','Truth','Estimate')

figure(2)
subplot(3,1,1)
plot(pi_to_pi(x(1,:)-x_est(1,:))*180/pi)
title('Phi (degrees)');
xlabel('Time Steps'); ylabel('Error');

subplot(3,1,2)
plot(pi_to_pi(x(2,:)-x_est(2,:))*180/pi)
title('Theta (degrees)');
xlabel('Time Steps'); ylabel('Error');

subplot(3,1,3)
plot(x(3,:)-x_est(3,:))
title('d (m)');
xlabel('Time Steps'); ylabel('Error');

