function [A,B,C,D] = getMotorStateSpace(Bm, La, Ra, Kt, Jm)
%getMotorStateSpace Return motor number state space matrix

A=[-Ra/La -Kt/La;
    Kt/Jm -Bm/Jm];

B=[1/La 0;
   0 -1/Jm];

C=[1 0;
   0 1];

D=[0 0;
   0 0];
end

