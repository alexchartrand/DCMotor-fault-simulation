function [tBm,tUt,tI,tW,tU] = getFaultParam(faultNumber,simTime, faultTime)

tBm = simTime + 1;
tUt = simTime + 1;
tI = simTime + 1;
tW = simTime + 1;
tU = simTime + 1;

% fault number
% 0: No fault
% 1: Bearing
% 2: Speed sensor
% 3: Currant sensor
% 4: Voltage sensor
% 5: Power short circuit

switch faultNumber
    case 1
        tBm = faultTime;
    case 2
        tW = faultTime;
    case 3
        tI = faultTime;
    case 4
       tU = faultTime;
    case 5
       tUt = faultTime; 
end

end

