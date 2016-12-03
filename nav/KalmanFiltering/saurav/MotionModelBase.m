classdef MotionModelBase < handle
    properties (Abstract, Constant) % note that all properties must be constant, because we have a lot of copies of this object and it can take a lot of memory otherwise.
        stDim; % state dimension
        ctDim;  % control vector dimension
        wDim;   % Process noise (W) dimension      
        zeroNoise; % zero noise vector
    end
    
    properties
        dt = 0.0; % delta_t for time discretization
        Q_w = 0.0; % covariance of process noise
    end
    
    methods (Abstract)
        x_next = evolve(x,u,w) % discrete motion model equation
        
        F = getStateTransitionJacobian(x,u) % state Jacobian
        
        B = getControlJacobian(x,u); % Jacobian w.r.t control u
                
        L = getProcessNoiseJacobian(x) % noise Jacobian
                
        w = generateProcessNoise(x,u) % simulate (generate) process noise based on the current poistion and controls
        
    end
end