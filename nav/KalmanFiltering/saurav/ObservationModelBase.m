classdef ObservationModelBase < handle
    properties (Abstract, Constant) % Note that you cannot change the order of the definition of properties in this class due to its ugly structure!! (due to dependency between properties.)
        obsDim; % dimension of the observation vector
        obsNoiseDim; % observation noise dimension. In some other observation models the noise dimension may be different from the observation dimension.
    end
    
    
    methods (Abstract)
        
        z = getObservation(x)
                
        H = getObservationJacobian(x)
        
        M = getObservationNoiseJacobian(x)
                
        v = generateObservationNoise(x)
                    
        innov = computeInnovation(obj,Xprd,Zg);
    end
    
end