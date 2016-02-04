function server = EnvSelec
env_correct = 0;
while env_correct == 0
    environment = input('Select an environment. Type one of the following:\n\nlive\n\npractice\n\nsandbox\n','s');
    if isequal(environment,'live')
        server = 'https://api-fxtrade.oanda.com/';
        env_correct = 1;
    elseif isequal(environment,'practice')
        server = 'https://api-fxpractice.oanda.com/';
        env_correct = 1;
    elseif isequal(environment,'sandbox')
        server = 'https://api-sandbox.oanda.com/';
        env_correct = 1;
    else
        warning('That is not a valid environment')
    end
end