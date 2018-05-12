function result=F_turn(l_motor,r_motor,direction)

% Application parameters
EXE_TIME = 0.7;                              % Application running time in seconds
PERIOD = 0.1;                               % Sampling period
SPEED = 20;                                 % Motor speed
P = 0.01;                                   % P controller parameter

if direction>0
    l_motor.Speed = SPEED;                     % Set motor speed
    r_motor.Speed = -SPEED;
else
    l_motor.Speed = -SPEED;                     % Set motor speed
    r_motor.Speed = SPEED;
end

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
    
    speed1 = (r1 - lastR1)/PERIOD;          % Calculate the real speed in d/s
    speed2 = (r2 - lastR2)/PERIOD;
    
    diff = abs(speed1) - abs(speed2);                 % P controller
    l_motor.Speed = l_motor.Speed - int8(diff * P);
    
    lastR1 = r1;
    lastR2 = r2;
    
    pause(PERIOD);                          % Wait for next sampling period
    count=count+PERIOD;
    
    if count>EXE_TIME
        stat=false;
    end
end

stop(l_motor);                             % Stop motor 
stop(r_motor);

result=true;

end