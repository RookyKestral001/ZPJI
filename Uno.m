classdef Uno < handle
    properties
        disAmp = 1.7;
        veloAmp = 4;
        radiAmp = 5;
        
        rule1Amp = 0.5;
        rule2Amp = 2;
        rule3Amp = 1000;
        
        id
        x
        y
        v
        w
        r
        rb
        
        xDest = 10;
        yDest = 10;
        vDest = 3;
        wDest = 3;
        
        neighborSet
        neighborNum = 0;
        xNeighborTotal = 0;
        yNeighborTotal = 0;
        xNeighborAverage = 0;
        yNeighborAverage = 0;
        
        vNeighborTotal = 0;
        wNeighborTotal = 0;
        vNeighborAverage = 0;
        wNeighborAverage = 0;
    end
    
    methods
        function obj = Uno(id0, x0, y0, v0, w0, r0, rb0)
            if nargin == 0
                obj.id = 0;
                obj.x = rand*obj.disAmp;
                obj.y = rand*obj.disAmp;
                obj.v = rand*obj.veloAmp;
                obj.w = rand*obj.veloAmp;
                obj.r = 1*obj.radiAmp;
                obj.rb = 1;
            elseif nargin == 1
                obj.id = id0;
                obj.x = rand*obj.disAmp;
                obj.y = rand*obj.disAmp;
                obj.v = rand*obj.veloAmp;
                obj.w = rand*obj.veloAmp;
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
%             obj.wDest = 3;
%             obj.neighborNum = 0;
%             obj.xNeighborTotal = 0;
%             obj.yNeighborTotal = 0;
%             obj.xNeighborAverage = 0;
%             obj.yNeighborAverage = 0;
        end
        
        function isNeighbor(obj, obj0) %1£ºÁÚ¾Ó 2£ºÅö×²·çÏÕ
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
                
        function [v1, w1] = rule1(obj) %Äý¾ÛÏòÐÄÐÔ
            if (obj.xNeighborAverage ~= 0)&&(obj.yNeighborAverage ~= 0)
                v1 = (obj.xNeighborAverage - obj.x)/obj.rule1Amp;
                w1 = (obj.yNeighborAverage - obj.y)/obj.rule1Amp;
            else
                v1 = 0;
                w1 = 0;
            end
        end
        
        function [v2, w2] = rule2(obj) %ÅÅ³âÐÔ
            v2 = 0;
            w2 = 0;
            for i = 1:size(obj.neighborSet, 1)
                if(obj.neighborSet(i,1) == 2)
                    v2 = v2 + (obj.x - obj.neighborSet(i,2))/obj.rule2Amp;
                    w2 = w2 + (obj.y - obj.neighborSet(i,3))/obj.rule2Amp;
                end
            end
        end
        
        function [v3, w3] = rule3(obj) %ËÙ¶ÈÆ¥Åä
            if (obj.vNeighborAverage ~= 0)&&(obj.wNeighborAverage ~= 0)
                v3 = (obj.vNeighborAverage - obj.v)/obj.rule3Amp;
                w3 = (obj.wNeighborAverage - obj.w)/obj.rule3Amp;
            else
                v3 = 0;
                w3 = 0;
            end
        end
    end
end