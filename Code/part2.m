T=300;                  %Temp in K
K=1.38e-23;             %Boltsmann constant
Tmn=0.2e-12;            %mean time between collisions
Mo=9.11e-31;            %rest mass
Mn=0.26*Mo;             %effective mass of electrons
L=200e-09;              %Length of region
W=100e-09;              %Width of region
PopE=20;                %number of particles
Vth=sqrt((K*T)/(Mn));   %Thermal velocity    
TimeS=15e-15;           %time step of 15ns
%Electron Modeling
iterations=100;         % # iterations, 
    Angle = rand(PopE,1)*2*pi;   %random angle
    Pos = [rand(PopE,1)*L rand(PopE,1)*W Vth*cos(Angle) Vth*sin(Angle)]; %vector containing x y and velocity in the x and y 
    initialX=Pos(:,1);
    initialY=Pos(:,2); 
    Pscat = 1 - exp(-TimeS/Tmn);                                        %probability of scattering
    VprobS = makedist('Normal', 'mu', 0, 'sigma', sqrt(K*T/Mn));        %Velocity Distribution
    Avg_V = sqrt(sum(Pos(:,3).^2)/PopE + sum(Pos(:,4).^2)/PopE);
    colorstring= rand(1,PopE);
    initialT=T;
    avgT=0;         %average Temp
for i= 1 : iterations
  
    OverV = rand(PopE,1) < Pscat ;                              %check for probability of scatter
    Pos(OverV,3:4)= random(VprobS,[sum(OverV),2]);                
    
    NextV=sqrt(sum(Pos(:,3).^2)/PopE + sum(Pos(:,4).^2)/PopE);  %save the new average Velocity for use in Temp plot
    NextT= T + ((Mn * (NextV.^2) )/K/PopE/2) ;                       %save the new Temp for plot
  
    NextX=initialX + Pos(:,3) * TimeS;
    NextY=initialY + Pos(:,4) * TimeS; 

    OverX=NextX > L;                 %check for values in next position that are greater than bounds
    NextX(OverX)=NextX(OverX)-L;         %subtract from the bound to reflect
  
    UnderX=NextX < 0;                   %check for values less than bounds
    NextX(UnderX)= NextX(UnderX) + L;   %reflect bound
    
    OverY=NextY > W;                    %check for values greater then bounds
    NextY(OverY)= 2*W -NextY(OverY) ;   %subtract from bounds to reflect
    Pos(OverY,4)=- Pos(OverY,4);
    
    UnderY= NextY < 0;                  %check for under bounds
    NextY(UnderY)=- NextY(UnderY);      %reflect
    Pos(UnderY,4)=- Pos(UnderY,4);
    
    avgV=mean(sqrt(Pos(:,3).^2 + Pos(:,4).^2));
    MFP=(avgV*i)/1000000;
 
    figure(1);
    subplot(2,1,1);
    scatter(initialX,initialY,PopE,colorstring,'.' );
    hold on
    scatter(NextX, NextY,PopE,colorstring,'.' );
    axis([0 L 0 W]);
    title (['trajectories, avg MFP= ', num2str(MFP),'e^-6']);
    
    initialX=NextX; %save the x and y positions previously used for the timestep at the beginning of for loop
    initialY=NextY;
    initialT=NextT;
    avgT=(avgT+NextT);
    subplot(2,1,2);
    scatter (i,initialT,'.k');
    hold on
    scatter (i,NextT,'.k');
    title (['Average Temperature ', num2str(avgT/i),'K'])
    axis([0 iterations 200 400])
    hold on
end
    TimeMN=MFP/avgV;
    %histogram of X and Y velocity
    figure(3)
    subplot(2,1,1);
    histogram(Pos(:,3),PopE);
    title ('Velocity in X Plane');
    subplot(2,1,2);
    histogram(Pos(:,4), PopE);
    title ('Velocities in Y Plane');