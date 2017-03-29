%% AxesDimensions.m

figure(1);


p1=makePaddle([-90 0]);

x=([p1.position(1)-p1.size(1)/2,p1.position(1)-p1.size(1)/2,...
    p1.position(1)+p1.size(1)/2,p1.position(1)+p1.size(1)/2]);

y=([p1.position(2)-p1.size(2)/2,p1.position(2)+p1.size(2)/2,...
    p1.position(2)+p1.size(2)/2,p1.position(2)-p1.size(2)/2]);

patch(x,y,'white');

axis([-100 100 -100 100])

disp(p1.position)
disp(p1.size)
