-- Fight for Australia — D1 Database Schema
-- Run this in Cloudflare Dashboard → D1 → your database → Console
-- or via: wrangler d1 execute ffa-db --file=./db/schema.sql

PRAGMA foreign_keys = ON;

-- Subscribers / registrations from the public form
CREATE TABLE IF NOT EXISTS subscribers (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  name          TEXT NOT NULL,
  email         TEXT NOT NULL UNIQUE,
  city          TEXT,
  interest      TEXT DEFAULT 'Updates only',
  consent       INTEGER NOT NULL DEFAULT 1,
  ip            TEXT,
  user_agent    TEXT,
  created_at    TEXT NOT NULL DEFAULT (datetime('now')),
  unsubscribed  INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_subscribers_email ON subscribers(email);
CREATE INDEX IF NOT EXISTS idx_subscribers_created ON subscribers(created_at);

-- Contact / volunteer messages
CREATE TABLE IF NOT EXISTS messages (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  name          TEXT NOT NULL,
  email         TEXT NOT NULL,
  subject       TEXT,
  body          TEXT NOT NULL,
  type          TEXT DEFAULT 'general', -- general | volunteer | media | sticker
  ip            TEXT,
  read          INTEGER NOT NULL DEFAULT 0,
  created_at    TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_messages_created ON messages(created_at);
CREATE INDEX IF NOT EXISTS idx_messages_read ON messages(read);

-- Blog / news posts
CREATE TABLE IF NOT EXISTS posts (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  slug          TEXT NOT NULL UNIQUE,
  title         TEXT NOT NULL,
  excerpt       TEXT,
  body          TEXT NOT NULL,          -- HTML or Markdown
  status        TEXT NOT NULL DEFAULT 'draft', -- draft | published
  published_at  TEXT,
  author        TEXT DEFAULT 'Fight for Australia',
  created_at    TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at    TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_posts_slug ON posts(slug);
CREATE INDEX IF NOT EXISTS idx_posts_status ON posts(status);

-- Events (city marches etc.)
CREATE TABLE IF NOT EXISTS events (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  slug          TEXT NOT NULL UNIQUE,
  title         TEXT NOT NULL,
  city          TEXT NOT NULL,
  state         TEXT,
  location      TEXT,
  starts_at     TEXT NOT NULL,          -- ISO datetime or date
  ends_at       TEXT,
  description   TEXT,
  status        TEXT NOT NULL DEFAULT 'upcoming', -- upcoming | past | cancelled
  external_url  TEXT,
  created_at    TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at    TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_events_slug ON events(slug);
CREATE INDEX IF NOT EXISTS idx_events_starts ON events(starts_at);

-- Admin users (simple password auth for now)
CREATE TABLE IF NOT EXISTS admins (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  username      TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,          -- SHA-256 hex (Worker will hash)
  display_name  TEXT,
  created_at    TEXT NOT NULL DEFAULT (datetime('now')),
  last_login    TEXT
);

-- Sessions for admin auth
CREATE TABLE IF NOT EXISTS sessions (
  id            TEXT PRIMARY KEY,       -- random token
  admin_id      INTEGER NOT NULL,
  created_at    TEXT NOT NULL DEFAULT (datetime('now')),
  expires_at    TEXT NOT NULL,
  FOREIGN KEY (admin_id) REFERENCES admins(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_sessions_expires ON sessions(expires_at);

-- Simple activity log
CREATE TABLE IF NOT EXISTS activity_log (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  actor         TEXT,                   -- admin username or 'public'
  action        TEXT NOT NULL,
  detail        TEXT,
  created_at    TEXT NOT NULL DEFAULT (datetime('now'))
);

-- Seed the 30 Aug 2026 events (optional — run after schema)
-- INSERT OR IGNORE INTO events (slug, title, city, state, location, starts_at, description, status, external_url) VALUES
-- ('melbourne-2026-08-30', 'March for Australia — Melbourne', 'Melbourne', 'Victoria', 'Flinders Street Station Steps', '2026-08-30T12:00:00+10:00', 'Nationwide march for free speech.', 'upcoming', 'https://marchforaustralia.org/event/melbourne/'),
-- ... etc.
