clear all
T=0.001;

simEnd = 2;
time = 0:T:simEnd;
u = ones(1,length(time));

simHeader = ["time", "currant", "speed", "voltage"];
simHeader = strjoin(simHeader, ',');

resHeader = ["motor", "fault"];
resHeader = strjoin(resHeader, ',');

resData = [];
availableMotor = [1 2 3];
availableFault = [0 1 2 3 4 5];
% 0: No fault
% 1: Bearing
% 2: Speed sensor
% 3: Currant sensor
% 4: Voltage sensor
% 5: Power short circuit


%% Model simulation
motor = 1;
for i= 1:length(availableFault)
    [Bm, La, Ra, Kt, Jm] = getMotorValues(motor, false);

    [tBm,tUt,tI,tW,tU] = getFaultParam(availableFault(i),simEnd);

    motorSim = sim('DCMotorFault_sim');
    
    SimFileName = fullfile(pwd,'Data', 'fault_motor', sprintf('%05d.csv',i-1));
    sdata = [motorSim.currant.Time, motorSim.currant.Data, motorSim.speed.Data, motorSim.voltage.Data];
    createCSV(simHeader,sdata, SimFileName);
    
    resData = [resData; motor availableFault(i)];
end

resFileName = fullfile(pwd,'Data', 'fault_motor', 'result', 'result.csv');
createCSV(resHeader,resData, resFileName);

