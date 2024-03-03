[x_mesh, y_mesh] = meshgrid(x_vec,y_vec);

dx = abs(x_mesh(1,2) - x_mesh(1,1));
dy = abs(y_mesh(2,1) - y_mesh(1,1));


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
delta_vx = zeros(size(v_x));
delta_vy = zeros(size(v_y));






neighbors_x = zeros(size(is_fluid));
neighbors_x(:,1:end-1) = neighbors_x(:,1:end-1) + is_fluid(:,2:end);
neighbors_x(:,2:end)   = neighbors_x(:,2:end)   + is_fluid(:,1:end-1);

neighbors_y = zeros(size(is_fluid));
neighbors_y(1:end-1,:) = neighbors_y(1:end-1,:) + is_fluid(2:end,:);
neighbors_y(2:end,:)   = neighbors_y(2:end,:)   + is_fluid(1:end-1,:);

neighbors = neighbors_x + neighbors_y;

clear neighbors_x neighbors_y



%% Slap a gpu on dat bitch



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



dvx_dx = gpuArray(dvx_dx);
dvx_dy = gpuArray(dvx_dy);
dvy_dx = gpuArray(dvy_dx);
dvy_dy = gpuArray(dvy_dy);

d2vx_dy = gpuArray(d2vx_dy);
d2vy_dx = gpuArray(d2vy_dx);



div_vx = gpuArray(div_vx);
div_vy = gpuArray(div_vy);
delta_vx = gpuArray(delta_vx);
delta_vy = gpuArray(delta_vy);




smoke = gpuArray(smoke);
ds_dx = gpuArray(ds_dx);
ds_dy = gpuArray(ds_dy);



neighbors = gpuArray(neighbors);


