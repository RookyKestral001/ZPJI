function [v, w] = transb(vx, vy)
v = sqrt(vx^2 + vy^2);
w = atan(vy/vx);
end