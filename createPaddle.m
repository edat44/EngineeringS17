function paddle = createPaddle(difficulty, strategy, xPos, yPos, width, height)
paddle = struct([]);
position = struct('x', xPos, 'y', yPos);
size = struct('width', width, 'height', height);

paddle.difficulty = difficulty;
paddle.strategy = strategy;
paddle.position = position;
paddle.size = size;
paddle.color = [1, 1, 1];
