classdef Flock < handle
    properties
        xMass
        yMass
        n
        uavs
        A
    end
    
    methods
        function obj = Flock(n0)
            obj.n = n0;
            for i = 1:obj.n
                obj.addUAV(Uno(i));
            end
        end
        
        function addUAV(obj, uavObj)
            obj.uavs = [obj.uavs, uavObj];
        end
        
        function drawUAVs(obj)
            for i = 1:obj.n
                hold on
                plot(obj.uavs(i).x, obj.uavs(i).y, '.');
            end
            %画出目标点
            hold on
            plot(obj.uavs(i).xDest, obj.uavs(i).yDest, 'h'), xlabel('x'), ylabel('y'), title('Process');
            %画出速度矢量
            for i = 1:obj.n
                hold on
                vx = obj.uavs(i).v*cos(obj.uavs(i).w);
                vy = obj.uavs(i).v*sin(obj.uavs(i).w);
                quiver(obj.uavs(i).x, obj.uavs(i).y, vx, vy, 0.1);
            end
        end
        
        function drawLinks(obj)
            for i = 1:obj.n
                obj.uavs(i).neighborSet = zeros(obj.n, 5);
                obj.uavs(i).neighborNum = 0;
                obj.uavs(i).xNeighborTotal = 0;
                obj.uavs(i).yNeighborTotal = 0;        
                obj.uavs(i).xNeighborAverage = 0;
                obj.uavs(i).yNeighborAverage = 0;
                for j = 1:obj.n
                    obj.uavs(i).isNeighbor(obj.uavs(j));
                    if obj.uavs(i).neighborSet(j, 1) == 1
                        s = [obj.uavs(i).x, obj.uavs(j).x];
                        h = [obj.uavs(i).y, obj.uavs(j).y];
                        hold on
                        plot(s, h, 'g-');
                    elseif obj.uavs(i).neighborSet(j, 1) == 2;
                        s = [obj.uavs(i).x, obj.uavs(j).x];
                        h = [obj.uavs(i).y, obj.uavs(j).y];
                        hold on
                        plot(s, h, 'r-');
                    end
                end
            end
        end
        
%         function buildMatrix()
%             A = zeros(n,10)
%             
%         end
       
        function updateAll(obj)
            for i = 1:obj.n
                [v1, w1] = obj.uavs(i).rule1(); %rule1
                [v2, w2] = obj.uavs(i).rule2(); %rule2
                [v3, w3] = obj.uavs(i).rule3(); %rule3
                
                [vx1, vy1] = transa(v1, w1);
                [vx2, vy2] = transa(v2, w2);
                
                [vxi, vyi] = transa(obj.uavs(i).v, obj.uavs(i).w);
                
                vxi = vxi + vx1 + vx2;
                vyi = vyi + vy1 + vy2;
                
                [vi, wi] = transb(vxi, vyi);
                wi = wi + w3;
                [vxi, vyi] = transa(vi, wi);
                
                obj.uavs(i).x = obj.uavs(i).x + vxi;
                obj.uavs(i).y = obj.uavs(i).y + vyi;
            end
            
            obj.uavs(i).xDest = obj.uavs(i).xDest + obj.uavs(i).vxDest;
            obj.uavs(i).yDest = obj.uavs(i).yDest + obj.uavs(i).vyDest;
        end
        
        function calcMass(obj)
            for i = 1:obj.n
               obj.xMass = obj.xMass + obj.uavs(i).x;
               obj.yMass = obj.yMass + obj.uavs(i).y;
            end
        end
        
    end
end