function [Ut,Tl] = getSimulationInput()
    Ut = randi([100,200],1);
    
    torqueMin = 0;
    torqueMax = 0.01;
    Tl = torqueMin + (torqueMax-torqueMin)*rand(1);
    % For now we don't use any load
    Tl = 0;
end

