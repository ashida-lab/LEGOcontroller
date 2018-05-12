close all
clear all

t = tcpip('localhost', 50009);
fopen(t);

% Set up MATLAB and EV3 communication
% mylego = legoev3('Bluetooth','COM3');
mylego = legoev3('bt','0016535BD5F8');

% Change based on your motor port numbers
l_motor = motor(mylego, 'A');              % Set up motor
r_motor = motor(mylego, 'C'); 
% m_motor = motor(mylego, 'B'); 

% mytouch = touchSensor(mylego,1);
% myirsensor = irSensor(mylego);

% LCD
% clearLCD(mylego);
% writeLCD(mylego,'Hello, LEGO!',2,3);

% touch sensor
% tt=readTouch(mytouch);

% IR sensor
% proximity = readProximity(myirsensor);

% forward
% F_gostraight(l_motor,r_motor,1);

% backward
% F_gostraight(l_motor,r_motor,-1);

% right turn
% F_turn(l_motor,r_motor,1);

% left turn
% F_turn(l_motor,r_motor,-1);
% F_turn(l_motor,r_motor,-1);

cons=-20.;

alpha1=0.;
[R1,R2]=F_goforward(l_motor,r_motor,alpha1);
y1=R1-R2-cons;
alpha2=0.7;
[R1,R2]=F_goforward(l_motor,r_motor,alpha2);
y2=R1-R2-cons;

ydot=(y2-y1)/(alpha2-alpha1);

alpha1=alpha2;
alpha2=alpha2-y2/ydot;

y1=y2;

figure;hold on

% alpha2=0.5
pos2=[];
for i=1:100
    % write a message
    fwrite(t, 'Get pos.');

    [R1,R2]=F_goforward(l_motor,r_motor,alpha2);
    y2=R1-R2-cons

    ydot=(y2-y1)/(alpha2-alpha1)

    alpha1=alpha2;
    alpha2=alpha2-y2/ydot
    
    if alpha2<-0.9
        alpha2=-0.5-0.5*rand();
    end
    
    if alpha2>0.9
        alpha2=0.5+0.5*rand();
    end

    y1=y2;
    
    plot(alpha1,y2,'*');
    
    % read the echo
    while t.BytesAvailable<1
    end
    bytes = fread(t, [1, t.BytesAvailable]);
    str=char(bytes);
    pos=str2double(strsplit(str,',')) 
    
    pos2=[pos2;pos];
    
end
