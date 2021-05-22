clear all
T=0.001;

simEnd = 5;
time = 0:T:simEnd;
u = ones(1,length(time));

availableMotor = [1 2 3];

states = {'Ia' 'Wm'};
inputs = {'Ut' 'Tl'};
outputs = {'currant' 'speed'};

simHeader = ["time", "currant", "speed"];
simHeader = strjoin(simHeader, ',');

%% Model simulation

for i=1:length(availableMotor)
    SimFileName = fullfile(pwd,'Data', 'no_fault_motor', sprintf('motor-%d_fault-0.csv', i));
    
    [Bm, La, Ra, Kt, Jm] = getMotorValues(availableMotor(i), false);
    [A, B, C, D] = getMotorStateSpace(Bm, La, Ra, Kt, Jm);

    motorSim = sim('DCMotor_sim');
    %createMotorCSV(motorSim, SimFileName);
end
