classdef Uno < handle
    properties
        disAmp = 1.7;
        veloAmp = 5;
        radiAmp = 5;
        
        rule1Amp = 1;
        rule2Amp = 1;
        rule3Amp = 1;
        
        id
        x
        y
        vx 
        vy 
        r
        rb
        
        v
        w
        
        xDest = 10;
        yDest = 10;
        vxDest = 3; 
        vyDest = 3; 
        
        neighborSet
        neighborNum = 0;
        xNeighborTotal = 0;
        yNeighborTotal = 0;
        xNeighborAverage = 0;
        yNeighborAverage = 0;
        
        vxNeighborTotal = 0; 
        vyNeighborTotal = 0; 
        vxNeighborAverage = 0;
        vyNeighborAverage = 0; 
        
        vNeighborAverage = 0;
        wNeighborAverage = 0;
    end
    
    methods
        function obj = Uno(id0, x0, y0, vx0, vy0, r0, rb0)
            if nargin == 0
                obj.id = 0;
                obj.x = rand*obj.disAmp;
                obj.y = rand*obj.disAmp;
                obj.vx = rand*obj.veloAmp;
                obj.vy = rand*obj.veloAmp;
                obj.r = 1*obj.radiAmp;
                obj.rb = 1;
            elseif nargin == 1
                obj.id = id0;
                obj.x = rand*obj.disAmp;
                obj.y = rand*obj.disAmp;
                obj.vx = rand*obj.veloAmp;
                obj.vy = rand*obj.veloAmp;
                obj.r = 1*obj.radiAmp;
                obj.rb = 1;
            elseif nargin == 7
                obj.id = id0;
                obj.x = x0;
                obj.y = y0;
                obj.vx = vx0;
                obj.vy = vy0;
                obj.r = r0;
                obj.rb = rb0;
            else
                error('wrong input arguments');
            end
            
            [obj.v, obj.w] = transb(obj.vx, obj.vy);
%             obj.v = sqrt(obj.vx^2 + obj.vy^2);
%             obj.w = atan(obj.vy/obj.vx);
        end
        
        function isNeighbor(obj, obj0) %1£ºÁÚ¾Ó 2£ºÅö×²·çÏÕ            
            d = sqrt((obj.x - obj0.x)^2 + (obj.y - obj0.y)^2);
            if (d>obj.rb)&&(d<obj.r)
                obj.neighborSet(obj0.id, 1) = 1;
                obj.neighborSet(obj0.id, 2) = obj0.x;
                obj.neighborSet(obj0.id, 3) = obj0.y;                
                obj.neighborSet(obj0.id, 4) = obj0.vx;
                obj.neighborSet(obj0.id, 5) = obj0.vy;
                
                obj.neighborNum = obj.neighborNum + 1;
                obj.xNeighborTotal = obj.xNeighborTotal + obj0.x;
                obj.yNeighborTotal = obj.yNeighborTotal + obj0.y;
                obj.xNeighborAverage = obj.xNeighborTotal/obj.neighborNum;
                obj.yNeighborAverage = obj.yNeighborTotal/obj.neighborNum;
                
                obj.vxNeighborTotal = obj.vxNeighborTotal + obj0.vx;
                obj.vyNeighborTotal = obj.vyNeighborTotal + obj0.vy;
                obj.vxNeighborAverage = obj.vxNeighborTotal/obj.neighborNum;
                obj.vyNeighborAverage = obj.vyNeighborTotal/obj.neighborNum;
                
                [obj.vNeighborAverage, obj.wNeighborAverage] = transb(obj.vxNeighborAverage, obj.vyNeighborAverage);
%                 obj.wNeighborAverage = atan(obj.vyNeighborAverage/obj.vxNeighborAverage);
            elseif (d>0)&&(d<obj.rb)
                obj.neighborSet(obj0.id, 1) = 2;
                obj.neighborSet(obj0.id, 2) = obj0.x;
                obj.neighborSet(obj0.id, 3) = obj0.y;
                obj.neighborSet(obj0.id, 4) = obj0.vx;
                obj.neighborSet(obj0.id, 5) = obj0.vy;
                
                obj.neighborNum = obj.neighborNum + 1;
                obj.xNeighborTotal = obj.xNeighborTotal + obj0.x;
                obj.yNeighborTotal = obj.yNeighborTotal + obj0.y;
                obj.xNeighborAverage = obj.xNeighborTotal/obj.neighborNum;
                obj.yNeighborAverage = obj.yNeighborTotal/obj.neighborNum;
                
                obj.vxNeighborTotal = obj.vxNeighborTotal + obj0.vx;
                obj.vyNeighborTotal = obj.vyNeighborTotal + obj0.vy;
                obj.vxNeighborAverage = obj.vxNeighborTotal/obj.neighborNum;
                obj.vyNeighborAverage = obj.vyNeighborTotal/obj.neighborNum; 
                
                [obj.vNeighborAverage, obj.wNeighborAverage] = transb(obj.vxNeighborAverage, obj.vyNeighborAverage);
%                 obj.wNeighborAverage = atan(obj.vyNeighborAverage/obj.vxNeighborAverage);
            end
        end
                
        function [vx1, vy1] = rule1(obj) %Äý¾ÛÏòÐÄÐÔ
            if (obj.xNeighborAverage ~= 0)&&(obj.yNeighborAverage ~= 0)
                vx1 = (obj.xNeighborAverage - obj.x)*obj.rule1Amp;
                vy1 = (obj.yNeighborAverage - obj.y)*obj.rule1Amp;

            else
                vx1 = 0;
                vy1 = 0;
            end
        end
        
        function [vx2, vy2] = rule2(obj) %ÅÅ³âÐÔ
            vx2 = 0;
            vy2 = 0;
            for i = 1:size(obj.neighborSet, 1)
                if(obj.neighborSet(i,1) == 2)
                    vx2 = vx2 + (obj.x - obj.neighborSet(i,2))*obj.rule2Amp;
                    vy2 = vy2 + (obj.y - obj.neighborSet(i,3))*obj.rule2Amp;
                end
            end
        end
        
        function [v3, w3] = rule3(obj) %ËÙ¶ÈÆ¥Åä
            if (obj.vxNeighborAverage ~= 0)&&(obj.vyNeighborAverage ~= 0)
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