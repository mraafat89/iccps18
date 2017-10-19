# Attack Intention Inference
## Important Matlab Files and parameters:
- runsim_iris.m : Runs the simulations.

- inference/initialize_goals_inference.m: Initializes simulations.
Parameters:
     * active_learning: set to 1 to enable active learning.
     * attack_enable: set to 1 to perform an attack.
     * defend: set to 1 to recover from an attack when attack_enable is set to 1. If defend = 0, the quadrotor shall go to the undesired goal (attacker's goal).
- inference/update_goals_posterior.m: Updates the posterior of the attacker's goal estimate at each state.
- process_state.m:
     * Computes the next state to go to at each state according to the optimal policy.
     * Computes the next state to go to at each state according to active learning algorithm if it is enabled.
     * Calls update_goals_posterior if attack is enabled.
