classdef Uno < handle
    properties
        disAmp = 1.7;
        veloAmp = 4;
        radiAmp = 5;
        
        rule1Amp = 0.5;
        rule2Amp = 2;
        rule3Amp = 1;
        
        id
        x
        y
        v %线速度
        w %角速度
        r
        rb
        
        xDest = 10;
        yDest = 10;
        vxDest = 3; %目标线速度
        vyDest = 3; %目标角速度
        
        neighborSet
        neighborNum = 0;
        xNeighborTotal = 0;
        yNeighborTotal = 0;
        xNeighborAverage = 0;
        yNeighborAverage = 0;
        
        vNeighborTotal = 0; %邻居总线速度
        wNeighborTotal = 0; %邻居总角速度
        vNeighborAverage = 0; %邻居平均线速度
        wNeighborAverage = 0; %邻居平均角速度
    end
    
    methods
        function obj = Uno(id0, x0, y0, v0, w0, r0, rb0)
            if nargin == 0
                obj.id = 0;
                obj.x = rand*obj.disAmp;
                obj.y = rand*obj.disAmp;
                obj.v = rand*obj.veloAmp;
                obj.w = rand*2*pi;
                obj.r = 1*obj.radiAmp;
                obj.rb = 1;
            elseif nargin == 1
                obj.id = id0;
                obj.x = rand*obj.disAmp;
                obj.y = rand*obj.disAmp;
                obj.v = rand*obj.veloAmp;
                obj.w = rand*2*pi;
                obj.r = 1*obj.radiAmp;
                obj.rb = 1;
            elseif nargin == 7
                obj.id = id0;
                obj.x = x0;
                obj.y = y0;
                obj.v = v0;
                obj.w = w0;
                obj.r = r0;
                obj.rb = rb0;
            else
                error('wrong input arguments');
            end
            
%             obj.xDest = 10;
%             obj.yDest = 10;
%             obj.vDest = 3;
%             obj.wDest = pi;
%             obj.neighborNum = 0;
%             obj.xNeighborTotal = 0;
%             obj.yNeighborTotal = 0;
%             obj.xNeighborAverage = 0;
%             obj.yNeighborAverage = 0;
        end
        
        function isNeighbor(obj, obj0) %1：邻居 2：碰撞风险
%             obj.neighborNum = 0;
%             obj.xNeighborTotal = 0;
%             obj.yNeighborTotal = 0;
%             obj.xNeighborAverage = 0;
%             obj.yNeighborAverage = 0;
            
            d = sqrt((obj.x - obj0.x)^2 + (obj.y - obj0.y)^2);
            if (d>obj.rb)&&(d<obj.r)
                obj.neighborSet(obj0.id, 1) = 1;
                obj.neighborSet(obj0.id, 2) = obj0.x;
                obj.neighborSet(obj0.id, 3) = obj0.y;                
                obj.neighborSet(obj0.id, 4) = obj0.v;
                obj.neighborSet(obj0.id, 5) = obj0.w;
                
                obj.neighborNum = obj.neighborNum + 1;
                obj.xNeighborTotal = obj.xNeighborTotal + obj0.x;
                obj.yNeighborTotal = obj.yNeighborTotal + obj0.y;
                obj.xNeighborAverage = obj.xNeighborTotal/obj.neighborNum;
                obj.yNeighborAverage = obj.yNeighborTotal/obj.neighborNum;
                
                obj.vNeighborTotal = obj.vNeighborTotal + obj0.v;
                obj.wNeighborTotal = obj.wNeighborTotal + obj0.w;
                obj.vNeighborAverage = obj.vNeighborTotal/obj.neighborNum;
                obj.wNeighborAverage = obj.wNeighborTotal/obj.neighborNum;
            elseif (d>0)&&(d<obj.rb)
                obj.neighborSet(obj0.id, 1) = 2;
                obj.neighborSet(obj0.id, 2) = obj0.x;
                obj.neighborSet(obj0.id, 3) = obj0.y;
                obj.neighborSet(obj0.id, 4) = obj0.v;
                obj.neighborSet(obj0.id, 5) = obj0.w;
                
                obj.neighborNum = obj.neighborNum + 1;
                obj.xNeighborTotal = obj.xNeighborTotal + obj0.x;
                obj.yNeighborTotal = obj.yNeighborTotal + obj0.y;
                obj.xNeighborAverage = obj.xNeighborTotal/obj.neighborNum;
                obj.yNeighborAverage = obj.yNeighborTotal/obj.neighborNum;
                
                obj.vNeighborTotal = obj.vNeighborTotal + obj0.v;
                obj.wNeighborTotal = obj.wNeighborTotal + obj0.w;
                obj.vNeighborAverage = obj.vNeighborTotal/obj.neighborNum;
                obj.wNeighborAverage = obj.wNeighborTotal/obj.neighborNum;                
            end
        end
                
        function [v1, w1] = rule1(obj) %凝聚向心性
            if (obj.xNeighborAverage ~= 0)&&(obj.yNeighborAverage ~= 0)
                vx1 = (obj.xNeighborAverage - obj.x)/obj.rule1Amp;
                vy1 = (obj.yNeighborAverage - obj.y)/obj.rule1Amp;
                v1 = sqrt(vx1^2 + vy1^2);
                w1 = atan(vy1/vx1);
            else
                v1 = 0;
                w1 = 0;
            end
        end
        
        function [v2, w2] = rule2(obj) %排斥性
            vx2 = 0;
            vy2 = 0;
            v2 = 0;
            w2 = 0;
            for i = 1:size(obj.neighborSet, 1)
                if(obj.neighborSet(i,1) == 2)
                    vx2 = vx2 + (obj.x - obj.neighborSet(i,2))/obj.rule2Amp;
                    vy2 = vy2 + (obj.y - obj.neighborSet(i,3))/obj.rule2Amp;
                end
                v2 = sqrt(vx2^2 + vy2^2);
                w2 = atan(vy2/vx2);
            end
        end
        
        function [v3, w3] = rule3(obj) %速度匹配
            if (obj.vNeighborAverage ~= 0)&&(obj.wNeighborAverage ~= 0)
%                 averNorm = sqrt((obj.vNeighborAverage)^2 + (obj.wNeighborAverage)^2);
%                 vAverDire = obj.vNeighborAverage/averNorm;
%                 wAverDire = obj.wNeighborAverage/averNorm;
%                 uavNorm = sqrt((obj.v)^2 + (obj.w)^2);
%                 vDire = obj.v/uavNorm;
%                 wDire = obj.w/uavNorm;
%                 v3 = (obj.vNeighborAverage - obj.v)/obj.rule3Amp;
                v3 = 0;
                w3 = (obj.wNeighborAverage - obj.w)/obj.rule3Amp;

            else
                v3 = 0;
                w3 = 0;
            end
        end
    end
end