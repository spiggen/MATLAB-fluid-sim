

for i = 1:40

div_vx(:,1:end-1) = - v_x(:,1:end-1) ...
                    + v_x(:,2:end  );

div_vy(1:end-1,:) = - v_y(1:end-1,:) ...
                    + v_y(2:end,:  );


div_v(:,:) = (div_vx + div_vy ).*...
             (1 + (not_blocked_x + not_blocked_y - 2*is_fluid))./...
             (neighbors + (neighbors == 0));



div_v(1,  :) = 0;
div_v(end,:) = 0;
div_v(:,  1) = 0;
div_v(:,end) = 0;

delta_vx(:,2:end) =    div_v(:,2:end  ) ...
                     - div_v(:,1:end-1);

delta_vy(2:end,:) =    div_v(2:end,:  ) ...
                     - div_v(1:end-1,:);



v_x = (v_x + delta_vx*0.42).*not_blocked_x;
v_y = (v_y + delta_vy*0.42).*not_blocked_y;


end


