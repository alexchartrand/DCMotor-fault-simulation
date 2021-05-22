function [Bm, La, Ra, Kt, Jm] = getMotorValues(motorNo, addVariation)
switch motorNo
    case 1
        Bm=4.32e-4;     %N.m.s/r
        La=8.05e-3;     %H
        Ra=1.4;         %?
        Kt=0.095;       %Nm
        Jm=7.49e-4;     %kg.M2
        Ta=5.7500;      %mH/?
        Tm=1.7330;      %Kg.m.r/N/s
    case 2
        Bm=1e-5;       %N.m.s/r
        La=5.35e-3;	%H
        Ra=3.2;     %?
        Kt=0.3;     %Nm
        Jm=5e-4;	%kg.M2
        Ta=1.6719;	%mH/?
        Tm=50;		%Kg.m.r/N/s
    case 3
        Bm=	3e-3;	%N.m.s/r
        La=162.73e-3;	%H
        Ra=7.72;	%?
        Kt=1.25;	%Nm
        Jm=2.36e-2;	%kg.M2
        Ta=21.0790;	%mH/?
        Tm=7.8667;	%Kg.m.r/N/s
    otherwise
        
end

if addVariation
    La=AddVariation(La,0.05);
    Ra=AddVariation(Ra,0.075);	
    Kt=AddVariation(Kt,0.1);
end

end

function val = AddVariation(mu, variation)
    std = (variation*mu) / 3;
    val = mu + std*randn(1);
end

