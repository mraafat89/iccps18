function initialize_goals_inference
global goals_set;
global goals_posterior;
% The set of possible goals contain the cells of the edges on the right,
% bottom and the top 
goals_set = [1,2,3,4,5,10,15,20,21,22,23,24,25];
% Initialize the posterior for each goal with a uniform prior for each goal.
n = length(goals_set);
uniform_prior = 1/n;
for i = 1:n
goals_posterior(i) = uniform_prior;
end