
mypath = erase(mfilename("fullpath"), "main");
addpath(mypath+"models")
warning("off") % New favourite command



%% video-stuff
writing_video = false;

if writing_video
video_index = 1;
while true
if ~isfile(mypath+"video"+string(video_index)+".mp4"); break ;end
video_index = video_index +1;
end

videoObj = VideoWriter(mypath+"video"+string(video_index)+".mp4","MPEG-4");
open(videoObj);
end


%% Initiate UI's
f1  = figure();
ax1 = axes();
f2  = figure();
ax2 = axes();

f1.WindowState = "maximized";

%% Setup
my_airfoil = imread("najs_vinge.png");

dt = 0.007;
diffusion_coeff = 10000;

x_vec             = linspace(0,5,width (my_airfoil));
y_vec             = linspace(0,5,height(my_airfoil));
pressure_constant = 10^5;
is_fluid  = floor(sum(my_airfoil,3)/(255*3));


initiate_fluid_field

viscosity_constant = viscosity_constant*30;

v_x_init = 1;




v_x(:,:) = not_locked_x*v_x_init;

smoke(1:30:end,1:70) = 0.05;
smoke(2:30:end,1:70) = 0.05;
smoke(3:30:end,1:70) = 0.05;
smoke(4:30:end,1:70) = 0.05;


iteration = 0;

%% Main loop
while true
%for i = 1:270

v_x(:,1)   = v_x_init;
smoke(:,1) = 0;
smoke(1:30:end,1) = 0.05;
smoke(2:30:end,1) = 0.05;
smoke(3:30:end,1) = 0.05;
smoke(4:30:end,1) = 0.05;

% Main simulation pipeline
projection
staggered2centered
advection
viscosity
centered2staggered
stabilize






% rendering
if mod(iteration,7) == 0
imagesc(ax1,  x_mesh(1,:), y_mesh(:,1), gather(smoke.*(smoke>0) + 0.01*(1-is_fluid)));
imagesc(ax2,  x_mesh(1,:), y_mesh(:,1), gather(sqrt(v_x.^2.*is_fluid + v_y.^2.*is_fluid)));

%l = streamslice(ax1,x_mesh(1:1:end,1:1:end), y_mesh(1:1:end, 1:1:end), v_x(1:1:end, 1:1:end),v_y(1:1:end, 1:1:end));
%set(l, "Color", [1 1 1]);


drawnow

if writing_video
writeVideo(videoObj, getframe(ax1))
end

end
%



iteration = iteration +1
end