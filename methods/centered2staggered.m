v_x(:,2:end) = (v_x_centered(:,1:end-1) + v_x_centered(:,2:end)).*is_fluid(:,2:end).*is_fluid(:,1:end-1)./2;
v_x(:,1)     =  v_x_centered(:,1);

v_y(2:end,:) = (v_y_centered(1:end-1,:) + v_y_centered(2:end,:)).*is_fluid(2:end,:).*is_fluid(1:end-1,:)./2;
v_y(1,:)     =  v_y_centered(1,:);