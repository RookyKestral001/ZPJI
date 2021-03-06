classdef Uno < handle
    properties
        disAmp = 3;
        veloAmp = 4;
        
        radiAmp = 3;
        radiColiAmp = 1;
        
        rule1Amp = 0.2; %凝聚
        rule2Amp = 0.6; %排斥
        rule3Amp = 0.4; %速度匹配
        rule4Amp = 0;   %朝指定方向
        
        levelUpRadiAmp = 2;
        levelUpRuleAmp = 2;
        
        id
        x
        y
        vx 
        vy 
        r
        rb
        rank
        
        v
        w
        
%         xDest = 10;
%         yDest = 10;
%         vxDest = 3; 
%         vyDest = 3; 
        isLid = 0;
        
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
        function obj = Uno(id0, x0, y0, vx0, vy0, r0, rb0,rank0)
            if nargin == 0
                obj.id = 0;
                obj.x = rand*obj.disAmp;
                obj.y = rand*obj.disAmp;
                obj.vx = rand*obj.veloAmp;
                obj.vy = rand*obj.veloAmp;
                obj.r = 1*obj.radiAmp;
                obj.rb = 1*obj.radiColiAmp;
                obj.rank = 1;
            elseif nargin == 1
                obj.id = id0;
                obj.x = rand*obj.disAmp;
                obj.y = rand*obj.disAmp;
                obj.vx = rand*obj.veloAmp;
                obj.vy = rand*obj.veloAmp;
                obj.r = 1*obj.radiAmp;
                obj.rb = 1*obj.radiColiAmp;
                obj.rank = 1;
            elseif nargin == 7
                obj.id = id0;
                obj.x = x0;
                obj.y = y0;
                obj.vx = vx0;
                obj.vy = vy0;
                obj.r = r0;
                obj.rb = rb0;
                obj.rank = rank0;
            else
                error('wrong input arguments');
            end
            
            [obj.v, obj.w] = transb(obj.vx, obj.vy);
%             obj.v = sqrt(obj.vx^2 + obj.vy^2);
%             obj.w = atan(obj.vy/obj.vx);
        end
        
        function isNeighbor(obj, obj0) %1：邻居 2：碰撞风险 3：自己            
            d = sqrt((obj.x - obj0.x)^2 + (obj.y - obj0.y)^2);
            if (d>obj.rb)&&(d<obj.r)
                obj.neighborSet(obj0.id, 1) = 1;
                obj.neighborSet(obj0.id, 2) = obj0.x;
                obj.neighborSet(obj0.id, 3) = obj0.y;                
                obj.neighborSet(obj0.id, 4) = obj0.vx;
                obj.neighborSet(obj0.id, 5) = obj0.vy;
                obj.neighborSet(obj0.id, 6) = obj0.rank;
                
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
                obj.neighborSet(obj0.id, 6) = obj0.rank;
                
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
            elseif d == 0
                obj.neighborSet(obj0.id, 1) = 9;
                obj.neighborSet(obj0.id, 2) = obj0.x;
                obj.neighborSet(obj0.id, 3) = obj0.y;
                obj.neighborSet(obj0.id, 4) = obj0.vx;
                obj.neighborSet(obj0.id, 5) = obj0.vy;
                obj.neighborSet(obj0.id, 6) = obj0.rank;
            end
        end
        
        function isLiderazgo(obj)
            xflag = 0;
            yflag = 0;
            xmid = median(obj.neighborSet(:, 2));
            ymid = median(obj.neighborSet(:, 3));
            
            for i = 1:(obj.neighborNum + 1)
                if obj.x == xmid
                    xflag = i;
                end
                if obj.y == ymid
                    yflag = i;
                end
            end
            
            if (xflag == yflag)&&(xflag ~= 0)
                obj.isLid = 1;
            else
                obj.isLid = 0;
            end
        end
                
        function levelUp(obj)
            obj.radiAmp = obj.radiAmp * obj.levelUpRadiAmp;
            obj.radiColiAmp = obj.radiColiAmp;
            
            obj.rank = 2;
            
            obj.rule1Amp = obj.rule1Amp / obj.levelUpRuleAmp; %凝聚
            obj.rule2Amp = obj.rule2Amp; %排斥
            obj.rule3Amp = obj.rule3Amp / obj.levelUpRuleAmp; %速度匹配
            obj.rule4Amp = obj.rule4Amp;   %朝指定方向
        end
        
        function levelDown(obj)
            obj.radiAmp = obj.radiAmp / obj.levelUpRadiAmp;
            obj.radiColiAmp = obj.radiColiAmp;
            
            obj.rank = 1;
            
            obj.rule1Amp = obj.rule1Amp * obj.levelUpRuleAmp; %凝聚
            obj.rule2Amp = obj.rule2Amp; %排斥
            obj.rule3Amp = obj.rule3Amp * obj.levelUpRuleAmp; %速度匹配
            obj.rule4Amp = obj.rule4Amp;   %朝指定方向
        end
        
        function [vx1, vy1] = rule1(obj) %凝聚向心性
            if (obj.xNeighborAverage ~= 0)&&(obj.yNeighborAverage ~= 0)
                vx1 = (obj.xNeighborAverage - obj.x)*obj.rule1Amp;
                vy1 = (obj.yNeighborAverage - obj.y)*obj.rule1Amp;

            else
                vx1 = 0;
                vy1 = 0;
            end
        end
        
        function [vx2, vy2] = rule2(obj) %排斥性
            vx2 = 0;
            vy2 = 0;

            for i = 1:size(obj.neighborSet, 1)
                if(obj.neighborSet(i,1) == 2)
%                     vx2 = vx2 + (obj.x - obj.neighborSet(i,2))*obj.rule2Amp;
%                     vy2 = vy2 + (obj.y - obj.neighborSet(i,3))*obj.rule2Amp;
                      signx = sign(obj.x - obj.neighborSet(i,2));
                      signy = sign(obj.y - obj.neighborSet(i,3));
                      absx = abs(obj.x - obj.neighborSet(i,2));
                      absy = abs(obj.y - obj.neighborSet(i,3));
                      d2 = sqrt(absx^2 + absy^2);
                      if(d2 < obj.rb)
                          sin2 = absy/d2;
                          cos2 = absx/d2;
                          vx2 = vx2 + signx*abs(absx - obj.rb*cos2)*obj.rule2Amp;
                          vy2 = vy2 + signy*abs(absy - obj.rb*sin2)*obj.rule2Amp;
                      end                          
                end
            end
        end
        
%         function [v3, w3] = rule3(obj) %速度匹配(根据位置调整速度方向角）
%             if (obj.vxNeighborAverage ~= 0)&&(obj.vyNeighborAverage ~= 0)
% %                 averNorm = sqrt((obj.vNeighborAverage)^2 + (obj.wNeighborAverage)^2);
% %                 vAverDire = obj.vNeighborAverage/averNorm;
% %                 wAverDire = obj.wNeighborAverage/averNorm;
% %                 uavNorm = sqrt((obj.v)^2 + (obj.w)^2);
% %                 vDire = obj.v/uavNorm;
% %                 wDire = obj.w/uavNorm;
% %                 v3 = (obj.vNeighborAverage - obj.v)/obj.rule3Amp;
%                 v3 = 0;
%                 w3 = (obj.wNeighborAverage - obj.w)*obj.rule3Amp;
% 
%             else
%                 v3 = 0;
%                 w3 = 0;
%             end
%         end

        function [vx3, vy3] = rule3(obj)%速度匹配（根据速度调整速度）
            vx3 = 0;
            vy3 = 0;

            for i = 1:size(obj.neighborSet, 1)
                if(obj.neighborSet(i,1) == 1)
                    vx3diff = obj.neighborSet(i,4) - obj.vx;
                    vy3diff = obj.neighborSet(i,5) - obj.vy;
                    
                    absx = abs(obj.x - obj.neighborSet(i,2));
                    absy = abs(obj.y - obj.neighborSet(i,3));
                    d3 = sqrt(absx^2 + absy^2);
                    vx3align = obj.rule3Amp * vx3diff/(d3^2);
                    vy3align = obj.rule3Amp * vy3diff/(d3^2);
                    
                    vx3 = vx3 + vx3align;
                    vy3 = vy3 + vy3align;
                end
            end
        end
        
        function [v4, w4] = rule4(obj, targ) %朝目标方向
            v4 = 0;
            wm = atan((targ.y - obj.y)/(targ.x - obj.x));
            w4 = (wm - obj.w)*obj.rule4Amp;
        end

    end
end