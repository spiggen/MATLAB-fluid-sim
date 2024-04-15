%% All of this is basically just a bunch of pre-allocation

[x_mesh, y_mesh] = meshgrid(x_vec,y_vec);

dx = abs(x_mesh(1,2) - x_mesh(1,1));
dy = abs(y_mesh(2,1) - y_mesh(1,1));

w1 = 0.4;
w2 = 0.6;

v_x = zeros(size(x_mesh));
v_y = zeros(size(y_mesh));



a_x = zeros(size(x_mesh));
a_y = zeros(size(y_mesh));



v_x_centered = zeros(size(v_x));
v_y_centered = zeros(size(v_y));


viscosity_constant = 1.85*10^-5;
density = 1;


not_blocked_x = is_fluid;
not_blocked_x(:,2:end) = relu(not_blocked_x(:,2:end) + not_blocked_x(:,1:end-1),1);
not_locked_x = is_fluid;
not_locked_x(:,2:end-1) = not_locked_x(:,2:end-1).*...
                          not_locked_x(:,1:end-2).*...
                          not_locked_x(:,3:end);


not_blocked_y = is_fluid;
not_blocked_y(2:end,:) = relu(not_blocked_y(2:end,:) + not_blocked_y(1:end-1,:),1);
not_locked_y = is_fluid;
not_locked_y(2:end-1,:) = not_locked_y(2:end-1,:).*...
                          not_locked_y(1:end-2,:).*...
                          not_locked_y(3:end,:);


left_border = is_fluid;
left_border(:,1:end-1) = (left_border(:,1:end-1) - left_border(:,2:end));
left_border = abs(left_border.*(~is_fluid));
left_border(:,1)   = 0;
left_border(:,end) = 0;

right_border = is_fluid;
right_border(:,2:end) = (right_border(:,1:end-1) - right_border(:,2:end));
right_border = abs(right_border.*(~is_fluid));
right_border(:,1)   = 0;
right_border(:,end) = 0;

bottom_border = is_fluid;
bottom_border(1:end-1,:) = (bottom_border(1:end-1,:) - bottom_border(2:end,:));
bottom_border = abs(bottom_border.*(~is_fluid));
bottom_border(1,:)   = 0;
bottom_border(end,:) = 0;

top_border = is_fluid;
top_border(2:end,:) = (top_border(1:end-1,:) - top_border(2:end,:));
top_border = abs(top_border.*(~is_fluid));
top_border(1,:)   = 0;
top_border(end,:) = 0;


smoke = zeros(size(x_mesh));
ds_dx = zeros(size(smoke));
ds_dy = zeros(size(smoke));



dvx_dx = zeros(size(v_x));
dvx_dy = zeros(size(v_x));
dvy_dx = zeros(size(v_y));
dvy_dy = zeros(size(v_y));

d2vx_dy = zeros(size(v_x));
d2vy_dx = zeros(size(v_y));


div_vx = zeros(size(v_x));
div_vy = zeros(size(v_y));
div_v  = zeros(size(v_x));
delta_vx = zeros(size(v_x));
delta_vy = zeros(size(v_y));

inflow_x = zeros(size(v_x));
inflow_y = zeros(size(v_y));
inflow   = zeros(size(v_x));


neighbors_x = zeros(size(is_fluid));
neighbors_x(:,1:end-1) = neighbors_x(:,1:end-1) + is_fluid(:,2:end);
neighbors_x(:,2:end)   = neighbors_x(:,2:end)   + is_fluid(:,1:end-1);

neighbors_y = zeros(size(is_fluid));
neighbors_y(1:end-1,:) = neighbors_y(1:end-1,:) + is_fluid(2:end,:);
neighbors_y(2:end,:)   = neighbors_y(2:end,:)   + is_fluid(1:end-1,:);

neighbors = neighbors_x + neighbors_y;

clear neighbors_x neighbors_y



%% Slap a gpu on dat bitch

if gpuDeviceCount > 0 && using_gpu

v_x           = gpuArray(v_x);
v_y           = gpuArray(v_y);

a_x           = gpuArray(a_x);
a_y           = gpuArray(a_y);

delta_vx      = gpuArray(delta_vx);
delta_vy      = gpuArray(delta_vy);

v_x_centered  = gpuArray(v_x_centered);
v_y_centered  = gpuArray(v_y_centered);


is_fluid      = gpuArray(is_fluid);
not_blocked_x = gpuArray(not_blocked_x);
not_blocked_y = gpuArray(not_blocked_y);
not_locked_x  = gpuArray(not_locked_x);
not_locked_y  = gpuArray(not_locked_y);

right_border  = gpuArray(right_border);
left_border   = gpuArray(left_border);
top_border    = gpuArray(top_border);
bottom_border = gpuArray(bottom_border);


dvx_dx = gpuArray(dvx_dx);
dvx_dy = gpuArray(dvx_dy);
dvy_dx = gpuArray(dvy_dx);
dvy_dy = gpuArray(dvy_dy);

d2vx_dy = gpuArray(d2vx_dy);
d2vy_dx = gpuArray(d2vy_dx);



div_vx = gpuArray(div_vx);
div_vy = gpuArray(div_vy);
div_v  = gpuArray(div_v);
delta_vx = gpuArray(delta_vx);
delta_vy = gpuArray(delta_vy);

inflow_x = gpuArray(inflow_x);
inflow_y = gpuArray(inflow_y);
inflow   = gpuArray(inflow);


smoke = gpuArray(smoke);
ds_dx = gpuArray(ds_dx);
ds_dy = gpuArray(ds_dy);



neighbors = gpuArray(neighbors);

end
