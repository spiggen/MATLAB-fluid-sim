

% dvx_dx(:,2:end-1) = (...
%                     v_x_centered(:,2:end-1).*sign(v_x(:,2:end-1)).* ...
%                                      (is_fluid(:,1:end-2) - sign(v_x(:,2:end-1))  ~= -1).* ...
%                                      (is_fluid(:,3:end)   + sign(v_x(:,2:end-1))  ~= -1)...
%                   - v_x_centered(:,1:end-2).*(sign(v_x(:,2:end-1)) ==  1).*is_fluid(:,1:end-2) ...
%                   + v_x_centered(:,3:end  ).*(sign(v_x(:,2:end-1)) == -1).*is_fluid(:,3:end  ) ...
%                     )/dx;
% 
% dvx_dy(2:end-1,:) = (...
%                     v_x_centered(2:end-1,:).*sign(v_y(2:end-1,:)).* ...
%                                      (is_fluid(1:end-2,:) - sign(v_y(2:end-1,:))  ~= -1).* ...
%                                      (is_fluid(3:end,:)   + sign(v_y(2:end-1,:))  ~= -1)...
%                   - v_x_centered(1:end-2,:).*(sign(v_y(2:end-1,:)) ==  1).*is_fluid(1:end-2,:) ...
%                   + v_x_centered(3:end,:  ).*(sign(v_y(2:end-1,:)) == -1).*is_fluid(3:end,:  ) ...
%                     )/dy;
% dvy_dx(:,2:end-1) = (...
%                     v_y_centered(:,2:end-1).*sign(v_x(:,2:end-1)).* ...
%                                      (is_fluid(:,1:end-2) - sign(v_x(:,2:end-1))  ~= -1).* ...
%                                      (is_fluid(:,3:end)   + sign(v_x(:,2:end-1))  ~= -1)...
%                   - v_y_centered(:,1:end-2).*(sign(v_x(:,2:end-1)) ==  1).*is_fluid(:,1:end-2) ...
%                   + v_y_centered(:,3:end  ).*(sign(v_x(:,2:end-1)) == -1).*is_fluid(:,3:end  ) ...
%                     )/dx;
% 
% dvy_dy(2:end-1,:) = (...
%                     v_y_centered(2:end-1,:).*sign(v_y(2:end-1,:)).* ...
%                                      (is_fluid(1:end-2,:) - sign(v_y(2:end-1,:))  ~= -1).* ...
%                                      (is_fluid(3:end,:)   + sign(v_y(2:end-1,:))  ~= -1)...
%                   - v_y_centered(1:end-2,:).*(sign(v_y(2:end-1,:)) ==  1).*is_fluid(1:end-2,:) ...
%                   + v_y_centered(3:end,:  ).*(sign(v_y(2:end-1,:)) == -1).*is_fluid(3:end,:  ) ...
%                     )/dy;
% 
% 
% 
% 
% 
% 
% ds_dx(:,2:end-1) = (...
%                     smoke(:,2:end-1).*sign(v_x(:,2:end-1)).* ...
%                                      (is_fluid(:,1:end-2) - sign(v_x(:,2:end-1))  ~= -1).* ...
%                                      (is_fluid(:,3:end)   + sign(v_x(:,2:end-1))  ~= -1)...
%                   - smoke(:,1:end-2).*(sign(v_x(:,2:end-1)) ==  1).*is_fluid(:,1:end-2) ...
%                   + smoke(:,3:end  ).*(sign(v_x(:,2:end-1)) == -1).*is_fluid(:,3:end  ) ...
%                     )/dx;
% 
% ds_dy(2:end-1,:) = (...
%                     smoke(2:end-1,:).*sign(v_y(2:end-1,:)).* ...
%                                      (is_fluid(1:end-2,:) - sign(v_y(2:end-1,:))  ~= -1).* ...
%                                      (is_fluid(3:end,:)   + sign(v_y(2:end-1,:))  ~= -1)...
%                   - smoke(1:end-2,:).*(sign(v_y(2:end-1,:)) ==  1).*is_fluid(1:end-2,:) ...
%                   + smoke(3:end,:  ).*(sign(v_y(2:end-1,:)) == -1).*is_fluid(3:end,:  ) ...
%                     )/dy(1:4:end,1:4:end,:);

dvx_dy(3:end-2,:) = ((v_x_centered(5:end  ,:)*w2  ...
                    + v_x_centered(4:end-1,:)*w1)   ...
                    -(v_x_centered(2:end-3,:)*w1  ...
                    + v_x_centered(1:end-4,:)*w2) )./dy;

dvx_dx(:,3:end-2) = ((v_x_centered(:,5:end  )*w2  ...
                    + v_x_centered(:,4:end-1)*w1)   ...
                    -(v_x_centered(:,2:end-3)*w1  ...
                    + v_x_centered(:,1:end-4)*w2) )./dx;

dvy_dy(3:end-2,:) = ((v_y_centered(5:end  ,:)*w2  ...
                    + v_y_centered(4:end-1,:)*w1)   ...
                    -(v_y_centered(2:end-3,:)*w1  ...
                    + v_y_centered(1:end-4,:)*w2) )./dy;

dvy_dx(:,3:end-2) = ((v_y_centered(:,5:end  )*w2  ...
                    + v_y_centered(:,4:end-1)*w1)   ...
                    -(v_y_centered(:,2:end-3)*w1  ...
                    + v_y_centered(:,1:end-4)*w2) )./dx;



ds_dy(3:end-2,:) = ((smoke(5:end  ,:)*w2  ...
                   + smoke(4:end-1,:)*w1)   ...
                   -(smoke(2:end-3,:)*w1  ...
                   + smoke(1:end-4,:)*w2) )./dy;

ds_dx(:,3:end-2) = ((smoke(:,5:end  )*w2  ...
                   + smoke(:,4:end-1)*w1)   ...
                   -(smoke(:,2:end-3)*w1  ...
                   + smoke(:,1:end-4)*w2) )./dx;


v_x_centered   = (v_x_centered - (dvx_dx.*v_x_centered.*dt + dvx_dy.*v_y_centered.*dt)).*is_fluid;
v_y_centered   = (v_y_centered - (dvy_dx.*v_x_centered.*dt + dvy_dy.*v_y_centered.*dt)).*is_fluid;
smoke          = (smoke        - (ds_dx .*v_x_centered.*dt + ds_dy .*v_y_centered.*dt)).*is_fluid;




