function x_next = pipe_motion_model(x, u, w_control, w_additive, dt, R)

delta_theta = ((u(1)+w_control(1))*dt*sin(x(2)))/R;
delta_phi =  (u(2)+w_control(2))*dt;
delta_z = ((u(1)+w_control(1))*dt*cos(x(2)));

x_next = x+[delta_theta; delta_phi; delta_z] + w_additive;

end