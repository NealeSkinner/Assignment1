T=300;                  %Temp in K
K=1.38e-23;             %Boltsmann constant
Tmn=0.2e-12;            %mean time between collisions
Mo=9.11e-31;            %rest mass
Mn=0.26*Mo;             %effective mass of electrons
L=200e-09;               %Length of region
W=100e-09;               %Width of region
PopE=25;                %number of particles
Vth=sqrt((K*T)/(Mn));   %Thermal velocity    
TimeS=15e-15;           %time step of 15ns
iterations=100;
%%%%Electron Modeling%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MFP=Tmn * Vth;          %Mean Free Path
%fprintf('the Mean Free Path is %d\n', MFP);
    Angle = rand(PopE,1)*2*pi;   %random angle
    Pos = [rand(PopE,1)*L rand(PopE,1)*W Vth*cos(Angle) Vth*sin(Angle)];        %initializing position array. column 1 holds X, 2 holds y, 3 holds velocity in X and 4 holds velocity in Y
    
    initialX=Pos(:,1);                  %array of the initial X values in Position array
    initialY=Pos(:,2);                 %array of the initial Y values in Position array
    colorstring=rand(PopE,1);           %array of values corresponding to shades of color, will be used in plotting
for i= 1 : iterations
    
    NextX=initialX + Pos(:,3) * TimeS;      %the next X position will be the initial plus a time step of velocity in X direction
    NextY=initialY + Pos(:,4) * TimeS;      %the next Y position will be the initial a plus a time step of velocity in Y.
    
    OverX=NextX > L;                     %check for values in next position that are greater than bounds
    NextX(OverX)=NextX(OverX)-L;         %subtract from the bound to reflect
  
    UnderX=NextX < 0;                   %check for values less than bounds
    NextX(UnderX)= NextX(UnderX) + L;   %reflect bound
    
    OverY=NextY > W;                    %check for values greater then bounds
    NextY(OverY)= 2*W -NextY(OverY) ;   %subtract from bounds to reflect
    Pos(OverY,4)=- Pos(OverY,4);        %reverse the velocity
    
    UnderY= NextY < 0;                  %check for under bounds
    NextY(UnderY)=- NextY(UnderY);      %reflect
    Pos(UnderY,4)=- Pos(UnderY,4);      %reverse the velocity
 

    figure(1)   
    subplot(2,1,1);
    scatter(initialX,initialY,PopE, colorstring,'.' );      %plot the coordinates of the electron before the move
    hold on
    scatter(NextX, NextY,PopE, colorstring,'.' );           %plot the coordinates of the electron after the move
    
    axis([0 L 0 W]);
    title (['Trajectories with MFP ', num2str(MFP)]);
    
    initialX=NextX;
    initialY=NextY;
end
    hold off
    %plot of temperature
    subplot(2,1,2);
    plot(Tar,'r');
    title (['Average Temperature ', num2str(T),'K'])
    axis([0 PopE 0 500])