function [deflection] = MPa_to_um(P)
%MPa_to_um converts pressure in MPa to deflection of a fixed substrates with parameters given below produced by small tip 

% Material properties: borosilicate glass D 263 bio Schott
E = 72900; %Young's modulus in MPa = N/mm^2
nu = 0.21; %Poisson's ratio

%Plate parameters
r = 5; % plate radius in mm or plate long side in mm for rectangular plate
t = 0.17; % plate thickness in mm

%Loading
r0 = 0.0035; % radius of the loading tip in mm
r0eqvlnt = sqrt(1.6*r0^2+t^2)-0.675*t; % equivalent radius for concentrated load

%Circular Plate constant 
D = E*t^3/12*(1-nu^2);

%Pressure in MPa to deflection in um

deflection = P*r^2*r0eqvlnt^2*1000/(16*D); %in um


end

