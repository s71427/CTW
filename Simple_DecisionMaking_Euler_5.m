% Created by Eugene M. Izhikevich, February 25, 2003
% Excitatory neurons    Inhibitory neurons
clc
clear
tic
SimulationTime=500; %ms;
DeltaT=0.01 %ms;
Vr=10;
Vth=130;
NoiseStrengthBase=0;
Velocity=[1,8]; % current nA
StimuluStrength=[5.5];
StimulusNeuron=1;
StimulationOnset=0;
StimulationOffset=50;
StimulationOnset=StimulationOnset/DeltaT;
StimulationOffset=StimulationOffset/DeltaT;
Direction=[0,4,-4];
ModulationCurrent=Direction(2);
Speed=Velocity(2);
%Speed=0;
FrameInterval=3
SpeedChecking=FrameInterval*16/DeltaT;


BoundNe=8;
ShiftNe=14;
InhibitionNe=1;
FMNe=1;
BaseFrequencyNe=1;
CoupledNe=2;
TotalNe=BoundNe+ShiftNe+InhibitionNe+FMNe+BaseFrequencyNe+CoupledNe;
%{
a=[0.04,0.04,0.04,0.02,0.02,0.02];
b=[0.1,0.1,0.1,0.2,0.2,0.2];
c=[-39.5,-52,-57,-45,-39.5,-60];
d=[0.1,0.1,0.1,0.1,0.1,0.1];
IB=[9.5,2,-2,16,10,-11];
c=c+100;
%}

% Bump,Shift,Inh,Couple,Base,FM
a=[0.04,0.04,0.04,0.02,0.02,0.02];
b=[0.1,0.1,0.1,0.2,0.21,0.2];
c=[-39.5,-52,-57,-45,-39.5,-57];
d=[0.1,0.1,0.1,0.1,0.1,0.1];
IB=[9.4,2,-2,16,10,-11];
c=c+100;

A=[a(1)*ones(BoundNe,1);a(2)*ones(ShiftNe,1);a(3)*ones(InhibitionNe,1);a(4)*ones(CoupledNe,1);a(5)*ones(BaseFrequencyNe,1);a(6)*ones(FMNe,1)];
B=[b(1)*ones(BoundNe,1);b(2)*ones(ShiftNe,1);b(3)*ones(InhibitionNe,1);b(4)*ones(CoupledNe,1);b(5)*ones(BaseFrequencyNe,1);b(6)*ones(FMNe,1)];
C=[c(1)*ones(BoundNe,1);c(2)*ones(ShiftNe,1);c(3)*ones(InhibitionNe,1);c(4)*ones(CoupledNe,1);c(5)*ones(BaseFrequencyNe,1);c(6)*ones(FMNe,1)];
D=[d(1)*ones(BoundNe,1);d(2)*ones(ShiftNe,1);d(3)*ones(InhibitionNe,1);d(4)*ones(CoupledNe,1);d(5)*ones(BaseFrequencyNe,1);d(6)*ones(FMNe,1)];

Ibias=[IB(1)*ones(BoundNe,1);IB(2)*ones(ShiftNe,1);IB(3)*ones(InhibitionNe,1);IB(4)*ones(CoupledNe,1);IB(5)*ones(BaseFrequencyNe,1);IB(6)*ones(FMNe,1)];
Inoise=NoiseStrengthBase*normrnd(0,1,[TotalNe,1]);
ExternalI=0*ones(TotalNe,1);

v=Vr.*ones(TotalNe,1);
v(TotalNe-1)=70;
u=10*ones(TotalNe,1);
S1=0*ones(TotalNe,1);
S2=0*ones(TotalNe,1);
Tau1=10;
Tau2=5;

Potential=transpose([0;v]);
SynapticCurrent1=transpose([0;S1]);
SynapticCurrent2=transpose([0;S2]);
g1=transpose(full(spconvert(dlmread('Connection_Table_temp.txt'))));
g2=transpose(full(spconvert(dlmread('Connection_Table_temp_short.txt'))));
%Information=dlmread('bmvx2vy2.csv');
%matrix=size(Information);
%Column=matrix(1);
for l=1:1

%Speed=Velocity(l);
ExternalI=0*ones(TotalNe,1);
v=Vr.*ones(TotalNe,1);
v(TotalNe-1)=70;
u=10*ones(TotalNe,1);
S1=0*ones(TotalNe,1);
S2=0*ones(TotalNe,1);
Tau1=10;
Tau2=5;
Potential=transpose([0;v]);
SynapticCurrent1=transpose([0;S1]);
SynapticCurrent2=transpose([0;S2]);
firings=[];             % spike timings
FirRate=transpose([0*ones(BoundNe+1)]);
TimeWindow=15; %ms
TimeWindow=TimeWindow/DeltaT;
Correct=[];
Position=[];
I=0*ones(TotalNe,1);
n=1;
for t=1:SimulationTime/DeltaT        % simulation time ms
  %Inoise=NoiseStrengthBase*normrnd(0,1,[TotalNe,1]);
  
  if t>StimulationOnset && t<=StimulationOffset
  ExternalI(StimulusNeuron)=StimuluStrength(1);
  else
  ExternalI(StimulusNeuron)=0;
  end
  if mod(t,SpeedChecking)==0
	x=0;
  	for m=1:8
		
  		if FirRate(t,m+1)>950
  			x=m
			temp=[t,(t/16)*DeltaT,x];
			Position=cat(1,Position,temp);
  		end;
		%t,m,x,FirRate(t,m+1)
  	end;
	 if x==8

    		break
  	end 
  end;	
 
  %{
  if mod(t,SpeedChecking)==0
	if n>Column
		break
	end

	if Information(n,6)>0
  		Speed=Velocity(Information(n,6));

	else
		Speed=0;
  	end
	
	%n,Information(n,2),n*16
	%ExternalI(Information(n,2))=StimuluStrength(1);
	
	%n=n+FrameInterval;
	
  	%m=0,t*DeltaT,Information(n,2),n
	x=0;
  	for m=1:8
		
  		if FirRate(t,m+1)>50
  			x=m
			temp=[t,(t/16)*DeltaT,x];
			Position=cat(1,Position,temp);
  		end;
		%t,m,x,FirRate(t,m+1)
  	end;
  	%Information(n,2)
	if x==Information(n,2) 
		temp=[t,x==Information(n,2) ];
		Correct=cat(1,Correct,temp);
	else
		temp=[t,x==Information(n,2) ];
		Correct=cat(1,Correct,temp);
	end
	
	if x==0
		ExternalI(Information(n,2))=StimuluStrength(1);
		StimulationOnset=10/DeltaT;
	else
		if x~=Information(n,2) 
			%x,Information(n,2),n
	  		ExternalI(Information(n,2))=StimuluStrength(1);
			StimulationOnset=10/DeltaT;
		end
	end
  	
  	n=n+FrameInterval;
	
  else
	if StimulationOnset==0 
  		ExternalI(1:BoundNe)=0;
	end
	StimulationOnset=StimulationOnset-1;
  end 
  %}
  
  
  fired1=find(v(1:BoundNe+ShiftNe+InhibitionNe)>=Vth);
  fired2=find(v(BoundNe+ShiftNe+InhibitionNe+1:end)>=Vth);
  fired3=find(v(1:BoundNe)>=Vth);
  fired3=find(v(1:BoundNe)>=Vth);
  fired2=fired2+(BoundNe+ShiftNe+InhibitionNe);
  fired=[fired1;fired2];
  firings=[firings; t*DeltaT+0*fired3,fired3];
  if t<=TimeWindow  
  	tem=find(firings(:,1)<=(t));
	temp=[t*DeltaT];
        for k=1:BoundNe
	temp=[temp;1000*sum(firings(tem,2)==k)/(t*DeltaT)];
	end
  elseif t>TimeWindow
	tem=find(firings(:,1)<=(t) & firings(:,1)>(t-TimeWindow)*DeltaT);
	temp=[t*DeltaT];
        for k=1:BoundNe
	temp=[temp;1000*sum(firings(tem,2)==k)/(TimeWindow*DeltaT)];
	end
  end
  
  temp=transpose(temp);
  FirRate=cat(1,FirRate,temp);








  v(fired)=C(fired);
  u(fired)=u(fired)+D(fired);

  S1=S1+sum(1*g1(:,fired1),2)-(S1/Tau1)*DeltaT;
  S2=S2+sum(1*g2(:,fired2),2)-(S2/Tau2)*DeltaT;
  if ModulationCurrent>0
	  ExternalI(BoundNe+1:ShiftNe/2+BoundNe)=ModulationCurrent;
	  ExternalI(ShiftNe+BoundNe+InhibitionNe+1:ShiftNe+BoundNe+1+CoupledNe)=Speed;
  elseif ModulationCurrent<0
	 ExternalI(ShiftNe+1:ShiftNe+BoundNe)=abs(ModulationCurrent);
	 ExternalI(ShiftNe+BoundNe+InhibitionNe+1:ShiftNe+BoundNe+1+CoupledNe)=Speed;
  else
	ExternalI(BoundNe+1:ShiftNe+BoundNe)=0;
  end
 
  I=ExternalI+S1+S2+Inoise+Ibias;
  
  fa1=funca(v,u,B,I,DeltaT);
  fb1=funcb(A,B,v,u,DeltaT);
  fa2=funca(v+DeltaT*0.5*fa1,u+DeltaT*0.5*fb1,B,I,DeltaT);
  fb2=funcb(A,B,v+DeltaT*0.5*fa1,u+DeltaT*0.5*fb1,DeltaT);
  fa3=funca(v+DeltaT*0.5*fa2,u+DeltaT*0.5*fb2,B,I,DeltaT);
  fb3=funcb(A,B,v+DeltaT*0.5*fa2,u+DeltaT*0.5*fb2,DeltaT);
  fa4=funca(v+DeltaT*fa3,u+DeltaT*fb3,B,I,DeltaT);
  fb4=funcb(A,B,v+DeltaT*fa3,u+DeltaT*fb3,DeltaT);
  v= v + (DeltaT/6)*(fa1 + 2*fa2 + 2*fa3 + fa4);
  u= u + (DeltaT/6)*(fb1 + 2*fb2 + 2*fb3 + fb4);
  
  %v=v+funca(v,u,B,I,DeltaT)*DeltaT;
  %u=u+funcb(A,B,v,u,DeltaT)*DeltaT;

  %xn+1 = xn + h 
  %yn+1 = yn + (h/2) (f(xn, yn) + f(xn + h, yn +  h f(xn, yn)))

  %{
  VK1=funca(v,u,B,I,DeltaT);
  UK1=funcb(A,B,v,u,DeltaT);
  VK2=funca(v+VK1*DeltaT,u+UK1*DeltaT,B,I,DeltaT);
  UK2=funcb(A,B,v+VK1*DeltaT,u+UK1*DeltaT,DeltaT);
  
  v=v+(DeltaT/2)*(VK1+VK2);
  u=u+(DeltaT/2)*(UK1+UK2);
  %}
  
  temp=transpose([t*DeltaT;v]);
  Potential=cat(1,Potential,temp);

  %temp=transpose([t*DeltaT;S1]);
  %SynapticCurrent1=cat(1,SynapticCurrent1,temp);
  %temp=transpose([t*DeltaT;S2]);
  %SynapticCurrent2=cat(1,SynapticCurrent2,temp);

end;
foldername=int2str(l);
mkdir (foldername);


for N=1:TotalNe
fig=plot(Potential(:,1),Potential(:,N+1),'b-');
saveas(fig,strcat('NeuronV','_',num2str(N),'.png'));
copyfile(strcat('NeuronV','_',num2str(N),'.png'),foldername);
%fig=plot(SynapticCurrent1(:,1),SynapticCurrent1(:,N+1),'b-');
%saveas(fig,strcat('NeuronC1','_',num2str(N),'.png'));
%fig=plot(SynapticCurrent2(:,1),SynapticCurrent2(:,N+1),'b-');
%saveas(fig,strcat('NeuronC2','_',num2str(N),'.png'));
end;




end

toc






















