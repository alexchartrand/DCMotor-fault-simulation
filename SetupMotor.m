%% Init
clear all
T=0.001;

simEnd = 5;
time = (0:T:simEnd)';

motor = 2;
motorPowerSupply = [12 24 48];
torqueRange = [0.01 0.1 0.01];
changeSpeedTime = 1500;
speed1 = 10;
speed2 = 20;

% 0: No fault
fault = 2;
faultTime = 3;

states = {'Ia' 'Wm'};
inputs = {'Ut' 'Tl'};
outputs = {'currant' 'speed'};

%% Get motor values
v_power = motorPowerSupply(motor);
torque = torqueRange(motor);
[Bm, La, Ra, Kt, Jm] = getMotorValues(motor, false);

%% Compute PID values
[A, B, C, D] = getMotorStateSpace(Bm, La, Ra, Kt, Jm);
motorSys = ss(A,B,C,D,'statename',states,...
        'inputname',inputs,...
        'outputname',outputs);
motorTf = tf(motorSys);
% input: Ut
% output: Wm
speed_uTf = tf(motorTf.Numerator(1,2), motorTf.Denominator(1,2));
controller=pidtune(speed_uTf, 'PID');
Kp = controller.Kp;
Ki = controller.Ki;
Kd = controller.Kd;

%% create speed command
u = ones(length(time),1)*speed1;
u(changeSpeedTime:end)=speed2;

command = [time u];

%% Get fault parameters and fault time
[tBm,tUt,tI,tW,tU] = getFaultParam(fault,simEnd, faultTime);

%% Save data
saveFolder = "C:\Users\alexc\Documents\data\solver";
SimFileName = fullfile(saveFolder, 'sim_fault.csv');

simHeader = ["time", "currant", "speed", "voltage"];
simHeader = strjoin(simHeader, ',');
sdata = [out.tout, out.currant.Data, out.speed.Data, out.voltage.Data];
createCSV(simHeader,sdata, SimFileName);

