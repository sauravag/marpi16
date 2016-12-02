classdef PancakeRobot < MotionModelBase
    properties (Constant = true) % note that all properties must be constant, because we have a lot of copies of this object and it can take a lot of memory otherwise.
        stDim = 3; % state dimension
        ctDim = 2;  % control vector dimension
        wDim = 2;   % Process noise (W) dimension      
        zeroNoise = [0;0]; % zero noise vector       
    end
    
    properties
         R = 1e-2*60.96/2; % radius of pipe in meters
    end
    
    methods
        
        function obj = PancakeRobot()
            obj@MotionModelBase();
            obj.dt = 0.1; % delta_t for time discretization
            obj.Q_w = diag([0.01^2, 0.01^2]); % covariance of process noise
        end
        
        function x_next = evolve(obj, x, u, w)
            
            phi = x(1);
            
            sqrt_dt = sqrt(obj.dt); 
            
            delta_phi =  u(2)*obj.dt + w(2)*sqrt_dt;
            
            delta_theta = u(1)*sin(phi)*obj.dt/obj.R +  w(1)*sin(phi)*sqrt_dt/obj.R;
            
            delta_d = u(1)*cos(phi)*obj.dt + w(1)*cos(phi)*sqrt_dt;
            
            x_next = x + [delta_phi; delta_theta; delta_d];
            
            x_next(1) = pi_to_pi(x_next(1));
            x_next(2) = pi_to_pi(x_next(2));
            
        end
        
        function F = getStateTransitionJacobian(obj, x, u)
        
                phi = x(1);
                
                F = [1, 0, 0;...
                    u(1)*cos(phi)*obj.dt/obj.R, 1, 0;...
                    -u(1)*sin(phi)*obj.dt, 0, 1];
                    
        end
                
        function L = getProcessNoiseJacobian(obj, x) % noise Jacobian
            phi = x(1);
            
            sqrt_dt = sqrt(obj.dt);
            
            L = [0, sqrt_dt;...
                sin(phi)*sqrt_dt/obj.R, 0;...
                cos(phi)*sqrt_dt, 0];
        
        end
                
        function w = generateProcessNoise(obj, x, u) % simulate (generate) process noise based on the current poistion and controls
            w = mvnrnd(obj.zeroNoise,obj.Q_w);
        end
        
    end
end