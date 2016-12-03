classdef GravityHeadingSensor < ObservationModelBase
    properties (Constant) % Note that you cannot change the order of the definition of properties in this class due to its ugly structure!! (due to dependency between properties.)
        obsDim = 4; % dimension of the observation vector
        obsNoiseDim = 4; % observation noise dimension. In some other observation models the noise dimension may be different from the observation dimension.
    end
    
    properties
        zeroNoise = zeros(4,1);
        R_v = 1e-6*eye(4);
        accG = 9.8;
        g_pipe = [-9.8;0;0];
    end
    
    methods
        
        function obj = GravityHeadingSensor()
            obj@ObservationModelBase();
        end
        
        function z = getObservation(obj,x,v)
            
            phi = x(1);
            theta = x(2);                      
            
            R_bp = [sin(theta)*sin(phi), -sin(theta)*cos(phi), -cos(theta); ...
                -cos(theta)*sin(phi), cos(theta)*cos(phi), -sin(theta); ...
                cos(phi), sin(phi), 0];
            
            z = [R_bp'*obj.g_pipe; phi] + v;
            
            z(4) = pi_to_pi(z(4));
        end
                
        function H = getObservationJacobian(obj,x)
            phi = x(1);
            theta = x(2);
            g = obj.accG;
            
            H = [ -g*sin(theta)*cos(phi), -g * cos(theta)*sin(phi), 0;...
                -g*sin(theta)*sin(phi), g*cos(theta)*cos(phi), 0;...
                0, -g*sin(theta), 0 ;...
                1, 0, 0];
        end
        
        function M = getObservationNoiseJacobian(obj,x)
            M = eye(4);
        end

        function v = generateObservationNoise(obj,x)
            v = mvnrnd(obj.zeroNoise,obj.R_v);
            v = v';
        end
        
        function innov = computeInnovation(obj,Xprd,Zg)
            
            innov = Zg - obj.getObservation(Xprd, obj.zeroNoise);
            
            innov(4) = pi_to_pi(innov(4));
            
        end
            
    end
    
end