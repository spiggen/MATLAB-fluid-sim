% v_x(:,2:end  ) = v_x(:,2:end  ) -1.2*v_x(:,1:end-1).* right_border(:,2:end  );
% v_x(:,1:end-1) = v_x(:,1:end-1) -1.2*v_x(:,2:end  ).*  left_border(:,1:end-1);
% v_y(2:end,:  ) = v_y(2:end,:  ) -1.2*v_y(1:end-1,:).*   top_border(2:end,:  );
% v_y(1:end-1,:) = v_y(1:end-1,:) -1.2*v_y(2:end,:  ).*bottom_border(1:end-1,:);
% 
div_v(:,:) = 0;
for i = 1:30


div_vx(:,1:end-1) = - v_x(:,1:end-1) ...
                    + v_x(:,2:end  );

div_vy(1:end-1,:) = - v_y(1:end-1,:) ...
                    + v_y(2:end,:  );


div_v(:,:) = div_v*0.99 + is_fluid.*(div_vx + div_vy )./...
             (neighbors + (neighbors == 0));




div_v(1:2,  :)     = 0;
div_v(end-1:end,:) = 0;
div_v(:,  1:2)     = 0;
div_v(:,end-1:end) = 0;




delta_vx(:,2:end) =    div_v(:,2:end  ) ...
                     - div_v(:,1:end-1);

delta_vy(2:end,:) =    div_v(2:end,:  ) ...
                     - div_v(1:end-1,:);


v_x(:,:) = (v_x + delta_vx*0.3).*is_fluid;
v_y(:,:) = (v_y + delta_vy*0.3).*is_fluid;
end

%v_x = v_x.*is_fluid;
%v_y = v_y.*is_fluid;




