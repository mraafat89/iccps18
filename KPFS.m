function varargout = KPFS(varargin)
global sim;
% KPFS MATLAB code for KPFS.fig
%      KPFS, by itself, creates a new KPFS or raises the existing
%      singleton*.
%
%      H = KPFS returns the handle to a new KPFS or the handle to
%      the existing singleton*.
%
%      KPFS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KPFS.M with the given input arguments.
%
%      KPFS('Property','Value',...) creates a new KPFS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KPFS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KPFS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KPFS

% Last Modified by GUIDE v2.5 11-Nov-2016 04:06:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KPFS_OpeningFcn, ...
                   'gui_OutputFcn',  @KPFS_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before KPFS is made visible.
function KPFS_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KPFS (see VARARGIN)

% Choose default command line output for KPFS
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using KPFS.
axes(handles.axes1);
axis([1 200 1 200]);

% UIWAIT makes KPFS wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = KPFS_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        plot(rand(5));
    case 2
        plot(sin(1:0.01:25.99));
    case 3
        bar(1:.5:10);
    case 4
        plot(membrane);
    case 5
        surf(peaks);
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)



% --- Executes on button press in goToGoal.
function goToGoal_Callback(hObject, eventdata, handles)
% hObject    handle to goToGoal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Step2: Go to goal
robot = nhrInit(100,100);
cla(handles.axes1);
cla(handles.axes2);
canvasInit(handles.axes1);
%Plot initial config
%robotPlot = nhrPlot(robot, 'r');
%set one goal
goal = nhrSetGoals(1);
%plot goal
nhrPlotGoals(goal);
%run simulation
%Init Control Parameters
dt = 0.2;
t = 0;
x_true= [];

error(1) = sqrt((goal(1).x - robot.x)^2 +  (goal(1).y - robot.y)^2);
desiredVel = 6;
velIntegral = 0;
prevVelError = 0;
%sensor noises
var1 = 0.1;
var2 = 0.2;
%input noise
varInput = 0.5;
%initial state
u = [0;
     0;
     0.1;
     0.1
     ];
x_true(:,1) = [25;
          25
          ];
x(:,1) = [round(100 *rand(1,1));
     round(100 *rand(1,1));
     0;
     0
    ];
F = [1  0  dt 0 ;
     0  1  0  dt;
     0  0  1  0 ;
     0  0  0  1];
 
B = [0 0 0 0 ;
     0 0 0 0 ;
     0 0 1 0 ;
     0 0 0 1 ];
 
P = [10 0  0  0 ;
     0  10  0  0 ;
     0  0  1  0 ;
     0  0  0  1];
 
H = [1  0  0  0 ;
     0  1  0  0 ;
     1  0  0  0 ;
     0  1  0  0];

Q = [0  0  0  0 ;
     0  0  0  0 ;
     0  0  varInput  0 ;
     0  0  0  varInput];
 
R = [var1  0  0     0 ;
     0  var1  0     0 ;
     0  0  var2     0 ;
     0  0     0   var2];
index = 2;
v(1) = 0;
while(error(index-1) > 2)
    %calculate the actual state based on previous input.
   % x_true = (F*x_true + B*u);
   x_true(1,index) = x_true(1,index-1)+ dt *u(3);
   x_true(2,index) = x_true(2,index-1)+ dt *u(4);
  %  x_true_sim{k} = x_true;
    % generate sensor mesaurements with noise.
    Z(:,index) = [x_true(1,index) + normrnd(0,sqrt(var1));
         x_true(2,index) + normrnd(0,sqrt(var1));
         x_true(1,index) + normrnd(0,sqrt(var2));
         x_true(2,index) + normrnd(0,sqrt(var2))
         ];
    % prediction
    P1 = F*P*F' + Q;
    S = H*P1*H' + R;
    
    % measurements update
    K = P1*H'*inv(S);
    P = P1 - K*H*P1;
    x(:,index) = F*x(:,index-1) + B*u +  K*(Z(:,index)-H*(F*x(:,index-1)+B*u)); 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    robot.x = x(1,index);
    robot.y = x(2,index);
    robot.v = sqrt(x(3,index)^2 + x(4,index)^2);
    v(index) = robot.v;
   % velocity_sim{k} = robot.v;
    
    %PID controller
    velError = desiredVel - robot.v;
    velIntegral = velIntegral + velError*dt;
    velDerivative = (velError - prevVelError)/dt;

    % calculate u using PID
    [robot, ux, uy] = nhrNavOneGoal(goal, robot, velError,velIntegral,velDerivative);
    % construct input vector with noise
    u = [0;
         0;
         ux + normrnd(0,sqrt(varInput));
         uy + + normrnd(0,sqrt(varInput))
         ];
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %plot robot position and velocity
    robot.x = x_true(1,index);
    robot.y = x_true(2,index);
    robot.theta =  atan2(u(4),u(3));
    axes(handles.axes1);
    %robotPlot = nhrUpdateRobotPlot(robot, robotPlot, 'r');
    plot(robot.x,robot.y, '.', 'Color', 'r');
    axes(handles.axes2); %set the current axes to axes2
    ylabel('velocity (m/s)');
    xlabel('time (sec)');
    plot(t,robot.v,'.','color', 'g');
    hold on

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    prevVelError = velError;
    error(index) = sqrt((goal(1).x - robot.x)^2 +  (goal(1).y - robot.y)^2);
    
    t = dt + t;
    index = index + 1;
    pause(dt);
end
hold off
axes(handles.axes1);
hold off
%plotting the speed of the robot and distance to the goal (estimated)
time = 0:dt:t+dt;
time = time(1:length(v));
figure, plot(time,v); xlabel('time (sec)'); ylabel('speed (m/s)'); title('estimated speed of the robot');
figure, plot(time,error); xlabel('time (sec)'); ylabel('Distance to goal (m)'); title('Estimated distance to goal over time');

% plotting the estimated x and y values of the robot
figure, plot(time,x(1,:)); xlabel('time (sec)'); ylabel('estimated x (m)'); title('estimated x position of the robot');
figure, plot(time,x(2,:)); xlabel('time (sec)'); ylabel('estimated y (m)'); title('estimated y position of the robot');

%plotting the estimated x and y position together with the sensory
%measurements and the actual values for comparison.
figure, plot(time,x(1,:),'b'); hold on;
plot(time,Z(1,:), 'r'); hold on;
plot(time,Z(3,:), 'g'); hold on; 
plot(time,x_true(1,:), 'k'); xlabel('time (sec)'); ylabel('x position (m)'); hold on; 
legend('estimated x position', 'sensor 1','sensor 2', 'actual x');

figure, plot(time,x(2,:),'b'); hold on;
plot(time,Z(2,:), 'r'); hold on;
plot(time,Z(4,:), 'g'); hold on; 
plot(time,x_true(2,:), 'k'); xlabel('time (sec)'); ylabel('y position (m)'); hold on; 
legend('estimated y position', 'sensor 1','sensor 2', 'actual y');

% --- Executes on button press in particleFilterButton.
function particleFilterButton_Callback(hObject, eventdata, handles)
% hObject    handle to particleFilterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Create a 100mx100m environment. Create 6 landmarks at the following locations {(25,25)(25,70)(70,25)(70,70)(10,40)(80,60)}
L = [25 25; 25 70; 70 25; 70 70 ; 10 40; 80 60;];
% Place your robot in a random position and orientation in the middle of the environment
robot = nhrInit(25 + 50*rand(1,1), 25 + 50*rand(1,1));
cla(handles.axes1);
cla(handles.axes2);
canvasInit(handles.axes1);
%Plot initial config
robotPlot = nhrPlot(robot, 'r');
% Guess an initial pose of your robot in the environment
P = [];
N = 1000;
M = [];
W = [];
X = [];
Y = [];
Theta = [];
sensorNoiseVar = 8;
motionNoiseVar = 0.5;
% Create 1000 particles scattered uniformly through the environment. Each particle should contain (random) x,y position and orientation.
for i = 1 : N
    X(i) = 1 + 99*rand(1,1);
    Y(i) = 1 + 99*rand(1,1);
    Theta(i) = -pi + 2 * pi * rand(1,1);
end
%estimate robot's pose
robot_est.x  = mean(X);
robot_est.y  = mean(Y);
robot_est.theta = mean(Theta);
robot_est.L1 = robot.L1;
robot_est.L2 = robot.L2;
robotPlot_est = nhrPlot(robot_est,'b');
errorPos(1) = sqrt((robot.x - robot_est.x)^2 +(robot.y - robot_est.y)^2);
errorTheta(1)= abs(robot.theta - robot_est.theta);

simSteps = 20;
for r = 1 : simSteps
    % move the robot 1 meter ahead an 0.2 rad
    robot.theta = robot.theta + 0.2 +  normrnd(0,sqrt(motionNoiseVar));
    input = 1+ normrnd(0,sqrt(motionNoiseVar));
    robot.x = robot.x + input * cos(robot.theta);
    robot.y = robot.y + input * sin(robot.theta);

    robotPlot = nhrUpdateRobotPlot(robot, robotPlot, 'r');
    % The robot can measure the distance to each landmark with some error  = N(0, 8).
    for i = 1 : 6
        M(i) = sqrt((robot.x - L(i,1))^2 + (robot.y - L(i,2))^2) +  normrnd(0,sqrt(sensorNoiseVar));
    end
    % The robot forward and turning motion noise is = N(0, 0.5). Note that
    % these errors apply also to the particles.
    % move particles and calculate weights
    wTot = 0;
    for i = 1 : N
        Theta(i) = Theta(i) + 0.2 + normrnd(0,sqrt(motionNoiseVar));
        input = 1+ normrnd(0,sqrt(motionNoiseVar));
        X(i) = X(i) + input * cos(Theta(i));
        Y(i) = Y(i) + input * sin(Theta(i));
        W(i) = 1;
        for j = 1 : 6
            D(j) = sqrt((X(i) - L(j,1))^2 + (Y(i) - L(j,2))^2)+  normrnd(0,sqrt(sensorNoiseVar));
            W(i) = W(i) * (1/sqrt(2*pi*sensorNoiseVar))*exp(-0.5*(D(j)-M(j))^2/sensorNoiseVar);
        end
        wTot = wTot + W(i);
    end
    %normalize weights
    W = W / wTot;
    % resampling
    P_new = [];
    index = ceil(rand(1,1)* N);
    beta = 0;
    mw = max(W);
    for i = 1 : N
        beta = beta + rand(1,1) * 2 * mw;
        while beta > W(index)
            beta = beta - W(index);
            index = mod(index + 1, N);
            if(index == 0)
                index = N;
            end
        end
        X_new(i) = X(index);
        Y_new(i) = Y(index);
        Theta_new(i) = Theta(index);
    end
    X = X_new;
    Y = Y_new;
    Theta = Theta_new;
    %estimate robot's pose
    robot_est.x  = mean(X);
    robot_est.y  = mean(Y);
    robot_est.theta = mean(Theta);
    robotPlot_est = nhrUpdateRobotPlot(robot_est, robotPlot_est,'b');
    errorPos(r+1) = sqrt((robot.x - robot_est.x)^2 +(robot.y - robot_est.y)^2);
   % errorY(r) = abs(robot.y - robot_est.y);
    errorTheta(r+1) = abs(robot.theta - robot_est.theta);
end
hold off;
axes(handles.axes2);
hold on;
x = 1:simSteps+1;
plot(x,errorPos); hold on;
plot(x,errorTheta);
xlabel('time (sec)'); ylabel('error');
legend('Error in position', 'Error in Pose');
%plot(x,errorY);


% Implement a particle filter to localize the robot after 10 steps. In particular pay attention on implementing:
% - a weight function as shown in class
% - the resampling procedure as shown in class
% NOTE: at each step make the robot move forward and rotate. It�s up to you to decide the control input but the robot should not jump around. You can try with move_forward 1m and rotate 0.2 rad.
% Print the 10 estimated poses of the robot and the error between the actual pose and each estimate. HINT: average all particle values.
