function fn() {    
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
	  url: 'https://conduit.productionready.io/api',
    userEmail: '',
    userPassword: ''
  }
  if (env == 'dev') {
    config.userEmail = "testag3a@test.com";
    config.userPassword = "karate123";
  } else if (env == 'e2e') {
    // customize
  }

  // Get token for test user and configure header with the token
  var token = karate.callSingle('classpath:helpers/CreateToken.feature',config).token;
  karate.configure('headers', {Authorization: 'Token ' + token});

  return config;
}