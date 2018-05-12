function [lastR1,lastR2]=F_goforward(l_motor,r_motor,alpha)

% Application parameters
EXE_TIME = 1;                              % Application running time in seconds
PERIOD = 0.1;                               % Sampling period
SPEED = 20;                                 % Motor speed
P = 0.01;                                   % P controller parameter

l_motor.Speed = -(1+alpha)*SPEED;                     % Set motor speed
r_motor.Speed = -(1-alpha)*SPEED;

resetRotation(l_motor);                    % Reset motor rotation counter
resetRotation(r_motor);

start(l_motor);                            % Start motor
start(r_motor);

stat = true;
lastR1 = 0;
lastR2 = 0;

count=0;

while stat == true                          % Quit when times up
    r1 = readRotation(l_motor);            % Read rotation counter in degrees
    r2 = readRotation(r_motor);            
    
    lastR1 = lastR1+r1;
    lastR2 = lastR2+r2;
    
    pause(PERIOD);                          % Wait for next sampling period
    count=count+PERIOD;
    
    if count>EXE_TIME
        stat=false;
    end
end

stop(l_motor);                             % Stop motor 
stop(r_motor);

lastR1=pi/180.*double(lastR1);
lastR2=pi/180.*double(lastR2);

end