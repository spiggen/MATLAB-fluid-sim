
mypath = erase(mfilename("fullpath"), "main");
addpath(mypath+"airfoils")
addpath(mypath+"methods")
warning("off") % New favourite command



%% video-stuff
writing_video = false;

if writing_video
video_index = 1;
while true
if ~isfile(mypath+"videos\video"+string(video_index)+".mp4"); break ;end
video_index = video_index +1;
end

videoObj = VideoWriter(mypath+"videos\video"+string(video_index)+".mp4","MPEG-4");
open(videoObj);
end


%% Initiate UI's
f1  = figure();
ax1 = axes();
ax1.NextPlot = "replacechildren";
axis(ax1, "image");
f2  = figure();
ax2 = axes();
ax2.NextPlot = "replacechildren";
axis(ax2, "image");

f1.WindowState = "maximized";
f2.WindowState = "maximized";

%% Setup
my_airfoil = imread("ball3.png");

dt = 0.007;
diffusion_coeff = 10000;

x_vec             = linspace(0,8,width (my_airfoil));
y_vec             = linspace(0,3,height(my_airfoil));
pressure_constant = 10^5;
is_fluid  = flipud(floor(sum(my_airfoil,3)/(255*3)));


initiate_fluid_field

viscosity_constant = viscosity_constant*0.1;

v_x_init = 1;




v_x(:,:) = is_fluid*v_x_init;

smoke(2:30:end,1:40) = 0.05;
smoke(3:30:end,1:40) = 0.05;
%smoke(3:30:end,1:70) = 0.05;
%smoke(4:30:end,1:70) = 0.05;


iteration = 0;

%% Main loop
while true
%for i = 1

v_x(:,1:2)     = v_x_init;
%v_x(1,:)     = v_x_init;
%v_x(end,:)   = v_x_init;
%smoke(:,1) = 0;
smoke(2:30:end,1) = 0.05;
smoke(3:30:end,1) = 0.05;
% 
% smoke(~not_locked_x) = 0.05;

%smoke(3:30:end,1) = 0.05;
%smoke(4:30:end,1) = 0.05;

% Main simulation pipeline
projection
staggered2centered
advection
viscosity
centered2staggered
stabilize





% rendering
if mod(iteration,20) == 0

%
% vorticity = v_x_centered(1:end-2,2:end-1) ...
%           - v_x_centered(3:end,  2:end-1) ...
%           - v_y_centered(2:end-1,1:end-2) ...
%           + v_y_centered(2:end-1,  3:end) ;

%
imagesc(ax1,  x_mesh(1,:), y_mesh(:,1), abs(gather(smoke)) + 0.01*(1-is_fluid) );
%imagesc(ax1,  x_mesh(1,:), y_mesh(:,1), gather( (1 -is_fluid) + (smoke > 0.002) + (smoke > 0.0025) + (smoke > 0.0027) +  (smoke > 0.003) ) );
imagesc(ax2,  x_mesh(1,:), y_mesh(:,1), gather(sqrt(v_x.^2.*is_fluid + v_y.^2.*is_fluid)));
%imagesc(ax2,x_vec(2:end-1), y_vec(2:end-1), real(gather(vorticity).^(1/3)))
% l = streamslice(ax2,x_mesh(2:end-1, 2:end-1), y_mesh(2:end-1, 2:end-1), v_x(2:end-1, 2:end-1),v_y(2:end-1, 2:end-1));
% set(l, "Color", [1 1 1]);


drawnow

if writing_video
writeVideo(videoObj, getframe(ax1))
end

end

%



iteration = iteration +1;
end