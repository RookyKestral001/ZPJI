classdef Objetivo < handle
    properties
        x
        y
        vx
        vy
    end
    
    methods
        function obj = Objetivo(x0, y0, vx0, vy0)
            if nargin == 0
                obj.x = rand*Uno.disAmp;
                obj.y = rand*Uno.disAmp;
                obj.vx = rand*Uno.veloAmp;
                obj.vy = rand*Uno.veloAmp;
            elseif nargin == 4
                obj.x = x0;
                obj.y = y0;
                obj.vx = vx0;
                obj.vy = vy0;
            end
        end
    end
end
