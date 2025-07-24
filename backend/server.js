import compression from 'compression';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import express from 'express';
import connectDB from './config/db.js';
import { PORT } from './config/utils.js';
import authRouter from './routes/auth.js';
import postsRouter from './routes/posts.js';
import { connectToRedis } from './services/redis.js';
const app = express();
// const port = PORT || 5000;
const port = process.env.PORT || 5000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// app.use(cors());
app.use(cors({
  origin: 
      // 'https://wanderlust-mega-dev-ops.vercel.app',
      // 'http://35.247.142.83:5173',
      'http://35.223.171.95:31000'
    , 
  credentials: true, // nếu dùng cookie
}));
app.use(cookieParser());
app.use(compression());

// Connect to database
connectDB();

// Connect to redis
// connectToRedis();

// API route
app.use('/api/posts', postsRouter);
// app.use('/api/posts', (req, res, next) => {
//   console.log(`[LOG] /api/posts called: ${req.method} ${req.originalUrl}`);
//   next();
// }, postsRouter); // <- Bổ sung router

app.use('/api/auth', authRouter);

app.get('/', (req, res) => {
  res.send('Yay!! Backend of wanderlust prod app is now accessible');
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

export default app;
