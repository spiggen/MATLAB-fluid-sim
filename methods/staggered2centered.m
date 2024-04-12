v_x_centered(:,1:end-1) = (v_x(:,2:end) + v_x(:,1:end-1)).*is_fluid(:,1:end-1)*0.5;
v_x_centered(:,end) = v_x(:,end);

v_y_centered(1:end-1,:) = (v_y(2:end,:) + v_y(1:end-1,:)).*is_fluid(1:end-1,:)*0.5;
v_y_centered(end,:) = v_y(end,:);