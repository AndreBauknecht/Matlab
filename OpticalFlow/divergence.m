function [div]=divergence(Vx, Vy)

% Vx = imfilter(Vx, [1 1 1 1 1]'*[1 1 1 1 1]/25,'symmetric');
% Vy = imfilter(Vy, [1 1 1 1 1]'*[1,1 1 1,1]/25,'symmetric');

dx=1;
D = [0, -1, 0; 0,0,0; 0,1,0]/2; %%% partial derivative 
Vx_x = imfilter(Vx, D'/dx, 'symmetric',  'same'); 
Vy_y = imfilter(Vy, D/dx, 'symmetric',  'same');
div=Vx_x+Vy_y;

