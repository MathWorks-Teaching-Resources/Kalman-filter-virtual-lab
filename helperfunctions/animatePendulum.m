function animatePendulum(t, y_actual, y_measured, y_estimated, theta_initial)
[~, L, ~] = pendparams;
if isempty(y_estimated) && isempty(y_measured)
    y_estimated = zeros(length(y_actual),1);
    y_measured = zeros(length(y_actual),1);
    visibility = ["on","off","off"];
elseif isempty(y_estimated)
    y_estimated = zeros(length(y_actual),1);
    visibility = ["on","off","on"];
elseif isempty(y_measured)
    y_measured = zeros(length(y_actual),1);
    visibility = ["on","on","off"];
else
    visibility = ["on","on","on"];
end

clf
tiledlayout(2,1)           
nexttile 
hold on
g1 = plot(t,y_actual,'g',LineWidth = 1.5, Visible = visibility(1));
g2 = plot(t,y_estimated,'b',LineWidth = 1, Visible = visibility(2));
g3 = plot(t,y_measured,'r',LineWidth = 0.5, Visible = visibility(3));

axis([t(1) t(end) -abs(theta_initial)-10 abs(theta_initial)+10])
title('System Response')

% Convert from degrees to radians
y_actual_rad = deg2rad(y_actual);
y_estimated_rad = deg2rad(y_estimated);
y_measured_rad = deg2rad(y_measured);

hold off

xactual_rad = L*sin(y_actual_rad);
yactual_rad = -L*cos(y_actual_rad);

xK = L*sin(y_estimated_rad);
yK = -L*cos(y_estimated_rad);

xL =  L*sin(y_measured_rad);
yL = -L*cos(y_measured_rad);

hold on
h1 = plot(t(1),Marker=".",MarkerSize=20,Color="g");
k1 = plot(t(1),Marker=".",MarkerSize=20,Color="b");
l1 = plot(t(1),Marker=".",MarkerSize=20,Color="r");

xlabel("Time (sec)")
ylabel("Angular position (deg)")
leg = ["Pendulum response","Kalman Filter estimate","Measured response"];
ind = (visibility == "on");
leg(ind==0) = '';
legend(leg, Location='eastoutside');
hold off

nexttile
hold on;
h2 = plot([0,xactual_rad(1,1)],[0,yactual_rad(1,1)], ...
    Marker=".",MarkerSize=25,LineWidth=2,Color='green',Visible = visibility(1));

k2 = plot([0,xK(1,1)],[0,yK(1,1)], ...
    Marker=".",MarkerSize=20,LineWidth=2,Color='blue',Visible = visibility(2));

l2 = plot([0,xL(1,1)],[0,yL(1,1)], ...
    Marker=".",MarkerSize=20,LineWidth=2,Color='red',Visible = visibility(3));
hold off;
axis equal
axis([-1.2*L 1.2*L -1.2*L 0.2*L])
ht = title("Time: "+t(1)+" sec");   

for id = 1:length(t)
    set(h1,XData=t(id),YData=y_actual(id))
    set(h2,XData=[0,xactual_rad(id)],YData=[0,yactual_rad(id)],Visible = visibility(1))
        
    set(k1,XData=t(id),YData=y_estimated(id),Visible = visibility(2))
    set(k2,XData=xK(id),YData=yK(id))  
    
    set(l1,XData=t(id),YData=y_measured(id),Visible = visibility(3))
    set(l2,XData=xL(id),YData=yL(id))
        
    set(ht,String="Time: "+t(id)+" sec")
    
    drawnow
end

end

% Copyright 2022 The MathWorks, Inc.