function [Kp,Ki,Kd] = getPIDValues(system)

C=pidtune(system, 'PID');
Kp = C.Kp;
Ki = C.Ki;
Kd = C.Kd;
end

