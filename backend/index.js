const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const app = express();
const PORT = 3000;

// Datos demo
const USERS = [
  { id: 1, email: 'admin@example.com', password: '123456', name: 'Admin' }
];

const PRODUCTS = [
  { id: 1, name: 'Item 1' },
  { id: 2, name: 'Item 2' }
];

app.use(cors());
app.use(bodyParser.json());

// login
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;
  const user = USERS.find(u => u.email === email && u.password === password);
  if (!user) return res.status(401).json({ error: 'Invalid credentials' });
  // token simulado (en proyecto real usar JWT)
  const token = 'demo_jwt_token_abc123';
  res.json({ token, user: { id: user.id, email: user.email, name: user.name } });
});

// middleware auth
function requireAuth(req, res, next) {
  const auth = req.headers['authorization'] || '';
  if (auth === 'Bearer demo_jwt_token_abc123') return next();
  return res.status(401).json({ error: 'Unauthorized' });
}

app.get('/api/products/', requireAuth, (req, res) => {
  res.json(PRODUCTS);
});

app.listen(PORT, () => console.log('Backend running on http://localhost:' + PORT));
