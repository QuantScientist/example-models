# http://www.mrc-bsu.cam.ac.uk/bugs/winbugs/Vol2.pdf
# Page 29: Ice: non-parametric smoothing in an age-cohort model

// The model is the same specified here as in JAGS example, 
// but this example's JAGS version is a different from that of 
// WinBUGS because JAGS does not support some feature. 
// TODO: 
// Maybe we should check if we could specify 
// the model the same as WinBUGS? 

// status: the results are farely cose to those 
// from JAGS 
data {
  int(0,) N; 
  int(0,) Nage; 
  int(0,) K; 
  int year[N]; 
  int cases[N]; 
  int age[N]; 
  int pyr[N]; 
  double alpha1; 
} 

parameters {
  double alpha[Nage - 1]; 
  double beta[K]; 
  double(0,) sigma; 
} 

derived parameters {
  double yaalpha[Nage]; 
  // double logRR[K]; 
  yaalpha[1] <- alpha1; 
  for (i in 2:Nage) 
    yaalpha[i] <- alpha[i - 1]; 
} 

model {
  sigma ~ uniform(0, 1); 
  for (k in 1:2)  beta[k] ~ normal(0, sigma * 1E3); 
  for (k in 3:K)  beta[k] ~ normal(2 * beta[k - 1] - beta[k - 2], sigma); 

  // for (k in 1:K) 
  //   logRR[k] <- beta[k] - beta[5];

  for (j in 2:Nage) alpha[j - 1] ~ normal(0, 1000); 
   
  for (i in 1:N)  
    cases[i] ~ poisson(exp(log(pyr[i]) + yaalpha[age[i]] + beta[year[i]]));
} 
