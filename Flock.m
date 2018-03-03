classdef Flock < handle
    properties
        xMass
        yMass
        n
        uavs
        A
        dock
        time
        coheMat
        coheVal
        
        target
    end
    
    methods
        function obj = Flock(n0)
            obj.time = 1;
            obj.n = n0;
            for i = 1:obj.n
                obj.addUAV(Uno(i));
            end
            %生成目标
            obj.target = Objetivo(30, 30, 0, 0);
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
%             plot(obj.uavs(i).xDest, obj.uavs(i).yDest, 'h'), xlabel('x'), ylabel('y'), title('Process');
            plot(obj.target.x, obj.target.y, 'h'), xlabel('x'), ylabel('y'), title('Process');
            %画出速度矢量
            for i = 1:obj.n
                hold on
                quiver(obj.uavs(i).x, obj.uavs(i).y, obj.uavs(i).vx, obj.uavs(i).vy, 0.1);
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
                obj.uavs(i).vxNeighborTotal = 0;
                obj.uavs(i).vyNeighborTotal = 0;        
                obj.uavs(i).vxNeighborAverage = 0;
                obj.uavs(i).vyNeighborAverage = 0;
                
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
                
                if obj.uavs(i).rank == 2
                    obj.uavs(i).levelDown();
                end

                obj.uavs(i).isLiderazgo();
                
                if obj.uavs(i).isLid == 1
                    obj.uavs(i).levelUp();
                    plot(obj.uavs(i).x, obj.uavs(i).y, 'o');
                end
            end
        end
        
        function saveAll(obj)
%           dock保存内容：[time id]对应的[x y]
            for i = 1:obj.n
                obj.dock(obj.time, i, 1) = obj.uavs(i).x;
                obj.dock(obj.time, i, 2) = obj.uavs(i).y;
                obj.dock(obj.time, i, 3) = obj.uavs(i).vx;
                obj.dock(obj.time, i, 4) = obj.uavs(i).vy;
                
            end
            obj.time = obj.time + 1;
        end
        
        function drawTraj(obj)
            [len1, len2, len3] = size(obj.dock); %[时间，id，信息]
            for i = 1:len2
                plot(obj.dock(:, i, 1), obj.dock(:, i, 2));
            end
        end
%         function buildMatrix()
%             A = zeros(n,10)
%             
%         end
        function coherenceCal(obj)
            [len1, len2, len3] = size(obj.dock);
            for i = 1:len1 %时刻t
                obj.coheVal(i) = 0;
                for j = 1:len2 %飞机j
                    for k = 1:len2 %飞机k
                        if k ~= j
                            vxj = obj.dock(i, j, 3);
                            vyj = obj.dock(i, j, 4);
                            vxk = obj.dock(i, k, 3);
                            vyk = obj.dock(i, k, 4);
                            vjAbs = sqrt(vxj^2 + vyj^2);
                            vkAbs = sqrt(vxk^2 + vyk^2);
                            obj.coheMat(i,j,k) = (vxj*vxk + vyj*vyk)/(vjAbs*vkAbs);
                        else
                            obj.coheMat(i,j,k) = 0;
                        end
                        
                        obj.coheVal(i) = obj.coheVal(i) + obj.coheMat(i,j,k);
                    end
                end
                obj.coheVal(i) = obj.coheVal(i)/(len2*(len2 - 1));
            end            
            plot(obj.coheVal);
        end
        
        function updateAll(obj)
            for i = 1:obj.n
                [vx1, vy1] = obj.uavs(i).rule1(); %rule1
                [vx2, vy2] = obj.uavs(i).rule2(); %rule2
                [vx3, vy3] = obj.uavs(i).rule3(); %rule3

                
                
                obj.uavs(i).vx = obj.uavs(i).vx + vx1 + vx2 + vx3;
                obj.uavs(i).vy = obj.uavs(i).vy + vy1 + vy2 + vy3;

                
%                 [obj.uavs(i).v, obj.uavs(i).w] = transb(obj.uavs(i).vx, obj.uavs(i).vy);
% 
%                 [v3, w3] = obj.uavs(i).rule3(); %rule3
%                 obj.uavs(i).w = obj.uavs(i).w + w3;
%                 
%                 [v4, w4] = obj.uavs(i).rule4(obj.target); %rule4
%                 obj.uavs(i).w = obj.uavs(i).w + w4;
%                 [obj.uavs(i).vx, obj.uavs(i).vy] = transa(obj.uavs(i).v, obj.uavs(i).w);
                
                obj.uavs(i).x = obj.uavs(i).x + obj.uavs(i).vx;
                obj.uavs(i).y = obj.uavs(i).y + obj.uavs(i).vy;
            end
            
%             obj.uavs(i).xDest = obj.uavs(i).xDest + obj.uavs(i).vxDest;
%             obj.uavs(i).yDest = obj.uavs(i).yDest + obj.uavs(i).vyDest;
        end
        
        function calcMass(obj)
            for i = 1:obj.n
               obj.xMass = obj.xMass + obj.uavs(i).x;
               obj.yMass = obj.yMass + obj.uavs(i).y;
            end
        end
        
    end
end