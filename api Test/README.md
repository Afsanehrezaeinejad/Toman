# DummyJSON Auth API Tests
This is a small set of pytest tests that check the authentication endpoints of DummyJSON.

## What it does
Login with correct credentials → Should return access & refresh tokens.

Login with wrong credentials → Should return a 400 status.

Call /auth/me with a valid token → Should return your user info.

