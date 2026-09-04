# One-time database setup

1. Create D1 database `ffa-db`
2. Run schema.sql in D1 Console
3. Pages project → Settings → Functions → bind D1 as variable `DB`
4. Generate password hash with create-admin.html, then:

INSERT INTO admins (username, password_hash, display_name)
VALUES ('admin', 'YOUR_HASH', 'National Admin');

5. Login: https://fight4australia.org/admin/

API is included in the site zip under /api/ (Pages Functions). No separate Worker.
