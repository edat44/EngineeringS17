function ball = createBall(xPos, yPos, size)

position = struct('x', xPos, 'y', yPos);
ball.position = position;
ball.width = size;
ball.height = size;
ball.image = image(imread('whitePixel.png'));
