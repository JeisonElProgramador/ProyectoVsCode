Backend (Node.js + Express)
- Abrir en VSCode.
- Instalar dependencias: npm install
- Ejecutar: npm start
- Endpoint login: POST /api/auth/login  (body JSON: { "email": "...", "password": "..." })
- Endpoint protegido: GET /api/products/  (usar header Authorization: Bearer demo_jwt_token_abc123)
- Credenciales de prueba: admin@example.com / 123456
