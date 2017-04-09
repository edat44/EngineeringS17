function ball = createBall(xPos, yPos, size)
ball = struct([]);
position = struct('x', xPos, 'y', yPos);
ball.position = position;
ball.size = size;
ball.color = [1, 1, 1];