
clear all; close all; clc

%-------------------------------------------------------------------------%
%----------------- Provide All Bounds for Problem ------------------------%
%-------------------------------------------------------------------------%
t0min = 0;  t0max = 0;
tfmin = 1;  tfmax = 1;
x0 = 0;
xmin = 0;   xmax = 1;
umin = 0;   umax = 1;

%-------------------------------------------------------------------------%
%----------------------- Setup for Problem Bounds ------------------------%
%-------------------------------------------------------------------------%
bounds.phase.initialtime.lower = t0min;
bounds.phase.initialtime.upper = t0max;
bounds.phase.finaltime.lower = tfmin;
bounds.phase.finaltime.upper = tfmax;
bounds.phase.initialstate.lower = [x0];
bounds.phase.initialstate.upper = [x0];
bounds.phase.state.lower = [xmin];
bounds.phase.state.upper = [xmax];
bounds.phase.finalstate.lower = [xmin];
bounds.phase.finalstate.upper = [xmax];
bounds.phase.control.lower = [umin];
bounds.phase.control.upper = [umax];
bounds.phase.integral.lower = 0;
bounds.phase.integral.upper = 100000;

%-------------------------------------------------------------------------%
%---------------------- Provide Guess of Solution ------------------------%
%-------------------------------------------------------------------------%
tGuess               = [0; 1];
xGuess              = [x0; x0];
uGuess               = [umax; umax];
guess.phase.state    = [xGuess];
guess.phase.control  = [uGuess];
guess.phase.time     = [tGuess];
guess.phase.integral = 0;

%-------------------------------------------------------------------------%
%----------Provide Mesh Refinement Method and Initial Mesh ---------------%
%-------------------------------------------------------------------------%
mesh.method          = 'hp-PattersonRao';
mesh.tolerance       = 1e-6;
mesh.maxiterations    = 20;
mesh.colpointsmin    = 4;
mesh.colpointsmax    = 10;
mesh.phase.colpoints = 4;

%-------------------------------------------------------------------------%
%------------- Assemble Information into Problem Structure ---------------%        
%-------------------------------------------------------------------------%
setup.mesh                        = mesh;
setup.name                        = 'Double-Integrator-Min-Time';
setup.functions.endpoint          = @counterexampleEndpoint;
setup.functions.continuous        = @counterexampleContinuous;
setup.displaylevel                = 2;
setup.bounds                      = bounds;
setup.guess                       = guess;
setup.nlp.solver                  = 'ipopt';
setup.derivatives.supplier        = 'sparseCD';
setup.derivatives.derivativelevel = 'second';
setup.method                      = 'RPM-Differentiation';

%-------------------------------------------------------------------------%
%----------------------- Solve Problem Using GPOPS2 ----------------------%
%-------------------------------------------------------------------------%
output = gpops2(setup);
fprintf('Optimal value = %f\n', output.result.objective);