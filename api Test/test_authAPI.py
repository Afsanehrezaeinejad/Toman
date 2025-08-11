import os
import json
import pytest
import requests

BASE_URL  = "https://dummyjson.com"
LOGIN_URL = f"{BASE_URL}/auth/login"
ME_URL    = f"{BASE_URL}/auth/me"
USERNAME = "emilys"
PASSWORD = "emilyspass"
HTTP_TIMEOUT = 10

@pytest.fixture(scope="session")
def http():
    s = requests.Session()
    s.headers.update({"Content-Type": "application/json"})
    return s


def as_json(resp):
    try:
        return resp.json()
    except json.JSONDecodeError:
        return {"_status": resp.status_code, "_raw": resp.text[:400]}


def login(http, username, password, expires=30):
    payload = {"username": username, "password": password, "expiresInMins": expires}
    return http.post(LOGIN_URL, json=payload, timeout=HTTP_TIMEOUT)


def bearer(token):
    return {"Authorization": f"Bearer {token}"}


def test_login_success_returns_tokens(http):
    resp = login(http, USERNAME, PASSWORD)
    body = as_json(resp)

    assert resp.status_code == 200, f"login != 200: {resp.status_code} -> {body}"
    assert body.get("accessToken"), "missing/empty accessToken"
    assert body.get("refreshToken"), "missing/empty refreshToken"


@pytest.mark.parametrize(
    "u,pw",
    [
        ("wrong", "nope"),
        (USERNAME, "badpass"),
        ("", ""),
    ],
)
def test_login_invalid_returns_400(http, u, pw):
    resp = login(http, u, pw)
    body = as_json(resp)

    # DummyJSON returns 400 for bad creds
    assert resp.status_code == 400, f"expected 400 for invalid creds, got {resp.status_code} -> {body}"


def test_me_with_valid_token(http):
    # Step 1: log in
    login_resp = login(http, USERNAME, PASSWORD)
    login_body = as_json(login_resp)

    assert login_resp.status_code == 200, f"login failed: {login_resp.status_code} -> {login_body}"
    token = login_body["accessToken"]

    # Step 2: call /auth/me with the token
    me_resp = http.get(ME_URL, headers=bearer(token), timeout=HTTP_TIMEOUT)
    me_body = as_json(me_resp)

    assert me_resp.status_code == 200, f"/auth/me != 200: {me_resp.status_code} -> {me_body}"
    for key in ("id", "username", "email"):
        assert key in me_body, f"missing '{key}' in /auth/me: {me_body}"

    assert me_body.get("username") == USERNAME
