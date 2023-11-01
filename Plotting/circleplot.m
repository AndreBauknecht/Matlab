function circleplot(x,y,z,r,width,color)
%circle(x,y,z,r)
%x, y and z are the coordinates of the center of the circle
%r is the radius of the circle in the horizontal direction
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
% width and color are strings containing the drawing options for the circle
% e.g. width=2 and color= 'r'
if ~isempty(z)
    ang=0:0.01:2*pi; 
    z=z*ones(size(ang,2),1);
    xp=r*cos(ang);
    yp=r*sin(ang);
    plot3(x+xp,y+yp,z,'LineWidth',width,'Color',color);
else %2D
    ang=0:0.01:2*pi; 
    xp=r*cos(ang);
    yp=r*sin(ang);
    plot(x+xp,y+yp,'LineWidth',width,'Color',color);
end

end