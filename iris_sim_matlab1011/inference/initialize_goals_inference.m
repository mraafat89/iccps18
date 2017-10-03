function initialize_goals_inference
global goals_set;
global goals_posterior;
global goals_prior;
global observation_count;
global sensor_readings;
global attack_drift;
global attack_enable;
global active_learning;
global defend;
global active_learning_counter;
active_learning_counter = 1;
active_learning = 0;
attack_enable = 1;
global posterior_update_counter;
posterior_update_counter = 1;
global xxx ;
xxx = load('energy.mat', 'xxx')
defend = 1;
observation_count =0;
% The set of possible goals contain the cells of the edges on the right,
% bottom and the top 
%goals_set = [1,2,3,4,5,10,15,20,21,22,23,24,25];
%goals_set = [1,2,3,4,5,6,12,18,24,30,31,32,33,34,35,36];
goals_set = [1,2,3,4,5,6,7,8,9,10,20,30,40,60,70,80,90,91,92,93,94,95,96,97,98,99,100];
%goals_set = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,40,60,80,100,120,140,160,180, ...
  %  181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200];

sensor_readings = zeros(3,2);
attack_drift = 0;
% Initialize the posterior for each goal with a uniform prior for each goal.
n = length(goals_set);
uniform_prior = 1/n;
for i = 1:n
goals_prior(i) = uniform_prior;
end
goals_posterior = goals_prior;