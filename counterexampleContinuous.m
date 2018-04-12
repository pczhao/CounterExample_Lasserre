function phaseout = counterexampleContinuous(input)

t  = input.phase.time;
x1 = input.phase.state(:,1);
u  = input.phase.control(:,1);

x1dot = (u-1).^2;
% x1dot = u;

phaseout.dynamics = [x1dot];
phaseout.integrand = 20*x1 + u;
% phaseout.integrand = 20*x1 + 1 - sqrt(u);