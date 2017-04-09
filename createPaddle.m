function paddle = createPaddle(difficulty, strategy, xPos, yPos, width, height)
paddle = struct();
position = struct('x', xPos, 'y', yPos);

paddle.difficulty = difficulty;
paddle.strategy = strategy;
paddle.position = position;
paddle.width = width;
paddle.height = height;