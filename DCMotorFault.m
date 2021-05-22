clear all
T=0.001;

simEnd = 5;
time = (0:T:simEnd)';

availableMotor = [1 2 3]; % 1 T=0.01, 2 T=0.1
%availableMotor = [2];
motorPowerSupply = [12 24 48];
motorControllers = cell(length(availableMotor),1);

% 0: No fault
% 1: Bearing
% 2: Speed sensor
% 3: Currant sensor
% 4: Voltage sensor
% 5: Power short circuit
availableFault = [0 1 2 3 4 5];
%faultProportion = [0.5 0.5/5 0.5/5 0.5/5 0.5/5 0.5/5]; % no fault append 50% of the time since it's the most common state
%faultProportion = [1 1 1 1 1 1];

% Input values
%torqueRange = [0.01 0.1 0.01];
torqueRange = [0 0 0];
availableSpeed1 = [10 15 20 25 30];
availableSpeed2 = [0 10 20 30];

states = {'Ia' 'Wm'};
inputs = {'Ut' 'Tl'};
outputs = {'currant' 'speed'};

%% Compute all PID values

for i =1:3
    [Bm, La, Ra, Kt, Jm] = getMotorValues(i, false);
    [A, B, C, D] = getMotorStateSpace(Bm, La, Ra, Kt, Jm);
    motorSys = ss(A,B,C,D,'statename',states,...
            'inputname',inputs,...
            'outputname',outputs);
    motorTf = tf(motorSys);
    % input: Ut
    % output: Wm
    speed_uTf = tf(motorTf.Numerator(1,2), motorTf.Denominator(1,2));
    controller=pidtune(speed_uTf, 'PID');
    motorControllers{i} = controller;
end

%% Model simulation
resHeader = ["motor", "fault", "faultTime"];
simHeader = ["time", "currant", "speed", "voltage"];
simHeader = strjoin(simHeader, ',');

numberOfSimPerMotor = [250, 250, 250];
totalNumberOfSim = sum(numberOfSimPerMotor);

simulationRes = zeros(totalNumberOfSim, length(resHeader));
fprintf(1, "Staring simulation: %d sims\n", totalNumberOfSim);
saveFolder = "C:\Users\alexc\Documents\data\simulation\test";
simulationIndex = 1;
for m= 1:length(availableMotor)
    motor = availableMotor(m);
    v_power = motorPowerSupply(motor);
    Kp = motorControllers{motor}.Kp;
    Ki = motorControllers{motor}.Ki;
    Kd = motorControllers{motor}.Kd;
    
    faultToGenerate = randsample(availableFault, numberOfSimPerMotor(motor), true);
    torque = torqueRange(motor);
    fprintf(1, "Running motor: %d\n", motor);
    fprintf(1, "With: %d sim\n", numberOfSimPerMotor(motor));
    fprintf(1, "Torque: %f\n", torque);
    fprintf(1, "Tension: %d\n", v_power);
    fprintf(1, "Number of fault: %d\n", length(faultToGenerate));
    fprintf(1, "Kp: %f, Ki: %f, Kd: %f\n", Kp, Ki, Kd);
    tic
    for i=1:length(faultToGenerate)
        % Get motor values with error
        [Bm, La, Ra, Kt, Jm] = getMotorValues(motor, true);
        
        % create speed command
        speed1 = randsample(availableSpeed1, 1);
        speed2 = randsample(availableSpeed2, 1);
        changeSpeedTime = 1 + ((simEnd-1)-1)*rand(1);
        changeSpeedTime = floor(changeSpeedTime / T);
        u = ones(length(time),1)*speed1;
        u(changeSpeedTime:end)=speed2;
        
        command = [time u];
  
        faultTime = (simEnd-1)*rand(1);
        % Get fault parameters and fault time
        fault = faultToGenerate(i);
        if speed2 ==0 && faultTime > (changeSpeedTime*T-0.4)
            fault=0;
        end
        [tBm,tUt,tI,tW,tU] = getFaultParam(fault,simEnd, faultTime);
        
        % Simulate model
        motorSim = sim('DCMotorFaultFullPlant_sim');
        
        % Save result
        simulationRes(simulationIndex,:) = [motor, fault, faultTime];
        
        %Save csv file
        SimFileName = fullfile(saveFolder, sprintf('%05d.csv',(simulationIndex)-1));
        sdata = [motorSim.currant.Time, motorSim.currant.Data, motorSim.speed.Data, motorSim.voltage.Data];
        createCSV(simHeader,sdata, SimFileName);
        simulationIndex = simulationIndex+1;
    end
    toc
end

% Save resul csv
resHeader = strjoin(resHeader, ',');
resFileName = fullfile(saveFolder, 'result.csv');
createCSV(resHeader, simulationRes, resFileName);
