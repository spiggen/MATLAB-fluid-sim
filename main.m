set(groot, 'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex');
mypath = erase(mfilename("fullpath"), "main");
addpath(mypath+"airfoils")
addpath(mypath+"methods")
warning("off") % New favourite command



%% video-stuff
writing_video = true;

if writing_video
video_index = 1;
if ~isfolder(mypath+"videos")
mkdir(mypath+"videos")
end

while isfile(mypath+"videos\smoke_video"      +string(video_index)+".mp4") + ...
      isfile(mypath+"videos\smoke_cell_video" +string(video_index)+".mp4") + ...
      isfile(mypath+"videos\velocity_video"   +string(video_index)+".mp4") > 0

video_index = video_index +1;
end

videoObj1 = VideoWriter(mypath+"videos\smoke_video"      +string(video_index)+".mp4","MPEG-4");
videoObj2 = VideoWriter(mypath+"videos\smoke_cell_video" +string(video_index)+".mp4","MPEG-4");
videoObj3 = VideoWriter(mypath+"videos\velocity_video"   +string(video_index)+".mp4","MPEG-4");
open(videoObj1);
open(videoObj2);
open(videoObj3);
end



%% Initiate UI's
f1  = figure();
ax1 = axes();
title(ax1, "Smoke-field");
ax1.NextPlot = "replacechildren";
axis(ax1, "image");
f2  = figure();
ax2 = axes();
title(ax2, "Smoke-field levels");
ax2.NextPlot = "replacechildren";
axis(ax2, "image");
f3  = figure();
ax3 = axes();
title(ax3, "Velocity-magnitude [m/s]")
colorbar(ax3);
ax3.NextPlot = "replacechildren";
axis(ax3, "image");

f1.WindowState = "maximized";
f2.WindowState = "maximized";
f3.WindowState = "maximized";


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

smoke(2:30:end,1:40) = 1;
smoke(3:30:end,1:40) = 1;
%smoke(3:30:end,1:70) = 1;
%smoke(4:30:end,1:70) = 1;



max_iterations = 10000;

%% Main loop
for iteration = 1:max_iterations
%for i = 1

v_x(:,1:2)     = v_x_init;
%v_x(1,:)     = v_x_init;
%v_x(end,:)   = v_x_init;
%smoke(:,1) = 0;
smoke(2:30:end,1) = 1;
smoke(3:30:end,1) = 1;
% 
% smoke(~not_locked_x) = 1;

%smoke(3:30:end,1) = 1;
%smoke(4:30:end,1) = 1;

% Main simulation pipeline
projection
staggered2centered
advection
viscosity
centered2staggered
stabilize





% rendering
if mod(iteration,20) == 0

disp("Iteration:"+string(iteration)+"/"+string(max_iterations))
%
imagesc(ax1,  x_mesh(1,:), y_mesh(:,1), abs(gather(smoke)) + 0.01*(1-is_fluid) );
imagesc(ax2,  x_mesh(1,:), y_mesh(:,1), gather( (1 -is_fluid) + (smoke > 0.05) + (smoke > 0.1) + (smoke > 0.2) +  (smoke > 0.3) ) );
imagesc(ax3,  x_mesh(1,:), y_mesh(:,1), gather(sqrt(v_x.^2.*is_fluid + v_y.^2.*is_fluid)));



drawnow

if writing_video
writeVideo(videoObj1, getframe(ax1))
writeVideo(videoObj2, getframe(ax2))
writeVideo(videoObj3, getframe(ax3))
end

end

%



iteration = iteration +1;
end



%% Closing video-writers
if writing_video
close(videoObj1)
close(videoObj2)
close(videoObj3)
end
